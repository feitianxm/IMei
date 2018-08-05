//
//  UILabel_WidthAndHeight.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/6/4.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabelWidthAndHeight)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
