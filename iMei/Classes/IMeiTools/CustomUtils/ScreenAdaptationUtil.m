//
//  ScreenAdaptationUtil.m
//  wawaGame
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import "ScreenAdaptationUtil.h"


IOSDeviceType getDeviceType()
{
    IOSDeviceType deviceType;// = DEVICE_IPAD;
    if (Iphone_Device) {
        deviceType = DEVICE_IPHONE4;
    }
//    //IMLOG(@"getDeviceType SCREEN_WIDTH=>%f %f %d", SCREEN_WIDTH_FIT, SCREEN_HEIGHT_FIT, SCREEN_WIDTH_FIT==768);
    if (SCREEN_WIDTH_FIT == 320 && SCREEN_HEIGHT_FIT == 480) {
        deviceType = DEVICE_IPHONE4;
    }
    else if (SCREEN_WIDTH_FIT == 320 && SCREEN_HEIGHT_FIT == 568) {
        deviceType = DEVICE_IPHONE5;
    }
    else if (SCREEN_WIDTH_FIT == 375 && SCREEN_HEIGHT_FIT == 667) {
        deviceType = DEVICE_IPHONE6;
    }
    else if (SCREEN_WIDTH_FIT == 414 && SCREEN_HEIGHT_FIT == 736) {
        deviceType = DEVICE_IPHONE6_PLUS;
    }
    else if ((SCREEN_WIDTH_FIT == 768 && SCREEN_HEIGHT_FIT == 1024)) {
        deviceType = DEVICE_IPAD;
    }
    else if (SCREEN_WIDTH_FIT == 1024 && SCREEN_HEIGHT_FIT == 1366)
    {
        deviceType = DEVICE_IPAD_PRO;
    }
//    //IMLOG(@"getDeviceType deviceType=>%d", deviceType);
    return deviceType;
}

float getScaleFor5()
{
    return 1136.0/1920.0;
}

float getPosScaleX()
{
    float scale = 1;
    
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            scale = 480/568.0;
            break;
        case DEVICE_IPHONE5:
            scale = 568/568.0;
            break;
        case DEVICE_IPHONE6:
            scale = 667/568.0;
            break;
        case DEVICE_IPHONE6_PLUS:
            scale = 736/568.0;
            break;
        case DEVICE_IPAD_PRO:
            scale = 1.333;
            break;
        default:
            break;
    }
    return scale;
}

float getPosScaleY()
{
    float scale = 1;
    
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            scale = 320/320.0;
            break;
        case DEVICE_IPHONE5:
            scale = 320/320.0;
            break;
        case DEVICE_IPHONE6:
            scale = 375/320.0;
            break;
        case DEVICE_IPHONE6_PLUS:
            scale = 414/320.0;
            break;
        case DEVICE_IPAD_PRO:
            scale = 1.333;
            break;
        default:
            break;
    }
    return scale;
}

CGFloat getFontSize(int aSize)
{
    int result = aSize;
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            result = aSize-2;
            break;
        case DEVICE_IPHONE5:
            result = aSize;
            break;
        case DEVICE_IPHONE6:
            result = aSize+2;
            break;
        case DEVICE_IPHONE6_PLUS:
            result = aSize+4;
            break;
        case DEVICE_IPAD:
            result = aSize;
            break;
        case DEVICE_IPAD_PRO:
            result = aSize*1.333;
            break;
        default:
            break;
    }
    return result;
}


CGFloat getFontSize2(int aSize, int padSize)
{
    int result = aSize;
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            result = aSize-2;
            break;
        case DEVICE_IPHONE5:
            result = aSize;
            break;
        case DEVICE_IPHONE6:
            result = aSize+2;
            break;
        case DEVICE_IPHONE6_PLUS:
            result = aSize+4;
            break;
        case DEVICE_IPAD:
            result = padSize;
            break;
        case DEVICE_IPAD_PRO:
            result = padSize*1.333;
            break;
        default:
            break;
    }
    return result;
}

CGRect getMainScreenFrame()
{
    CGRect mainFrame = CGRectMake(0, 0, SCREEN_WIDTH_FIT, SCREEN_HEIGHT_FIT);
    return mainFrame;
}

