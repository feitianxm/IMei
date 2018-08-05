//
//  UIImage+File.m
//  wawaGame
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//

#import "UIImage+File.h"

@implementation UIImage (File)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)imageFile:(NSString *)name
{
    return  [UIImage imageWithContentsOfFile:IMAGENAME(name)];
}

+ (UIImage *)composeWithUpImageFile:(NSString *)upImage downImageFile:(NSString *)downImage
{
    UIImage *imageUp = [self imageFile:upImage];
    UIImage *imageDown = [self imageFile:downImage];
    UIGraphicsBeginImageContext(imageUp.size);
    [imageDown drawAtPoint:CGPointMake(0,0)];
    [imageUp drawAtPoint:CGPointMake(0,0)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)grayscale:(UIImage *)normal
{
    float width = normal.size.width;
    float height = normal.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), normal.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage *)roundedWithImage:(UIImage *)image radius:(float)r
{
    return [self createRoundedRectImage:image size:image.size radius:r];
}


+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

//缩放一个图大小
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//把数字变成图片
+ (UIImage *)imageWithInt:(int)num imagePrefix:(NSString*)prefix symbol:(NSString*)symbole
{
    //IMLOG(@"imageWithInt num=>%d prefix=>%@ symbole=>%@", num, prefix, symbole);
    NSString *numString =[NSString stringWithFormat:@"%d",num];
    int max = (int)numString.length;
    int tempLength = 0;
    if (symbole) {
        tempLength = 1;
    }
    NSString *imageName = [numString substringWithRange:NSMakeRange(0,1)];
    imageName = [NSString stringWithFormat:@"%@%@.png", prefix, imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    //IMLOG(@"image w=>%f h=>%f", image.size.width, image.size.height);
    CGSize size = CGSizeMake(image.size.width * (max+tempLength) * scaleFor5, image.size.height * scaleFor5);
    //获取地面的上下文
    UIGraphicsBeginImageContext(size);
    
    if (symbole) {
        NSString *symbolName = [NSString stringWithFormat:@"%@%@.png", prefix, symbole];
        UIImage *tempImage = [UIImage imageNamed:symbolName];
        [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleFor5, tempImage.size.height * scaleFor5)];
    }
    
    for(int i=0;i<max;i++)
    {
        NSString *tempImageName = [numString substringWithRange:NSMakeRange(i,1)];
        tempImageName = [NSString stringWithFormat:@"%@%@.png", prefix, tempImageName];
        UIImage *tempImage = [UIImage imageNamed:tempImageName];
        //IMLOG(@"image w=>%f h=>%f", image.size.width*scaleFor5, image.size.height*scaleFor5);
        [tempImage drawInRect:CGRectMake((i+tempLength)*tempImage.size.width * scaleFor5,0,
                                         tempImage.size.width * scaleFor5, tempImage.size.height * scaleFor5)];
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//numberString 格式规定，纯数字，可以有小数点，最后一个可以带万字，@"3.2万", @"12333",@"12万",
+ (UIImage *)imageWithString:(NSString *)numberString
{
    int length = (int)numberString.length;
    float sizeX = 0;
    float sizeY = 0;
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"numberImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"numberImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"numberImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"numberImage_million.png";
        }
        else if([letter isEqualToString:@"亿"])
        {
            imageName = @"numberImage_billion.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"numberImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"numberImage_bean.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"numberImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        sizeX = sizeX+letterImage.size.width;
        sizeY = letterImage.size.height;
    }
    CGSize rectSize = CGSizeMake(sizeX, sizeY);
    
    
    sizeX = 0;
    sizeY = 0;
    UIGraphicsBeginImageContext(rectSize);
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"numberImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"numberImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"numberImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"numberImage_million.png";
        }
        else if([letter isEqualToString:@"亿"])
        {
            imageName = @"numberImage_billion.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"numberImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"numberImage_bean.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"numberImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        [letterImage drawInRect:CGRectMake(sizeX,0,letterImage.size.width,letterImage.size.height)];
        sizeX = sizeX+letterImage.size.width;
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//newImageWithString 格式规定，纯数字，可以有小数点，最后一个可以带万字，@"3.2万", @"12333",@"12万",
+ (UIImage *)newImageWithString:(NSString *)numberString
{
    int length = (int)numberString.length;
    float sizeX = 0;
    float sizeY = 0;
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"numberImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"numberImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"numberImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"numberImage_million.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"numberImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"numberImage_bean.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"numberImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        sizeX = sizeX+letterImage.size.width;
        sizeY = letterImage.size.height;
    }
    CGSize rectSize = CGSizeMake(sizeX * scaleFor5, sizeY * scaleFor5);
    
    
    sizeX = 0;
    sizeY = 0;
    UIGraphicsBeginImageContext(rectSize);
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"numberImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"numberImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"numberImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"numberImage_million.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"numberImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"numberImage_bean.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"numberImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        [letterImage drawInRect:CGRectMake(sizeX,0,letterImage.size.width * scaleFor5,letterImage.size.height * scaleFor5)];
        sizeX = sizeX + letterImage.size.width * scaleFor5;
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//newChargeImageWithString 格式规定，纯数字，可以有小数点，最后一个可以带万字，@"3.2万", @"12333",@"12万",
+ (UIImage *)newChargeImageWithString:(NSString *)numberString
{
    int length = (int)numberString.length;
    float sizeX = 0;
    float sizeY = 0;
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"newNumbersImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"newNumbersImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"newNumbersImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"newNumbersImage_million.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"newNumbersImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"newNumbersImage_bean.png";
        }
        else if([letter isEqualToString:@"含"])
        {
            imageName = @"newNumbersImage_han.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"newNumbersImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        sizeX = sizeX+letterImage.size.width;
        sizeY = letterImage.size.height;
    }
    CGSize rectSize = CGSizeMake(sizeX * scaleFor5, sizeY * scaleFor5);
    
    
    sizeX = 0;
    sizeY = 0;
    UIGraphicsBeginImageContext(rectSize);
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [numberString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = @"newNumbersImage_decimal.png";
        }
        else if([letter isEqualToString:@"/"])
        {
            imageName = @"newNumbersImage_divisionSign.png";
        }
        else if([letter isEqualToString:@"%"])
        {
            imageName = @"newNumbersImage_percent.png";
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = @"newNumbersImage_million.png";
        }
        else if([letter isEqualToString:@","])//判断是否逗号
        {
            imageName = @"newNumbersImage_comma.png";
        }
        else if([letter isEqualToString:@"豆"])
        {
            imageName = @"newNumbersImage_bean.png";
        }
        else if([letter isEqualToString:@"含"])
        {
            imageName = @"newNumbersImage_han.png";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"newNumbersImage_%@.png",letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        [letterImage drawInRect:CGRectMake(sizeX,0,letterImage.size.width * scaleFor5,letterImage.size.height * scaleFor5)];
        sizeX = sizeX + letterImage.size.width * scaleFor5;
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage*)drawCommImageWith:(NSString*)imageString imagePrefix:(NSString*)prefix
{
    //IMLOG(@"drawCommImageWith imageString=>%@ prefix=>%@", imageString, prefix);
    UIImage *image;
    if (imageString == nil || imageString.length == 0) {
        return image;
    }
    
    int length = (int)imageString.length;
    float sizeX = 0;
    float sizeY = 0;
    
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [imageString substringWithRange:NSMakeRange(i,1)];
        if([letter isEqualToString:@"."])
        {
            imageName = [NSString stringWithFormat:@"%@点.png", prefix];
        }
        else if([letter isEqualToString:@"万"])
        {
            imageName = [NSString stringWithFormat:@"%@万.png", prefix];
        }
        else if([letter isEqualToString:@"亿"])
        {
            imageName = [NSString stringWithFormat:@"%@亿.png", prefix];
        }
        else
        {
            imageName = [NSString stringWithFormat:@"%@%@.png",prefix, letter];
        }
        UIImage *letterImage = [UIImage imageNamed:imageName];
        sizeX = sizeX+letterImage.size.width;
        sizeY = letterImage.size.height;
    }
    
    CGSize rectSize = CGSizeMake(sizeX * scaleFor5, sizeY * scaleFor5);
    UIGraphicsBeginImageContext(rectSize);
    float tempWidht = 0;
    for(int i=0;i<length;i++)
    {
        NSString *imageName = nil;
        NSString *letter = [imageString substringWithRange:NSMakeRange(i,1)];
        if ([letter isEqualToString:@"."]) {
            letter = @"点";
        }
        imageName = [NSString stringWithFormat:@"%@%@.png",prefix, letter];
        //IMLOG(@"drawCommImageWith imageName=>%@", imageName);
        UIImage *letterImage = [UIImage imageNamed:imageName];
        [letterImage drawInRect:CGRectMake(tempWidht * scaleFor5,0,
                                         letterImage.size.width * scaleFor5, letterImage.size.height * scaleFor5)];
        tempWidht = tempWidht+letterImage.size.width;
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//创建抗锯齿头像
- (UIImage*)antialiasedImage
{
    return [self antialiasedImageOfSize:self.size scale:self.scale];
}

//创建抗锯齿头像,并调整大小和缩放比。
- (UIImage*)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(1, 1, size.width-2, size.height-2)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage *)editImage:(UIImage *)image
{
    float height = image.size.height;
    float width = height*0.8;
    UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(0.1*height, 0, width, height))];
    newImage = [self scaleImage:newImage];
    return newImage;
}

