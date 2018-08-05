//
//  IMeiTabBarView.m
//  iMei
//
//  Created by Chengfei Liang on 2018/8/4.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import "IMeiTabBarView.h"

@interface IMeiTabBarView ()

@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIImageView * backgroundImageView;

@property (nonatomic, strong) NSMutableArray * buttonArray;
@property (nonatomic, strong) NSMutableArray * titleLabels;


@property (nonatomic, strong) NSMutableArray * unSelectedImages;
@property (nonatomic, strong) NSMutableArray * selectedImages;
@property (nonatomic, strong) NSMutableArray * titles;

@end


@implementation IMeiTabBarView


-(id)initWithItemSelectedImages:(NSMutableArray *)selected
                   normalImages:(NSMutableArray *)normal
                         titles:(NSMutableArray *)titles
{
    if ([super init])
    {
        self.frame = CGRectMake(0, SCREEN_HEIGHT_FIT - 49, SCREEN_WIDTH_FIT, 49);
        IMLOG(@"frame=>%@", NSStringFromCGRect(self.frame));
        self.buttonArray = [NSMutableArray array];
        self.titleLabels = [NSMutableArray array];
        
        self.unSelectedImages = normal;
        self.selectedImages = selected;
        self.titles = titles;
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line];
    
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.image = self.backgroundImage;
    [self addSubview:self.backgroundImageView];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.centerButton];
    
    
    for (int i = 0; i < self.unSelectedImages.count; i ++)
    {
        IMeiButton * button = [IMeiButton imei_shareButton];
        [button setImage:self.unSelectedImages[i] forState:UIControlStateNormal];
        [button setImage:self.selectedImages[i] forState:UIControlStateSelected];
        
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
}


-(void)tabBarBadgeValue:(NSUInteger)value item:(NSInteger)index{
    IMeiButton * button = self.buttonArray[index];
    button.badgeValue = value;
}


-(void)setItemSelectedIndex:(NSInteger)itemSelectedIndex{
    _itemSelectedIndex = itemSelectedIndex;
    for (IMeiButton * item in self.buttonArray) {
        item.selected = NO;
        if (item.tag == itemSelectedIndex)  item.selected = YES;
    }
}

-(void)setShowCenter:(BOOL)showCenter
{
    _showCenter = showCenter;
}

-(void)setCenterImage:(UIImage *)centerImage
{
    _centerImage = centerImage;
    [self.centerButton setImage:_centerImage forState:UIControlStateNormal];
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (IMeiButton * button in self.buttonArray) {
        [button setTitleColor:textColor forState:UIControlStateSelected];
    }
}

-(void)buttonClick:(IMeiButton *)button
{
    for (IMeiButton * item in self.buttonArray) item.selected = NO;
    /**
     *  选中哪一个item将上面的badgeValue清零
     */
    [self tabBarBadgeValue:0 item:button.tag];
    
    button.selected = !button.selected;
    [self.delegate tabBarViewSelectedItem:button.tag];
}

-(void)centerButtonClick:(UIButton *)button
{
    [self.delegate tabBarViewCenterItemClick:button];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.backgroundImageView.frame = CGRectMake(0, 0.5, self.frame.size.width, self.frame.size.height - 0.5);
    
    NSUInteger count = self.buttonArray.count%2 == 0 ? self.buttonArray.count:self.buttonArray.count+1;
    
    /** 中间按钮的宽高 */
    CGFloat centerButtonWH = 60;
    /** 普通按钮的高度 */
    CGFloat buttonHeight = 48.5;
    /** 普通按钮的宽度 */
    CGFloat buttonWidth = self.frame.size.width/count;
    CGFloat centerButtonX = (self.frame.size.width - centerButtonWH)*0.5;
    
    if (_showCenter)
    {
        self.centerButton.frame = CGRectMake(centerButtonX, self.frame.size.height - centerButtonWH, centerButtonWH, centerButtonWH);
        buttonWidth = (self.frame.size.width- centerButtonWH - 20)/count;
    }
    
    CGFloat buttonX = 0;
    
    for (int i = 0; i < self.buttonArray.count;i ++)
    {
        IMeiButton * button = self.buttonArray[i];
        if (_showCenter && button.tag == count/2) {
            buttonX += centerButtonWH + 20;
        }
        button.frame = CGRectMake(buttonX, 0.5, buttonWidth, buttonHeight);
        buttonX += buttonWidth;
    }
}

@end


/** 图标在上，文本在下按钮的图文间隔比例（0-1）*/
#define imei_buttonTopRadio 0.7

@interface IMeiButton ()

@property (nonatomic, strong) UILabel * badgeValueLabel;

@end

@implementation IMeiButton


+ (instancetype)imei_shareButton{
    
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.badgeValueLabel = [[UILabel alloc]init];
        self.badgeValueLabel.backgroundColor = [UIColor redColor];
        self.badgeValueLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeValueLabel.font = [UIFont systemFontOfSize:11];
        self.badgeValueLabel.textColor = [UIColor whiteColor];
        self.badgeValueLabel.layer.masksToBounds = YES;
        self.badgeValueLabel.layer.cornerRadius = 6.5;
        [self addSubview:self.badgeValueLabel];
        
    }
    return self;
}
-(void)setBadgeValue:(NSUInteger)badgeValue{
    _badgeValue = badgeValue;
    self.badgeValueLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_badgeValue];
}
- (void)alignmentTop{
    
    // 获得按钮的大小
    CGFloat im_btnWidth = self.bounds.size.width;
    CGFloat im_btnHeight = self.bounds.size.height;
    // 获得按钮中UILabel文本的大小
    CGFloat im_labelWidth = self.titleLabel.bounds.size.width;
    CGFloat im_labelHeight = self.titleLabel.bounds.size.height;
    // 获得按钮中image图标的大小
    CGFloat im_imageWidth = self.imageView.bounds.size.width;
    CGFloat im_imageHeight = self.imageView.bounds.size.height;
    
    
    /** 没有文字，返回普通按钮 */
    if (self.titleLabel.text == nil) return;
    
    
    /** 设置button上的图片或文字 */
    
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGFloat imageX = (im_btnWidth - im_imageWidth) * 0.5;
    self.imageView.frame = CGRectMake(imageX, im_btnHeight * 0.5 - im_imageHeight *imei_buttonTopRadio, im_imageWidth, im_imageHeight);
    self.titleLabel.frame = CGRectMake((self.center.x - frame.size.width) * 0.5, im_btnHeight * 0.5 + im_labelHeight * imei_buttonTopRadio, im_labelWidth, im_labelHeight);
    
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
    
    
}

- (CGSize)sizeWithFont:(UIFont *)font string:(NSString *)text
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(self.frame.size.width * 0.35, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self alignmentTop];
    
    /** 设置badgeValue */
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:12] string:self.badgeValueLabel.text];
    
    if (self.badgeValue == 0) {
        self.badgeValueLabel.frame = CGRectMake(self.frame.size.width*0.65, 3, 0, 0);
        return;
    }
    if (size.width < 10) size.width = 10;
    self.badgeValueLabel.frame = CGRectMake(self.frame.size.width*0.65, 3, size.width + 3, 13);
    
}

@end




