//
//  IMeiTabBarViewController.h
//  iMei
//
//  Created by Chengfei Liang on 2018/8/3.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMeiTabBarControllerDelegate <NSObject>

@optional
-(void)xm_selectedViewController:(UIViewController *)viewController;
@end




@interface IMeiTabBarViewController : UITabBarController


@property (nonatomic, assign) NSInteger selectedItem;

/** 是否显示中间按钮，默认为NO */
@property (nonatomic, assign) BOOL showCenterItem;

/** 中间按钮的图片 */
@property (nonatomic, strong) UIImage *centerItemImage;

/** 中间按钮控制的试图控制器 */
@property (nonatomic, strong) UIViewController *centerViewController;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, weak) id<IMeiTabBarControllerDelegate>XMDelegate;


/**
 *  指定item设置badgeValue
 */
-(void)tabBarBadgeValue:(NSUInteger)value item:(NSInteger)index;

/**
 *  隐藏或显示TabBar
 */
-(void)xmTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *  隐藏或显示中间试图控制器
 */
-(void)showCenterViewController:(BOOL)show animated:(BOOL)animated;

@end
