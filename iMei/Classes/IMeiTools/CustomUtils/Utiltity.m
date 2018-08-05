//
//  Utiltity.m
//  wawaGame
//
// Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import "Utiltity.h"
#import "UIDevice+IdentifierAddition.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

static const char charTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

NSString* randomAsciiString(int len)
{
    NSMutableString*result=[[NSMutableString alloc] init];
    for (int i = 0; i < len; i++)
    {
        int randInt = (arc4random() % 62);
        [result appendFormat:@"%c",charTable[randInt]];
    }
    return  result;
}

NSString* GetAnimalYear(NSInteger year)
{
    if (year <= 0)
    {
        return  @"";
    }
    NSInteger start = 1972;
    NSInteger x = (start - year)>=0 ?((start - year) % 12):((start - year)%-12);
    
    NSString *TreeYear = @"鼠牛虎兔龙蛇马羊猴鸡狗猪";
    NSRange range;
    switch (x) {
        case 0:
        case -12:
            range =NSMakeRange(0, 1);
            break;
        case -1:
        case 11:
            range =NSMakeRange(1, 1);
            break;
        case -2:
        case 10:
            range =NSMakeRange(2, 1);
            break;
        case -3:
        case 9:
            range =NSMakeRange(3, 1);
            break;
        case -4:
        case 8:
            range =NSMakeRange(4, 1);
            break;
        case -5:
        case 7:
            range =NSMakeRange(5, 1);
            break;
        case -6:
        case 6:
            range =NSMakeRange(6, 1);
            break;
        case -7:
        case 5:
            range =NSMakeRange(7, 1);
            break;
        case -8:
        case 4:
            range =NSMakeRange(8, 1);
            break;
        case -9:
        case 3:
            range =NSMakeRange(9, 1);
            break;
        case -10:
        case 2:
            range =NSMakeRange(10, 1);
            break;
            
        case -11:
        case 1:
            range =NSMakeRange(11, 1);
            break;
        default:
            break;
    }
    return [TreeYear substringWithRange:range];
    
}

#pragma mark -
#pragma mark 蛙币等大数字显示格式化
#define s_qian  @"千"
#define s_wan   @"万"
#define s_yi    @"亿"
#define i_qian  1000
#define i_wan   10000
#define i_yi    100000000
NSString *qian_wan_yi_format(long long  _src_num){
    if (_src_num==0) {
        return @"0";
    }
    NSString *result = nil;
    float f_rs=0.0;
    long long  src_num = _src_num;
    while (src_num>=0) {
        if (src_num>=i_yi) {
            f_rs = (float)src_num/i_yi;
            if (src_num%i_yi>0) {
                result = [NSString stringWithFormat:@"%0.4f%@",f_rs,s_yi];
            }else {
                result = [NSString stringWithFormat:@"%0.0f%@",f_rs,s_yi];
            }
            break;
        }
        else if (src_num>=i_wan) {
            f_rs = (float)src_num/i_wan;
            if (src_num%i_wan>0) {
                result = [NSString stringWithFormat:@"%0.2f%@",f_rs,s_wan];
            }else {
                result = [NSString stringWithFormat:@"%0.0f%@",f_rs,s_wan];
            }
            break;
        }
        else if (src_num>=i_qian) {
            f_rs = (float)src_num/i_qian;
            if (src_num%i_qian>0) {
                result = [NSString stringWithFormat:@"%0.2f%@",f_rs,s_qian];
            }else {
                result = [NSString stringWithFormat:@"%0.0f%@",f_rs,s_qian];
            }
            break;
        }else {
            result = [NSString stringWithFormat:@"%lld", src_num];
            break;
        }
    }
    return result;
}

UIColor* colorWith16bit(NSString *color16) {
    if ([[color16 substringToIndex:1] isEqualToString:@"#"]) {  //兼容，设计师的ps软件，颜色值前面有一个#符号
        color16 = [color16 substringFromIndex:1];
    }
    
    unsigned int red=0, green=0, blue=0;  //生成颜色值
    NSRange range = NSMakeRange(0, 2);  //初始化范围值
    
    //取得red颜色
    range.location = 0;
    [[NSScanner scannerWithString:[color16 substringWithRange:range]] scanHexInt:&red];
    
    //取得green颜色
    range.location = 2;
    [[NSScanner scannerWithString:[color16 substringWithRange:range]] scanHexInt:&green];
    
    //取得blue颜色
    range.location = 4;
    [[NSScanner scannerWithString:[color16 substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

UIColor* colorWithRGB(int r, int g, int b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

NSString *getSIM_Info()
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *netWorkName = @"无";
    if (carrier != nil) {
        netWorkName = carrier.carrierName;
    }
    return netWorkName;
}


TelCarrierType getTelCarrierType()
{
    NSString *telCarrier = getSIM_Info();
//    //IMLOG(@"telCarrier=>%@", telCarrier);
    TelCarrierType telCarrierType = TelCarrier_unkown;
    if ([telCarrier isEqualToString:@"中国移动"]) {
        telCarrierType = TelCarrier_mobile;
    } else if ([telCarrier isEqualToString:@"中国联通"]) {
        telCarrierType = TelCarrier_unicom;
    } else if ([telCarrier isEqualToString:@"中国电信"]) {
        telCarrierType = TelCarrier_telecom;
    } else {
        telCarrierType = TelCarrier_telecom;
    }
//    //IMLOG(@"telCarrierType=>%d", telCarrierType);
    return telCarrierType;
}

NSString* bundlePath(NSString *fileName)
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

NSString *documentsPath(NSString *fileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

//获取当前时间
NSString* stringFromCurrentDate()
{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string  = [dateFormatter stringFromDate:date];
    return string;
}

//数字加逗号
NSString* numberStringWithComma(NSInteger num)
{
    NSString *number = [NSString stringWithFormat:@"%ld", num];
    NSString *numStr = @"";
    NSInteger count = 0;
    if (number.length > 3) {
        count = number.length / 3;
    }
    else
    {
        return number;
    }
    
    NSInteger noCommaLength = number.length % 3;
    NSString *noCommaStr = [number substringWithRange:NSMakeRange(0, noCommaLength)];
    if (noCommaStr) {
        numStr = [numStr stringByAppendingString:noCommaStr];
    }
    for (NSInteger i = 0; i < count; i++) {
        if (i == 0) {
            if (noCommaLength == 0) {
                NSString *withCommaStr = [number substringWithRange:NSMakeRange(noCommaLength + i *3, 3)];
                if (withCommaStr) {
                    numStr = [numStr stringByAppendingString:[NSString stringWithFormat:@"%@", withCommaStr]];
                }
                continue;
            }
        }
        
        NSString *withCommaStr = [number substringWithRange:NSMakeRange(noCommaLength + i *3, 3)];
        if (withCommaStr) {
            numStr = [numStr stringByAppendingString:[NSString stringWithFormat:@",%@", withCommaStr]];
        }
    }
    return numStr;
}

//去除字符串空格
NSString* stringWithoutSpace(NSString *str)
{
    if (str) {
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return str;
}

NSString* getImageName(NSString *aImgName)
{
    //    //IMLOG(@"getImageName aImgName=>%@", aImgName);
    NSArray *array = [aImgName componentsSeparatedByString:@"."];
    if (array && [array count] == 2) {
        NSString *name = [array objectAtIndex:0];
        NSString *suffix = [array objectAtIndex:1];
        NSString *imgName = [[NSBundle mainBundle] pathForResource:name ofType:suffix];
        return imgName;
    }
    return nil;
}


UIFont* getIMeiFont(int fontSize)
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

