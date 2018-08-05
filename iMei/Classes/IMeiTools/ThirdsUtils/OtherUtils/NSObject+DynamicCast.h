//
//  NSObject+DynamicCast.h
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DynamicCast)

-(id)objectIfKindOfClass:(Class)aClass;

-(id)objectIfMemberOfClass:(Class)aClass;
@end
