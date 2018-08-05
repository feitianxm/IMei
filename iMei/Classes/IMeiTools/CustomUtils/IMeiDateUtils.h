//
//  IMeiDateUtils.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMeiDateUtils : NSObject


+ (NSDate*)dateFromString:(NSString*)dateString;
+ (NSString*)stringFromDate:(NSDate*)date;


@end
