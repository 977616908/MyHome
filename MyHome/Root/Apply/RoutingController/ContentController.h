//
//  ContentViewController.h
//  MyHome
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentController : UIViewController
@property(nonatomic,assign)BOOL isLeft;
@property (strong,nonatomic)id dataObject;
@property(nonatomic,strong,readonly)UIImage *imageShow;
@property(nonatomic,assign)CGFloat viewHg;
@end
