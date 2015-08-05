//
//  FlashInView.m
//  PiFiiHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ApplyView.h"

#define HEIGHT 202
@interface ApplyView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSArray *_arrTitle;
}

@property(nonatomic,weak)UIView *moveView;
@end
@implementation ApplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =RGBAlpha(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelfView:)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        [self createApply];

    }
    return self;
}


-(void)createApply{
    _arrTitle=@[@{@"icon":@"hm_shigxc",@"title":@"时光相册"},
                @{@"icon":@"hm_shext",@"title":@"智能摄像头"},
                @{@"icon":@"hm_wqswkj",@"title":@"安全上网控件"},
                @{@"icon":@"hm_sgmore",@"title":@"其它"}];
    UIView * childView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), 320 , HEIGHT)];
    CCTableView *table=CCTableViewCreateStylePlain(CGRectMake(0, 0, CGRectGetWidth(childView.frame), CGRectGetHeight(childView.frame)), self, NO);
    table.backgroundColor=[UIColor clearColor];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), 30)];
    headView.backgroundColor=[UIColor clearColor];
    CCLabel *lbMsg=CCLabelCreateWithNewValue(@"选择要连接的设备", 16.0, CGRectMake(15, 0, CGRectGetWidth(headView.frame)-15, CGRectGetHeight(headView.frame)));
    lbMsg.textColor=[UIColor whiteColor];
    [headView addSubview:lbMsg];
    
    table.tableHeaderView=headView;
    
    [childView addSubview:table];
    self.moveView=childView;
    [self addSubview:childView];
}


-(void)moveTransiton:(BOOL)isAnimation{
    self.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (isAnimation) {
            _moveView.transform=CGAffineTransformMakeTranslation(0, 2-HEIGHT);
        }else{
            _moveView.transform=CGAffineTransformIdentity;
        }
    }completion:^(BOOL finished) {
        self.hidden=!isAnimation;
    }];
}

- (void)hiddenSelfView:(UITapGestureRecognizer *)gesture
{
   self.type(-1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTitle.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_jiantou"]];
    }
    NSDictionary *param=_arrTitle[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:param[@"icon"]];
    cell.textLabel.text=param[@"title"];
    cell.textLabel.textColor=RGBCommon(52, 52, 52);
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.type(indexPath.row);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")])
        return NO;
    else
        return YES;
}

@end
