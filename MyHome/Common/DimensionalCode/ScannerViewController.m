//
//  ScannerViewController.m
//  YYQMusic
//
//  Created by Harvey on 13-10-18.
//  Copyright (c) 2013年 广东星外星文化传播有限公司. All rights reserved.
//

#import "ScannerViewController.h"

#define H_DegreesToRadinas(x) (M_PI * (x)/180.0)

@interface ScannerViewController()<UIAlertViewDelegate>{
    MBProgressHUD *stateView;
}

@end


@implementation ScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    OutMethodMessage;
    [self myViewDidLoad];
    [self coustomNav];
    NSString *backImage = @"hm_bg00_iOS6";
    if (is_iOS7()) {
        
        backImage = @"hm_bg00";
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:backImage] forBarMetrics:UIBarMetricsDefault];
    viewSize = self.view.frame.size;
    //self.navigationItem.hidesBackButton = YES;;
    CGFloat gh=0;
    if (is_iOS7()) {
        gh+=20;
    }
    self.readview.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-gh);
    
    
    tipBack = CCLabelCreateWithNewValue(@"正在为你开启摄像头...", 16, CGRectMake(0, 0, viewSize.width, viewSize.height - 44));
    
    tipBack.textColor = [UIColor whiteColor];
    tipBack.backgroundColor = RGBBlackColor();
    tipBack.alpha = 0;
    tipBack.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipBack];
    
    [UIView animateWithDuration:.5 animations:^{
        
        tipBack.alpha = 1;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeTip) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden=YES;
    OutMethodMessage;
}


- (void)coustomNav
{
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (is_iOS7()^1) {//低于ios7执行
        negativeSpacer.width=0;
    }else{
        negativeSpacer.width=-10;
    }
    if (self.type==ScannerMac) {
        self.title=@"快速绑定";
    }else{
        self.title=@"扫一扫";
    }

    self.navigationController.hidesBottomBarWhenPushed = YES;
    rigViewNav = [CCView createWithFrame:CGRectMake(0, 0, 49, 44) backgroundColor:RGBClearColor()];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCurrentController)];
    [rigViewNav addGestureRecognizer:tap];
    
    [rigViewNav addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(5, 11.75, 12, 20.5))];
    NSString *praentTitle  = @"返回";
    CCLabel *_labTitle = CCLabelCreateWithNewValue(praentTitle, 18, CGRectMake(20, 0, 100, 44));
    _labTitle.textColor = RGBWhiteColor();
    _labTitle.backgroundColor = RGBClearColor();
    [rigViewNav addSubview:_labTitle];
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:rigViewNav];
    //       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigViewNav];
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,leftBarItem];
    self.scanDelegate = self;
//    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)exitCurrentController
{
    [self.readview stop];
    [self.readview flushCache];
    if (self.type==ScannerMac||self.type==ScannerOther) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f ;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1;
        animation.removedOnCompletion = NO;
        animation.type = @"oglFlip";//101
        animation.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (![self.navigationController popViewControllerAnimated:YES]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)DimensionalCodeReaderWithContent:(NSString *)myContent
                               fromImage:(UIImage *)image
{
//    svc.crInfo = myContent;
    PSLog(@"myDim:%@",myContent);
    if (self.type==ScannerMac) {
        [self performSelector:@selector(bindMac:) withObject:myContent afterDelay:1.5];
    }else if(self.type==ScannerOther){
        [self.readview stop];
        [self.readview flushCache];
        //    [self.scanLine.layer removeAllAnimations];
        self.scanLine.hidden=YES;
        [self.delegate scannerMessage:myContent];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    }
    else{
        if (tipView.frame.origin.y == (org_Y - 180)) {
            return;
        }
        crMsg.text = myContent;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.38];
        tipView.frame = CGRectMake(0, org_Y - 180, 320, 180);
        [UIView commitAnimations];
    }
}

#pragma mark -绑定界面
- (void)bindMac:(NSString *)mac
{
    [self.readview stop];
    [self.readview flushCache];
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
//    [self.scanLine.layer removeAllAnimations];
    self.scanLine.hidden=YES;
    stateView.removeFromSuperViewOnHide=YES;
    stateView.labelText=@"正在绑定...请稍候";
    [self performSelector:@selector(requestSaveBindMac:) withObject:mac afterDelay:1.5];
}

-(void)requestSaveBindMac:(NSString *)mac{
    NSMutableArray *_mydataArray=[NSMutableArray array];
    WFXDeviceFinder * finder = [[WFXDeviceFinder alloc] initWithDispatcher:[[SemiAsyncDispatcher alloc] init]];
    [finder findAllDevicesMatched:^(NSArray *responsedEchos) {
        [_mydataArray addObjectsFromArray:responsedEchos];
    }
                           missed:^{
                           }
                       completion:^{
                           if (_mydataArray.count >0) {
                               DeviceEcho *mymodels = [_mydataArray objectAtIndex:0];
                               PSLog(@"************%@",mymodels);
                               NSString *macBind=[[mymodels.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""] uppercaseString];
                               macBind=[macBind substringToIndex:macBind.length-1];
                               
                               NSString *macAddress=mac;
                               macAddress=[[macAddress stringByReplacingOccurrencesOfString:@":" withString:@""] uppercaseString];
                               macAddress=[macAddress substringToIndex:macAddress.length-1];
                               
                              PSLog(@"---%@----%@",macBind,macAddress);
                              if (![macBind isEqualToString:macAddress]) {
                                  [[[UIAlertView alloc]initWithTitle:@"提示" message:@"扫描路由跟当前连接的路由地址不一致，扫描失败，请确定后重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                                  [self performSelector:@selector(setStateView:) withObject:@NO afterDelay:0.5];
                                  return;
                              }
//                               [self.delegate scannerWithParam:@{@"mac":mymodels.macAddr,@"name":mymodels.name}];
//                               NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                               [user setObject:mymodels.token forKey:TOKEN];
//                               [user setObject:mymodels.hostIP forKey:ROUTERIP];
//                               [user setObject:mymodels.macAddr forKey:ROUTERMAC];
//                               [user setObject:mymodels.name forKey:ROUTERNAME];
//                               [user setObject:@(YES) forKey:BOUNDMAC];
//                               [user synchronize];
                               if ([self.delegate respondsToSelector:@selector(scannerMacWithDeviceEcho:)]) {
                                   [self.delegate scannerMacWithDeviceEcho:mymodels];
                               }
                               stateView.labelText=@"扫描成功!";
                               [self performSelector:@selector(setStateView:) withObject:@YES afterDelay:0.5];
                           }else{
                               [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有可管理的路由器，请确定路由后重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                           }
                       }];
}

-(void)setStateView:(id)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state boolValue]) {
            [self exitCurrentController];
        }
    }];
}



