//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by Harvey on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//


#import <Foundation/Foundation.h>

#define APP_PUBLIC_PASSWORD @"cn.yyq.yyqmusic"
#define gIv             @"01234567"

@interface CocoaSecurity : NSObject

/// (可与安卓通用)加密对字符串进行加密, 要使用encryptString:进行解密
+ (NSString*)encryptString:(NSString*)plainText;

/// (可与安卓通用)解密方法, encryptText必须是使用encryptString:进行加密后的字符串
+ (NSString*)decryptString:(NSString*)encryptText;

@end


@interface NSString (MD5)

/// 将字条串MD5,结果中字母全为大写
- (NSString *)md5Encrypt;

/// 将字条串MD5,结果中字母全为小写
- (NSString *)md5EncryptLower;

/// 将字符串进行base64
- (NSString *)encodeBase64String;

/// 将base64 字符串还原
- (NSString *)decodeBase64String;

@end


@interface NSData (Base64)

/// 将base64 data 还原
- (NSString *)decodeBase64Data;

/// 对data进行ASE256加密
- (NSData *)AES256Encrypt;

/// 对ASE256的data进行解密
- (NSData *)AES256Decrypt;

/// 将字条串MD5,结果中字母全为大写
- (NSString *)md5Encrypt;

/// 将字条串MD5,结果中字母全为小写
- (NSString *)md5EncryptLower;

@end