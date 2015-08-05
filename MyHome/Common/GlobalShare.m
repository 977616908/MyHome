//
//  GlobalShare.m
//  YYQMusic
//
//  Created by Harvey on 13-7-15.
//  Copyright (c) 2013年 IFIDC. All rights reserved.
//

#import "GlobalShare.h"
#import <sys/utsname.h>
//#import <CoreText/CoreText.h>

@implementation GlobalShare

FOUNDATION_EXPORT CGFloat ScreenHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

FOUNDATION_EXPORT CGFloat ScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}

+ (NSString *)routerIP
{
    NSString *ip=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERIP];
    return ip?ip:@"";
//    return @"192.168.1.1";
}

+ (NSString *)getToken
{
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    return token?token:@"";
//    return @"110086fcgykwpwq7";
}
+ (NSString *)routerMac{
    NSString *mac=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERMAC];
    return mac?mac:@"";
}
+ (BOOL)isBindMac{
    NSNumber *num=[[NSUserDefaults standardUserDefaults] objectForKey:BOUNDMAC];
    return  [num boolValue];
}

+ (BOOL)isHDPicture{
    NSNumber *num=[[NSUserDefaults standardUserDefaults] objectForKey:ISHDPICTURE];
    return  [num boolValue];
}

+(void)clearMac{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:BOUNDMAC];
}

+ (NSDictionary *)userCookie
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [[defaults objectForKey:@"yyqsso"] encodedString];
    PSLog(@"用户cookieString: %@",tokenString);
    if((NSNull *)tokenString == [NSNull null] || tokenString.length == 0) {
        
        return nil;
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"yyqsso" forKey:NSHTTPCookieName];
    [cookieProperties setObject:tokenString forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@".yyq.cn" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@".yyq.cn" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSDictionary* cookieHeaders = [ NSHTTPCookie requestHeaderFieldsWithCookies: @[cookie]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    return [cookieHeaders objectForKey: @"Cookie"];
}

+ (NSDictionary *)userCookieForRouter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [[defaults objectForKey:@"yyqsso"] encodedString];
    PSLog(@"用户cookieString: %@",tokenString);
    if((NSNull *)tokenString == [NSNull null] || tokenString.length == 0) {
        
        return nil;
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"_xsrf" forKey:NSHTTPCookieName];
    [cookieProperties setObject:ReadFromLocalWithKey(@"_xsrf") forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"witfii.com" forKey:NSHTTPCookieDomain];
    //[cookieProperties setObject:@".yyq.cn" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSDictionary* cookieHeaders = [ NSHTTPCookie requestHeaderFieldsWithCookies: @[cookie]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    return [cookieHeaders objectForKey: @"Cookie"];
}


FOUNDATION_EXPORT NSString *NSLocalizedStringWithKey(NSString *key)
{
    return NSLocalizedStringFromTable(key, @"InfoPlist", nil);
}

+ (UIWindow *)RootWindow
{
    return [(PiFiiAppDelegate *)[UIApplication sharedApplication].delegate window];
}

