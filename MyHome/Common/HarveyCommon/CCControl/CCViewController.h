//
//  CCViewController.h
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCViewController : UIViewController
{
    CGSize viewSize;
}

/// 变量初始化在此函数进行
- (void)initBase;

/// 更改风格, 例如: 背影颜色, 导航风格,等
- (void)initStyle;

/// 添加子控件在此函数进行
- (void)addControl;

/// 网络请求此函数进行
- (void)HTTPRequest;

@end
