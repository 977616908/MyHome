//
//  AppleStatue.h
//  MyHome
//
//  Created by HXL on 15/8/21.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleStatue : NSObject
@property(nonatomic,copy)NSString *appIcon;
@property(nonatomic,copy)NSString *appTitle;
@property(nonatomic,copy)NSString *appMsg;
@property(nonatomic,assign)NSInteger appStatue;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,assign)NSInteger appTag;

@end
