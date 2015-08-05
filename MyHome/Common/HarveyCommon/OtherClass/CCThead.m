//
//  CCThead.m
//  HarveySDK
//
//  Created by Harvey on 14-1-25.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "CCThead.h"

@implementation CCThead

+ (void)GCDAsyncModeOnMainQueueWithAction:(SEL)action parameter:(id)para runTarget:(id)target
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [target performSelector:action withParameter:para];
    });
}

+ (void)GCDAsyncModeOnGlobalQueueWithAction:(SEL)action parameter:(id)para runTarget:(id)target
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    
    
        [target performSelector:action withParameter:para];
    });
}

@end
