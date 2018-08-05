//
//  NSArray+Extensions.m
//  IMei
//
//  Created by fuhui on 31/8/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import "NSArray+Extensions.h"


@implementation NSArray (NSArray_Extensions) 

- (int)intValue:(int)idx
{
	return [[self objectAtIndex:idx] intValue];
}

- (int)findIndexInArray:(int)pointValue
{
	for (int i=0;i<[self count];i++)
		if ([self intValue:i] == pointValue) return i;
	
	return -1;
}

- (NSString *)printIntValue
{
	NSMutableString *sb = [[NSMutableString alloc] init];
	for (int i=0;i<[self count];i++)
		[sb appendFormat:@"%d,",[self intValue:i]];
	

	return [sb autorelease];
}

@end

@implementation NSMutableArray (NSMutableArray_Extensions) 

- (void)addIntValue:(int)object
{
	//if (!self) {self = [[NSMutableArray alloc] init];}
	[self addObject:[NSNumber numberWithInt:object]];
}




@end
