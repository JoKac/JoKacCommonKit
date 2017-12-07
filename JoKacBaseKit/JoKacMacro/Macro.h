//
//  Macro.h
//  JoKacCommonKit
//
//  Created by mac on 2017/12/7.
//  Copyright © 2017年 jay. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//
//  颜色
//
#define JKColorRGBA(r, g, b, a)  [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define JKColorRGB(r, g, b)      [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define HEX_RGBA(rgba) RGBA(((rgba) & 0xff000000) >> 24, \
((rgba) & 0x00ff0000) >> 16, \
((rgba) & 0x0000ff00) >> 8, \
((rgba) & 0x000000ff) >> 0)

#define HEX_RGB(rgb) HEX_RGBA(((rgb) << 8) + 0xff)

//
// 设备
//

#define JKDeviceWidth    UIScreen.mainScreen.bounds.size.width
#define JKDeviceHeight   UIScreen.mainScreen.bounds.size.height

#define JKSystemVersion                                          UIDevice.currentDevice.systemVersion.floatValue
#define JKSystemName                                             UIDevice.currentDevice.systemName
#define JKDeviceModel                                            UIDevice.currentDevice.model
#define JKDeviceModelLocalized                                   UIDevice.currentDevice.localizedModel

//
// GCD
//

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) { block(); }\
else { dispatch_sync(dispatch_get_main_queue(), block); }

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) { block(); }\
else { dispatch_async(dispatch_get_main_queue(), block); }\

#define dispatch_sync_main(block)   dispatch_sync(dispatch_get_main_queue(), block)
#define dispatch_async_main(block)  dispatch_async(dispatch_get_main_queue(), block)

#define dispatch_sync_global_default(block)     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define dispatch_async_global_default(block)    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

//
// LOG
//
#define JKLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//
//iOS 11
//
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

#endif /* Macro_h */
