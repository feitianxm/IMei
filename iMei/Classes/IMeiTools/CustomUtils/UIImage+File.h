//
//  UIImage+File.h
//  wawaGame
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (File)

//通过指定颜色创建UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

//通过一个图片名字来创建一个UIImage
//+ (UIImage *)imageFile:(NSString *)name;

//两个图片合成一个
+ (UIImage *)composeWithUpImageFile:(NSString *)upImage downImageFile:(NSString *)downImage;

//灰度图
+ (UIImage *)grayscale:(UIImage *)normal;

//把图片设置成圆角
+ (UIImage *)roundedWithImage:(UIImage *)image radius:(float)r;

//缩放一个图大小
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

//把数字变成图片
+ (UIImage *)imageWithInt:(int)num imagePrefix:(NSString*)prefix symbol:(NSString*)symbole;

//numberString 格式规定，纯数字，可以有小数点，最后一个可以带万字，@"3.2万", @"12333",@"12万",
+ (UIImage *)imageWithString:(NSString *)numberString;//（后期去掉）

+ (UIImage *)newImageWithString:(NSString *)numberString;

//newChargeImageWithString 格式规定，纯数字，可以有小数点，最后一个可以带万字，@"3.2万", @"12333",@"12万",
+ (UIImage *)newChargeImageWithString:(NSString *)numberString;

+ (UIImage*)drawCommImageWith:(NSString*)imageString imagePrefix:(NSString*)prefix;

//创建抗锯齿头像
- (UIImage*)antialiasedImage;

//处理用户头像
- (UIImage *)editImage:(UIImage *)image;


- (UIImage *)getSquareImageFromImage:(UIImage *)image;

+ (UIImage *)createGrayCopy:(UIImage *)source;

+ (UIImage *)imageWithContentsOfmainBundle:(NSString *)imageName;


@end
