//
//  DataReader.h
//  IMei
//
//  Created by fuhui on 14/10/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface DataReader : NSObject
{
    int count;
    int pos;
    int mark;
    NSMutableData *data;
//    WWMessage header;
}

//@property(assign)WWMessage header;

- (id)initWithBytes:(const void *)bytes length:(NSUInteger)length;

//-(WWMessage)makeHeader;

-(NSInteger)available;


-(BOOL)readBOOL;

-(NSInteger)read;

-(long long)readLong;

-(NSData*)read:(int)len;

-(NSInteger)readShort;

-(NSInteger)readInt;

-(NSInteger)readHead;

-(NSData*)readBytes;

-(NSData*)getReadData;

-(NSString*)readUTF8;

-(void)skip:(NSInteger)step;

-(void)mark;

-(void)reset;


@end
