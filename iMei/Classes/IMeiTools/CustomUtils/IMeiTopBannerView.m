//
//  IMeiTopBannerView.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/16.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiTopBannerView.h"
#import "QuartzCore/QuartzCore.h"
#import "UILabel_WidthAndHeight.h"

//时间
#define SCROLL_TIME 2.4
#define SHOW_TIME 4.0


#define Lable_Width SCREEN_WIDTH    //400
#define Lable_Height 60.0f   //一行文字的高度
#define BannerView_Frame    commRect(0, 0, SCREEN_WIDTH, 64)
#define MsgScrollView_Frame commRect((SCREEN_WIDTH-Lable_Width)/2.0, 0, Lable_Width, 64)
#define FontSize 15.0
#define A_Right 0.0
#define B_Right 23
#define A_Left 320
#define B_Left -13
#define BannerView_Y SCREEN_WIDTH/2.0
#define Lable_Offset_Y 1

#define BannerView_Y_New8 -8
#define BannerView_X_New8 SCREEN_WIDTH/2.0


@interface IMeiTopBannerView ()

- (void)addObservers;
- (void)removeObservers;
- (void)positionToFitOrientation;
- (void)showAnimation;
- (void)hideAnimation;

@end


@implementation IMeiTopBannerView


@synthesize isNeedShow;

+ (id)defaultBanner{
    static IMeiTopBannerView *singleton = nil;
    @synchronized(self){
        if(singleton == nil){
            singleton = [[[self class] alloc] init];
        }
    }
    return singleton;
}

- (void)prepareToShow {
    UIApplication *app = [UIApplication sharedApplication];
    switch (app.statusBarOrientation) {
        case UIDeviceOrientationLandscapeRight:	//2
            bannerView.layer.transform = CATransform3DIdentity;
            bannerView.layer.transform = CATransform3DMakeRotation(-M_PI/2, 0, 0, 1);
            a=A_Right;
            b=B_Right;
            bannerView.center = CGPointMake(a+b, BannerView_Y);
            break;
        case UIDeviceOrientationLandscapeLeft:	//3
            bannerView.layer.transform = CATransform3DIdentity;
            bannerView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
            a=A_Left;
            b=B_Left;
            bannerView.center = CGPointMake(a+b-2, BannerView_Y);
            break;
        default:
            break;
    }
    _orientation = app.statusBarOrientation;
    bannerView.center = CGPointMake(a-b, BannerView_Y*posScaleX);
    //IMLOG(@"bannerView.center=>%@ BannerView_Y*posScaleX=>%f", NSStringFromCGPoint(bannerView.center), BannerView_Y*posScaleX);
    if (isRun)
    {
        msgScrollView.contentOffset = CGPointMake(0, 0);
    }
}


- (void)prepareToShowNew8 {
    UIApplication *app = [UIApplication sharedApplication];
    switch (app.statusBarOrientation) {
        case UIDeviceOrientationLandscapeRight:	//2
            bannerView.layer.transform = CATransform3DIdentity;
            break;
        case UIDeviceOrientationLandscapeLeft:	//3
            bannerView.layer.transform = CATransform3DIdentity;
            break;
        default:
            break;
    }
    _orientation = app.statusBarOrientation;
    bannerView.center = commPoint(BannerView_X_New8, BannerView_Y_New8);
    //IMLOG(@"bannerView.center=》%@", NSStringFromCGPoint(bannerView.center));
    if (isRun)
    {
        msgScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (id)init{
    if (self = [super init]) {
        CGRect frame;
        if (isIphone4) {
            frame = commRect4(0, 0, 410, 44, 1);
        } else {
            frame = BannerView_Frame;
        }
        
        //bannerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Banner_BGImg.png"]];//346 46
        bannerView = [[UIImageView alloc] initWithFrame:frame];
        bannerView.backgroundColor = [UIColor blackColor];
        bannerView.alpha = 0.8f;
//        bannerView.image = [UIImage imageNamed:@"comm_bannerBg.png"];
        
        msgScrollView = [[UIScrollView alloc] initWithFrame:MsgScrollView_Frame];
        msgLabel = [[UILabel alloc] initWithFrame:commRect(0, 10, SCREEN_WIDTH, Lable_Height)];
//        msgLabel.backgroundColor = [UIColor redColor];
        msgLabel.font = [UIFont boldSystemFontOfSize:FontSize];
        msgLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.numberOfLines = 3;
        [msgScrollView addSubview:msgLabel];
        [bannerView addSubview:msgScrollView];
//        msgScrollView.backgroundColor = [UIColor grayColor];
//        msgScrollView.hidden = YES;
        isRun = NO;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:bannerView];
        [self positionToFitOrientation];
        [self addObservers];
        [self selectVersionShow];
        bannerView.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

-(void)startAnimating:(NSNumber *)animateTimes
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimation) object:nil];
    [UIView	beginAnimations:nil context:nil];
    [UIView	setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView	setAnimationDuration:0.8f];
    isRun = YES;
    msgScrollView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
    
    if ([animateTimes intValue] > 2) {  //超过两行，不止进行一次动画
        animateTimes = [NSNumber numberWithInt:[animateTimes intValue] - 1];
        [self performSelector:@selector(startAnimating:) withObject:animateTimes afterDelay:SCROLL_TIME];
    }
    else {  //两行，只需1次动画
        [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:SHOW_TIME];
    }
}

