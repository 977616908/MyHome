//
//  RoutingMsg.h
//  RoutingTime
//
//  Created by HXL on 15/5/27.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutingMsg : NSObject

@property(nonatomic,copy)NSString *msgNum;
@property(nonatomic,copy)NSString *msgPath;
@property(nonatomic,copy)NSString *msgDuration;
@property(nonatomic,copy)NSString *msgStory;
@property(nonatomic,copy)NSString *msgStroyId;
@property(nonatomic,assign)BOOL isVedio;

-(id)initWithData:(NSDictionary *)data;

-(id)initWithSmallData:(NSDictionary *)data;

@end
