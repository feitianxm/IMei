//
//  NSString+Extensions.h
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Extensions) 

- (int)indexOf:(NSString *)newStr;
- (int)indexOf:(NSString *)newStr searchFrom:(int)_from;
- (NSString *)stringByRemovingCodeTags;

- (NSString *)fetchNumber;

- (NSString *)encodeToPercentEscapeString;
@end
