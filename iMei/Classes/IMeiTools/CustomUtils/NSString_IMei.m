//
//  NSString_IMei.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/20.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "NSString_IMei.h"
#import "NSData_IMei.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (NSString_IMei)

+ (NSString*)convertToNSString:(const char *)hString
{
    return [NSString stringWithUTF8String:hString];
}

- (NSString*)MD5EncodedString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5EncodedString];
}

- (NSData*)HMACSHA1EncodedDataWithKey:(NSString*)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] HMACSHA1EncodedDataWithKey:key];
}

//- (NSString *) base64EncodedString
//{
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//}

- (NSString*)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),encoding) autorelease];
}

+ (NSString *)GUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}
@end