+ (PiFiiAppDelegate *)AppDelegate
{
    return (PiFiiAppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (void)addSubViewToAlertWindowAndShow:(UIView *)view
{
    UIWindow *win = [GlobalShare AppDelegate].alertWindow;
    win.hidden = NO;
    [win addSubview:view];
    view.transform = CGAffineTransformIdentity;
    view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [win makeKeyAndVisible];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    win.backgroundColor = RGBAlpha(0, 0, 0, .5);
    view.transform = CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}

+ (void)showRootWindowAndHiddenAlertWindow
{
     UIWindow *win = [GlobalShare AppDelegate].alertWindow;
    [UIView animateWithDuration:0.5 animations:^{
        
        win.backgroundColor = RGBClearColor();
        ((UIView *)[[win subviews] lastObject]).transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {

        win.hidden = YES;
         [[GlobalShare RootWindow] makeKeyAndVisible];
        
        for (UIView *v in win.subviews) {
            
            [v removeFromSuperview];
        }
    }];
}

+ (UIWindow *)alertWindow
{
    return [GlobalShare AppDelegate].alertWindow;
}

+ (UIApplication *)app
{
    return [UIApplication sharedApplication];
}

FOUNDATION_EXPORT BOOL isInstallWithURLScheme(NSString *scheme)
{
    return [[UIApplication sharedApplication] canOpenURL:[scheme urlInstance]];
}

FOUNDATION_EXPORT BOOL is_iOS7()
{
    return [[MyDevice OS_Version] hasPrefix:@"7"]||[[MyDevice OS_Version] hasPrefix:@"8"];
}

FOUNDATION_EXPORT BOOL is3_5Screen()
{
    return [UIScreen mainScreen].bounds.size.height==480;
}

FOUNDATION_EXPORT NSUInteger CurrentRouterConnectionMode()
{
    return [GlobalShare AppDelegate].routerConnectionMode;
}

FOUNDATION_EXPORT BOOL SaveToLoal(id obj, NSString *key)
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:obj forKey:key];
    return [df synchronize];
}

FOUNDATION_EXPORT id ReadFromLocalWithKey(NSString *key)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

FOUNDATION_EXPORT BOOL is_Device(NSString *decvide)
{
    struct utsname u;
    uname(&u);
    NSString *machine = [NSString stringWithUTF8String:u.machine];
    return [machine hasPrefix:decvide];
}

FOUNDATION_EXTERN BOOL isNotNull(id obj)
{
    return obj==[NSNull null] ? NO:YES;
}

+ (NSArray *)areaMessageWithKey:(NSString *)local
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area"
                                                         ofType:@"json"];
    NSString *contentString = [[NSString alloc] initWithContentsOfFile:filePath
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];
    id dict = [contentString objectFromJSONString];
    if(isNIL(local)) {
        
        return [dict allKeys];
    }
    NSArray *keys = [local componentsSeparatedByString:@","];
    for(NSInteger i=0; i<keys.count; i++) {
        
        if([dict isKindOfClass:[NSDictionary class]]) {
            
            dict = [dict objectForKey:[keys objectAtIndex:i]];
        }
        if(i == keys.count - 1) {
    
            if([dict isKindOfClass:[NSDictionary class]]) {
                
                return [dict allKeys];
            }
            else if ([dict isKindOfClass:[NSArray class]]) {
               
                return dict;
            }
        }else if (i < keys.count) {
            
            if([dict isKindOfClass:[NSArray class]]) {
                
                return nil;
            }
        }
    }
    return nil;
}

+ (NSString *)LBSJoinStringWithPara:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    keys =  [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    
    NSMutableString *mStr = [NSMutableString new];
    for(NSString *key in keys) {
        
        NSString *value = [dict objectForKey:key];
        [mStr appendFormat:@"%@=%@&",key,value];
    }
    
    [mStr deleteCharactersInRange:NSMakeRange(mStr.length - 1, 1)];
    mStr = (NSMutableString *)mStr.encodedString;
    return[mStr stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
}

+ (BOOL)containChineseInString:(NSString *)varString
{
    NSData *data = [varString stringConvertData];
    return data.length==varString.length ? NO:YES;
}

+ (NSString *)LBS_SNEncodeToPercentEscapeString:(NSString *) input
{
     return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)input,
                                                                                  NULL,
                                                                                  CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
}

+(BOOL) isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    PSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString *)getDateWithNow:(NSString *)dateType{
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    [sdf setDateFormat:dateType];
    return [sdf stringFromDate:date];
}

+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    if(is_iOS7()){
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }else{
        return [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    }
  
}

@end



@implementation DEUBGREL

#ifndef DEBUG
FOUNDATION_EXPORT void NSLog(NSString *format, ...) { }
#endif

@end
