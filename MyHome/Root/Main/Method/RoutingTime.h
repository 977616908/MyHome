//
//  RoutingTime.h
//  RoutingTime
//
//  Created by HXL on 15/5/27.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutingTime : NSObject
@property(nonatomic,assign)NSInteger rtId;
@property(nonatomic,copy)NSString  *rtNums;
@property(nonatomic,copy)NSString  *rtDate;
@property(nonatomic,copy)NSString  *rtTitle;
@property(nonatomic,copy)NSArray   *rtPaths;
@property(nonatomic,copy)NSArray   *rtSmallPaths;

-(id)initWithData:(NSDictionary *)data;

-(id)initWithSmallData:(NSDictionary *)data;

@end
