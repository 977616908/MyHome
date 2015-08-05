//
//  PiFiiAppDelegate.h
//  MyHome
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PiFiiBaseViewController.h"
typedef NS_ENUM(NSUInteger, RouterConnectionMode) {
  
    RouterConnectionModeLocal,          /**<本地连接*/
    RouterConnectionModeTransitServer,  /**<中转服务器*/
    RouterConnectionModeOwnServer       /**<自己的服务器*/
};

@interface PiFiiAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic)   UIWindow                *window;
@property (strong, nonatomic)   UIWindow                *alertWindow;
@property (strong, nonatomic) NSDictionary *header;


@property (nonatomic,assign)    RouterConnectionMode    routerConnectionMode;/**<连路由器方式*/


@end
