//
//  PiFiiAppDelegate.m
//  MyHome
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiAppDelegate.h"
#import <dlfcn.h>
#import "WFXDeviceFinder.h"
#import "SemiAsyncDispatcher.h"
#import "PiFiiBaseTabBarController.h"

#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@implementation PiFiiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 用于捕捉错误,如果无法定位错误地方,取消下面注释,在控制台上可获得更多关于错误的信息*/
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    self.alertWindow.backgroundColor = RGBClearColor();

    PSLog(@"%@",NSHomeDirectory());
    NSString *path=pathInCacheDirectory(@"AppCache");
    NSFileManager *manager=[NSFileManager defaultManager];
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    // SaveToLoal(@"192.168.10.1", @"routerIP");//拿到新的路由器IP保存
   
    self.routerConnectionMode = RouterConnectionModeLocal;// 接连路由器方式
    [self shareSDK];
//    [self serverInfo];
//    [self requestMacForIP];
//    [self requestTokenOfRouting];
//    [self requestSaveBindMac];
    [NSThread sleepForTimeInterval:1];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
   
    PiFiiBaseTabBarController *tab=[[PiFiiBaseTabBarController alloc]init];
    self.window.rootViewController = tab;
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
//    self.window.backgroundColor = @"hm_bg".colorInstance;
    self.window.backgroundColor=RGBCommon(2, 137, 193);
    [self.window makeKeyAndVisible];
    
//     [self loadReveal];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    PSLog(@"CRASH: %@", exception);
    PSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

-(void)requestMacForIP{
    if (![GlobalShare isBindMac])return;
    WFXDeviceFinder *finder = [[WFXDeviceFinder alloc] initWithDispatcher:[[SemiAsyncDispatcher alloc] init]];
    NSString *mac=[GlobalShare routerMac];
    PSLog(@"mac:%@",mac);
    __block DeviceEcho *decho=NULL;
   [finder findDevicesWithMacAddr:mac matched:^(DeviceEcho *echo) {
       decho=echo;
   } missed:^{
       PSLog(@"----missed---%@",decho);
   } completion:^{
        PSLog(@"----completion---%@",decho);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
       if (decho) {
           [user setObject:decho.token forKey:TOKEN];
           [user setObject:decho.hostIP forKey:ROUTERIP];
           [user setObject:decho.name forKey:ROUTERNAME];
           [user setObject:@(1) forKey:ISCONNECT];
       }else{
           [user setObject:@(0) forKey:ISCONNECT];
       }
       [user synchronize];
   }];
}

-(void)requestSaveBindMac{
    NSMutableArray *_mydataArray=[NSMutableArray array];
    WFXDeviceFinder * finder = [[WFXDeviceFinder alloc] initWithDispatcher:[[SemiAsyncDispatcher alloc] init]];
    [finder findAllDevicesMatched:^(NSArray *responsedEchos) {
        [_mydataArray addObjectsFromArray:responsedEchos];
    }
    missed:^{
    }
    completion:^{
       if (_mydataArray.count >0) {
           DeviceEcho *mymodels = [_mydataArray objectAtIndex:0];
           PSLog(@"************%@",mymodels);
           NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
           [user setObject:mymodels.token forKey:TOKEN];
           [user setObject:mymodels.hostIP forKey:ROUTERIP];
           [user setObject:mymodels.macAddr forKey:ROUTERMAC];
           [user setObject:mymodels.name forKey:ROUTERNAME];
           [user setObject:@(1) forKey:BOUNDMAC];
           [user synchronize];
       }else{
           [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有可管理的路由器!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
       }
       PSLog(@"echos: %@",_mydataArray);
   }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    PSLog(@"applicationDidEnterBackground");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterbackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark 返回前台调用的方法
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [self requestTokenOfRouting];
     PSLog(@"---applicationDidBecomeActive--");
    [self requestMacForIP];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"becomeActive" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Reveal
- (void)loadReveal
{
    NSString *revealLibName = @"libReveal";
    NSString *revealLibExtension = @"dylib";
    NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
    PSLog(@"Loading dynamic library: %@", dyLibPath);
    
    void *revealLib = NULL;
    revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    
    if (revealLib == NULL)
    {
        char *error = dlerror();
        PSLog(@"dlopen error: %s", error);
        NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", revealLibName, revealLibExtension, error];
        [[[UIAlertView alloc] initWithTitle:@"Reveal library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}



#pragma mark -创建分享
-(void)shareSDK{
    [ShareSDK registerApp:@"7ab47a6975cc"];
    
    [ShareSDK connectSinaWeiboWithAppKey:@"4164192594" appSecret:@"51a4a913583870a0501c47c81c60b26d" redirectUri:@"www.pifii.com" weiboSDKCls:[WeiboSDK class]];
    
    [ShareSDK connectWeChatWithAppId:@"wxca95672398f19838"
                           appSecret:@"04383b3f8824135f303343c57b1c62e1"
                           wechatCls:[WXApi class]];
    //连接QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //连接QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //连接短信分享
    [ShareSDK connectSMS];
}

//添加两个回调方法,return的必须要ShareSDK的方法
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end
