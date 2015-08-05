//
//  MyHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "LoginRegisterController.h"
#import "ScannerViewController.h"
#import "CCTextField.h"
#import "PiFiiBaseTabBarController.h"

typedef enum{
    LOGINTYPE,
    REGISTERTYPE
}SelectType;
@interface LoginRegisterController ()<UIAlertViewDelegate,ScannerMacDelegate>{
    MBProgressHUD *stateView;
    BOOL isBind;
    NSString *userPhone;
    NSMutableArray *arrAddress;
    NSMutableArray  *arrImg;
    NSMutableOrderedSet *_saveSet;
    BOOL isAdd;
}

@property (nonatomic,assign)SelectType type;
@property(nonatomic,weak)CCScrollView *rootScrollView;
@property (weak, nonatomic) UIView *bgLine;

@property (weak, nonatomic)CCTextField    *loginPhone;
@property (weak, nonatomic)CCTextField    *loginPwd;

@property (weak, nonatomic)CCTextField    *registerPhone;
@property (weak, nonatomic)CCTextField    *registerPwd;
@property (weak, nonatomic)CCButton       *lbType;
@property (nonatomic,strong)DeviceEcho    *echo;
@end

@implementation LoginRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=@"hm_bg".colorInstance;
    [self createNav];
    [self createLoginView];
    [self createRegisterView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}


-(void)createNav{
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, gh, 80, 44) backgroundColor:[UIColor clearColor]];
//    [navTopView addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(10, 11.75, 12, 20.5))];
//    NSString *prasentTitle  = @"返回";
//    CCButton *btnBack = CCButtonCreateWithValue(CGRectMake(25, 0, 40,44), @selector(exitCurrentController), self);
//    [btnBack alterNormalTitle:prasentTitle];
//    [btnBack alterNormalTitleColor:RGBWhiteColor()];
//    [btnBack alterFontSize:18];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_fanhui"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btnBack.hidden=YES;
    [navTopView addSubview:btnBack];
    [self.view addSubview:navTopView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 36)];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    CCButton *btnLogin=CCButtonCreateWithValue(CGRectMake(0, 0, 160, 35), @selector(onClickType:), self);
    btnLogin.tag=1;
    [btnLogin alterFontSize:18.0f];
    [btnLogin alterNormalTitle:@"登录"];
    [btnLogin alterNormalTitleColor:RGBCommon(104, 78, 111)];
    [bgView addSubview:btnLogin];
    
    CCButton *btnRegister=CCButtonCreateWithValue(CGRectMake(160, 0, 160, 35), @selector(onClickType:), self);
    btnRegister.tag=2;
    [btnRegister alterFontSize:18.0f];
    [btnRegister alterNormalTitle:@"注册"];
    [btnRegister alterNormalTitleColor:RGBCommon(104, 78, 111)];
    [bgView addSubview:btnRegister];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 320, 1)];
    lineView.backgroundColor=RGBCommon(104, 78, 111);
    [bgView addSubview:lineView];
    
    UIView *bgLine=[[UIView alloc]initWithFrame:CGRectMake(0, 34, 160, 2)];
    bgLine.backgroundColor=RGBCommon(104, 78, 111);
    self.bgLine=bgLine;
    [bgView addSubview:bgLine];
    
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, CGRectGetMaxY(bgView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), self, YES);
    rootScrollView.bounces=YES;
    rootScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame)*2, 0);
    self.rootScrollView=rootScrollView;
    [self.view addSubview:rootScrollView];
}

