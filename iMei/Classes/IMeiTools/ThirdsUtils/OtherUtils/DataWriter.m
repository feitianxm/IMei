//
//  DataWriter.m
//  IMei
//
//  Created by fuhui on 15/10/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import "DataWriter.h"

@implementation DataWriter

-(id)initWithCapacity:(NSInteger)len
{
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc ]initWithCapacity:len] ;
        //data = [NSMutableData dataWithCapacity:len];
    }
    return self;
}



-(void)write:(NSInteger)value
{
    char write[1];
    int v1 = 0xff & value;
    write[0] = v1;
    [data appendBytes:write length:1];
}



-(void)writeBOOL:(BOOL)value;
{
    [self write:value?1:0];
}

-(void)writeShort:(NSInteger)value
{
    char write[2];
    int v1 = (0xff00 & value)>>8;
    int v2 = 0xff & value;
    write[0] = v1;
    write[1] = v2;
    
    [data appendBytes:write length:2];
}



-(void)writeInt:(NSInteger)value
{
    char write[4];
    int v1 = (0xff000000 & value)>>24;
    int v2 = (0xff0000 & value)>>16;
    int v3 = (0xff00 & value)>>8;
    int v4 = 0xff & value;
    
    write[0] = v1;
    write[1] = v2;
    write[2] = v3;
    write[3] = v4;
    [data appendBytes:write length:4];
   // free(write);
}



-(void)writeBytes:(NSData*)value
{
    [self writeShort:[value length]];
    [data appendData:value];
}


-(void)appendBytes:(NSData*)value
{
    //[self writeShort:[value length]];
    [data appendData:value];
}

-(void)writeUTF8:(NSString*)aString
{
    if (aString == nil) {
        [self writeShort:0];
    }else{
        aString = [NSString stringWithFormat:@"%@", aString];
        NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
        [self writeBytes:aData];
    }
}

-(NSData*)getData
{
    return [NSData dataWithBytes:[data bytes] length:[data length]];
}


-(char*)getBytes
{
    return (char*)[data bytes];
}

-(NSInteger)length
{
    return [data length];
}

-(void)dealloc
{
    ////IMLOG(@"***writer dealloc %@",self);
    [data release];
    [super dealloc];
}
@end
