//
//  GlobalShare.h
//  YYQMusic
//
//  Created by Harvey on 13-7-15.
//  Copyright (c) 2013年 广东星外星文化传播有限公司. All rights reserved.
//

/*!
 @header GlobalShare.h
 @abstract 常用方法
 @author Harvey
 @version 1.0.0 2014/04/20 Creation
 */
#import <Foundation/Foundation.h>
#import "PiFiiAppDelegate.h"

@interface GlobalShare : NSObject

FOUNDATION_EXPORT CGFloat ScreenHeight();

FOUNDATION_EXPORT CGFloat ScreenWidth();

/**
 *  获取用户的Cookie
 *
 *  @return 登陆用户的Cookie
 */
+ (NSDictionary *)userCookie;
+ (NSDictionary *)userCookieForRouter;

/**
 *  多国语言, 通过key获取, 在本应用必须使用此方法调用, 否则多国语言无法正常使用
 *
 *  @param key 多国语言Key
 *
 *  @return value
 */
FOUNDATION_EXPORT NSString *NSLocalizedStringWithKey(NSString *key);

/**
 *  检测字符串中是否包含中文字符
 *
 *  @param varString 需检测的字符串
 *
 *  @return YES: varString含有中文字符(串); NO: varString不存在中文字符(串)
 */
+ (BOOL)containChineseInString:(NSString *)varString;

/// 判断是设备类型 e.g: is_Device(@"iPhone5")、is_Device(@"iPod4")、is_Device(@"iPad2");
FOUNDATION_EXPORT BOOL is_Device(NSString *decvide);

/// 系统是否安装某个了应用
FOUNDATION_EXPORT BOOL isInstallWithURLScheme(NSString *scheme);

/// 设备的系统是否是iOS7系统
FOUNDATION_EXPORT BOOL is_iOS7();

/// 设备的屏幕是否3.5 inch
FOUNDATION_EXPORT BOOL is3_5Screen();

/// 保存信息到本地(NSUserDefaults), obj为value, key为从本地取值时的
FOUNDATION_EXPORT BOOL SaveToLoal(id obj, NSString *key);

/// 读取信息从本地(NSUserDefaults)
FOUNDATION_EXPORT id ReadFromLocalWithKey(NSString *key);


/**
 *  判断一个对象是否为[NSNull null]
 *
 *  @param obj input
 *
 *  @return YES:obj为![NSNull null] ; NO: obj为[NSNull null]
 */
FOUNDATION_EXTERN BOOL isNotNull(id obj);

/// 获取接连路由器方式
FOUNDATION_EXPORT NSUInteger CurrentRouterConnectionMode();

+ (UIWindow *)RootWindow;
+ (PiFiiAppDelegate *)AppDelegate;

+ (NSString *)getToken;
+ (NSString *)routerIP;
+ (NSString *)routerMac;
+ (BOOL)isBindMac;
+ (void)clearMac;
+ (BOOL)isHDPicture;
/**
 *  显示提示窗口,并加入一个子视图
 *
 *  @param view 子视图
 */
+ (void)addSubViewToAlertWindowAndShow:(UIView *)view;

/// 显示主窗口并隐藏提示窗口
+ (void)showRootWindowAndHiddenAlertWindow;

/// 获得提示窗口
+ (UIWindow *)alertWindow;

+ (id)app;

/**
 *  获取区域信息
 *
 *  @param local e.g: @"广东省,天河区"; local为nil时则返回所有省份,自治区,直辖市
 *
 *  @return 区域信息数组
 */
+ (NSArray *)areaMessageWithKey:(NSString *)local;

/**
 *  参数拼接成字符串,用于百度LBS请求
 *
 *  @param dict 参数字典
 *
 *  @return 将参数字典拼接的字符串
 */
+ (NSString *)LBSJoinStringWithPara:(NSDictionary *)dict;

/**
 *  百度LBS SN签名算法
 *
 *  @param input 需要签名的字符串
 *
 *  @return 签名后的input
 */
+ (NSString *)LBS_SNEncodeToPercentEscapeString: (NSString *) input;

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateEmail:(NSString *)email;
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
/*返回当前日期的显示格式  */
+(NSString *)getDateWithNow:(NSString *)dateType;
/*计算文字大小长度*/
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
@end



@interface DEUBGREL : NSObject

#ifndef DEBUG
FOUNDATION_EXPORT void NSLog(NSString *format, ...);
#endif

@end







