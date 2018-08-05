
//
//  DataReader.m
//  IMei
//
//  Created by fuhui on 14/10/13.
//  Copyright (c) 2013 i美. All rights reserved.
//

#import "DataReader.h"

@implementation DataReader

//@synthesize header;

- (id)initWithBytes:(const void *)bytes length:(NSUInteger)length
{
    self = [super init];
    if (self) {
        pos = 0;
        count = length;
        data = [[NSMutableData alloc]initWithBytes:bytes length:length] ;//]:bytes length:length];//initWithBytes:bytes length:length];
    }
    return self;
}

//-(WWMessage)makeHeader
//{
//    int mType = [self read];
//    int uType = [self read];
//    int mFlag = [self read];
//    self.header = WWMessageMake(mType,uType,mFlag);
//    return self.header;
//}

-(NSData*)getReadData
{
    return [NSData dataWithBytes:[data bytes] length:[data length]];
}

-(NSData*)read:(int)len
{
    char uuid[len];
    [data getBytes:uuid range:NSMakeRange(pos, len)];
    NSData *nd = [NSData dataWithBytes:uuid length:len];
    pos+=len;
    return nd;
}

-(NSInteger)read
{
    char uuid[1];
   [data getBytes:uuid range:NSMakeRange(pos, 1)];
    pos+=1;
    return uuid[0]&0xff;
    
}


-(BOOL)readBOOL;
{
    return [self read]==1?YES:NO;
}

-(NSInteger)readHead
{
    
    char uuid[3];
    [data getBytes:uuid range:NSMakeRange(pos, 3)];

    int b1 = (0xFF & uuid[0])<<16;
    int b2 = (0xFF & uuid[1])<<8;
    int b3 = (0xFF & uuid[2])<<0;
    pos+=3;
    return (b1|b2|b3);
}

-(NSInteger)readInt
{
    char uuid[4];
    [data getBytes:uuid range:NSMakeRange(pos, 4)];
//    //IMLOG(@"uuid[0]=>%d, uuid[1]=>%d, uuid[2]=>%d, uuid[3]=>%d", uuid[0], uuid[1], uuid[2], uuid[3] );
    int b0 = (uuid[0])<<24;
    int b1 = (0xFF & uuid[1])<<16;
    int b2 = (0xFF & uuid[2])<<8;
    int b3 = (0xFF & uuid[3])<<0;
    pos+=4;
    return (b0|b1|b2|b3);
    
}

-(long long)readLong
{
    char uuid[8];
    [data getBytes:uuid range:NSMakeRange(pos, 8)];
//    //IMLOG(@"uuid[0]=>%ld, uuid[1]=>%ld, uuid[2]=>%ld, uuid[3]=>%ld", uuid[0], uuid[1], uuid[2], uuid[3] );
//    //IMLOG(@"uuid[4]=>%ld, uuid[5]=>%ld, uuid[6]=>%ld, uuid[7]=>%ld", uuid[4], uuid[5], uuid[6], uuid[7] );
    long long b0 = (long long) (uuid[0])<<56;
    long long b1 = (long long) (0xFF & uuid[1])<<48;
    long long b2 = (long long) (0xFF & uuid[2])<<40;
    long long b3 = (long long) (0xFF & uuid[3])<<32;
    long long b4 = (long long) (0xFF & uuid[4])<<24;
    long long b5 = (long long) (0xFF & uuid[5])<<16;
    long long b6 = (long long) (0xFF & uuid[6])<<8;
    long long b7 = (long long) (0xFF & uuid[7])<<0;
    pos+=8;
    return (b0|b1|b2|b3|b4|b5|b6|b7);
    
}

-(NSInteger)available
{
    return  count - pos;
}


-(NSInteger)readShort
{
    char uuid[2];
    [data getBytes:uuid range:NSMakeRange(pos,2)];
    int b0 = (0xFF & uuid[0])<<8;
    int b1 = (0xFF & uuid[1])<<0;
    pos+=2;
    return (b0|b1);
}

-(NSData*)readBytes
{
    int len = [self readShort];
    if (len >= 0xFFFF) {
        len = [self readInt];
    }
    return [self read:len];
}




-(NSString*)readUTF8
{
    
    int len = [self readShort];
    if (len >= 0xFFFF) {
        len = [self readInt];
    }
    //NSLog(@"readUTF8 len=%d",len);
    //pos+=len;
    if (len > 0) {
    
        NSData *adata  = [self read:len];
    
        //NSLog(@"readUTF8 adata=%@ len=%d",adata,[adata length]);
    
    
        NSString *aString = [[[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding]autorelease];
        //NSString* ret = aString;
        //NSLog(@"readUTF8 astring=%@ c=%d",aString,aString.retainCount);
        //[adata release];
        //[aString release];
        //aString = nil;
        return aString;
    }
    else
        return nil;
    
}


-(void)skip:(NSInteger)step
{
    pos+=step;
}



-(void)mark
{
    mark = pos;
}

-(void)reset;

{
    pos = mark;
}

-(void)dealloc
{
    ////IMLOG(@"***reader dealloc %@",[self description]);
    [data release];
    [super dealloc];
}
@end
