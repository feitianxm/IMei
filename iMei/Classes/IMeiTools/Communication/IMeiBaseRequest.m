//
//  IMeiBaseRequest.m
//  LeagSoftApp
//
//  Created by Chengfei Liang on 16/5/20.
//  Copyright © 2016年 联软. All rights reserved.
//

#import "IMeiBaseRequest.h"
#import "JSON.h"
#import "DataWriter.h"
#import "DataReader.h"
#import "NSString_IMei.h"


#define SOCKET_HTTP_URL @""

static const NSTimeInterval kTimeoutInterval = 180.0;

NSString* domainLeagSoftError       = @"domainLeagSoftError";
NSString* keyCodeReqClientError     = @"LeagSoft_request_error_code";

@interface IMeiBaseRequest(Private)
- (BOOL)loading;
- (void)handleResponseData:(NSData *)data;
- (void)failWithError:(NSError *)error;
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error;
- (id)formError:(NSInteger)code userInfo:(NSDictionary *)errorData;
+ (NSString*)stringFromDictionary:(NSDictionary*)dicInfo;
@end

@interface IMeiBaseRequest()
@property (nonatomic, retain)NSString *phpMethod;
@end

@implementation IMeiBaseRequest
@synthesize phpMethod = _phpMethod;
@synthesize requestDelegate;
@synthesize context;
//@synthesize url = _url;
@synthesize requstType, requestCode;

- (void)dealloc {
    IMLOG(@"IMeiBaseRequest dealloc...");
    [self clearRequestInfo];
}

- (void)clearRequestInfo
{
    self.requestDelegate = nil;
    self.phpMethod = nil;
    self.context = nil;
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    if (_responseText) {
        _responseText = nil;
    }
    if (dataConnection) {
        [dataConnection cancel];
        dataConnection = nil;
    }
}

#pragma mark -
#pragma mark private function
- (BOOL)loading
{
    return _connection;
}

- (void)cancelRequest
{
    [_connection cancel];
    self.requestDelegate = nil;
}

- (void)cancelDataRequest
{
    [dataConnection cancel];
    dataConnection = nil;
}

//字典内容拼接成字符串
+ (NSString*)stringFromDictionary:(NSDictionary*)dicInfo
{
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [dicInfo keyEnumerator])
    {
        if( ([[dicInfo valueForKey:key] isKindOfClass:[NSString class]]) == FALSE)
        {
            NSLog(@"Please Use NSString for this kind of params");
            continue;
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dicInfo objectForKey:key] URLEncodedString]]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData
{
    return [NSError errorWithDomain:domainLeagSoftError code:code userInfo:errorData];
}

