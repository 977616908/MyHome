//
//  RoutingTime.m
//  RoutingTime
//
//  Created by HXL on 15/5/27.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingTime.h"
#import "RoutingMsg.h"
#import "MJExtension.h"

@implementation RoutingTime
-(id)initWithData:(NSDictionary *)data{
    if (self=[super init]) {
        if (data) {
            _rtId=[data[@"id"] integerValue];
            _rtNums=[data[@"nums"] stringValue];
            _rtDate=data[@"record_date"];
            _rtTitle=data[@"title"];
            NSMutableArray *arrPath=[NSMutableArray array];
            for (NSDictionary *param in data[@"path"]) {
                RoutingMsg *msg=[[RoutingMsg alloc]initWithData:param];
                [arrPath addObject:msg];
            }
            _rtPaths=arrPath;
            NSMutableArray *arrSmallPath=[NSMutableArray array];
            for (NSDictionary *param in data[@"smallpath"]) {
                RoutingMsg *msg=[[RoutingMsg alloc]initWithSmallData:param];
                [arrSmallPath addObject:msg];
            }
            _rtSmallPaths=arrSmallPath;
        }
        
    }
    return self;
}

-(id)initWithSmallData:(NSDictionary *)data{
    if (self=[super init]) {
        if (data) {
            _rtId=[data[@"id"] integerValue];
            _rtNums=[data[@"nums"] stringValue];
            _rtDate=data[@"record_date"];
            _rtTitle=data[@"title"];
            NSMutableArray *arrSmallPath=[NSMutableArray array];
            for (NSDictionary *param in data[@"smallpath"]) {
                RoutingMsg *msg=[[RoutingMsg alloc]initWithData:param];
                [arrSmallPath addObject:msg];
            }
            _rtSmallPaths=arrSmallPath;
            NSMutableArray *arrPath=[NSMutableArray array];
            for (NSDictionary *param in data[@"path"]) {
                RoutingMsg *msg=[[RoutingMsg alloc]initWithSmallData:param];
                [arrPath addObject:msg];
            }
            _rtPaths=arrPath;
        }
    }
    return self;
}

MJCodingImplementation
@end
