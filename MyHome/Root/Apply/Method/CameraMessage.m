//
//  CameraMessage.m
//  MyHome
//
//  Created by HXL on 15/7/3.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CameraMessage.h"

@implementation CameraMessage

-(id)initWithData:(NSDictionary *)data{
    if (self=[super init]) {
        _camdevice=data[@"camdevice"];
        _camdevicewifiname=data[@"camdevicewifiname"];
        _camid=data[@"camid"];
        _camname=data[@"camname"];
        _campas=data[@"campas"];
        _camwifiname=data[@"camwifiname"];
        _isOpen=[data[@"isopen"] boolValue];
    }
    return self;
}

-(instancetype)init{
    if (self=[super init]) {
        _camdevice=@"";
        _camdevicewifiname=@"";;
        _camid=@"";
        _camname=@"admin";;
        _campas=@"admin";;
        _camwifiname=@"";;
    }
    return self;
}

@end
