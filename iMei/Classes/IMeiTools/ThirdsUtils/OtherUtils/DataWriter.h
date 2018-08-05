//
//  DataWriter.h
//  IMei
//
//  Created by fuhui on 15/10/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataWriter : NSObject
{
    NSMutableData *data;
}

-(id)initWithCapacity:(NSInteger)len;


-(void)write:(NSInteger)value;

-(void)writeBOOL:(BOOL)value;



-(void)writeShort:(NSInteger)value;

-(void)writeInt:(NSInteger)value;


-(void)writeUTF8:(NSString*)aString;

-(void)writeBytes:(NSData*)value;

-(void)appendBytes:(NSData*)value;

-(NSData*)getData;


-(char*)getBytes;

-(NSInteger)length;
@end
