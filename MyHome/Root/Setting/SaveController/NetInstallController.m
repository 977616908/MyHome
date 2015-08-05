//
//  NetSaveViewController.m
//  MyHome
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetInstallController.h"
#import "PFDownloadIndicator.h"


@interface NetInstallController (){
    CGFloat downloadedBytes;
    NSTimer *timer;
}

@property(nonatomic,weak)PFDownloadIndicator *downIndicator;
@property(nonatomic,weak)CCLabel *downMsg;
@property(nonatomic,weak)CCButton *btnStart;
@end

@implementation NetInstallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)createNav{
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, gh, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, 80, 44) backgroundColor:[UIColor clearColor]];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_return"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navTopView addSubview:btnBack];
    [bgView addSubview:navTopView];
    
    
    CCLabel *title=CCLabelCreateWithNewValue(@"连接安全上网控件", 16, CGRectMake(0,CGRectGetMaxY(navTopView.frame)+10,CGRectGetWidth(bgView.frame),16));
    title.textColor=RGBCommon(63, 205, 225);
    title.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:title];
    
    CCLabel *msg=CCLabelCreateWithNewValue(@"有效识别色情图片、文字等不良信息，并拦截屏蔽", 13, CGRectMake(0,CGRectGetMaxY(title.frame)+10,CGRectGetWidth(bgView.frame),14));
    msg.textColor=RGBCommon(155, 155, 155);
    msg.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:msg];
    
    CCImageView *img=CCImageViewCreateWithNewValue(@"hm_routing", CGRectMake(110,CGRectGetMaxY(msg.frame)+100, 100, 67));
    [bgView addSubview:img];
    
    PFDownloadIndicator *downIndicator = [[PFDownloadIndicator alloc]initWithFrame:CGRectMake(90, CGRectGetMaxY(msg.frame)+70, 140, 140) type:kRMClosedIndicator];
    [downIndicator setBackgroundColor:[UIColor clearColor]];
    [downIndicator setFillColor:RGBCommon(201, 201, 201)];
    [downIndicator setStrokeColor:RGBCommon(63, 205, 225)];
    downIndicator.radiusPercent = 0.45;
    
    self.downIndicator=downIndicator;
//    downIndicator.hidden=YES;
    [bgView addSubview:downIndicator];
    [downIndicator loadIndicator];
    
    CCLabel *downMsg=CCLabelCreateWithNewValue(@"正在为您连接中...", 15, CGRectMake(0,CGRectGetMaxY(downIndicator.frame)+15,CGRectGetWidth(bgView.frame),15));
    downMsg.textColor=RGBCommon(123, 123, 123);
    downMsg.textAlignment=NSTextAlignmentCenter;
    self.downMsg=downMsg;
    downMsg.hidden=YES;
    [bgView addSubview:downMsg];
    
    CGFloat hg=30;
    if (ScreenHeight()>480) {
        hg=hg*2;
    }
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(downMsg.frame)+hg, CGRectGetWidth(self.view.frame)-40, 42), @selector(onTypeClick:), self);
    btnStart.backgroundColor=RGBCommon(63, 205, 225);
    btnStart.tag=2;
    [btnStart alterFontSize:20];
    [btnStart alterNormalTitle:@"安装"];
    self.btnStart=btnStart;
    [bgView addSubview:btnStart];

}




-(void)onTypeClick:(CCButton *)sendar{
    self.btnStart.enabled=NO;
    [self startAnimation];
}


#pragma mark - Update Views
- (void)startAnimation
{
    self.downMsg.hidden=NO;
    self.downIndicator.hidden=NO;
    downloadedBytes = 0;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)updateView
{
    downloadedBytes+=arc4random()%5;
    downloadedBytes=downloadedBytes>100?100:downloadedBytes;
    _downMsg.text=[NSString stringWithFormat:@"正在为您安装中...(%.0f%%)",downloadedBytes];
    [_downIndicator updateWithTotalBytes:100 downloadedBytes:downloadedBytes];
    if(downloadedBytes>=100){
        [timer invalidate];
        timer=nil;
        self.btnStart.enabled=YES;
        _downMsg.text=@"安装成功";
        [self.pifiiDelegate pushViewDataSource:@(3)];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:0.7];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

@end
