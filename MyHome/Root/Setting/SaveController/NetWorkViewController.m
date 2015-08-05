//
//  SettingOneViewController.m
//  MyHome
//
//  Created by Harvey on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetWorkViewController.h"
#import "MBProgressHUD.h"
#import "CCTextField.h"
#import "NetSaveViewController.h"

@interface NetWorkViewController (){
    MBProgressHUD *_dialing;
}
@property (nonatomic,weak)   CCTextField *userPhone;
@property (nonatomic,weak)   CCTextField *pwd;

@end

@implementation NetWorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title = @"安全上网";
    
    UIImageView *bgUser=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    bgUser.frame=CGRectMake(27, 25, 266, 42);
    [self.view addSubview:bgUser];
    CCButton *btnUser=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnUser setImage:[UIImage imageNamed:@"hm_shoujii02"] forState:UIControlStateNormal];
    [bgUser addSubview:btnUser];
    
    CCTextField *tfUser=[[CCTextField alloc]initWithFrame:CGRectMake(53,25, 236, 42)];
    [tfUser setBackgroundColor:[UIColor clearColor]];
    tfUser.textColor=RGBCommon(63, 205, 225);
    tfUser.font=[UIFont systemFontOfSize:16.0f];
    tfUser.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [tfUser setKeyboardType:UIKeyboardTypeNumberPad];
    tfUser.placeholder=@"手机号码";
    tfUser.type=TextFieldTel;
    _userPhone=tfUser;
    [self.view addSubview:tfUser];
    
    
    UIImageView *bgPwd=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    bgPwd.frame=CGRectMake(27, 85, 266, 42);
    [self.view addSubview:bgPwd];
    CCButton *btnPwd=CCButtonCreateWithFrame(CGRectMake(10, 13, 16, 16));
    [btnPwd setImage:[UIImage imageNamed:@"hm_miyao02"] forState:UIControlStateNormal];
    [bgPwd addSubview:btnPwd];
    
    CCTextField *tfPwd=[[CCTextField alloc]initWithFrame:CGRectMake(53,85, 236, 42)];
    [tfPwd setBackgroundColor:[UIColor clearColor]];
    tfPwd.textColor=RGBCommon(63, 205, 225);
    tfPwd.font=[UIFont systemFontOfSize:16.0f];
    tfPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tfPwd.placeholder=@"启用密码";
    tfPwd.secureTextEntry=YES;
    _pwd=tfPwd;
    [self.view addSubview:tfPwd];
    
    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(27, 144, 266, 42), @selector(onClick:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    [btnBind alterFontSize:18];
    [btnBind alterNormalTitle:@"启动"];
    [self.view addSubview:btnBind];
    
    CGRect rectMsg=CGRectMake(27, CGRectGetMaxY(btnBind.frame)+10, 266, 40);
    CCLabel *lbMsg=CCLabelCreateWithNewValue(@"开启后,您将无法访问这些网站:\n 色情、恐怖、反动、暴力", 16,rectMsg);
    lbMsg.textAlignment=NSTextAlignmentCenter;
    lbMsg.numberOfLines=0;
    lbMsg.textColor=RGBCommon(165, 165, 165);
    [self.view addSubview:lbMsg];
}


- (void)onClick:(id)sendar
{
    [self.view endEditing:YES];
    NSString *user=_userPhone.text?[self.userPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""]:@"";
    NSString *pwd=_pwd.text?_pwd.text:@"";
    if(![GlobalShare isValidateMobile:user]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    if (pwd.length<6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入6-16位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    NSUserDefaults *use=[NSUserDefaults standardUserDefaults];
    [use setObject:pwd forKey:NETPASSWORD];
    [use synchronize];
    _dialing = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _dialing.labelText = @"正在启动...请稍后";
    _dialing.removeFromSuperViewOnHide = YES;
    [self performSelector:@selector(showSuccess:) withObject:@1 afterDelay:1.5];
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
    _dialing.labelText=@"启动成功!";
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


@end
