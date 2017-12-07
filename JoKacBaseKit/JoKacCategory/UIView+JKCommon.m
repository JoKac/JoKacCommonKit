//
//  UIView+JKCommon.m
//  JoKacCommonKit
//
//  Created by mac on 2017/12/7.
//  Copyright © 2017年 jay. All rights reserved.
//

#import "UIView+JKCommon.h"

@implementation UIView (JKCommon)

@end


@implementation UIButton (JKCommon)

@end


@implementation UIImage (JKCommon)

+ (UIImage *)imageWithOrientationExifFix:(UIImage *)image
{
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0.f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0.f, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0.f);
            transform = CGAffineTransformScale(transform, -1.f, 1.f);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0.f);
            transform = CGAffineTransformScale(transform, -1.f, 1.f);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             image.size.width,
                                             image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0.f,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0.f, 0.f, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0.f, 0.f, image.size.width, image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)image1x1WithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.f, 0.f, 1.f, 1.f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)image:(UIImage *)image withAlpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextTranslateCTM(context, 0.f, -rect.size.height);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    
    CGContextDrawImage(context, rect, image.CGImage);
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:rect];
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)imageBlackAndWhite:(UIImage *)image
{
    CGRect rect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:rect];
    
    CGContextSetBlendMode(context, kCGBlendModeLuminosity);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size scalingMode:(JKImageScalingMode)scalingMode
{
    return [self image:image scaleToSize:size scalingMode:scalingMode backgroundColor:nil];
}

+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size scalingMode:(JKImageScalingMode)scalingMode backgroundColor:(UIColor *)backgroundColor
{
    if (scalingMode == JKImageScalingModeAspectFit)
    {
        CGFloat koefWidth = (image.size.height > image.size.width ? image.size.width/image.size.height : 1.f);
        CGFloat koefHeight = (image.size.width > image.size.height ? image.size.height/image.size.width : 1.f);
        
        size.width *= koefWidth;
        size.height *= koefHeight;
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]])
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    
    if (scalingMode == JKImageScalingModeAspectFill)
    {
        if (image.size.width / image.size.height >= 1 && image.size.width / image.size.height > size.width / size.height)
            size.width = size.height * (image.size.width / image.size.height);
        else if (image.size.height / image.size.width >= 1 && image.size.height / image.size.width > size.height / size.width)
            size.height = size.width * (image.size.height / image.size.width);
        
        if (rect.size.width < size.width)
        {
            rect.origin.x = -(size.width - rect.size.width)/2;
            rect.size.width = size.width;
        }
        
        if (rect.size.height < size.height)
        {
            rect.origin.y = -(size.height - rect.size.height)/2;
            rect.size.height = size.height;
        }
    }
    else if (scalingMode == JKImageScalingModeAspectFit)
    {
        if (image.size.width / image.size.height <= 1 && image.size.width / image.size.height < size.width / size.height)
            size.width = size.height * (image.size.width / image.size.height);
        else if (image.size.height / image.size.width <= 1 && image.size.height / image.size.width < size.height / size.width)
            size.height = size.width * (image.size.height / image.size.width);
        
        if (rect.size.width > size.width)
        {
            rect.origin.x = (rect.size.width - size.width)/2;
            rect.size.width = size.width;
        }
        
        if (rect.size.height > size.height)
        {
            rect.origin.y = (rect.size.height - size.height)/2;
            rect.size.height = size.height;
        }
    }
    
    [image drawInRect:rect];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image scaleWithMultiplier:(float)multiplier
{
    CGSize size = CGSizeMake(image.size.width*multiplier, image.size.height*multiplier);
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    
    [image drawInRect:rect];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image roundWithRadius:(CGFloat)radius
{
    return [self image:image roundWithRadius:radius backgroundColor:nil];
}

+ (UIImage *)image:(UIImage *)image roundWithRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor
{
    CGRect rect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]])
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    
    [image drawInRect:rect];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image cropCenterWithSize:(CGSize)size
{
    return [self image:image cropCenterWithSize:size backgroundColor:nil];
}

+ (UIImage *)image:(UIImage *)image cropCenterWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor
{
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]])
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    
    int heightDifference = size.height-image.size.height;
    int widthDifference = size.width-image.size.width;
    
    CGRect bounds = CGRectMake(widthDifference/2, heightDifference/2, image.size.width, image.size.height);
    
    [image drawInRect:bounds];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+ (UIImage *)image:(UIImage *)image withMaskImage:(UIImage *)maskImage
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskImageReference = maskImage.CGImage;
    
    maskImageReference = CGImageMaskCreate(CGImageGetWidth(maskImageReference),
                                           CGImageGetHeight(maskImageReference),
                                           CGImageGetBitsPerComponent(maskImageReference),
                                           CGImageGetBitsPerPixel(maskImageReference),
                                           CGImageGetBytesPerRow(maskImageReference),
                                           CGImageGetDataProvider(maskImageReference),
                                           NULL,
                                           YES);
    
    CGImageRef maskedImageReference = CGImageCreateWithMask(imageReference, maskImageReference);
    CGImageRelease(maskImageReference);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageReference];
    CGImageRelease(maskedImageReference);
    
    return maskedImage;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    return [self imageFromView:view inPixels:NO];
}

+ (UIImage *)imageFromView:(UIView *)view inPixels:(BOOL)inPixels
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, (inPixels ? 1.f : 0.f));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

+ (UIColor *)image:(UIImage *)image colorAtPixel:(CGPoint)point
{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point))
        return nil;
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (BOOL)maskAlphaImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point
{
    UIColor *pixelColor = [self image:maskImage colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    
    return alpha > 0.f;
}

+ (BOOL)maskAlphaImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point containerSize:(CGSize)containerSize
{
    CGSize imageSize = maskImage.size;
    
    point.x *= (containerSize.width != 0) ? (imageSize.width / containerSize.width) : 1;
    point.y *= (containerSize.height != 0) ? (imageSize.height / containerSize.height) : 1;
    
    UIColor *pixelColor = [self image:maskImage colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    
    return alpha > 0.f;
}

+ (BOOL)maskBlackAndWhiteImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point
{
    UIColor *pixelColor = [self image:maskImage colorAtPixel:point];
    
    return ![pixelColor isEqual:[UIColor blackColor]];
}

+ (BOOL)maskBlackAndWhiteImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point containerSize:(CGSize)containerSize
{
    CGSize imageSize = maskImage.size;
    
    point.x *= (containerSize.width != 0) ? (imageSize.width / containerSize.width) : 1;
    point.y *= (containerSize.height != 0) ? (imageSize.height / containerSize.height) : 1;
    
    UIColor *pixelColor = [self image:maskImage colorAtPixel:point];
    
    return ![pixelColor isEqual:[UIColor blackColor]];
}

@end
