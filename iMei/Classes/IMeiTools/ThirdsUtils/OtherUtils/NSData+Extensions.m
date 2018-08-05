/*
**  NSData+Extensions.m
**
**  Copyright (c) 2001-2004
**
**  Author: Ludovic Marcotte <ludovic@Sophos.ca>
**          Alexander Malmberg <alexander@malmberg.org>
**
**  This library is free software; you can redistribute it and/or
**  modify it under the terms of the GNU Lesser General Public
**  License as published by the Free Software Foundation; either
**  version 2.1 of the License, or (at your option) any later version.
**  
**  This library is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
**  Lesser General Public License for more details.
**  
**  You should have received a copy of the GNU Lesser General Public
**  License along with this library; if not, write to the Free Software
**  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include "NSData+Extensions.h"

#include <Foundation/NSArray.h>
#include <Foundation/NSString.h>

#include "CWConstants.h"

#include <stdlib.h>
#include <string.h>

//
// C functions and constants
//
int getValue(char c);
void nb64ChunkFor3Characters(char *buf, const char *inBuf, int numChars);

static const char basis_64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char *hexDigit = "0123456789ABCDEF";



// TODO:
// add an NSData cluster member NSSubrangeData that retaind its parent and
// used its data. Would make almost all of these operations work without
// copying.
@implementation NSData (PantomimeExtensions)

+ (id) dataWithCString: (const char *) theCString
{
  return [self dataWithBytes: theCString 
	       length: strlen(theCString)];
}


//
// FIXME: this should ignore characters in the stream that aren't in
//        the base64 alphabet (as per the spec). would remove need for
//        ...removeLinefeeds... too
//
- (NSData *) decodeBase64
{
  int i, j, length, rawIndex, block, pad, data_len;
  const unsigned char *bytes;
  char *raw;

  if ([self length] == 0)
    {
      return nil;
    }

  data_len = [self length];
  bytes = [self bytes];
  pad = 0;

  for (i = data_len - 1; bytes[i] == '='; i--)
    {
      pad++;
    }
  
  length = data_len * 6 / 8 - pad;
  
  raw = (char *)malloc(length);
  rawIndex = 0;

  for (i = 0; i < data_len; i += 4)
    {
      block = (getValue(bytes[i]) << 18) +
	(getValue(bytes[i+1]) << 12) +
	(getValue(bytes[i+2]) << 6) +
	(getValue(bytes[i+3]));
      
      for (j = 0; j < 3 && rawIndex+j < length; j++)
	{
	  raw[rawIndex+j] = (char)((block >> (8 * (2 - j))) & 0xff);
	}

      rawIndex += 3;
    }
  
  return AUTORELEASE([[NSData alloc] initWithBytesNoCopy: raw  length: length]);
}


//
//
//
- (NSData *) encodeBase64WithLineLength: (int) theLength
{
  NSData *result;

  const char *inBytes = [self bytes];
  const char *inBytesPtr = inBytes;
  int inLength = [self length];

  char *outBytes = malloc(sizeof(char)*inLength*2);
  char *outBytesPtr = outBytes;

  int numWordsPerLine = theLength/4;
  int wordCounter = 0;

  // We memset 0 our buffer so with are sure to not have
  // any garbage in it.
  memset(outBytes, 0, sizeof(char)*inLength*2);

  while (inLength > 0)
    {
      nb64ChunkFor3Characters(outBytesPtr, inBytesPtr, inLength);
      outBytesPtr += 4;
      inBytesPtr += 3;
      inLength -= 3;

      wordCounter ++;

      if (theLength && wordCounter == numWordsPerLine)
	{
	  wordCounter = 0;
	  *outBytesPtr = '\n';
	  outBytesPtr++;
	}
    }

  result = [[NSData alloc] initWithBytesNoCopy: outBytes
			   length: (outBytesPtr-outBytes)];

  return AUTORELEASE(result);
}


//
//
//
- (NSData *) unfoldLines
{
  NSMutableData *aMutableData;
  int i, length;
  
  const unsigned char *bytes, *b;
   
  length = [self length];
  b = bytes = [self bytes];
  
  aMutableData = [[NSMutableData alloc] initWithCapacity: length];
  
  [aMutableData appendBytes: b  length: 1];
  b++;
  
  for (i = 1; i < length; i++,b++)
    {
      if (b[-1]=='\n' && (*b==' ' || *b=='\t'))
	{
	  [aMutableData setLength: ([aMutableData length] - 1)];
	}
      
      [aMutableData appendBytes: b length: 1];
    }
  
  return AUTORELEASE(aMutableData);
}


//
//
//
- (NSData *) decodeQuotedPrintableInHeader: (BOOL) aBOOL
{
  NSMutableData *result;

  const unsigned char *bytes,*b;
  unsigned char ch;
  int i,len;

  len = [self length];
  bytes = [self bytes];

  result = [[NSMutableData alloc] initWithCapacity: len];
  
  b=bytes;

  for (i = 0; i < len; i++,b++)
    {
      if (b[0]=='=' && i+1<len && b[1]=='\n')
	{
	  b++,i++;
	  continue;
	}
      else if (*b=='=' && i+2<len)
	{
	  b++,i++;
	  if (*b>='A' && *b<='F')
	    {
	      ch=16*(*b-'A'+10);
	    }
	  else if (*b>='a' && *b<='f')
	    {
	      ch=16*(*b-'a'+10);
	    }
	  else if (*b>='0' && *b<='9')
	    {
	      ch=16*(*b-'0');
	    }

	  b++,i++;

	  if (*b>='A' && *b<='F')
	    {
	      ch+=*b-'A'+10;
	    }
	  else if (*b>='a' && *b<='f')
	    {
	      ch+=*b-'a'+10;
	    }
	  else if (*b>='0' && *b<='9')
	    {
	      ch+=*b-'0';
	    }
	  
	  [result appendBytes: &ch length: 1];
	}
      else if (aBOOL && *b=='_')
	{
	  ch=0x20;
	  [result appendBytes: &ch length: 1];
	}
      else
	{
	  [result appendBytes: b length: 1];
	}
    }

  return AUTORELEASE(result);
}


//
//
//
- (NSData *) encodeQuotedPrintableWithLineLength: (int) theLength
					inHeader: (BOOL) aBOOL
{
  NSMutableData *aMutableData;
  const unsigned char *b;
  int i, length, line;
  char buf[4];
  
  aMutableData = [[NSMutableData alloc] initWithCapacity: [self length]];
  b = [self bytes];
  length = [self length];

  buf[3] = 0;
  buf[0] = '=';
  line = 0;

  for (i = 0; i < length; i++, b++)
    {
      if (theLength && line >= theLength)
	{
	  [aMutableData appendBytes: "=\n" length: 2];
	  line = 0;
	}
      // RFC says must encode space and tab right before end of line
      if ( (*b == ' ' || *b == '\t') && i < length - 1 && b[1] == '\n')
	{
	  buf[1] = hexDigit[(*b)>>4];
	  buf[2] = hexDigit[(*b)&15];
	  [aMutableData appendBytes: buf 
			length: 3];
	  line += 3;
	}
      // FIXME: really always pass \n through here?
      else if (!aBOOL &&
	       (*b == '\n' || *b == ' ' || *b == '\t'
		|| (*b >= 33 && *b <= 60)
		|| (*b >= 62 && *b <= 126)))
	{
	  [aMutableData appendBytes: b  length: 1];
	  if (*b == '\n')
	    {
	      line = 0;
	    }
	  else
	    {
	      line++;
	    }
	}
      else if (aBOOL && ((*b >= 'a' && *b <= 'z') || (*b >= 'A' && *b <= 'Z')))
	{
	  [aMutableData appendBytes: b  length: 1];
	  if (*b == '\n')
	    {
	      line = 0;
	    }
	  else
	    {
	      line++;
	    }
	}
      else if (aBOOL && *b == ' ')
	{
	  [aMutableData appendBytes: "_"  length: 1];
	}
      else
	{
	  buf[1] = hexDigit[(*b)>>4];
	  buf[2] = hexDigit[(*b)&15];
	  [aMutableData appendBytes: buf  length: 3];
	  line += 3;
	}
    }
  
  return AUTORELEASE(aMutableData);
}


//
//
//
- (NSRange) rangeOfData: (NSData *) theData
{
  const char *b, *bytes, *str;
  int i, len, slen;
  
  bytes = [self bytes];
  len = [self length];

  if (!theData)
    {
      return NSMakeRange(NSNotFound,0);
    }
  
  slen = [theData length];
  str = [theData bytes];
  
  b = bytes;
  
  // TODO: this could be optimized
  i = 0;
  b += i;
  for (; i<= len-slen; i++, b++)
    {
      if (!memcmp(str,b,slen))
	{
	  return NSMakeRange(i,slen);
	}
    }
  
  return NSMakeRange(NSNotFound,0);
}


//
//
//
- (NSRange) rangeOfCString: (const char *) theCString
{
  return [self rangeOfCString: theCString
	       options: 0
	       range: NSMakeRange(0,[self length])];
}


//
//
//
-(NSRange) rangeOfCString: (const char *) theCString
		  options: (unsigned int) theOptions
{
  return [self rangeOfCString: theCString 
	       options: theOptions 
	       range: NSMakeRange(0,[self length])];
}


//
//
//
-(NSRange) rangeOfCString: (const char *) theCString
		  options: (unsigned int) theOptions
		    range: (NSRange) theRange
{
  const char *b, *bytes;
  int i, len, slen;
  
  if (!theCString)
    {
      return NSMakeRange(NSNotFound,0);
    }
  
  bytes = [self bytes];
  len = [self length];
  slen = strlen(theCString);
  
  b = bytes;
  
  if (len > theRange.location + theRange.length)
    {
      len = theRange.location + theRange.length;
    }

//#warning this could be optimized
  if (theOptions == NSCaseInsensitiveSearch)
    {
      i = theRange.location;
      b += i;
      
      for (; i <= len-slen; i++, b++)
	{
	  if (!strncasecmp(theCString,b,slen))
	    {
	      return NSMakeRange(i,slen);
	    }
	}
    }
  else
    {
      i = theRange.location;
      b += i;
      
      for (; i <= len-slen; i++, b++)
	{
	  if (!memcmp(theCString,b,slen))
	    {
	      return NSMakeRange(i,slen);
	    }
	}
    }
  
  return NSMakeRange(NSNotFound,0);
}


//
//
//
- (NSData *) subdataFromIndex: (int) theIndex
{
  return [self subdataWithRange: NSMakeRange(theIndex, [self length] - theIndex)];
}


//
//
//
- (NSData *) subdataToIndex: (int) theIndex
{
  return [self subdataWithRange: NSMakeRange(0, theIndex)];
}


//
//
//
- (NSData *) dataByTrimmingWhiteSpaces
{
  const char *bytes;
  int i, j, len;
  
  bytes = [self bytes];
  len = [self length];

  for ( i = 0; i < len && bytes[i] == ' '; i++) ;
  for ( j = len-1; j >= 0 && bytes[j] == ' '; j--) ;
  
  if ( j <= i )
    {
      return AUTORELEASE(RETAIN(self));
    }
      
  return [self subdataWithRange: NSMakeRange(i, j-i+1)];
}


//
//
//
- (NSData *) dataByRemovingLineFeedCharacters
{
  const char *bytes;
  int i, j, len;
  char *dest;

  NSMutableData *aMutableData;
  
  bytes = [self bytes];
  len = [self length];
  
  aMutableData = [[NSMutableData alloc] init];
  [aMutableData setLength: len];
  
  dest = [aMutableData mutableBytes];
  
  for (i = j = 0; i < len; i++)
    {
      if (bytes[i] != '\n')
	{
	  dest[j++] = bytes[i];
	}
    }
  
  [aMutableData setLength: j];
  
  return AUTORELEASE(aMutableData);
}


//
//
//
- (NSData *) dataFromQuotedData
{
  const char *bytes;
  int len;
  
  bytes = [self bytes];
  len = [self length];

  if (len < 2)
    {
      return AUTORELEASE(RETAIN(self));
    }
  
  if (bytes[0] == '"' && bytes[len-1] == '"')
    {
      return [self subdataWithRange: NSMakeRange(1, len-2)];
    }
  
  return AUTORELEASE(RETAIN(self));
}


//
//
//
- (int) indexOfCharacter: (char) theCharacter
{
  const char *b;
  int i, len;
 
  b = [self bytes];
  len = [self length];

  for ( i = 0; i < len; i++, b++)
    if (*b == theCharacter)
      {
	return i;
      }
  
  return -1;
}


//
//
//
- (BOOL) hasCPrefix: (const char *) theCString
{
  const char *bytes;
  int len, slen;
  
  if (!theCString)
    {
      return NO;
    }
  
  bytes = [self bytes];
  len = [self length];

  slen = strlen(theCString);
  
  if ( slen > len)
    {
      return NO;
    }

  if (!strncmp(bytes,theCString,slen))
    {
      return YES;
    }
  
  return NO;
}


//
//
//
- (BOOL) hasCSuffix: (const char *) theCString
{
  const char *bytes;
  int len, slen;
  
  if (!theCString) 
    {
      return NO;
    }

  bytes = [self bytes];
  len = [self length];

  slen = strlen(theCString);

  if (slen > len) 
    {
      return NO;
    }

  if (!strncmp(&bytes[len-slen],theCString,slen))
    {
      return YES;
    }
  
  return NO;
}


//
//
//
- (BOOL) hasCaseInsensitiveCPrefix: (const char *) theCString
{
  const char *bytes;
  int len, slen;
  
  if (!theCString) 
    {
      return NO;
    }

  bytes = [self bytes];
  len = [self length];
  slen = strlen(theCString);
  
  if ( slen > len)
    {
      return NO;
    }
      
  if ( !strncasecmp(bytes,theCString,slen) )
    {
      return YES;
    }

  return NO;
}


//
//
//
- (BOOL) hasCaseInsensitiveCSuffix: (const char *) theCString
{
  const char *bytes;
  int len, slen;
  
  if (!theCString)
    {
      return NO;
    }
  
  bytes = [self bytes];
  len = [self length];
  slen = strlen(theCString);

  if (slen > len) 
    {
      return NO;
    }  

  if (!strncasecmp(&bytes[len-slen],theCString,slen))
    {
      return YES;
    }
  
  return NO;
}


//
//
//
- (NSComparisonResult) caseInsensitiveCCompare: (const char *) theCString
{
  int slen, len, clen, i;
  const char *bytes;
  
  // Is this ok?
  if (!theCString)
    {
      return NSOrderedDescending;
    }
      
  bytes = [self bytes];
  len = [self length];
  slen = strlen(theCString);
  
  if (slen > len)
    {
      clen = len;
    }
  else
    {
      clen = slen;
    }

  i = strncasecmp(bytes,theCString,clen);
  
  if (i < 0)
    {
      return NSOrderedAscending;
    }
  
  if (i > 0)
    {
      return NSOrderedDescending;
    }
  
  if (slen == len)
    {
      return NSOrderedSame;
    }

  if (slen < len)
    {
      return NSOrderedAscending;
    }
  
  return NSOrderedDescending;
}


//
//
//
- (NSArray *) componentsSeparatedByCString: (const char *) theCString
{
  NSMutableArray *aMutableArray;
  NSRange r1, r2;
  int len;
  
  aMutableArray = [[NSMutableArray alloc] init];
  len = [self length];
  r1 = NSMakeRange(0,len);
  
  r2 = [self rangeOfCString: theCString
	     options: 0 
	     range: r1];
  
  while (r2.length)
    {
      [aMutableArray addObject: [self subdataWithRange: NSMakeRange(r1.location, r2.location - r1.location)]];
      r1.location = r2.location + r2.length;
      r1.length = len - r1.location;
      
      r2 = [self rangeOfCString: theCString  options: 0  range: r1];
    }

  [aMutableArray addObject: [self subdataWithRange: NSMakeRange(r1.location, len - r1.location)]];
  
  return AUTORELEASE(aMutableArray);
}

//
//
//
- (NSString *) asciiString
{
  return AUTORELEASE([[NSString alloc] initWithData: self  encoding: NSASCIIStringEncoding]);
}


//
//
//
- (const char *) cString
{
  NSMutableData *aMutableData;
  
  aMutableData = [[NSMutableData alloc] init];
  AUTORELEASE(aMutableData);
   
  [aMutableData appendData: self];
  [aMutableData appendBytes: "\0"  length: 1];
  
  return [aMutableData mutableBytes];
}

@end


//
//
//
@implementation NSMutableData (PantomimeExtensions)

- (void) appendCFormat: (NSString *) theFormat, ...
{
  NSString *aString;
  va_list args;
  
  va_start(args, theFormat);
  aString = [[NSString alloc] initWithFormat: theFormat  arguments: args];
  va_end(args);
  
  // We allow lossy conversion to not lose any information / raise an exception
  [self appendData: [aString dataUsingEncoding: NSASCIIStringEncoding  allowLossyConversion: YES]];
  
  RELEASE(aString);
}


//
//
//
- (void) appendCString: (const char *) theCString
{
  [self appendBytes: theCString  length: strlen(theCString)];
}


//
//
//
- (void) insertCString: (const char *) theCString
	       atIndex: (int) theIndex
{
  int s_length, length;

  if (!theCString)
    {
      return;
    }
  
  s_length = strlen(theCString);

  if (s_length == 0)
    {
      return;
    }

  length = [self length];
  
  // We insert at the beginning of the data
  if (theIndex <= 0)
    {
      NSMutableData *data;
      
      data = [NSMutableData dataWithBytes: theCString  length: s_length];
      [data appendData: self];
      [self setData: data];
    }
  // We insert at the end of the data
  else if (theIndex >= length)
    {
      [self appendCString: theCString];
    }
  // We insert somewhere in the middle
  else
    {
      NSMutableData *data;

      data = [NSMutableData dataWithBytes: [self subdataWithRange: NSMakeRange(0, theIndex)]  length: theIndex];
      [data appendCString: theCString];
      [data appendData: [self subdataWithRange: NSMakeRange(theIndex, length - theIndex)]];
      [self setData: data];
    }
}


//
//
//
- (void) replaceCRLFWithLF
{
  unsigned char *bytes, *bi, *bo;
  int delta, i,length;
  
  bytes = [self mutableBytes];
  length = [self length];
  bi = bo = bytes;
  
  for (i = delta = 0; i < length; i++, bi++)
    {
      if (i+1 < length && bi[0] == '\r' && bi[1] == '\n')
	{
	  i++;
	  bi++;
	  delta++;
	}
      
      *bo = *bi;
      bo++;
    }
  
  [self setLength: length-delta];
}


//
//
//
- (NSMutableData *) replaceLFWithCRLF
{
  NSMutableData *aMutableData;
  unsigned char *bytes, *bi, *bo;
  int delta, i, length;
  
  bi = bytes = [self mutableBytes];
  length = [self length];
  delta = 0;
  
  if (bi[0] == '\n')
    {
      delta++;
    }
  
  bi++;
  
  for (i = 1; i < length; i++, bi++)
    {
      if ((bi[0] == '\n') && (bi[-1] != '\r'))
	{
	  delta++;
	}
    }
  
  bi = bytes;
  aMutableData = [[NSMutableData alloc] initWithLength: (length+delta)];
  bo = [aMutableData mutableBytes];
  
  for (i = 0; i < length; i++, bi++, bo++)
    {
      if ((i+1 < length) && (bi[0] == '\r') && (bi[1] == '\n'))
	{
	  *bo = *bi;
	  bo++;
	  bi++;
	  i++;
	}
      else if (*bi == '\n')
	{
	  *bo = '\r';
	  bo++;
	}
      
      *bo = *bi;
    }

  return AUTORELEASE(aMutableData);
}

@end


//
// C functions
//
int getValue(char c)
{
  if (c >= 'A' && c <= 'Z') return (c - 'A');
  if (c >= 'a' && c <= 'z') return (c - 'a' + 26);
  if (c >= '0' && c <= '9') return (c - '0' + 52);
  if (c == '+') return 62;
  if (c == '/') return 63;
  if (c == '=') return 0;
  return -1;
}


//
//
//
void nb64ChunkFor3Characters(char *buf, const char *inBuf, int theLength)
{
  if (theLength >= 3)
    {
      buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
      buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((inBuf[1] & 0xF0) >> 4)) & 0x3F];
      buf[2] = basis_64[(((inBuf[1] & 0xF) << 2) | ((inBuf[2] & 0xC0) >>6)) & 0x3F];
      buf[3] = basis_64[inBuf[2] & 0x3F];
    }
  else if(theLength == 2)
    {
      buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
      buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((inBuf[1] & 0xF0) >> 4)) & 0x3F];
      buf[2] = basis_64[(((inBuf[1] & 0xF) << 2) | ((0 & 0xC0) >>6)) & 0x3F];
      buf[3] = '=';
    }
  else
    {
      buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
      buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((0 & 0xF0) >> 4)) & 0x3F];
      buf[2] = '=';
      buf[3] = '=';
    }
}
