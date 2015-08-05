//
//  PiFiiSiderView.h
//  MyHome
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CCView.h"
#import "PiFiiSiderViewCell.h"
typedef void(^PushStepViewController)(NSInteger index);

@interface PiFiiSiderView : CCView<UITableViewDelegate,UITableViewDataSource>
{
    CCTableView         *_mainTableView;
    NSMutableArray      *_data;
}

@property (nonatomic,copy)PushStepViewController  pushStepViewController;
@property (nonatomic,assign)BOOL bindMac;

@end