- (id)parseJsonResponse:(NSData *)data error:(NSError **)error
{
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    IMLOG(@"http链接： %@\n返回的原始信息responseString： %@", _url, responseString);
    SBJSON *jsonParser = [[SBJSON alloc]init];
    
    //    UIAlertView *textAlert = [[UIAlertView alloc] initWithTitle:@"responseString" message:responseString delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    //    [textAlert show];
    //    [textAlert release];
    
    NSError* parserError = nil;
    id result = [jsonParser objectWithString:responseString error:&parserError];
    
    if( parserError && *error)
        *error = [self formError:CodeReqError_Client
                        userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",CodeReqClientError_ParserError] forKey:keyCodeReqClientError]];
    
    if( [result isKindOfClass:[NSDictionary class]] )
    {
        if( [result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"]intValue] != 200 )
        {
            if (error != nil)
            {
                *error = [self formError:CodeReqError_Server userInfo:result];
            }
        }
    }
    
    return result;
    
}

- (void)failWithError:(NSError *)error
{
    if ([requestDelegate respondsToSelector:@selector(iMeiRequest:didFailWithError:)])
    {
        [requestDelegate iMeiRequest:self didFailWithError:error];
    }
}

- (void)handleResponseData:(NSData *)data
{
    if ([requestDelegate respondsToSelector:@selector(iMeiRequest:didLoadRawResponse:)])
    {
        [requestDelegate iMeiRequest:self didLoadRawResponse:data];
    }
    
    //requstType: 0表示为普通文本， 1表示为二进制流
    if (self.requstType == 0) {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        IMLOG(@"handleResponseData responseString=>%@", responseString);
        [self responeWithResult:responseString];
    } else if (requstType == 1) {
        IMLOG(@"handleResponseData json");
        NSError *error = nil;
        NSDictionary *resultDic = [self parseJsonResponse:data error:&error];
        [self responseAddressWithResult:resultDic];
    }
}

- (void)responeWithResult:(NSString*)result
{
    SBJSON *jsonParser = [[SBJSON alloc] init];
    id resultDic = [jsonParser objectWithString:result error:nil];
    
    if (requestDelegate && [requestDelegate respondsToSelector:@selector(iMeiRequest:didLoad:)]) {
        [requestDelegate iMeiRequest:self didLoad:resultDic];
    }
    
//    if (requestDelegate && [requestDelegate respondsToSelector:@selector(iMeiRequest:didReceiveResult:)]) {
//        [requestDelegate iMeiRequest:self didReceiveResult:result];
//    }
}

- (void)responseAddressWithResult:(NSDictionary*)result {
    if (requestDelegate && [requestDelegate respondsToSelector:@selector(iMeiRequest:didReceiveDictionary:)]) {
        [requestDelegate iMeiRequest:self didReceiveDictionary:result];
    }
}

#pragma mark -
#pragma mark 二进制流
- (void)requestWithUrl:(NSString *)reqUrl data:(NSData *)reqData
{
    IMLOG(@"requestWithUrl reqUrl=>%@ reqData=>%@", reqUrl, reqData);
    
    NSURL *url = [NSURL URLWithString:reqUrl];
    
    NSMutableURLRequest *urlRequest =[NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[NSData dataWithData:reqData]];
    
    [urlRequest setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld",[body length]];
    [urlRequest addValue:postLength forHTTPHeaderField: @"Content-Length"];
    
    if (dataConnection) {
        dataConnection = nil;
    }
    dataConnection =[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];  //生成连接
}


#pragma mark -
#pragma mark 公共方法
- (NSString*)serializeURL:(NSString *)baseUrl   //Generate get URL
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod
{
    
    NSString *result ;
    
    return result;
}

#pragma mark - 通用接口
- (void)requestNormalRequest:(NSDictionary*)params httpUrl:(NSString *)urlString
{
    _url = urlString;
    _params = params;
    _httpMethod = @"POST";
    _postDataType = IMeiBaseRequestPostDataType_Normal;
    _connection = nil;
    _responseText = nil;
    [self normalConnectWithMoreParams:NO];
}

- (void)requestGetNormalRequest:(NSDictionary*)params httpUrl:(NSString *)urlString
{
    _url = urlString;
    _params = params;
    _httpMethod = @"GET";
    _postDataType = IMeiBaseRequestPostDataType_Normal;
    _connection = nil;
    _responseText = nil;
    [self normalConnectWithMoreParams:NO];
}

//上传图片
- (void)requestUploadImageData:(NSData *)imageData  paramsDictionary:(NSDictionary *)dic  httpUrl:(NSString *)urlString
{
    _url = urlString;
    _params = dic;
    _httpMethod = @"POST";
    _postBody = imageData;
    _postDataType = IMeiBaseRequestPostDataType_Multipart;
    _connection = nil;
    _responseText = nil;
    [self normalConnectWithMoreParams:NO];
}

#pragma mark - normalConnectWithMoreParams
- (void)normalConnectWithMoreParams:(BOOL)needMoreParams
{  //小数据量http请求，needMoreParams决定附加参数多少
    
    if ([requestDelegate respondsToSelector:@selector(iMeiRequestLoading:)])
    {
        [requestDelegate iMeiRequestLoading:self];
    }
    
    NSString* url = [self serializeURL:_url params:_params httpMethod:_httpMethod];
    IMLOG(@"FIRST url:%@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:kTimeoutInterval];
    
    [request setHTTPMethod:_httpMethod];
    
    if ([_httpMethod isEqualToString:@"POST"])
    {
        if(_postBody)
        {
            [request setHTTPBody:_postBody];
        }
        else
        {
            NSData *body = [self generateNormalPostBodyWithParams:needMoreParams];
            IMLOG(@"normalConnectWithMoreParams POST请求最终数据包body:%@;%@",[body class],body);
            [request setHTTPBody:body];
            
            NSString *html = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            IMLOG(@"normalConnectWithMoreParams POST请求最终数据包html:  %@",html);
        }
    }
    
    for (NSString* key in [_headerFieldsInfo keyEnumerator])
        [request setValue:[_headerFieldsInfo objectForKey:key] forHTTPHeaderField:key];
    
    IMLOG(@"normalConnectWithMoreParams POST请求最终数据包request:  %@",request);
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSMutableData *)generateNormalPostBodyWithParams:(BOOL)needMoreParams
{  //小数据量的打包，needMoreParams决定附加参数多少
    if (_params == nil || [_params count] == 0) {
        return nil;
    }
    NSMutableData *body = [NSMutableData data];
    NSString *pramasString = @"";//[_params JSONFragment];
    NSArray *keys = [_params allKeys];
    for (int i = 0; i < [keys count]; i++)
    {
        NSString *aKey = [keys objectAtIndex:i];
        NSString *tempString = [NSString stringWithFormat:@"%@=%@&", aKey, [_params objectForKey:aKey]];
        IMLOG(@"tempString=>%@", tempString);
        if (tempString) {
            pramasString = [pramasString stringByAppendingString:tempString];
        }
    }
    if(pramasString == nil || [pramasString isEqualToString:@""] || pramasString.length == 0)
    {
        return body;
    }
    pramasString = [pramasString substringToIndex:pramasString.length-1];
    IMLOG(@"pramasString=>%@", pramasString);
    
    [body appendData:[pramasString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

#pragma mark
#pragma mark NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // we only trust our own domain
//        if ([challenge.protectionSpace.host isEqualToString:gstr_auth_ip])
//        {
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseText = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if (requestDelegate && [requestDelegate respondsToSelector:@selector(iMeiRequest:didReceiveResponse:)]) {
        [requestDelegate iMeiRequest:self didReceiveResponse:httpResponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self handleResponseData:_responseText];
    
    _responseText = nil;
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    IMLOG(@"didFailWithError");
    [self failWithError:error];
    
    _responseText = nil;
    _connection = nil;
}

@end
