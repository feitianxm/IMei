//
//  ScreenAdaptationUtil.h
//  wawaGame
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    DEVICE_IPHONE4,
    DEVICE_IPHONE5,
    DEVICE_IPHONE6,
    DEVICE_IPHONE6_PLUS,
    DEVICE_IPAD,
    DEVICE_IPAD_PRO,
}IOSDeviceType;     //设备类型

IOSDeviceType getDeviceType();  //获取设备类型
float getPosScaleX();           //获取设备屏幕宽相对于iphone5的比例值
float getPosScaleY();           //获取设备屏幕高相对于iphone5的比例值
float getScaleFor5();           //iphone5相对于iphone6_plus适配比例值

CGRect  getMainScreenFrame();    //获取设备全屏Frame
CGRect  getAdaptationRect(float x, float y, float w, float h, float scale);
CGPoint getAdaptationPoint(float x, float y);
CGSize  getAdaptationSize(float w, float h, float scale);
//CGRect  getAdaptationRect4(float x, float y, float w, float h,float scale);
//CGSize  getAdaptationSize4(float w, float h, float scale);
UIEdgeInsets getAdaptationEdgeInsets(float top, float left, float bottom, float right);

CGFloat getFontSize(int aSize);
CGFloat getFontSize2(int aSize, int padSize);
CGFloat getScreenWidth();
CGFloat getScreenHeight();
