//
//  RoutingCell.h
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingTime.h"
#import "RoutingDown.h"
@interface RoutingCell : UITableViewCell

+(instancetype)cellWithTarget:(id)target tableView:(UITableView *)tableView;

@property(nonatomic,strong)RoutingTime *routingTime;
@property(nonatomic,strong)RoutingDown *routingDown;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,assign)BOOL isAdd;
@end
