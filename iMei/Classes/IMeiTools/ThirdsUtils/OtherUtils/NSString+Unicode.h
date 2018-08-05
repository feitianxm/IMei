//
//  NSString+Unicode.h
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Unicode)
- (NSString *)gbEncoding;
- (NSString *)decodeUnicode;

@end
