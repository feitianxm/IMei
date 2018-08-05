//
//  IMeiTabBarView.h
//  iMei
//
//  Created by Chengfei Liang on 2018/8/4.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IMeiTabBarViewDelegate <NSObject>

-(void)tabBarViewSelectedItem:(NSInteger)index;
-(void)tabBarViewCenterItemClick:(UIButton *)button;

@end

@interface IMeiTabBarView : UIView

@property (nonatomic, strong) UIImage * backgroundImage;
@property (nonatomic, strong) UIImage * centerImage;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, assign) NSUInteger badgeValue;
@property (nonatomic, assign) NSInteger itemSelectedIndex;
@property (nonatomic, strong) UIButton * centerButton;
@property (nonatomic, assign) BOOL showCenter;

@property (nonatomic, weak) id<IMeiTabBarViewDelegate>delegate;

- (id)initWithItemSelectedImages:(NSMutableArray *)selected
                    normalImages:(NSMutableArray *)normal
                          titles:(NSMutableArray *)titles;
-(void)tabBarBadgeValue:(NSUInteger)value item:(NSInteger)index;

@end


@interface IMeiButton : UIButton

@property (nonatomic, assign) NSUInteger badgeValue;
+ (instancetype)imei_shareButton;

@end


