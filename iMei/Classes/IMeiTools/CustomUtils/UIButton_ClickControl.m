//
//  UIButton_ClickControl.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/30.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "UIButton_ClickControl.h"
#import <objc/runtime.h>


static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

@implementation UIControl (IMei)

//@synthesize uxy_acceptEventInterval;

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
//    if (NSDate.date.timeIntervalSince1970 - self.uxy_acceptedEventTime < 1.0)
//    {
//        return;
//    }
//    
//    if (self.uxy_acceptEventInterval > 0)
//    {
//        self.uxy_acceptedEventTime = NSDate.date.timeIntervalSince1970;
//    }
    
    [self __uxy_sendAction:action to:target forEvent:event];
}

//- (NSTimeInterval)uxy_acceptedEventTime
//{
//    return NSDate.date.timeIntervalSince1970;
//}

- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
