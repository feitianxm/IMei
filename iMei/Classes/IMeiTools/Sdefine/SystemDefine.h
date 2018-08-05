//
//  SystemDefine.h  IOS系统级的自定义的宏定义
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016年 i美. All rights reserved.
//


//判断是否高清设备
#define isRetina    [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0

//多语言
#define LocStr(key) NSLocalizedString(key, @"")

//自定义日志输出
#if DEBUG_MODEL
#define IMLOG( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#define IMLOG( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#endif

//int 转换成 String
#define INT_TOSTRING(__x__) [NSString stringWithFormat:@"%d",__x__]

//资源图片名
#define IMAGENAME(n)     getImageName(n)

//字体Font
#define IMFont(s)        getIMeiFont(s)