- (void)removeTip
{
    [UIView animateWithDuration:.5 animations:^{
        
        tipBack.alpha = 0;
    } completion:^(BOOL finished) {
        
        tipBack.hidden = YES;
    }];
}

- (void)myViewDidLoad
{
    CGRect rect = self.readview.frame;
    rect.origin.y = (viewSize.height - 280 - 44)/2.0f;
      self.readview.frame = rect;
    
    rect = self.scanLine.frame;
    rect.origin.y = (viewSize.height - 280 - 44)/2.0f;
    rect.origin.y += 15;
    rect.origin.x += 15;
    rect.size.width -= 30;
    self.scanLine.frame = rect;
    self.isEnbleScanLine = YES;
    self.scanLine.hidden = NO;
    [self.readview stop];
    CCLabel *tip = CCLabelCreateWithNewValue(@"请将二维码放入扫描框内，即可自动扫描", 14, CGRectMake(0,  self.readview.frame.origin.y + 290, viewSize.width, 20));
    [self performSelector:@selector(startScanner) withObject:nil afterDelay:1.0];
    tip.textColor = [UIColor whiteColor];
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    
    CABasicAnimation *opAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    opAnim.fromValue = [NSNumber numberWithFloat:0];
    opAnim.toValue= [NSNumber numberWithFloat: 280 - 30];
    opAnim.duration = 2.0;
    opAnim.cumulative = YES;
    opAnim.autoreverses = YES;
    opAnim.repeatCount = INT32_MAX;
    [self.scanLine.layer addAnimation:opAnim forKey:@"transform.translation.y"];

    CCImageView *angle = CCImageViewCreateWithNewValue(@"green", CGRectMake(25, self.readview.frame.origin.y + 5, 25, 25));
    [self.view addSubview:angle];
    
    angle = CCImageViewCreateWithNewValue(@"green", CGRectMake(25, self.readview.frame.origin.y + 250, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(-90));
    [self.view addSubview:angle];
    
    angle = CCImageViewCreateWithNewValue(@"green",CGRectMake(viewSize.width - 50, self.readview.frame.origin.y + 5, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(90));
    [self.view addSubview:angle];

    angle = CCImageViewCreateWithNewValue(@"green",CGRectMake(viewSize.width - 50, self.readview.frame.origin.y + 250, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(180));
    [self.view addSubview:angle];
    
    [self scannerTipView];
}

-(void)startScanner{
    [self.readview start];
}

- (void)scannerTipView
{
    org_Y = 504;
    if (is3_5Screen()) {
        
        org_Y = 416;
    }
    
    tipView = [CCView createWithFrame:CGRectMake(0, org_Y, 320, 180) backgroundColor:RGBWhiteColor()];
    [self.view addSubview:tipView];
    
    CCLabel *tip = CCLabelCreateWithNewValue(@"是否确定下载", 17, CGRectMake(0, 20, 320, 40));
    tip.textAlignment = NSTextAlignmentCenter;
    [tipView addSubview:tip];
    
    crMsg = CCLabelCreateWithNewValue(@"", 14, CGRectMake(20, 60, 280, 52));
    crMsg.numberOfLines = 3;
    [tipView addSubview:crMsg];
    
    CCImageView *actionView = CCImageViewCreateWithNewValue(@"0730aj", CGRectMake(13, 125, 294, 41));
    actionView.userInteractionEnabled = YES;
    [tipView addSubview:actionView];
    
    CCButton *cancel = CCButtonCreateWithValue(CGRectMake(0, 0, 147, 41), @selector(cancelOrOK:), self);
    [cancel alterNormalTitle:@"取消"];
    [cancel alterFontSize:15];
    [cancel alterNormalTitleColor:RGBBlackColor()];
    cancel.tag = 0;
    [actionView addSubview:cancel];
    
    CCButton *BtnOK = CCButtonCreateWithValue(CGRectMake(147, 0, 147, 41), @selector(cancelOrOK:), self);
    [BtnOK alterNormalTitle:@"确定"];
    BtnOK.tag = 1;
    [BtnOK alterNormalTitleColor:RGBBlackColor()];
    [BtnOK alterFontSize:15];
    [actionView addSubview:BtnOK];
}

- (void)cancelOrOK:(CCButton *)btn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    tipView.frame = CGRectMake(0, org_Y, 320, 180);
    [UIView commitAnimations];
    if (btn.tag==1) {// 确定
        [self.readview stop];
        [self.readview flushCache];
        DownLoadViewController *dvc = [[DownLoadViewController alloc]init];
        dvc.url = crMsg.text;
        [self.navigationController pushViewController:dvc animated:YES];
        PSLog(@"确定 %@",crMsg.text);
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self exitCurrentController];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
