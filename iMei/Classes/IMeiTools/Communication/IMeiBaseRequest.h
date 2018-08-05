//
//  IMeiBaseRequest.h
//  LeagSoftApp
//
//  Created by Chengfei Liang on 16/5/20.
//  Copyright © 2016年 联软. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMeiBaseRequestDelegate;


typedef enum
{
    IMeiBaseRequestPostDataType_Normal,				//for normal data post,such as "user=name&password=psd"
    IMeiBaseRequestPostDataType_Multipart,			//for uploading the images and files.
}IMeiBaseRequestPostDataType;

typedef enum
{
    CodeReqError_Server	= 100,
    CodeReqError_Client	= 101,
}CodeWawaError;

typedef enum
{
    CodeReqClientError_ParserError          = 200,
    CodeReqClientError_GetRequestError      = 201,
    CodeReqClientError_GetAccessError		= 202,
    CodeReqClientError_NotAuthorized		= 203,
}CodeReqClientError;


@interface IMeiBaseRequest : NSObject
{
    IMeiBaseRequestPostDataType _postDataType;        //only valid when the method is "POST"
    NSString*             _url;                     //the URL which will be contacted to excute the request
    NSString*             _httpMethod;              //such as:"GET","POST" and so on.
    NSDictionary*		  _params;
    NSDictionary*		  _headerFieldsInfo;        //the header info of the request which you want to create.
    NSURLConnection*      dataConnection;           //二进制流的url请求连接
    NSURLConnection*      _connection;
    NSMutableData*        _responseText;
    NSData               *_postBody;
    int                   requstType;               //0表示为普通文本， 1表示为json格式
    int                   requestCode;
    
}

@property(nonatomic, weak) id<IMeiBaseRequestDelegate> requestDelegate;
@property(nonatomic, retain)id  context;
//@property(nonatomic, strong)NSString *url;
@property(nonatomic, assign)int requstType;
@property(nonatomic, assign)int requestCode;

- (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;

- (BOOL)loading;
- (void)cancelRequest;
- (void)cancelDataRequest;
- (void)requestWithUrl:(NSString*)reqUrl data:(NSData*)reqData;    //二进制流方式请求

#pragma mark - 通用接口
- (void)requestGetNormalRequest:(NSDictionary*)params httpUrl:(NSString *)urlString;
- (void)requestNormalRequest:(NSDictionary*)params httpUrl:(NSString *)urlString;
//上传图片数据
- (void)requestUploadImageData:(NSData *)imageData  paramsDictionary:(NSDictionary *)dic  httpUrl:(NSString *)urlString;
@end


@protocol IMeiBaseRequestDelegate <NSObject>
@optional
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didReceiveDictionary:(NSDictionary*)result;
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didReceiveResult:(NSString*)result;
- (void)iMeiRequestLoading:(IMeiBaseRequest *)iMeiRequest;											//Called just before the request is sent to the server.
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didReceiveResponse:(NSURLResponse *)response;		//Called when the server responds and begins to send back data.
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didFailWithError:(NSError *)error;					//Called when an error prevents the request from completing successfully.
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didLoadRawResponse:(NSData *)data;					//Called when a request returns and its response has been parsed into an object.
//The resulting object may be a dictionary, an array, a string, or a number,
//depending on thee format of the API response.
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didLoad:(id)result;								//Called when a request returns a response.The result object is the raw response from the server of type NSData

- (NSString *)getNewURLStr;
@end
