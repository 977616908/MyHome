//
//  CCTableView.m
//  HarveySDK
//
//  Created by Harvey on 13-11-5.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCTableView.h"

@implementation CCTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CCTableView *)createStylePlainWithFrame:(CGRect)frame target:(id)target
{
    return [CCTableView createWithFrame:frame target:target style:UITableViewStylePlain];
}

+ (CCTableView *)createStyleGroupWithFrame:(CGRect)frame target:(id)target
{
    return [CCTableView createWithFrame:frame target:target style:UITableViewStyleGrouped];
}

UIKIT_EXTERN CCTableView *CCTableViewCreateStylePlain(CGRect frame,id target,BOOL noSeparatorStyle)
{
    CCTableView *tableView = [CCTableView createWithFrame:frame target:target style:UITableViewStylePlain];
    if(noSeparatorStyle){tableView.separatorStyle = UITableViewCellSeparatorStyleNone;}
    return tableView;
}

UIKIT_EXTERN CCTableView *CCTableViewCreateStyleGroup(CGRect frame,id target)
{
    return [CCTableView createWithFrame:frame target:target style:UITableViewStyleGrouped];
}

+ (CCTableView *)createWithFrame:(CGRect)frame target:(id)target style:(UITableViewStyle)style
{
    CCTableView *tableView = [[self alloc] initWithFrame:frame style:style];
    tableView.delegate = (id)target;
    tableView.dataSource = (id)target;
    return tableView;
}

@end
