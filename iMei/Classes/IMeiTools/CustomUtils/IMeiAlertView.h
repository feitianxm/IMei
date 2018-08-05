//
//  IMeiAlertView.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiBaseAlertView.h"

@interface IMeiAlertView : IMeiBaseAlertView


- (id)initWithTitle:(NSString*)title
            message:(NSString*)msg
      textAlignment:(NSTextAlignment)alignment
           delegate:(id)target
    confirmCallBack:(SEL)confirm;

- (id)initWithTitle:(NSString*)title
            message:(NSString*)msg
      textAlignment:(NSTextAlignment)alignment
           delegate:(id)target
     cancleCallBack:(SEL)cancle
    confirmCallBack:(SEL)confirm;

@end
