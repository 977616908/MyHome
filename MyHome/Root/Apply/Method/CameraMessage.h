//
//  CameraMessage.h
//  MyHome
//
//  Created by HXL on 15/7/3.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraMessage : NSObject
@property(nonatomic,copy)NSString *camdevice;
@property(nonatomic,copy)NSString *camdevicewifiname;
@property(nonatomic,copy)NSString *camid;
@property(nonatomic,copy)NSString *camname;
@property(nonatomic,copy)NSString *campas;
@property(nonatomic,copy)NSString *camwifiname;
@property(nonatomic,assign)BOOL isOpen;

-(id)initWithData:(NSDictionary *)data;

@end
