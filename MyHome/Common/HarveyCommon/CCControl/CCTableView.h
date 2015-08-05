//
//  CCTableView.h
//  HarveySDK
//
//  Created by Harvey on 13-11-5.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTableView : UITableView

/// 获取CCTableView实例
+ (CCTableView *)createStylePlainWithFrame:(CGRect)frame target:(id)target;

/// 获取CCTableView实例
+ (CCTableView *)createStyleGroupWithFrame:(CGRect)frame target:(id)target;

/// 获取CCTableView实例
UIKIT_EXTERN CCTableView *CCTableViewCreateStylePlain(CGRect frame,id target,BOOL noSeparatorStyle);

/// 获取CCTableView实例
UIKIT_EXTERN CCTableView *CCTableViewCreateStyleGroup(CGRect frame,id target);

@end
