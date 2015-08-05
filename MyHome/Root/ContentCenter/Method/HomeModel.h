//
//  HomeModel.h
//  MyHome
//
//  Created by HXL on 15/4/2.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
/// 活动标题
@property (nonatomic,copy) NSString *item1;
@property (nonatomic,copy) NSString *item2;
@property (nonatomic,copy) NSString *item3;
@property (nonatomic,copy) NSString *item4;
@property (nonatomic,copy) NSString *item5;
@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *image3;
@property (nonatomic,copy) NSString *image4;
@property (nonatomic,copy) NSString *image5;
@property (nonatomic,copy) NSDictionary *Diction1;
@property (nonatomic,assign) BOOL isSelect;
@end
