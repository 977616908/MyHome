//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingShareController.h"

@interface RoutingShareController ()


@property (weak, nonatomic) UIView *bgView;

@end

@implementation RoutingShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"rt_content"];
    [self.view addSubview:imageView];
    self.view.backgroundColor=[UIColor clearColor];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 135)];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.center=self.view.center;
    self.bgView=bgView;
    [self.view addSubview:bgView];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 140)];
    img.image=[UIImage imageNamed:@"rt_sharebg"];
    [bgView addSubview:img];
    
    CCButton *btnExit=CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(bgView.frame)-12, 5, 24, 24), @selector(onClick:), self);
    [btnExit alterNormalBackgroundImage:@"rt_exit"];
    [bgView addSubview:btnExit];
    
    CCButton *btnShare=CCButtonCreateWithValue(CGRectMake(43, 40, 94, 22), @selector(onClick:), self);
    btnShare.backgroundColor=RGBCommon(140, 181, 156);
    [btnShare alterNormalTitle:@"分享"];
    [btnShare alterFontSize:14.0f];
    [bgView addSubview:btnShare];
    
    CCButton *btnPay=CCButtonCreateWithValue(CGRectMake(43, 80, 94, 22), @selector(onClick:), self);
    [btnPay alterNormalTitle:@"购买"];
    [btnPay alterFontSize:14.0f];
    btnPay.backgroundColor=RGBCommon(140, 181, 156);
    [bgView addSubview:btnPay];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    CGFloat hg=self.bgView.top;
    self.bgView.top=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top=hg;
    }];
    
}




- (void)onClick:(id)sender {
    [self exitCurrentController];

}


-(void)exitCurrentController{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top=0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end
