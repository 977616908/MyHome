//
//  WiFiSetViewController.m
//  MyHome
//
//  Created by Harvey on 14-6-4.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WiFiSetNameViewController.h"
#import "SevenSwitch.h"
#import "CCTextField.h"

@interface WiFiSetNameViewController ()<UIAlertViewDelegate>{
    MBProgressHUD *stateView;
    NSString *tvName;
}
@property (nonatomic,weak) CCTextField *wifiName;

@end

@implementation WiFiSetNameViewController

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
    self.navigationItem.title = @"WiFi设置";
    
    
    
    //    UIImageView *bgImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    //    //    UIView *bgImage=[[UIView alloc]init];
    //    bgImage.frame=CGRectMake(27, 25, 266, 42);
    //    [self.view addSubview:bgImage];
    //    CCTextField *textName=[[CCTextField alloc]initWithFrame:CGRectMake(35,25, 236, 42)];
    CCTextField *textName=[[CCTextField alloc]initWithFrame:CGRectMake(27, 25, 266, 42)];
    [textName setBackgroundColor:[UIColor whiteColor]];
    textName.textColor=RGBCommon(52, 52, 52);
    textName.font=[UIFont systemFontOfSize:16.0f];
    textName.layer.borderWidth=0.5;
    textName.layer.borderColor=RGBCommon(197, 197, 197).CGColor;
    
    textName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    //    [textPwd setTextAlignment:NSTextAlignmentLeft|NSTextAlignmentCenter];
    textName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入名称" attributes:@{NSForegroundColorAttributeName:RGBCommon(181, 181, 181)}];
    tvName=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERNAME];
    textName.text=tvName;
    self.wifiName=textName;
    [self.view addSubview:textName];
    
    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(27, 85, 266, 42), @selector(onClick:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    btnBind.tag=1;
    [btnBind alterFontSize:18];
    [btnBind alterNormalTitle:@"确定"];
    [self.view addSubview:btnBind];
    
}


-(void)HTTPRequest{
    [self initGetWithURL:ROUTINGBASEURL path:@"module/sys_hostname_get" paras:@{@"token": [GlobalShare getToken]} mark:@"device" autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@,%@",response,mark);
    if ([mark isEqualToString:@"device"]) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            tvName=response[@"hostname"];
            _wifiName.text=tvName;
        }
    }else if([mark isEqualToString:@"device1"]){
        //        if ([response isKindOfClass:[NSDictionary class]]) {
        //            NSNumber *status=response[@"status"];
        //            if (status.intValue==0||status.intValue==1) {
        //                stateView.labelText=@"设置成功";
        //            }else{
        //                stateView.labelText=@"设置失败";
        //            }
        //            [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
        //        }
        NSNumber *code=response[@"returnCode"];
        if ([code integerValue]==200) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:_wifiName.text forKey:ROUTERNAME];
            [user synchronize];
            stateView.labelText=@"设置成功";
        }else{
            stateView.labelText=response[@"desc"];
        }
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    PSLog(@"%@ : %@",mark,error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)onClick:(id)sender
{
    [self.view endEditing:YES];
    NSString *hostName=_wifiName.text;
    int count= hostName.length;
    NSString *message=count<1?@"请输入路由名称":(count>25?@"请输入名称不能多于25个字":nil);
    if (tvName&&[hostName isEqualToString:tvName])message=@"修改的名称与当前路由名称一致,请重新输入!";
    if (message) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定修改设备名?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil]show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        stateView.removeFromSuperViewOnHide=YES;
        stateView.labelText=@"正在设置...";
        //        [self initGetWithURL:ROUTINGBASEURL path:@"module/sys_hostname_set" paras:@{@"token": [GlobalShare getToken],@"hostname":_wifiName.text} mark:@"device1" autoRequest:YES];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *userData= [user objectForKey:USERDATA];
        NSString *userPhone=userData[@"userPhone"];
        [self initGetWithURL:FLOWTTBASEURL path:@"routerRename" paras:@{@"user": userPhone,@"wifiname":_wifiName.text} mark:@"device1" autoRequest:YES];
        //        [self initPostWithURL:FLOWTTBASEURL path:@"routerRename" paras:@{@"user": userPhone,@"wifiname":_wifiName.text} mark:@"device1" autoRequest:YES];
    }
}

@end