//缩放图片最长边为512
- (UIImage *)scaleImage:(UIImage *)image
{
    //IMLOG(@"缩放之前大小=>%@",NSStringFromCGSize(image.size));
    float value = 512;
    float factor = value / image.size.height;
    CGSize newSize = CGSizeMake(image.size.width * factor, image.size.height * factor);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, image.size.width*factor, image.size.height*factor)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)getSquareImageFromImage:(UIImage *)superImage
{
    if (!superImage) {
        return nil;
    }
    CGSize superSize = superImage.size;
    CGFloat squareLen = 0.0f;
    CGPoint squarePos = CGPointMake(0.0f, 0.0f);
    if (superSize.width > superSize.height) {
        squarePos.x = (superSize.width-superSize.height)/2;
        squareLen = superSize.height;
    }else if (superSize.height > superSize.width) {
        squarePos.y = (superSize.height-superSize.width)/2;
        squareLen = superSize.width;
    }else {
        return superImage;
    }
    
    CGSize subImageSize = CGSizeMake(squareLen, squareLen);
    //定义裁剪的区域相对于原图片的位置
    CGRect subImageRect = CGRectMake(squarePos.x, squarePos.y, squareLen, squareLen);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    //返回裁剪的部分图像
    return subImage;
}

+ (UIImage *)createGrayCopy:(UIImage *)source
{
    int width = source.size.width;
    int height = source.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), source.CGImage);
    CGImageRef image=CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:image];
    CGContextRelease(context);
    CGImageRelease(image);
    return grayImage;
}

+ (UIImage *)imageWithContentsOfmainBundle:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
