//
//  MyDevice.h
//  Own
//
//  Created by Harvey on 13-10-11.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDevice : NSObject

/// 写Email
+ (void)callSystemEmailWithToAddress:(NSString *)emailAddress;

/// 拨打callNumber
+ (void)callSystemPhoneWithCallNumber:(long long int)callNumber;

/// 发短信到receiveNumber
+ (void)callSystemSMSWithReceiveNumber:(long long int)receiveNumber;

/// Safari打开url
+ (void)callSystemSafariWithURL:(NSString *)url;

/// 设备的名字
+ (NSString *)name;

/// 设备上系统的名字
+ (NSString *)OS_Name;

/// 设备上系统的版本
+ (NSString *)OS_Version;

/// 设备模式, iPhone or iPod touch.
+ (NSString *)model;

@end


/// 当前应用
@interface App : NSObject

/// 应用的名字
+ (NSString *)name;

/// 应用的版本号
+ (NSString *)shortVersion;

/// 应用创建的版本号
+ (NSString *)version;

@end


