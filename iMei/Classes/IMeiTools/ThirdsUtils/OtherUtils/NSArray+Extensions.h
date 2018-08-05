//
//  NSArray+Extensions.h
//  IMei
//
//  Created by fuhui on 31/8/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (NSArray_Extensions) 
- (int)intValue:(int)idx;
- (int)findIndexInArray:(int)pointValue;
- (NSString *)printIntValue;


@end


@interface NSMutableArray (NSMutableArray_Extensions) 
- (void)addIntValue:(int)object;


@end