#pragma mark -创建登录
-(void)createLoginView{
    UIImageView *bgUser=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_login_kuang"]];
    bgUser.frame=CGRectMake(27, 60, 266, 50);
    [_rootScrollView addSubview:bgUser];
    CCImageView *imgUser=CCImageViewCreateWithNewValue(@"hm_shoujii", CGRectMake(8, 17, 20, 20));
    [bgUser addSubview:imgUser];
    
    CCTextField *tfUser=[[CCTextField alloc]initWithFrame:CGRectMake(53,60, 236, 50)];
    [tfUser setBackgroundColor:[UIColor clearColor]];
//    tfUser.textColor=RGBCommon(100, 192, 237);
    tfUser.textColor=[UIColor whiteColor];
    tfUser.font=[UIFont systemFontOfSize:16.0f];
    tfUser.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [tfUser setKeyboardType:UIKeyboardTypeNumberPad];
    tfUser.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName:RGBAlpha(255, 255, 255, 0.4)}];
    tfUser.type=TextFieldTel;
    _loginPhone=tfUser;
    [_rootScrollView addSubview:tfUser];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *txtPhone=userData[@"userPhone"];
    if (txtPhone&&![txtPhone isEqualToString:@""]) {
        [tfUser setTxt:txtPhone];
    }
    
    UIImageView *bgPwd=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_login_kuang"]];
    bgPwd.frame=CGRectMake(27, CGRectGetMaxY(bgUser.frame)+15, 266, 50);
    [_rootScrollView addSubview:bgPwd];
    CCImageView *imgPwd=CCImageViewCreateWithNewValue(@"hm_mima", CGRectMake(8, 17, 20, 20));
    [bgPwd addSubview:imgPwd];
    
    CCTextField *tfPwd=[[CCTextField alloc]initWithFrame:CGRectMake(53,CGRectGetMaxY(bgUser.frame)+15, 236, 50)];
    [tfPwd setBackgroundColor:[UIColor clearColor]];
    tfPwd.textColor=[UIColor whiteColor];
    tfPwd.font=[UIFont systemFontOfSize:16.0f];
    tfPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
//    tfPwd.placeholder=@"密码";
    tfPwd.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:RGBAlpha(255, 255, 255, 0.4)}];
    tfPwd.secureTextEntry=YES;
    _loginPwd=tfPwd;
    [_rootScrollView addSubview:tfPwd];
    
    CCButton *showPwd=CCButtonCreateWithFrame(CGRectMake(210, 15, 20, 20));
    [showPwd alterNormalBackgroundImage:@"hm_yjguan"];
    showPwd.tag=1;
    [showPwd addTarget:self action:@selector(onShowPwd:) forControlEvents:UIControlEventTouchUpInside];
    [tfPwd addSubview:showPwd];
    
    CCButton *btnLogin=CCButtonCreateWithValue(CGRectMake(27, CGRectGetMaxY(bgPwd.frame)+15, 266, 50), @selector(onClick:), self);
    btnLogin.backgroundColor=RGBAlpha(255, 255, 255, 0.4);
    btnLogin.tag=1;
    [btnLogin setTitleColor:RGBCommon(106, 85, 27) forState:UIControlStateNormal];
    [btnLogin alterFontSize:18];
    [btnLogin alterNormalTitle:@"登录"];
    [_rootScrollView addSubview:btnLogin];
}

