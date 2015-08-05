//
//  SettingOneViewController.m
//  MyHome
//
//  Created by Harvey on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetSetViewController.h"
#import "MBProgressHUD.h"
#import "CCTextField.h"

@interface NetSetViewController (){
    MBProgressHUD *_dialing;
}
@property (nonatomic,weak)   CCTextField *user;
@property (nonatomic,weak)   CCTextField *pwd;

@end

@implementation NetSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title = @"快速上网";
    
//    UIImageView *bgUser=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    UIView *bgUser=[[UIView alloc]init];
    bgUser.frame=CGRectMake(27, 25, 266, 42);
    bgUser.backgroundColor=[UIColor whiteColor];
    bgUser.layer.borderWidth=0.5;
    bgUser.layer.borderColor=RGBCommon(197, 197, 197).CGColor;
    [self.view addSubview:bgUser];
    CCButton *btnUser=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnUser setImage:[UIImage imageNamed:@"hm_bhzh"] forState:UIControlStateNormal];
    [bgUser addSubview:btnUser];
    
    CCTextField *tfUser=[[CCTextField alloc]initWithFrame:CGRectMake(53,25, 236, 42)];
    [tfUser setBackgroundColor:[UIColor clearColor]];
    tfUser.textColor=RGBCommon(52, 52, 52);
    tfUser.font=[UIFont systemFontOfSize:16.0f];
    tfUser.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"拨号账号" attributes:@{NSForegroundColorAttributeName:RGBCommon(181, 181, 181)}];
    tfUser.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _user=tfUser;
    [self.view addSubview:tfUser];
    
    
    UIView *bgPwd=[[UIView alloc]init];
    bgPwd.frame=CGRectMake(27, 85, 266, 42);
    bgPwd.backgroundColor=[UIColor whiteColor];
    bgPwd.layer.borderWidth=0.5;
    bgPwd.layer.borderColor=RGBCommon(197, 197, 197).CGColor;
    [self.view addSubview:bgPwd];
    CCButton *btnPwd=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnPwd setImage:[UIImage imageNamed:@"hm_miyao02"] forState:UIControlStateNormal];
    [bgPwd addSubview:btnPwd];
    
    CCTextField *tfPwd=[[CCTextField alloc]initWithFrame:CGRectMake(53,85, 236, 42)];
    [tfPwd setBackgroundColor:[UIColor clearColor]];
    tfPwd.textColor=RGBCommon(100, 192, 237);
    tfPwd.font=[UIFont systemFontOfSize:16.0f];
    tfPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tfPwd.placeholder=@"拨号密码";
    tfPwd.secureTextEntry=YES;
    _pwd=tfPwd;
    [self.view addSubview:tfPwd];
    
    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(27, 144, 266, 42), @selector(onClick:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    [btnBind alterFontSize:18];
    [btnBind alterNormalTitle:@"确定"];
    [self.view addSubview:btnBind];
    
    
}

-(void)HTTPRequest{
//    http://192.168.1.1/cgi-bin/luci/api/0/module/wan_ip_get?token=1124b4ai2ebym1vq
//    [self initGetWithURL:ROUTINGBASEURL path:@"module/wan_ip_get" paras:@{@"token": [GlobalShare getToken]} mark:@"getling" autoRequest:YES];
    NSString *path=[NSString stringWithFormat:@"module/wan_ip_get?token=%@",[GlobalShare getToken]];
    [self initPostWithURL:ROUTINGBASEURL path:path paras:nil mark:@"getling" autoRequest:YES];
}

- (void)onClick:(id)sendar
{
    if (_dialing) {
        
        return;
    }
    [self.view endEditing:YES];
    NSString *user=_user.text?_user.text:@"";
    NSString *pwd=_pwd.text?_pwd.text:@"";
    NSArray *array=@[user,pwd];
    NSArray *arrayContent=@[@"请输入拨号账号",@"请输入拨号密码"];
    for (int i=0; i<array.count; i++) {
        if ([array[i] length]<=0) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:arrayContent[i] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
    }
    _dialing = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _dialing.labelText = @"正在为您拨号...请稍后";
    _dialing.removeFromSuperViewOnHide = YES;
    NSString *path=[NSString stringWithFormat:@"module/wan_ip_set?token=%@",[GlobalShare getToken]];
    [self initPostWithURL:ROUTINGBASEURL
                     path:path
                    paras:@{@"proto": @"pppoe",     /**<拨号联网*/
                            @"user": array[0],    /**<拨号账号*/
                            @"pass": array[1],     /**<拨号密码*/
                            @"auto": @(0),          /**<是否自动重连,1自动重连 0不自动重连*/
                            @"demand":@(0)}         /**<重连时间间隔, 0表示无限重连*/
                     mark:@"dialing"
              autoRequest:YES];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    if ([mark isEqualToString:@"getling"]) {
        NSDictionary *pppoeDict=response[@"pppoe"];
        if (pppoeDict) {
            NSString *pass=pppoeDict[@"pass"];
            NSString *user=pppoeDict[@"user"];
            _user.text=user;
            _pwd.text=pass;
        }
    }else{
        id status=response[@"status"];
        if ([status integerValue]==1||[status integerValue]==0) {
            _dialing.labelText=@"拨号完成...请等待!";
            [self performSelector:@selector(showSuccess:) withObject:@1 afterDelay:1.5];
        }else{
            _dialing.labelText=@"拨号失败...正在检测";
            [self performSelector:@selector(showSuccess:) withObject:@0 afterDelay:1.5];
        }
    }
   
    PSLog(@"%@=%@",mark,response);
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@=%@",mark,error);
    if ([mark isEqualToString:@"dialing"]) {
        _dialing.labelText=@"拨号失败...正在检测";
        [self performSelector:@selector(showSuccess:) withObject:@0 afterDelay:1.5];
    }
}

-(void)showSuccess:(id) isStatue{
    [_dialing hide:YES];
    if ([isStatue boolValue]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"拨号成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"拨号失败,请确定拨号的账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
