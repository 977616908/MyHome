//
//  REPhoto.h
//  MyHome
//
//  Created by HXL on 14/12/18.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REPhoto : NSObject
@property(nonatomic,copy)NSString *routingId;
@property(nonatomic,copy) NSString *imageUrl;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSDate  *photoDate;
@property(nonatomic,copy)NSString *duration;
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *rtContent;
@property(nonatomic,assign)BOOL isVedio;
@property(nonatomic,assign)BOOL isBackup;

@end
