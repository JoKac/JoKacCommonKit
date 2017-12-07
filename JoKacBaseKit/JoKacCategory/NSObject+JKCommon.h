//
//  NSObject+JKCommon.h
//  JoKacCommonKit
//
//  Created by mac on 2017/12/7.
//  Copyright © 2017年 jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JKCommon)

@end

@interface NSString (JKCommon)

/**
 *  正则表达式验证手机号
 *
 *  @param mobile 传入手机号
 *
 *  @return BOOL (Yes/No)
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  正则表达式验证邮箱
 *
 *  @param email 传入邮箱
 *
 *  @return BOOL (Yes/No)
 */

+ (BOOL)checkEmail:(NSString *)email;

/**
 *  正则表达式验证身份证
 *
 *  @param identityString 传入身份证
 *
 *  @return BOOL (Yes/No)
 */

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;

/**
 *  正则表达式判断密码强度
 *
 *  @param password 传入密码
 *
 *  @return BOOL (Yes/No)
 */

+ (BOOL)judgePasswordStrength:(NSString *)password;

@end


@interface NSDate (JKCommon)

/**
 *  时间间隔多少秒
 *
 *  @param date 传入密码
 *
 *  @return s
 */

- (NSTimeInterval)timeOutAnthorDate:(NSDate *)date;

@end

