//
//  IMeiLoadingView.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/13.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiLoadingView.h"
#import "AppDelegate.h"

@implementation IMeiLoadingView


- (id)initWithText:(NSString *)text timeOut:(int)time isHaveMask:(BOOL)isMask isTop:(BOOL)isTop
{
    CGRect rect;
    if (isTop) {
        rect = commRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
        rect = commRect(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    }
    if(self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        
        if (isMask)
        {
            UIImageView *mask = [[UIImageView alloc] initWithFrame:rect];
            mask.alpha = 0.15;
            mask.backgroundColor = [UIColor blackColor];
            [self addSubview:mask];
        }
        
        float tempY = 0;
        if (isTop) {
            tempY = 44;
        }
        
        
        
        UIView *loadingView = [[UIView alloc] initWithFrame:commRect(0,(SCREEN_HEIGHT/2.0)+tempY,SCREEN_WIDTH,100)];
        [self addSubview:loadingView];
        loadingView.center = SCREEN_CENTER;
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:commRect((SCREEN_WIDTH-30)/2.0, 20, 30, 30)];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [loadingView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:commRect(50,50,SCREEN_WIDTH-100,40)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 2;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = IMFont(FONT_SIZE(16));
        textLabel.text = text;
        [loadingView addSubview:textLabel];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
         [IMeiLoadingView performSelector:@selector(hiddenLoading) withObject:nil afterDelay:time];
        
    }
    return self;
}

- (id)initSmallWithOrigin:(CGPoint)point time:(int)time
{
    CGRect rect = CGRectMake(point.x, point.y, 40*posScaleY, 40*posScaleY);
    
    if(self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *loadingView = [[UIView alloc] initWithFrame:commRect(0,0,40,40)];
        loadingView.backgroundColor = [UIColor clearColor];
        [self addSubview:loadingView];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
         [IMeiLoadingView performSelector:@selector(hiddenLoading) withObject:nil afterDelay:time];
        
    }
    return self;
}

/*! @brief 把自己加载到Window的rootViewController.view 上面，防止因屏幕旋转，弹框不能旋转
 */
+ (void)showWithText:(NSString *)text timeOut:(int)second isTop:(BOOL)isTop
{
    IMeiLoadingView *loading = [ [IMeiLoadingView alloc] initWithText:text timeOut:second isHaveMask:YES isTop:isTop];
    UIView *rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    [rootView addSubview:loading];
    [rootView bringSubviewToFront:loading];
    //IMLOG(@"IMeiLoadingView showWithText...loading=>%@", loading);
}

+ (void)hiddenLoading
{
    UIView *rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    for(UIView *view in rootView.subviews)
    {
        if([view isKindOfClass: [IMeiLoadingView class]])
        {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //IMLOG(@"IMeiLoadingView dealloc...");
}

@end
