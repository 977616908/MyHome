//
//  CCThead.h
//  HarveySDK
//
//  Created by Harvey on 14-1-25.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCThead : NSObject

/// 开启异步线程, 在主线程中执行
+ (void)GCDAsyncModeOnMainQueueWithAction:(SEL)action parameter:(id)para runTarget:(id)target;

/// 开启异步线程, 在非主线程中执行
+ (void)GCDAsyncModeOnGlobalQueueWithAction:(SEL)action parameter:(id)para runTarget:(id)target;

@end
