//
//  IMeiTopBannerView.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/16.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TYPE_ISSHOW,
    TYPE_ISHIDE,
    TYPE_NOTHING
}_BannerType;


@interface IMeiTopBannerView : NSObject
{
    UILabel         *msgLabel;					//banner里面显示的内容
    UIImageView     *bannerView;
    _BannerType     curBannerType;
    BOOL            isShown;
    BOOL            isRun;
    BOOL            isNeedShow;
    UIScrollView    *msgScrollView;
    NSString        *msgStr;
    
    int             a, b;                       //控制banner在旋转后要隐藏时的坐标
    UIInterfaceOrientation _orientation;		//banner当前的方向
}

@property (nonatomic,readwrite) BOOL isNeedShow;

+ (id)defaultBanner;

@end
