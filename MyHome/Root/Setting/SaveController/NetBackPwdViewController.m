//
//  SettingOneViewController.m
//  MyHome
//
//  Created by Harvey on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetBackPwdViewController.h"
#import "MBProgressHUD.h"
#import "CCTextField.h"
#import "NetSaveViewController.h"

@interface NetBackPwdViewController (){
    MBProgressHUD *_dialing;
    NSTimer *_timer;
    NSInteger _countDown;
}
@property (nonatomic,weak)   CCTextField *tfNumber;
@property (nonatomic,weak)   CCTextField *tfPwd;
@property (nonatomic,weak)   CCButton    *btnSend;

@end

@implementation NetBackPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
    _countDown=60;
    UIImageView *bgPwd=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    bgPwd.frame=CGRectMake(27, 25, 266, 42);
    [self.view addSubview:bgPwd];
    CCButton *btnPwd=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnPwd setImage:[UIImage imageNamed:@"hm_miyao02"] forState:UIControlStateNormal];
    [bgPwd addSubview:btnPwd];
    
    CCTextField *tfPwd=[[CCTextField alloc]initWithFrame:CGRectMake(53,25, 236, 42)];
    [tfPwd setBackgroundColor:[UIColor clearColor]];
    tfPwd.textColor=RGBCommon(63, 205, 225);
    tfPwd.font=[UIFont systemFontOfSize:16.0f];
    tfPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tfPwd.placeholder=@"新密码";
    tfPwd.secureTextEntry=YES;
    _tfPwd=tfPwd;
    [self.view addSubview:tfPwd];
    
    UIImageView *bgUser=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    bgUser.frame=CGRectMake(27, 85, 176, 42);
    [self.view addSubview:bgUser];
    CCButton *btnUser=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnUser setImage:[UIImage imageNamed:@"hm_shoujii02"] forState:UIControlStateNormal];
    [bgUser addSubview:btnUser];
    
    CCTextField *tfUser=[[CCTextField alloc]initWithFrame:CGRectMake(53,85, 160, 42)];
    tfUser.textColor=RGBCommon(63, 205, 225);
    tfUser.font=[UIFont systemFontOfSize:16.0f];
    tfUser.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [tfUser setKeyboardType:UIKeyboardTypeNumberPad];
    tfUser.placeholder=@"短信验证码";
    tfUser.enabled=NO;
    tfUser.backgroundColor=[UIColor clearColor];
    _tfNumber=tfUser;
    [self.view addSubview:tfUser];
    
    CCButton *btnMsg=CCButtonCreateWithValue(CGRectMake(CGRectGetMaxX(bgUser.frame)+5, 85, 95, 42), @selector(onSend:), self);
    [btnMsg alterFontSize:15.0f];
    [btnMsg alterNormalTitleColor:RGBCommon(63, 205, 225)];
    [btnMsg alterNormalTitle:@"获取验证码"];
    self.btnSend=btnMsg;
    [self.view addSubview:btnMsg];
    
    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(27, 144, 266, 42), @selector(onClick:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    [btnBind alterFontSize:18];
    [btnBind alterNormalTitle:@"确定"];
    [self.view addSubview:btnBind];
    
 
}

- (void)onClick:(id)sendar
{
    [self.view endEditing:YES];
    NSString *number=_tfNumber.text?_tfNumber.text:@"";
    NSString *pwd=_tfPwd.text?_tfPwd.text:@"";

    if (pwd.length<6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入6-16位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }

    if(number.length!=4){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    NSUserDefaults *use=[NSUserDefaults standardUserDefaults];
    [use setObject:pwd forKey:NETPASSWORD];
    [use synchronize];
    _dialing = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _dialing.labelText = @"正在设置密码...请稍后";
    [self performSelector:@selector(showSuccess:) withObject:@1 afterDelay:1.5];
}

-(void)onSend:(CCButton *)sendar{
    [self startTimer];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{

   
    PSLog(@"%@=%@",mark,response);
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@=%@",mark,error);

}

-(void)showSuccess:(id) isStatue{
    _dialing.labelText=@"设置成功!";
    [_dialing hide:YES afterDelay:1.5];
    [self performSelector:@selector(startNetSave) withObject:nil afterDelay:1.5];
}

-(void)startNetSave{
    NetSaveViewController *saveController=[[NetSaveViewController alloc]init];
    [self.navigationController pushViewController:saveController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startTimer{
    _tfNumber.enabled=YES;
    _btnSend.enabled=NO;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onTimer{
    if (_countDown>0) {
        [_btnSend alterNormalTitle:[NSString stringWithFormat:@"%d秒重新获取",_countDown]];
        _countDown--;
    }else{
        _countDown=60;
        [_timer invalidate];
        _timer=nil;
        _tfNumber.enabled=NO;
        _btnSend.enabled=YES;
        [_btnSend alterNormalTitle:@"获取验证码"];
    }
}

@end