CGRect getAdaptationRect(float x, float y, float w, float h, float scale)
{
    CGRect rect = CGRectMake(x, y, w, h);
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
//            rect = CGRectMake((x)*getPosScaleX(), y, (w)*getPosScaleX(), h);
            rect = CGRectMake(x, y, (w)*(scale), (h)*(scale));
            break;
        case DEVICE_IPHONE5:
            rect = CGRectMake(x, y, w, h);
            break;
        case DEVICE_IPHONE6:
            rect = CGRectMake((x)*getPosScaleX(), (y)*getPosScaleY(), (w)*getPosScaleX(), (h)*getPosScaleY());
            break;
        case DEVICE_IPHONE6_PLUS:
            rect = CGRectMake((x)*getPosScaleX(), (y)*getPosScaleY(), (w)*getPosScaleX(), (h)*getPosScaleY());
            break;
        case DEVICE_IPAD:
            rect = CGRectMake(x, y, w, h);
            break;
        case DEVICE_IPAD_PRO:
            rect = CGRectMake(x*1.333, y*1.333, w*1.333, h*1.333);
            break;
        default:
            break;
    }
    return rect;
}

///**
// sx:宽高乘以的系数，在0.85~1.0之间
// */
//CGRect getAdaptationRect4(float x, float y, float w, float h,float scale){
//    CGRect rect = CGRectMake(x, y, (w)*(scale), (h)*(scale));
//    return rect;
//}


CGPoint getAdaptationPoint(float x, float y)
{
    CGPoint point = CGPointMake(x, y);
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            point = CGPointMake((x)*getPosScaleX(), y);
            break;
        case DEVICE_IPHONE5:
            point = CGPointMake(x, y);
            break;
        case DEVICE_IPHONE6:
            point = CGPointMake((x)*getPosScaleX(), (y)*getPosScaleY());
            break;
        case DEVICE_IPHONE6_PLUS:
            point = CGPointMake((x)*getPosScaleX(), (y)*getPosScaleY());
            break;
        case DEVICE_IPAD:
            point = CGPointMake(x, y);
            break;
        case DEVICE_IPAD_PRO:
            point = CGPointMake(x*1.333, y*1.333);
            break;
        default:
            break;
    }
    return point;
}

CGSize getAdaptationSize(float w, float h, float scale)
{
    CGSize size = CGSizeMake( w, h);
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
//            size = CGSizeMake(w*getPosScaleX(), h);
            size = CGSizeMake((w)*(scale), (h)*(scale));
            break;
        case DEVICE_IPHONE5:
            size = CGSizeMake(w, h);
            break;
        case DEVICE_IPHONE6:
            size = CGSizeMake(w*getPosScaleX(), h*getPosScaleY());
            break;
        case DEVICE_IPHONE6_PLUS:
            size = CGSizeMake(w*getPosScaleX(), h*getPosScaleY());
            break;
        case DEVICE_IPAD:
            size = CGSizeMake(w, h);
            break;
        case DEVICE_IPAD_PRO:
            size = CGSizeMake(w*1.333, h*1.333);
            break;
        default:
            break;
    }
    return size;
}

//CGSize getAdaptationSize4(float w, float h, float scale)
//{
//    CGSize size = CGSizeMake((w)*(scale), (h)*(scale));
//    return size;
//}

UIEdgeInsets getAdaptationEdgeInsets(float top, float left, float bottom, float right)
{
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    IOSDeviceType deviceType = getDeviceType();
    switch (deviceType) {
        case DEVICE_IPHONE4:
            insets = UIEdgeInsetsMake(top, (left)*getPosScaleX(), bottom, (right)*getPosScaleX());
            break;
        case DEVICE_IPHONE5:
            insets = UIEdgeInsetsMake(top, left, bottom, right);
            break;
        case DEVICE_IPHONE6:
            insets = UIEdgeInsetsMake((top)*getPosScaleY(), (left)*getPosScaleX(), (bottom)*getPosScaleY(), (right)*getPosScaleX());
            break;
        case DEVICE_IPHONE6_PLUS:
            insets = UIEdgeInsetsMake((top)*getPosScaleY(), (left)*getPosScaleX(), (bottom)*getPosScaleY(), (right)*getPosScaleX());
            break;
        case DEVICE_IPAD:
            insets = UIEdgeInsetsMake(top, left, bottom, right);
            break;
        case DEVICE_IPAD_PRO:
            insets = UIEdgeInsetsMake(top*1.333, left*1.333, bottom*1.333, right*1.333);
            break;
        default:
            break;
    }
    
    return insets;
}

CGFloat getScreenWidth()
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    if(w < h)
    {
        return w;
    }
    return h;
}
CGFloat getScreenHeight()
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    if(h > w)
    {
        return h;
    }
    return w;
}
