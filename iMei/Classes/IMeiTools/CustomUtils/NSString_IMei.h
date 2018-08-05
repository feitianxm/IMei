//
//  NSString_IMei.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/20.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

//Functions for Encoding String.
@interface NSString (NSString_IMei)


+ (NSString*)convertToNSString:(const char *)hString;

- (NSString*)MD5EncodedString;

- (NSData*)HMACSHA1EncodedDataWithKey:(NSString*)key;

//- (NSString*)base64EncodedString;
- (NSString*)URLEncodedString;

- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

+ (NSString *)GUIDString;

@end
