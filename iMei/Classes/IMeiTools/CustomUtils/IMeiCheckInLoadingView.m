//
//  IMeiCheckInLoadinView.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/16.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiCheckInLoadingView.h"
#import "AppDelegate.h"

@interface IMeiCheckInLoadingView ()
{
    UIImageView *loadingImgView;
    UILabel     *descLabel;
}

@end

@implementation IMeiCheckInLoadingView

- (id)init
{
    CGRect rect = commRect(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    if(self = [super initWithFrame:rect])
    {
        self.backgroundColor = colorWith16bit(@"#0778E5");;
        
        UIView *loadingView = [[UIView alloc] initWithFrame:commRect(0,280,SCREEN_WIDTH,600)];
        [self addSubview:loadingView];
        
        loadingImgView = [[UIImageView alloc] initWithFrame:commRect((SCREEN_WIDTH-150)/2.0, 10, 150, 150)];
        loadingImgView.image = [UIImage imageNamed:@"checkIn_loading.png"];
        [loadingView addSubview:loadingImgView];
        [self startLoadingAnimation];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:commRect(50, 260,SCREEN_WIDTH-100,25)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 2;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = IMFont(FONT_SIZE(21));
        textLabel.text = @"正在进行准入检查...";
        [loadingView addSubview:textLabel];
        
        
        descLabel = [[UILabel alloc] initWithFrame:commRect(50,300,SCREEN_WIDTH-100,40)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.numberOfLines = 2;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.textColor = [UIColor whiteColor];
        descLabel.font = IMFont(FONT_SIZE(13));
//        descLabel.text = text;
        [loadingView addSubview:descLabel];
        
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenLoading) withObject:nil afterDelay:5];
        
    }
    return self;
}

/*! @brief 把自己加载到Window的rootViewController.view 上面，防止因屏幕旋转，弹框不能旋转
 */
- (void)showCheckInLoadinView
{
//    IMeiCheckInLoadinView *loading = [ [IMeiCheckInLoadinView alloc] initWithText:text];
    UIView *rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    [rootView addSubview:self];
    [rootView bringSubviewToFront:self];
    //IMLOG(@"showCheckInLoadinView...loading=>%@", self);
}

- (void)updateShowProcessWithText:(NSString*)text
{
    //IMLOG(@"updateShowProcessWithText text...");
    descLabel.text = text;
}


- (void)hiddenLoading
{
    UIView *rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    for(UIView *view in rootView.subviews)
    {
        if([view isKindOfClass: [IMeiCheckInLoadingView class]])
        {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)startLoadingAnimation
{
    //IMLOG(@"startLoadingAnimation...");
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.2f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [loadingImgView.layer addAnimation:rotationAnimation forKey:@"checkInLoadinAnimationKey"];
}

- (void)dealloc
{
    //IMLOG(@"IMeiCheckInLoadingView dealloc...");
}

@end
