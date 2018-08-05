//
//  ScreenAdaptationDefine.h    适配工具的宏定义
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//

//*************************适配工具的宏定义，详见ScreenAdaptationUtil文件实现************************

#define SCREEN_WIDTH_FIT    getScreenWidth()        //设备屏幕宽
#define SCREEN_HEIGHT_FIT   getScreenHeight()       //设备屏幕高
#define SCALE_W_H  0.9                              //iphone4相对iphone的缩放比

#define DEVICE_TYPE         getDeviceType()         //获取设备类型
#define posScaleX           getPosScaleX()          //获取设备屏幕宽相对于iphone5的比例值置
#define posScaleY           getPosScaleY()          //获取设备屏幕高相对于iphone5的比例值
#define scaleFor5           getScaleFor5()          //iphone5相对于iphone6_plus适配比例值

//Rect的通用适配宏定义(非iphone4设备，iphone4设备见下面)
#define commRect(x,y,w,h)   getAdaptationRect(x, y, w, h, 1)    //Rect的通用适配宏定义
#define commPoint(x,y)      getAdaptationPoint(x, y)            //Point的通用适配宏定义
#define commSize(w,h)       getAdaptationSize(w, h, 1)             //Size的通用适配宏定义
#define commEdgeInsets(top,left,bottom,right) getAdaptationEdgeInsets(top,left,bottom,right)


//针对iphone4的坐标：sx:宽高乘以的系数，范围在0.85~1.0之间
#define commRect4(x,y,w,h,scale)   getAdaptationRect(x, y, w, h ,scale)
#define commSize4(w,h,scale)       getAdaptationSize(w, h, scale)


#if  Ipad_Device  //ipad屏幕大小
#define SCREEN_WIDTH        768.0
#define SCREEN_HEIGHT       1024.0
#define muliteX             (SCREEN_WIDTH / 768.0)
#define sizeValue           2
#elif defined(Iphone_Device)    //ihone屏幕大小
//界面适配是基于iphone5分辨率尺寸的
#define SCREEN_WIDTH        320.0
#define SCREEN_HEIGHT       568.0
#endif

#define SCREEN_FRAME        getMainScreenFrame()                                //屏幕Frame
#define SCREEN_SIZE         CGSizeMake(SCREEN_WIDTH_FIT,SCREEN_HEIGHT_FIT)      //屏幕尺寸大小
#define SCREEN_CENTER       CGPointMake(SCREEN_WIDTH_FIT/2,SCREEN_HEIGHT_FIT/2) //屏幕中心点
#define FONT_SIZE(s)        getFontSize(s)          //系统文字大小宏定义;不同分辨率下的字段大小适配
#define FONT_SIZE2(s, p)    getFontSize2(s, p)          //系统文字大小宏定义;不同分辨率下的字段大小适配

#define isIphone4           (getDeviceType() == DEVICE_IPHONE4)     //是否是iphone4设备
#define isIpad              (getDeviceType() == DEVICE_IPAD)        //是否是ipad设备

//系统版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
