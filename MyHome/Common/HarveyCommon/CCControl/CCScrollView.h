//
//  CCScrollView.h
//  Own
//
//  Created by Harvey on 13-9-8.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCScrollViewTouchDelegate;

@interface CCScrollView : UIScrollView

@property(nonatomic,weak)id<CCScrollViewTouchDelegate> touchDelegate;
/// 获取CCScrollView实例
+ (CCScrollView *)createWithFrame:(CGRect)frame;

/// 获取CCScrollView实例
UIKIT_EXTERN CCScrollView *CCScrollViewCreateNoneIndicatorWithFrame(CGRect frame,id target,BOOL pagingEnabled);

@end

@protocol CCScrollViewTouchDelegate <NSObject>

-(void)scrollViewWithTouch:(NSSet *)touches withEvent:(UIEvent *)event scrollView:(id)scrollView;

@end