#pragma mark -创建注册
-(void)createRegisterView{
    CGFloat wh=CGRectGetWidth(self.view.frame);
    CCButton *btnSao=CCButtonCreateWithValue(CGRectMake(129+wh, 15+30, 64, 64), @selector(onBind), self);
    [btnSao alterNormalBackgroundImage:@"hm_sao"];
    [_rootScrollView addSubview:btnSao];
    
    CCButton *btnType=CCButtonCreateWithFrame(CGRectMake(27+wh, CGRectGetMaxY(btnSao.frame)+10, 266, 22));
    [btnType alterFontSize:16];
    [btnType alterNormalTitle:@"扫一扫"];
    self.lbType=btnType;
    [_rootScrollView addSubview:btnType];
    
    UIImageView *bgUser=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_login_kuang"]];
    bgUser.frame=CGRectMake(27+wh, CGRectGetMaxY(btnType.frame)+10, 266, 50);
    [_rootScrollView addSubview:bgUser];
    CCImageView *imgUser=CCImageViewCreateWithNewValue(@"hm_shoujii", CGRectMake(8, 17, 20, 20));
    [bgUser addSubview:imgUser];
    
    CCTextField *tfUser=[[CCTextField alloc]initWithFrame:CGRectMake(53+wh,CGRectGetMaxY(btnType.frame)+10, 236, 50)];
    [tfUser setBackgroundColor:[UIColor clearColor]];
    tfUser.textColor=[UIColor whiteColor];
    tfUser.font=[UIFont systemFontOfSize:16.0f];
    tfUser.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [tfUser setKeyboardType:UIKeyboardTypeNumberPad];
    tfUser.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName:RGBAlpha(255, 255, 255, 0.4)}];
    tfUser.type=TextFieldTel;
    _registerPhone=tfUser;
    [_rootScrollView addSubview:tfUser];
    
    
    UIImageView *bgPwd=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_login_kuang"]];
    bgPwd.frame=CGRectMake(27+wh, CGRectGetMaxY(bgUser.frame)+15, 266, 50);
    [_rootScrollView addSubview:bgPwd];
    CCImageView *imgPwd=CCImageViewCreateWithNewValue(@"hm_mima", CGRectMake(8, 17, 20, 20));
    [bgPwd addSubview:imgPwd];
    
    CCTextField *tfPwd=[[CCTextField alloc]initWithFrame:CGRectMake(53+wh,CGRectGetMaxY(bgUser.frame)+15, 236, 50)];
    [tfPwd setBackgroundColor:[UIColor clearColor]];
    tfPwd.textColor=[UIColor whiteColor];
    tfPwd.font=[UIFont systemFontOfSize:16.0f];
    tfPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tfPwd.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:RGBAlpha(255, 255, 255, 0.4)}];
    tfPwd.secureTextEntry=YES;
    _registerPwd=tfPwd;
    [_rootScrollView addSubview:tfPwd];
    
    CCButton *btnPwd=CCButtonCreateWithFrame(CGRectMake(210, 15, 20, 20));
    [btnPwd alterNormalBackgroundImage:@"hm_yjguan"];
    btnPwd.tag=2;
    [btnPwd addTarget:self action:@selector(onShowPwd:) forControlEvents:UIControlEventTouchUpInside];
    [tfPwd addSubview:btnPwd];
    
    CCButton *btnLogin=CCButtonCreateWithValue(CGRectMake(27+wh, CGRectGetMaxY(bgPwd.frame)+15, 266, 50), @selector(onClick:), self);
    btnLogin.backgroundColor=RGBAlpha(255, 255, 255, 0.4);
    [btnLogin setTitleColor:RGBCommon(106, 85, 27) forState:UIControlStateNormal];
    btnLogin.tag=2;
    [btnLogin alterFontSize:18];
    [btnLogin alterNormalTitle:@"注册"];
    [_rootScrollView addSubview:btnLogin];
}

-(void)scannerMacWithDeviceEcho:(DeviceEcho *)echo{
    if (echo) {
        isBind=YES;
        [_lbType setImage:[UIImage imageNamed:@"hm_wifi"] forState:UIControlStateNormal];
        [_lbType setTitle:[NSString stringWithFormat:@" %@",echo.name] forState:UIControlStateNormal];
        self.echo=echo;
    }
}

-(void)onBind{
    [self.navigationController.view.layer addAnimation:[self customAnimation1:self.view upDown:YES] forKey:@"animation1"];
    ScannerViewController *svc = [[ScannerViewController alloc]init];
    svc.type=ScannerMac;
    svc.delegate=self;
    [self.navigationController pushViewController:svc animated:NO];
}

-(void)onShowPwd:(CCButton *)sendar{
    BOOL isSecure;
    if (sendar.tag==1) {
        _loginPwd.secureTextEntry=!_loginPwd.isSecureTextEntry;
        isSecure=_loginPwd.isSecureTextEntry;
    }else{
        _registerPwd.secureTextEntry=!_registerPwd.isSecureTextEntry;
         isSecure=_registerPwd.isSecureTextEntry;
    }
    if (isSecure) {
        [sendar alterNormalBackgroundImage:@"hm_yjguan"];
    }else{
        [sendar alterNormalBackgroundImage:@"hm_yjkai"];
    }
}

-(void)onClickType:(CCButton *)sender {
    BOOL isLeft=sender.tag==1?YES:NO;
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
//    CGRect rect=self.bgLine.frame;
//    rect.origin.x=self.rootScrollView.contentOffset.x/2;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.bgLine.frame=rect;
//    }];
    if (_rootScrollView.contentOffset.x<=0) {
        [self moveLine:YES];
    }else{
        [self moveLine:NO];
    }
}


#pragma -mark 获取绑定图片
-(void)getImg{
    arrAddress=[NSMutableArray arrayWithArray:@[ROUTER_FOLDER_BASEURL(@"Photo")]];
    arrImg=[NSMutableArray array];
    _saveSet=[NSMutableOrderedSet orderedSet];
    isAdd=YES;
    [self initWithRequestAll];
}

