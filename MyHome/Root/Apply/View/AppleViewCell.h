//
//  AppleViewCell.h
//  MyHome
//
//  Created by HXL on 15/8/21.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppleStatue.h"

@interface AppleViewCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)table;

@property(nonatomic,strong)AppleStatue *state;

-(void)setViewStyle:(NSInteger)styleTag;

@end
