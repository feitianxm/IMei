//
//  IMeiBaseAlertView.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiBaseAlertView.h"
#import "AppDelegate.h"

@implementation IMeiBaseAlertView

/*! @brief 把自己加载到Window的rootViewController.view 上面，防止因屏幕旋转，弹框不能旋转
 */
-(void)show
{
    UIView *rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    //IMLOG(@"rootView.bounds=>%@",NSStringFromCGRect(rootView.bounds));
    UIImageView *backgroundMask = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    backgroundMask.image = [self backgroundGradientImageWithSize:rootView.bounds.size];
    backgroundMask.userInteractionEnabled = YES;
    [rootView addSubview:backgroundMask];
    self.center = backgroundMask.center;
    [backgroundMask addSubview:self];
    [self performPresentationAnimation];
}

-(void)showWithNotAnimation
{
    UIView*rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    for(UIView* view in rootView.subviews)
    {
        for(UIView*subView in view.subviews)
        {
            if([subView  isKindOfClass: [IMeiBaseAlertView class]])
            {
                [subView.superview removeFromSuperview];
                [subView removeFromSuperview];
            }
        }
    }
    //IMLOG(@"rootView.bounds=>%@",NSStringFromCGRect(rootView.bounds));
    UIImageView *backgroundMask = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    //    backgroundMask.image = [self backgroundGradientImageWithSize:rootView.bounds.size];
    backgroundMask.userInteractionEnabled = YES;
    [rootView addSubview:backgroundMask];
    self.center = backgroundMask.center;
    [backgroundMask addSubview:self];
    [self performPresentationAnimation2];
}


- (UIImage *)backgroundGradientImageWithSize:(CGSize)size
{
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    CGFloat innerRadius = 0;
    CGFloat outerRadius = sqrtf(size.width * size.width + size.height * size.height) * 0.5;
    
    BOOL opaque = NO;
    UIGraphicsBeginImageContextWithOptions(size, opaque, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const size_t locationCount = 2;
    CGFloat locations[locationCount] = { 0.0, 1.0 };
    CGFloat components[locationCount * 4] = {
        0.0, 0.0, 0.0, 0.1, // More transparent black
        0.0, 0.0, 0.0, 0.7  // More opaque black
    };
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, locationCount);
    
    CGContextDrawRadialGradient(context, gradient, center, innerRadius, center, outerRadius, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    return image;
}


- (void)performPresentationAnimation2
{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.superview.layer addAnimation:fadeInAnimation forKey:@"opacity"];
}


- (void)performPresentationAnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.01],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [self.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.superview.layer addAnimation:fadeInAnimation forKey:@"opacity"];
}

-(void)dismiss
{
    UIView*rootView = ((AppDelegate*)[UIApplication sharedApplication].delegate).rootVC.view;
    self.hidden = YES;
    for(UIView* view in rootView.subviews)
    {
        for(UIView*subView in view.subviews)
        {
            if([subView  isKindOfClass: [IMeiBaseAlertView class]])
            {
                [subView.superview removeFromSuperview];
                [subView removeFromSuperview];
            }
        }
    }
}

- (void)dealloc
{
    //IMLOG(@"IMeiBaseAlertView dealloc...");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end
