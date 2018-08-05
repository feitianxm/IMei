//
//  Utiltity.h
//  wawaGame
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef enum {
    TelCarrier_unkown,  //未知运营商
    TelCarrier_mobile,  //移动
    TelCarrier_unicom,  //联通
    TelCarrier_telecom, //电信
} TelCarrierType;


NSString* randomAsciiString(int len);   //获取注册时的随时密码
NSString* GetAnimalYear(NSInteger year);    //获取年月日

uint32_t invert(uint32_t x);
NSString *formatBigNumber(NSString *bigNumString);
NSString *moneyCheeseFormatLongLong(long long num, BOOL isClip);
NSInteger sortProductWithMoney(id num1, id num2, void *context);
NSInteger sortGameZone(id num1, id num2, void *context);
NSInteger sortPokers(id num1, id num2, void *context);
UIColor* colorWith16bit(NSString *color16);
UIColor* colorWithRGB(int r, int g, int b);

NSString *getSIM_Info();
TelCarrierType getTelCarrierType();
NSString *qian_wan_yi_format(long long  _src_num);
NSString* bundlePath(NSString *fileName);
NSString *documentsPath(NSString *fileName);

//获取当前日期(yyyy-MM-dd)
NSString* stringFromCurrentDate();

//数字加逗号
NSString* numberStringWithComma(NSInteger num);

//去除字符串空格
NSString* stringWithoutSpace(NSString *str);

NSString* getImageName(NSString *aImgName);
UIFont* getIMeiFont(int fontSize);
