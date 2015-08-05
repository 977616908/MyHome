//
//  LeafScrollView.h
//  LeafScrollView
//
//  Created by Wang on 14-5-12.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RoutingView;
typedef void (^BeginUpdatingBlock)(RoutingView *);

@interface RoutingView : UIView
@property (nonatomic,assign,readonly) BOOL isLoading;
@property (strong,nonatomic) BeginUpdatingBlock beginUpdatingBlock;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImgView;
/**
 *  内容视图大小，可根据此摆放你的内容视图
 */
@property (assign,nonatomic) CGRect contentRect;
/**
 *  刷新时的图片
 *
 *  @param image 图片
 */
-(void)setRefreshImage:(UIImage *)image;

/**
 *  背景图片
 *
 *  @param image 图片
 */
-(void)setBgImage:(UIImage *)image;
/**
 *  您需要展示的视图，可展示范围可通过contentRect获取
 */
@property(strong,nonatomic) UIView *contentView;
/**
 *  停止刷新状态
 */
-(void)endUpdating;

@end
