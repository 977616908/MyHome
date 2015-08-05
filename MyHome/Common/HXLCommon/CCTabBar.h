//
//  CCTabBar.h
//  MyHome
//
//  Created by HXL on 15/5/19.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCTabBar;

@protocol CCTabBarDelegate <NSObject>

@optional
- (void)tabBar:(CCTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface CCTabBar : UIView

@property(nonatomic,weak) id<CCTabBarDelegate>delegate;

-(void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end


