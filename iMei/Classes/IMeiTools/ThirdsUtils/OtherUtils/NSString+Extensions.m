//
//  NSString+Extensions.m
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

#import "NSString+Extensions.h"


@implementation NSString (NSString_Extensions)

- (int)indexOf:(NSString *)newStr
{
	NSRange range = [self rangeOfString:newStr];
	/*if (NSLocationInRange(range.location,range)) {
		return YES;
	}
	return NO;*/
	if (range.length > 0)
		return (int)range.location;
	else return -1;
}

- (int)indexOf:(NSString *)newStr searchFrom:(int)_from
{
	
	NSRange range = [self rangeOfString:newStr options:NSCaseInsensitiveSearch range:NSMakeRange(_from, [self length] - _from)];

	/*if (NSLocationInRange(range.location,range)) {
	 return YES;
	 }
	 return NO;*/
	if (range.length > 0)
		return (int)range.location;
	else return -1;
}

- (NSString *)fetchNumber
{
    NSMutableString* outNumber = [[NSMutableString alloc] init];
	for(unsigned int i = 0;i<[self length];i++){
		unichar aChar = [self characterAtIndex:i];
		if(aChar >= '0' && aChar <= '9'){
			[outNumber appendFormat:@"%c",aChar];	
		}
	}
	return outNumber;

}

- (NSString *)stringByRemovingCodeTags
{
    //NSLog(@"self:%@",self);
	NSMutableString *sb = [NSMutableString string];
	BOOL stepThis = NO;
	for (int i=0;i<[self length];i++)
	{
		NSRange range = [self rangeOfString:@"[" options:NSCaseInsensitiveSearch range:NSMakeRange(i, 1)];
		if (range.length > 0 && (range.location > 0 || range.location == 0))
			stepThis = YES; 
        
		NSRange rangeEnd = [self rangeOfString:@"]" options:NSCaseInsensitiveSearch range:NSMakeRange(i, 1)];
		if (rangeEnd.length > 0 && rangeEnd.location > 0)
			stepThis = NO;

		NSRange range1 = [self rangeOfString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(i, 1)];
		if (range1.length > 0 && range1.location > 0)
		{
			i +=3;
			stepThis = NO;
			[sb appendString:@"#"];
			
		}
		@try {
		if (!stepThis) [sb appendString:[self substringWithRange:NSMakeRange(i,1)]];
        }@catch (NSException *e) {
            NSLog(@"error:%@",[e description]);
            //[sb appendString:@"#"];
        }

	}

	return [[sb stringByReplacingOccurrencesOfString:@"]" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:LocStr(@"<Emoji>")];
}


- (NSString *)encodeToPercentEscapeString
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

@end
