//
//  CCDownloadViewController.m
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingOrderViewController.h"


@interface RoutingOrderViewController (){

}

@property (nonatomic,weak) UIView         *bgLine;
@property (nonatomic,weak) CCScrollView   *rootScrollView;


@end

@implementation RoutingOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"订单管理";
    [self createView];
}


-(void)createView{
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 37)];
    bgView.layer.borderWidth=0.5;
    bgView.layer.borderColor=[RGBCommon(2, 137, 193) CGColor];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    CCButton *btnDownLoad=CCButtonCreateWithValue(CGRectMake(0, 0, 160, 37), @selector(onClick:), self);
    btnDownLoad.tag=1;
    [btnDownLoad alterFontSize:18.0f];
    [btnDownLoad alterNormalTitle:@"当前订单"];
    [btnDownLoad alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnDownLoad];
    
    CCButton *btnDownFinish=CCButtonCreateWithValue(CGRectMake(160, 0, 160, 37), @selector(onClick:), self);
    btnDownFinish.tag=2;
    [btnDownFinish alterFontSize:18.0f];
    [btnDownFinish alterNormalTitle:@"历史订单"];
    [btnDownFinish alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnDownFinish];
    
    UIView *bgLine=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 160, 2)];
    bgLine.backgroundColor=RGBCommon(2, 137, 193);
    self.bgLine=bgLine;
    [bgView addSubview:bgLine];
    
    CGFloat hg=64;
    hg=[UIScreen mainScreen].bounds.size.height-hg-37;
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 37, CGRectGetWidth(self.view.frame), hg), self, YES);
    rootScrollView.bounces=YES;
    rootScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame)*2, 0);
    self.rootScrollView=rootScrollView;
    [self.view addSubview:rootScrollView];
    
 
}



- (void)onClick:(CCButton *)sendar
{
    BOOL isLeft=sendar.tag==1?YES:NO;
    PSLog(@"======刷新clickMe---%d---",isLeft);
    [self moveLine:isLeft];
}

-(void)moveLine:(BOOL)isLeft{
    CGRect rect=self.bgLine.frame;
    CGFloat move=0;
    if (isLeft) {
        rect.origin.x=0;
        move=0;
    }else{
        rect.origin.x=160;
        move=320;
    }
    [UIView animateWithDuration:0.35 animations:^{
        self.bgLine.frame=rect;
        _rootScrollView.contentOffset = CGPointMake(move, 0);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_rootScrollView.contentOffset.x<=0) {
        [self moveLine:YES];
    }else{
        [self moveLine:NO];
    }
}




- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@:%@",mark,error);
    if ([mark isEqualToString:@"add"]) {
      
    }
}

#pragma mark 加载成功返回值

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    
}






@end