-(void)initWithRequestAll{
    if (arrAddress.count==0&&isAdd) {
        isAdd=NO;
        [arrAddress addObjectsFromArray:@[ROUTER_FOLDER_BASEURL(@"Data"),ROUTER_FOLDER_BASEURL(@"Data/download")]];
    }
    if (arrAddress.count>0) {
        NSString *path=arrAddress[0];
        [arrAddress removeObject:path];
        [self initGetWithURL:path
                        path:nil
                       paras:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"list", [GlobalShare getToken], @"token", nil]
                        mark:@"getImg"
                 autoRequest:YES];
    }else{
        [self downImageWithArray:arrImg];
    }
    
}

-(void)downImageWithArray:(NSArray *)arr{
    NSString *saveArchtive=pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ImageCacher *image=[[ImageCacher alloc]init];
        for (NSString *path in arr) {
            PSLog(@"---%@---",path);
            [image downImage:path];
        }
    });
}

#pragma -mark 登录与注册业务

-(void)onClick:(CCButton *)sendar
{
    [self.view endEditing:YES];
    NSString *userPwd;
    switch (sendar.tag) {
        case 1:
            _type=LOGINTYPE;
            userPhone=_loginPhone.text?[_loginPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""]:@"";
            userPwd=_loginPwd.text?_loginPwd.text:@"";
            break;
        case 2:
            _type=REGISTERTYPE;
            userPhone=_registerPhone.text?[_registerPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""]:@"";
            userPwd=_registerPwd.text?_registerPwd.text:@"";
            break;
    }
    
//    if (_type==REGISTERTYPE&&!isBind) {
//        [self showDialog:@"请扫一扫绑定路由设备"];
//        return;
//    }
    
    if (![self isCorrect:userPhone]) {
        [self showDialog:@"请输入正确的手机号码"];
        return;
    }
    
    if (userPwd.length<6) {
        [self showDialog:@"请输入6-16位密码"];
        return;
    }
    
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    if (_type==LOGINTYPE) {
        stateView.labelText=@"正在登录...";
        [self initPostWithPath:@"login"
                         paras:@{@"tradeCode": @(1002),
                                 @"user": userPhone,
                                 @"password": userPwd
                                 }
                          mark:@"login"
                   autoRequest:YES];
    }else{
        stateView.labelText=@"正在注册...";
        NSString *mac=@"";//00A2F51122A1
        NSString *wifiName=@"";
        if (_echo) {
            wifiName=_echo.name;
            mac=[[_echo.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""]uppercaseString];
        }
        [self initPostWithPath:@"register"
                         paras:@{@"tradeCode": @(1001),
                                 @"user": userPhone,
                                 @"password": userPwd,
                                 @"mac":mac,
                                 @"wifiname":wifiName
                                 }
                          mark:@"register"
                   autoRequest:YES];
    }
}

-(BOOL)isCorrect:(NSString*)message{
    if ([GlobalShare isValidateEmail:message]||[GlobalShare isValidateMobile:message]) {
        return true;
    }
    return false;
}

