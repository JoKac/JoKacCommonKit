//
//  UIView+JKCommon.h
//  JoKacCommonKit
//
//  Created by mac on 2017/12/7.
//  Copyright © 2017年 jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JKCommon)

@end

@interface UIButton (JKCommon)

@end

typedef enum
{
    JKImageScalingModeAspectFill,
    JKImageScalingModeAspectFit
}
JKImageScalingMode;

@interface UIImage (JKCommon)

+ (UIImage *)imageWithOrientationExifFix:(UIImage *)image;
+ (UIImage *)image1x1WithColor:(UIColor *)color;
+ (UIImage *)image:(UIImage *)image withAlpha:(CGFloat)alpha;
+ (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageBlackAndWhite:(UIImage *)image;
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size scalingMode:(JKImageScalingMode)scalingMode;
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size scalingMode:(JKImageScalingMode)scalingMode backgroundColor:(UIColor *)backgroundColor;
+ (UIImage *)image:(UIImage *)image scaleWithMultiplier:(float)multiplier;
+ (UIImage *)image:(UIImage *)image roundWithRadius:(CGFloat)radius;
+ (UIImage *)image:(UIImage *)image roundWithRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor;
+ (UIImage *)image:(UIImage *)image cropCenterWithSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image cropCenterWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor;
+ (UIImage *)image:(UIImage *)image withMaskImage:(UIImage *)maskImage;
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromView:(UIView *)view inPixels:(BOOL)inPixels;
+ (UIColor *)image:(UIImage *)image colorAtPixel:(CGPoint)point;

+ (BOOL)maskAlphaImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point;
+ (BOOL)maskAlphaImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point containerSize:(CGSize)containerSize;
+ (BOOL)maskBlackAndWhiteImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point;
+ (BOOL)maskBlackAndWhiteImage:(UIImage *)maskImage pointIsCorrect:(CGPoint)point containerSize:(CGSize)containerSize;

@end
