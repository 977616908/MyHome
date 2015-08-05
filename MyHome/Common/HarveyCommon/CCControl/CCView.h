//
//  CCView.h
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCView : UIView
{
    CGSize viewSize;
}

/// 将内容加载到视图上
- (void)viewLoad;

/// 变量初始化在此函数进行
- (void)initBase;

/// 更改风格, 例如: 背影颜色, 定义导航风格等
- (void)initStyle;

/// 添加子控件在此函数进行
- (void)addControl;

/// 网络请求此函数进行
- (void)HTTPRequest;

/// 启动旋转动画, duration旋转一周所有的时间
- (void)startRotationAnimationWithDuration:(NSTimeInterval)duration;

/// 停止旋转动画
- (void)stopRotationAnimation;

/// 返回一个View实例
+ (id)createWithFrame:(CGRect)frame;

/// 返回一个View实例
+ (id)createWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

- (void)addAction:(SEL)action runTarget:(id)target;

@end
