//
//  NSObject+DynamicCast.m
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import "NSObject+DynamicCast.h"

@implementation NSObject (DynamicCast)
-(id)objectIfKindOfClass:(Class)aClass;
{
    return [self isKindOfClass:aClass] ? self : nil;
}


-(id)objectIfMemberOfClass:(Class)aClass;
{
    return [self isMemberOfClass:aClass] ? self : nil;
}
@end
