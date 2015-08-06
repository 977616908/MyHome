//
//  LineStandView.m
//  MyHome
//
//  Created by HXL on 14/11/11.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "LiveDownView.h"

@interface LiveDownView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *arrContent;
}


@end

@implementation LiveDownView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
//        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"hm_sruked"]];
//        self.backgroundColor=[UIColor grayColor];
        arrContent=[NSMutableArray array];
        _tableView=[[UITableView alloc]init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.layer.borderWidth=1;
        _tableView.layer.borderColor=[[UIColor grayColor]CGColor];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setBounces:YES];
        [self addSubview:_tableView];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _heightTb=30.0f;
    }
    return self;
}


-(void)setArrayList:(NSArray *)arrayList{
    _arrayList=arrayList;
    [arrContent removeAllObjects];
    [arrContent addObjectsFromArray:arrayList];
    [_tableView reloadData];
}

-(void)showHidden:(BOOL)hidden{
    _isHidden=hidden;
    CGFloat hg=ScreenHeight()-self.frame.origin.y-65;
//    if (!is_iOS7()) {
//        hg+=20;
//    }
    hg=hg<_heightTb*arrContent.count?hg:_heightTb*arrContent.count;
    CGFloat height=hidden?0:hg;
    CGFloat noHeight=hidden?hg:0;
    
    _tableView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame),noHeight);
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.1*arrContent.count];
    _tableView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
    [UIView commitAnimations];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text=arrContent[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
    cell.textLabel.numberOfLines=0;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _heightTb;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.liveDown(arrContent[indexPath.row]);
}

@end
