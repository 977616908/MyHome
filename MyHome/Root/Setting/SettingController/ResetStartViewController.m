//
//  ResetStartRoutingViewController.m
//  MyHome
//
//  Created by Harvey on 14-6-4.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ResetStartViewController.h"

@interface ResetStartViewController ()<UIAlertViewDelegate>{
    MBProgressHUD *stateView;
}
@property (nonatomic,weak) CCImageView *startImage;
@end

@implementation ResetStartViewController

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
    self.navigationItem.title = @"重启路由器";
    [self createView];
}


-(void)createView{
    CCImageView *startImg=CCImageViewCreateWithNewValue(@"hm_jindu", CGRectMake(CGRectGetWidth(self.view.frame)/2-31, 20, 62, 62));
    self.startImage=startImg;
    [self.view addSubview:startImg];
    
    CCLabel *lbMessage=CCLabelCreateWithNewValue(@"1. 重启后将会中断当前所有接连,需要约1分钟才能恢复\n2. 重启后可能需要手动连接WiFi", 16.0, CGRectMake(15, CGRectGetMaxY(startImg.frame)+20, CGRectGetWidth(self.view.frame)-30, 60));
    lbMessage.textColor=RGBCommon(52, 52, 52);
    lbMessage.numberOfLines=0;
    [self.view addSubview:lbMessage];
    
    CCButton *btnOk=CCButtonCreateWithValue(CGRectMake(15, CGRectGetMaxY(lbMessage.frame)+15, CGRectGetWidth(self.view.frame)-30, 42), @selector(restartRouting:), self);
    [btnOk alterFontSize:18.0];
    btnOk.backgroundColor=RGBCommon(63, 205, 225);
    [btnOk alterNormalTitle:@"确定"];
    [self.view addSubview:btnOk];
    
    
    
}

- (void)restartRouting:(id)sender
{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否需要重启设备?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重启", nil]show];
}


-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@:%@",response,mark);
    if ([mark isEqualToString:@"device"]) {
        //        if ([response isKindOfClass:[NSDictionary class]]) {
        //            id status=response[@"status"];
        //            if ([status integerValue]==1||[status integerValue]==0) {
        //                stateView.labelText=@"正在启动...请等待";
        //                [self performSelector:@selector(showSuccess:) withObject:@1 afterDelay:6];
        //            }else{
        //                stateView.labelText=@"重启失败...正在检测";
        //               [self performSelector:@selector(showSuccess:) withObject:@0 afterDelay:1.5];
        //            }
        //
        //        }
        NSNumber *code=response[@"returnCode"];
        if ([code integerValue]==200) {
            stateView.labelText=@"正在启动...请等待";
        }else{
            stateView.labelText=@"重启失败...正在检测";
        }
        [self performSelector:@selector(showSuccess:) withObject:response[@"desc"] afterDelay:1.5];
    }
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    //    [self showSuccess:@(0)];
    [self showSuccess:@"网络异常，请检测网络!"];
}

//-(void)showSuccess:(id) isStatue{
//    stateView.hidden=YES;
//    [_startImage.layer removeAllAnimations];
//    if ([isStatue boolValue]) {
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"重启成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
//    }else{
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"重启失败,请检测是否为当前路由!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
//    }
//}

-(void)showSuccess:(NSString *) msg{
    stateView.hidden=YES;
    [_startImage.layer removeAllAnimations];
    [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.duration = 1.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INT32_MAX;
        [_startImage.layer addAnimation:rotationAnimation forKey:@"rotation"];
        
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        stateView.removeFromSuperViewOnHide=YES;
        stateView.labelText=@"正在重启路由器...";
        //        [self initGetWithURL:ROUTINGBASEURL path:@"module/sys_reboot_set" paras:@{@"token": [GlobalShare getToken]} mark:@"device" autoRequest:YES];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *userData= [user objectForKey:USERDATA];
        NSString *userPhone=userData[@"userPhone"];
        [self initGetWithURL:FLOWTTBASEURL path:@"routerReboot" paras:@{@"user": userPhone} mark:@"device" autoRequest:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
