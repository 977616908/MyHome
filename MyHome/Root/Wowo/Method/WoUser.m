//
//  WoUser.m
//  MyHome
//
//  Created by HXL on 15/6/4.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WoUser.h"

@implementation WoUser

-(instancetype)initWithData:(NSDictionary *)param{
    if (self=[super init]) {
        _facephotoUrl=param[@"facephoto"];
        _nickname=param[@"nickname"];
        _gender=param[@"gender"];
    }
    return self;
}


@end
