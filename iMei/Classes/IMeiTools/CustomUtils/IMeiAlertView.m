//
//  IMeiAlertView.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiAlertView.h"
#import "Utiltity.h"

@interface IMeiAlertView()
{
    id          myTarget;
    SEL         confirmSelector;
    SEL         cancleSelector;
    UITextView  *textView;
}
@end

@implementation IMeiAlertView


- (id)initWithTitle:(NSString*)title
            message:(NSString*)msg
      textAlignment:(NSTextAlignment)alignment
           delegate:(id)target
    confirmCallBack:(SEL)confirm
{
    if(self = [super initWithFrame:commRect(0, 0, 388, 225)])
    {
        [self setTitle:title
               message:msg
         textAlignment:alignment
              delegate:target
     cancelButtonTitle:nil
    confirmButtonTitle:nil
        cancleCallBack:nil
       confirmCallBack:confirm
               btnsNum:1];
    }
    return self;
}

- (id)initWithTitle:(NSString*)title
            message:(NSString*)msg
      textAlignment:(NSTextAlignment)alignment
           delegate:(id)target
     cancleCallBack:(SEL)cancle
    confirmCallBack:(SEL)confirm
{
    if(self = [super initWithFrame:commRect(0, 0, 388, 225)])
    {
        [self setTitle:title
               message:msg
         textAlignment:alignment
              delegate:target
     cancelButtonTitle:nil
    confirmButtonTitle:nil
        cancleCallBack:cancle
       confirmCallBack:confirm
               btnsNum:2];
    }
    return self;
}


- (void)setTitle:(NSString*)title
         message:(NSString*)msg
   textAlignment:(NSTextAlignment)alignment
        delegate:(id)target
cancelButtonTitle:(NSString*)cancleButtonTitle
confirmButtonTitle:(NSString*)confirmButtonTitle
  cancleCallBack:(SEL)cancle
 confirmCallBack:(SEL)confirm
         btnsNum:(int)num

{
    //IMLOG(@"WWAlertView:: title:%@  message:%@",title,msg);
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView * backgroundImageView = nil;
    backgroundImageView = [[UIImageView alloc] initWithFrame:commRect(0, 0, 388,225)];
    backgroundImageView.image = [UIImage imageNamed:@"comm_smallBG.png"];
    backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundImageView];
    
    myTarget = target;
    confirmSelector = confirm;
    cancleSelector = cancle;
    
    UILabel*titleLabel = nil;
    titleLabel = [[UILabel alloc] initWithFrame:commRect(94,2,200,40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE(20)];
    titleLabel.textColor = colorWith16bit(@"f8edbf");    //[ColorUtil hexStringToUIColor:@"0xf8edbf"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    textView = [[UITextView alloc] initWithFrame:commRect(20,48,348,120)];
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = alignment;
    textView.editable = NO;
    if(SYSTEM_VERSION_GREATER_THAN(@"7.0"))
    {
        textView.selectable = NO;
    }
    if(SYSTEM_VERSION_LESS_THAN(@"6.0"))  //小于6.0的系统
    {
        msg = [NSString stringWithFormat:@"\n\n%@",msg];
    }
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.text = msg;
    textView.textColor = colorWith16bit(@"285a94");    //[ColorUtil hexStringToUIColor:@"0x285a94"];;
    textView.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE(16)];
    textView.returnKeyType = UIReturnKeyDefault;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.scrollEnabled = YES;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:textView];
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton*confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton = [[UIButton alloc] initWithFrame:commRect(70,176,104,42)];
    confirmButton.backgroundColor = [UIColor clearColor];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE(16)]];
    [confirmButton  setBackgroundImage:[UIImage imageNamed:@"comm_greenSamllBtn.png"] forState:UIControlStateNormal];
    if(confirmButtonTitle)
    {
        [confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
    }
    else
    {
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
    UIButton*cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton = [[UIButton alloc] initWithFrame:commRect(214,176,104,42)];
    cancleButton.backgroundColor = [UIColor clearColor];
    [cancleButton.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE(16)]];
    [cancleButton  setBackgroundImage:[UIImage imageNamed:@"comm_blueCancleSamllBtn.png"] forState:UIControlStateNormal];
    if(cancleButtonTitle)
    {
        [cancleButton setTitle:cancleButtonTitle forState:UIControlStateNormal];
    }
    else
    {
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    [cancleButton addTarget:self action:@selector(cancleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
    if(num == 1)//此时只有一个按钮
    {
        cancleButton.hidden = YES;
        confirmButton.frame = commRect((388 - 104)*0.5,178,104,42);
    }
}

//接收处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    textView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
}


-(void)cancleButtonPressed:(id)sender
{
    if(cancleSelector && [myTarget respondsToSelector:cancleSelector])
    {
        [myTarget performSelector:cancleSelector withObject:sender];
    }
    [super dismiss];
}

-(void)confirmButtonPressed:(id)sender
{
    if(confirmSelector && [myTarget respondsToSelector:confirmSelector])
    {
        [myTarget performSelector:confirmSelector withObject:sender];
    }
    
    [super dismiss];
}


#pragma mark-
#pragma mark 内存释放

-(void)dealloc
{
    [textView removeObserver:self forKeyPath:@"contentSize"];
    //IMLOG(@"IMeiAlertView dealloc...");
}
@end
