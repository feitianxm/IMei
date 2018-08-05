//
//  IMeiLoadingView.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/13.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LoadinTime      10

@interface IMeiLoadingView : UIView

+ (void)showWithText:(NSString *)text timeOut:(int)second isTop:(BOOL)isTop;

+ (void)hiddenLoading;


@end
