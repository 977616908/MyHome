//
//  RoutingCell.h
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontprintCell : UITableViewCell

+(instancetype)cellWithTarget:(id)target tableView:(UITableView *)tableView;

@property(nonatomic,assign)BOOL isDouble;

@end
