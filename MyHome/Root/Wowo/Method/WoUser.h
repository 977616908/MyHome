//
//  WoUser.h
//  MyHome
//
//  Created by HXL on 15/6/4.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoUser : NSObject
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)NSString *facephotoUrl;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *gender;

-(instancetype)initWithData:(NSDictionary *)param;

@end
