//
//  NSData_IMei.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/20.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(NSData_IMei)

- (NSString*)MD5EncodedString;

- (NSData*)HMACSHA1EncodedDataWithKey:(NSString*)key;

//- (NSString*)base64EncodedString;
@end
