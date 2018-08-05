//
//  IMeiDateUtils.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiDateUtils.h"

@implementation IMeiDateUtils


+ (NSDate*)dateFromString:(NSString*)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate = [dateFormat dateFromString:dateString];
    
    return destDate;
}

+ (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormat stringFromDate:date];
    
    return destDateString;
}

@end
