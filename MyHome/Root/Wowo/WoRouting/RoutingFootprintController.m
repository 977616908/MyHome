//
//  MyHomeController.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingFootprintController.h"
#import "FontprintCell.h"

@interface RoutingFootprintController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)CCTableView *table;


@end

@implementation RoutingFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title=@"时光脚印";
    CGFloat gh=44;
    if(is_iOS7()){
        gh+=20;
    }
    CCTableView *table=CCTableViewCreateStylePlain(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), self, YES);
    table.backgroundColor=[UIColor clearColor];
    self.table=table;
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FontprintCell *cell=[FontprintCell cellWithTarget:self tableView:tableView];
    if (indexPath.row%2==0) {
        cell.isDouble=YES;
    }else{
        cell.isDouble=NO;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138.0f;
}


@end