-(void)showDialog:(NSString *)msg{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    if ([mark isEqualToString:@"getImg"]) {
        NSArray *fileInfo = [response objectForKey:@"contents"];
        for (NSDictionary *info in fileInfo) {
            NSString *path = [info objectForKey:@"path"];
            NSNumber *isDir=[info objectForKey:@"is_dir"];
            NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
            if (![name hasPrefix:@"."]) {
                NSRange range=[name rangeOfString:@"."];
                if (range.location!=NSNotFound&&![isDir boolValue]) {
                    NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                    BOOL isMyNeed =[self isImageWithFileSuffix:suffix];
                    if (isMyNeed) {
                        [arrImg addObject:path];
                        name=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        [_saveSet addObject:name];
                    }
                }else{
                    if (isAdd) {
                        PSLog(@"%@",ROUTER_FOLDER_BASEURL(path));
                        NSString *address=[ROUTER_FOLDER_BASEURL(path) encodedString];
                        [arrAddress addObject:address];
                    }
                }
            }
        }
        [self initWithRequestAll];
    }else if([mark isEqualToString:@"bind"]){
        PSLog(@"%@",response);
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        if ([returnCode intValue]==200) {
            [self bindMacWithDeviceEcho:self.echo];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:[response objectForKey:@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    
    }else{
        [NSThread sleepForTimeInterval:1];
        PSLog(@"%@",response);
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            NSDictionary *data=[response objectForKey:@"data"];
            NSString *mac=data[@"mac"];
            NSString *wifiName=data[@"wifiname"];
            if(isNIL(mac))mac=@"";
            if(isNIL(wifiName))wifiName=@"";
            [self saveUserData:@{@"userPhone":userPhone,@"mac":mac,@"wifiName":wifiName}];
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            if (_type==REGISTERTYPE) {
                if (_echo&&isBind) {
                    _echo.isConnect=YES;
                    [self bindMacWithDeviceEcho:_echo];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功!是否绑定当前路由?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil] show];
                }
            }else{
                NSString *mac=data[@"mac"];
                if (isNIL(mac)) {
                     [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功!是否绑定当前路由?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil] show];
                }else{
                    _echo=[[DeviceEcho alloc]init];
                    _echo.name=wifiName;
                    _echo.macAddr=mac;
                    [self bindMac:mac];
                }
            }
        }else{
            NSString *msg=[response objectForKey:@"desc"];
            if (isNIL(msg)) {
                msg=@"网络异常，请检查网络!";
            }
            stateView.labelText=msg;
            [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
//             [[[UIAlertView alloc]initWithTitle:@"提示" message:[response objectForKey:@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"是"]) {
        stateView.hidden=NO;
        stateView.labelText=@"正在绑定...请稍候!";
        [self performSelector:@selector(bindMac:) withObject:nil afterDelay:1.5];
    }else{
//        if (![self.navigationController popToRootViewControllerAnimated:YES]) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//        [self exitCurrentController];
        PiFiiBaseTabBarController *tab=[[PiFiiBaseTabBarController alloc]init];
        [self presentViewController:tab animated:YES completion:nil];
    }
}


-(void)bindMac:(NSString *)macAddress{
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
                               mymodels.isConnect=YES;
                               
                               NSString *macBind=[[mymodels.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""] lowercaseString];
                               if (macAddress) {
                                   macBind=[macBind substringToIndex:macBind.length-1];
                                   NSString *address=[[macAddress stringByReplacingOccurrencesOfString:@":" withString:@""]lowercaseString];
                                   address=[address substringToIndex:macAddress.length-1];
                                   if ([address isEqualToString:macBind]) {
                                        [self bindMacWithDeviceEcho:mymodels];
                                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                                   }else{
                                       _echo.isConnect=NO;
                                       [self bindMacWithDeviceEcho:_echo];
                                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆成功！该账号绑定的不是当前连接的路由，请重新绑定。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                                   }
                               }else{
                                   _echo=mymodels;
                                   [self initPostWithPath:@"routerBind"
                                                    paras:@{@"tradeCode": @(1005),
                                                            @"user": userPhone,
                                                            @"mac":macBind,
                                                            @"wifiname":mymodels.name
                                                            }
                                                     mark:@"bind"
                                              autoRequest:YES];
                               }
                           }else{
                               [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有可管理的路由器!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                           }
                           PSLog(@"echos: %@",_mydataArray);
                       }];

}


-(void)bindMacWithDeviceEcho:(DeviceEcho *)deviceEcho{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (deviceEcho.isConnect) {
        [user setObject:deviceEcho.token forKey:TOKEN];
        [user setObject:deviceEcho.hostIP forKey:ROUTERIP];
    }
    [user setObject:deviceEcho.macAddr forKey:ROUTERMAC];
    [user setObject:deviceEcho.name forKey:ROUTERNAME];
    [user setObject:@YES forKey:BOUNDMAC];
    [user setObject:@(deviceEcho.isConnect) forKey:ISCONNECT];
    [user synchronize];
    if(deviceEcho.isConnect)[self getImg];//获取绑定的图片
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    NSDictionary *param=error.userInfo;
    if (![mark isEqualToString:@"getImg"]){
        if (_type==LOGINTYPE) {
            stateView.labelText=[NSString stringWithFormat:@"%@,登录失败!",param[@"error"]];
        }else{
            stateView.labelText=[NSString stringWithFormat:@"%@,注册失败!",param[@"error"]];
        }
        PSLog(@"%@=%@",mark,error);
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
  
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
//            [self exitCurrentController];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CATransition *)customAnimation1:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = @"oglFlip";//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

#pragma mark -- 保存用户日记
-(void)saveUserData:(NSDictionary *)data;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:USERDATA];
    [userDefaults setObject:@YES forKey:ISLOGIN];
    [userDefaults setObject:@YES forKey:ISLOADING];
    [userDefaults synchronize];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;
}
    
@end
