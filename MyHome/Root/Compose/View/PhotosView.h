//
//  PhotosView.h
//  MyHome
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosViewDelegate <NSObject>
@optional
-(void)photosTapWithIndex:(NSInteger)index;

@end

@interface PhotosView : UIView

@property(nonatomic,assign)BOOL isAdd;

@property(nonatomic,weak)id<PhotosViewDelegate> delegate;
/**
 *  添加一张新的图片
 */
- (UIImageView *)addImage:(UIImage *)image duration:(NSString *)duration;

/**
 *  返回内部所有的图片
 */
- (NSArray *)totalImages;
@end