- (void)selectVersionShow {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self prepareToShowNew8];
    } else {
        [self prepareToShow];
    }
}

- (void)showAnimation{
    [self selectVersionShow];
    //IMLOG(@"showAnimation start");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        bannerView.center = commPoint(BannerView_X_New8, BannerView_Y_New8+40);
    } else {
        bannerView.center = CGPointMake(a+b-5, BannerView_Y*posScaleX);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    //    bannerView.center = CGPointMake(a+b-5, BannerView_Y); //xcode5
    [UIView commitAnimations];
    curBannerType = TYPE_ISSHOW;
    isShown = YES;
    isRun = NO;
    
    // 计算消息的长度
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CGFloat width = [UILabel getHeightByWidth:(SCREEN_WIDTH-30) title:msgStr font:IMFont(FONT_SIZE(13))];
//    CGFloat width = [msgStr sizeWithFont:[UIFont boldSystemFontOfSize:FontSize]].width;
    NSInteger intWidth = (NSInteger)width + 1;
    NSInteger lableWidth = (NSInteger)Lable_Width;
    NSInteger lineNumber = intWidth / lableWidth;
    if (0 != intWidth % lableWidth) {
        // 需要的label 的行数
        lineNumber +=1;
    }
    
    //    下面这种方法也是可行的
    //    CGSize textSize = [msgStr sizeWithFont:[UIFont systemFontOfSize:FontSize]
    //                      constrainedToSize:CGSizeMake(Lable_Width,320)
    //                          lineBreakMode:UILineBreakModeWordWrap];
    //    CGFloat height = [msgStr sizeWithFont:[UIFont boldSystemFontOfSize:FontSize]].height;
    //    NSInteger lineNumber = textSize.height / height;
    
//    msgLabel.numberOfLines = lineNumber;
//    msgLabel.frame =  CGRectMake(0,Lable_Offset_Y, lableWidth, Lable_Height*lineNumber);
    msgLabel.text = msgStr;
    msgScrollView.contentOffset = CGPointMake(0, 0);
    
    //IMLOG(@"showAnimation start  2");
    [self startAnimating:[NSNumber numberWithInt:lineNumber]];
    
    //IMLOG(@"showAnimation end");
}

- (void)hideAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        bannerView.center = commPoint(BannerView_X_New8, BannerView_Y_New8);
    } else {
        bannerView.center = CGPointMake(a-b, BannerView_Y*posScaleX);
    }
    //    bannerView.center = CGPointMake(a-b, BannerView_Y); //xcode5
    [UIView commitAnimations];
    curBannerType = TYPE_ISHIDE;
    isShown = NO;
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight;
    }
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        _orientation = orientation;
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        _orientation = orientation;
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)positionToFitOrientation{
    if (_orientation == UIInterfaceOrientationLandscapeLeft) {
        a=A_Left;
        b=B_Left;
        if (_orientation == UIInterfaceOrientationLandscapeLeft && isShown) {
            b -= 4;
        }
        bannerView.center = CGPointMake(a+b, BannerView_Y);
    }else if (_orientation == UIInterfaceOrientationLandscapeRight) {
        a=A_Right;
        b=B_Right;
        if (_orientation == UIInterfaceOrientationLandscapeRight && isShown) {
            b -= 4;
        }
        bannerView.center = CGPointMake(a+b, BannerView_Y);
    }
    bannerView.transform = [self transformForOrientation];
}

- (void)deviceOrientationDidChange:(void*)object {
    UIInterfaceOrientation  orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( isShown && [self shouldRotateToOrientation:orientation]) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:[NSString stringWithFormat:@"%d", curBannerType] context:nil];
        [UIView setAnimationDuration:2*duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(rotationDidStop:finished:context:)];
        [self positionToFitOrientation];
        [UIView commitAnimations];
    }
}

- (void)willShowBannerWithMsg:(NSNotification*)message
{
    NSString *str = [message object];
    //IMLOG(@"willShowBannerWithMsg str=>%@ isNeedShow=>%d", str, isNeedShow);
    
    if (!isNeedShow) {
        return;
    }
    
    msgStr = [str copy];
    bannerView.hidden = NO;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self showAnimation];
    });
}

- (void)hiddenBannerWithMsg:(NSNotification*)message{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    bannerView.hidden = YES;
}

#pragma mark animation didstop delegate
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    //IMLOG(@"animation Did Stop %d", curBannerType);
    curBannerType = TYPE_NOTHING;
    if (!isShown) {
        bannerView.hidden = YES;
    }
}
- (void)rotationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    //IMLOG(@"rotation stop %@", animationID);
    int type = [animationID intValue];
    switch (type) {
        case TYPE_ISHIDE:
            [self hideAnimation];
            break;
        case TYPE_ISSHOW:
            [self showAnimation];
            break;
        default:
            break;
    }
}

#pragma mark observer
- (void)addObservers
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(willShowBannerWithMsg:)
//                                                 name:LGS_Banner_Msg_Key
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hiddenBannerWithMsg:)
//                                                 name:LGS_Hidden_Banner_Msg_Key
//                                               object:nil];
}
- (void)removeObservers
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:LGS_Banner_Msg_Key
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:LGS_Hidden_Banner_Msg_Key
//                                                  object:nil];
}

@end
