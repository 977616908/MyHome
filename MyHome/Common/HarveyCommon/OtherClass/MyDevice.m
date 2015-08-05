//
//  MyDevice.m
//  Own
//
//  Created by Harvey on 13-10-11.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import "MyDevice.h"

@implementation MyDevice

+ (void)callSystemEmailWithToAddress:(NSString *)emailAddress
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",emailAddress]]];
}

+ (void)callSystemPhoneWithCallNumber:(long long int)callNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%lld",callNumber]]];
}

+ (void)callSystemSMSWithReceiveNumber:(long long int)receiveNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%lld",receiveNumber]]];
}

+ (void)callSystemSafariWithURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSString *)name
{
  return  [UIDevice currentDevice].name;
}

+ (NSString *)OS_Name
{
     return  [UIDevice currentDevice].systemName;
}

+ (NSString *)OS_Version
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)model
{
    return [UIDevice currentDevice].model;
}

@end


@implementation App

+ (NSString *)name
{
    return [[NSBundle mainBundle].infoDictionary objectForKey:CFBundleDisplayName];
}

+ (NSString *)shortVersion
{
     return [[NSBundle mainBundle].infoDictionary objectForKey:CFBundleShortVersionString];
}

+ (NSString *)version
{
     return [[NSBundle mainBundle].infoDictionary objectForKey:CFBundleVersion];
}

@end





