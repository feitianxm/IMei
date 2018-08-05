//
//  NSString+Unicode.m
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import "NSString+Unicode.h"

int GetIntegerFromString(const char* pStr)
{
	int nValue = 0;
	for (int i = 0; i < strlen(pStr); i++)
	{
		int nLetterValue ;  //针对数字0~9。a~f自己想 （别告诉我不知道啊）
        
		switch (*(pStr+i))
		{
			case 'a':case 'A':
				nLetterValue = 10;break;
			case 'b':case 'B':
				nLetterValue = 11;break;
			case 'c': case 'C':
				nLetterValue = 12;break;
			case 'd':case 'D':
				nLetterValue = 13;break;
			case 'e': case 'E':
				nLetterValue = 14;break;
			case 'f': case 'F':
				nLetterValue = 15;break;
			default:nLetterValue = *(pStr+i) - '0';
				
		}
		nValue = nValue * 16 + nLetterValue; //16进制
	}
	return nValue;
}


@implementation NSString (Unicode)

- (NSString *)decodeUnicode 
{
	if (self == NULL || [self length] <= 0)
		return NULL;
    
	
	int p = 0;
	long len = [self length];
    
	NSMutableString *buffer = [NSMutableString stringWithCapacity:len];
	
	char c1, c2, c3;
	int code;
	while (p < len) {
		c1 = [self characterAtIndex:p++];
		if (c1 == '\\') {
			@try {
				c2 = [self characterAtIndex:p++];
				switch (c2) {
                    case '\\':
						[buffer appendFormat:@"%c",c2];
                        break; //Resered
                    case 'u': // unicode: e.g. \u4A24, \u0045
                        //c3 = (char) Integer.parseInt(dataStr
						//							 .substring(p, p + 4), 16); // 16进制parse整形字符串。
						c3 = [[self substringWithRange:NSMakeRange(p, p+4)] intValue];
                        //buffer.append(c3);//new Character(c3).toString() );
						[buffer appendFormat:@"%c",c3];
                        p += 4;
                        break;
                    default: 
						
						code = GetIntegerFromString([[self substringWithRange:NSMakeRange(p -1, 4)] UTF8String]);
						//c3 =  GetIntegerFromString([[dataStr substringWithRange:NSMakeRange(p -1, 4)] UTF8String]);
						[buffer appendFormat:@"%C",(unichar)code];
                        p += 3;
                        break;
				}
				
			} @catch (NSException *e) {
				NSLog(@"handle error :%@,orgin string:%@",[e description],self);
				break;
			}
		} 
		else if(c1 == 0x7F)
		{
			[buffer appendFormat:@"|"];
		}
		else if(c1 == 0x7D)
		{
			[buffer appendFormat:@"|"];
		}
		else
			//buffer.append(c1);
			[buffer appendFormat:@"%c",c1];
	}
	return buffer;
}

- (NSString *)gbEncoding
{
	if (self == NULL || [self length] <= 0)
		return self;
	
	
	
	int utfBytes[[self length]];
	for (int i=0;i<[self length];i++)
	{
		utfBytes[i] = [self characterAtIndex:i];
		//NSLog(@"utfBytes[%d]:%d",i,[gbString characterAtIndex:i]);
		if (i==[self length] - 1) utfBytes[i+1] = '\0';
	}
	//StringBuffer unicodeBytes = new StringBuffer(4*gbString.length());
	NSMutableString *unicodeBytes = [NSMutableString stringWithCapacity:4*[self length]];
	
	for (int byteIndex = 0; byteIndex < [self length]; byteIndex++) {		
		//NSLog(@"%d:%d",byteIndex,utfBytes[byteIndex]);
		
		int c = utfBytes[byteIndex];
		switch (c) {
            case '\\':
                [unicodeBytes appendString:@"\\"];
                [unicodeBytes appendFormat:@"%C",(unichar)c];
                break;
				//            case G_CHAR_COMMA:
				//                unicodeBytes.append("\\");
				//                unicodeBytes.append(G_CHAR_REPLACE_COMMA);
				//                break;
				//            case G_CHAR_ABBR:
				//                unicodeBytes.append("\\");
				//                unicodeBytes.append(G_CHAR_REPLACE_ABBR);
				//                break;
            default:
                if (c >= 32 && c < 128 )//&& c != 127 && c != 125)
                {
					[unicodeBytes appendFormat:@"%C",(unichar)c];
					
				}
                else {
					
                    NSString *hexB = [NSString stringWithFormat:@"%X",utfBytes[byteIndex]];
					
                    switch ([hexB length]) {
						case 1:
							[unicodeBytes appendString:@"\\000"];
							break;
						case 2:
							[unicodeBytes appendString:@"\\00"];
							break;
						case 3:
							[unicodeBytes appendString:@"\\0" ];
							break;
						default:
							[unicodeBytes appendString:@"\\"];
                    }
                    [unicodeBytes appendFormat:@"%@",hexB];
                }
		}
	}
	return unicodeBytes;
}



@end
