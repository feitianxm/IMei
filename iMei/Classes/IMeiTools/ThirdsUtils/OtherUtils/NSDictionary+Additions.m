//
//  NSDictionary+Additions.m
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (int)intValueForKey:(NSString *)key
{
    return [[self objectForKey:key] intValue];
}

@end
