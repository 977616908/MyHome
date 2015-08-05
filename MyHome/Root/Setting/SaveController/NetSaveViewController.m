//
//  NetSaveViewController.m
//  MyHome
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetSaveViewController.h"
#import "WWTagsCloudView.h"
#import "CCTextField.h"
#import "NetBackPwdViewController.h"
#import "ApplyViewController.h"

@interface NetSaveViewController (){
    BOOL isOff;//NO表示关闭,YES开启
    NSMutableArray *onArr;
    NSMutableArray *offArr;
    NSArray *colorArr;
    NSString *password;
}
@property(nonatomic,weak)WWTagsCloudView *tagView;
@property(nonatomic,weak)UILabel *lbTitle;
@property(nonatomic,weak)UIImageView *imgBg;
@property(nonatomic,weak)CCImageView *imgShow;
@property(nonatomic,weak)MHTextField *txtPwd;
@property(nonatomic,weak)UIView *startView;
@property(nonatomic,weak)CCButton *btnStart;

@end

@implementation NetSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContent];
    [self createNav];
    [self createView];
    [self showImage];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)initContent{
    onArr=[NSMutableArray array];
    offArr=[NSMutableArray array];
    colorArr=@[RGBCommon(8, 118, 162),[UIColor whiteColor]];
    NSArray *nameArr=@[@"hm_save00.jpg",@"hm_save00.jpg",@"hm_save01.jpg",@"hm_save01.jpg",@"hm_save01.jpg",@"hm_save01.jpg",@"hm_save02.jpg",@"hm_save02.jpg",@"hm_save02.jpg",@"hm_save02.jpg",@"hm_save03.jpg",@"hm_save03.jpg"];
    for (int i=0; i<nameArr.count; i++) {
        NSString *path=[[NSBundle mainBundle]pathForResource:nameArr[i] ofType:nil];
        UIImage *imgStart=[UIImage imageWithContentsOfFile:path];
        [onArr addObject:imgStart];
    }
    for (int j=nameArr.count-1; j>=0; j--) {
        UIImage *imgStop=onArr[j];
        [offArr addObject:imgStop];
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    password=[user objectForKey:NETPASSWORD];
    isOff=[[user objectForKey:ISNET] boolValue];
}

-(void)createNav{
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    UIImageView *imgBg=[[UIImageView alloc]initWithFrame:self.view.frame];
//    imgBg.image=startArr[startArr.count-1];
    self.imgBg=imgBg;
    [self.view addSubview:imgBg];
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, gh, 80, 44) backgroundColor:[UIColor clearColor]];
    [navTopView addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(10, 11.75, 12, 20.5))];
    NSString *prasentTitle  = @"返回";
    CCButton *btnBack = CCButtonCreateWithValue(CGRectMake(25, 0, 40,44), @selector(exitCurrentController), self);
    [btnBack alterNormalTitle:prasentTitle];
    [btnBack alterNormalTitleColor:RGBWhiteColor()];
    [btnBack alterFontSize:18];
    [navTopView addSubview:btnBack];
    [self.view addSubview:navTopView];

}

-(void)exitCurrentController{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ApplyViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (void)createView{
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }

    NSArray *arrTag=@[@"色情",@"恐怖",@"反动",@"宣扬暴力",@"垃圾广告"];
    NSArray* colors = @[colorArr[0]];
    NSArray* fonts = @[[UIFont systemFontOfSize:18]];
    WWTagsCloudView *tagView=[[WWTagsCloudView alloc] initWithFrame:CGRectMake(0, 120+gh, 320, 200)
                                                            andTags:arrTag
                                                       andTagColors:colors
                                                           andFonts:fonts
                                                    andParallaxRate:50.7
                                                       andNumOfLine:3];
    _tagView=tagView;
    [self.view addSubview:tagView];
    
    //    UIView *bgView=[];
    CCImageView *imgShow=CCImageViewCreateWithNewValue(@"hm_anniu", CGRectMake(105, 55+gh, 110, 110));
    self.imgShow=imgShow;
    [self.view addSubview:imgShow];
    
    UIView *startView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgShow.frame)+10, 320, 60)];
    startView.backgroundColor=[UIColor clearColor];
    self.startView=startView;
    [self.view addSubview:startView];
    
    MHTextField *txtPwd=[[MHTextField alloc]initWithFrame:CGRectMake(40, 0, 240, 34)];
    txtPwd.secureTextEntry=YES;
    txtPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtPwd.textColor=RGBCommon(196, 216, 251);
    txtPwd.font=[UIFont systemFontOfSize:16.0];
    txtPwd.background=[UIImage imageNamed:@"hm_srk"];
    txtPwd.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    txtPwd.leftViewMode=UITextFieldViewModeAlways;
    txtPwd.placeholder=@"请输入密码关闭健康模式";
    self.txtPwd=txtPwd;
    UIBarButtonItem *doneBarButton=txtPwd.toolbar.items[1];
    CCButton *done=(CCButton *)doneBarButton.customView;
    [done alterNormalTitle:@"关闭"];
    [done addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [startView addSubview:txtPwd];
    
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(CGRectGetMaxX(txtPwd.frame)-80, CGRectGetMaxY(txtPwd.frame)+5, 80, 20), @selector(onTypeClick:), self);
    btnBack.tag=1;
    [btnBack alterNormalTitle:@"找回密码"];
    [btnBack alterFontSize:16.0];
    [startView addSubview:btnBack];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(80, CGRectGetMaxY(imgShow.frame)+15, 160, 42), @selector(onTypeClick:), self);
    btnStart.backgroundColor=RGBCommon(63, 205, 225);
    btnStart.tag=2;
    [btnStart alterFontSize:20];
    [btnStart alterNormalTitle:@"开启"];
    self.btnStart=btnStart;
    btnStart.hidden=YES;
    [self.view addSubview:btnStart];
    
    CCLabel *lbTitle=CCLabelCreateWithNewValue(@"您可能访问到这些网站:", 20.0f, CGRectMake(30, CGRectGetMaxY(imgShow.frame)+80, 250, 30));
    lbTitle.backgroundColor=[UIColor clearColor];
    lbTitle.textAlignment=NSTextAlignmentCenter;
    lbTitle.textColor=colorArr[0];
    _lbTitle=lbTitle;
    [self.view addSubview:lbTitle];
    
}

-(void)onClick{
    
    [self.view endEditing:YES];
    NSString *pwd=_txtPwd.text;
    if ([password isEqualToString:pwd]) {
        isOff=YES;
        _txtPwd.text=@"";
        [self show:isOff];
    }else{
        NSString *message=@"输入的密码有误!";
        if ([pwd isEqualToString:@""]) {
            message=@"请输入密码";
        }
        [[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }
}

-(void)show:(BOOL)isShow{
    if (_imgBg.isAnimating)return;
    if (isShow) {//NO表示关闭,YES开启
        _imgBg.animationImages=offArr;
        _imgBg.animationDuration=offArr.count*0.1;
    }else{
        _imgBg.animationImages=onArr;
        _imgBg.animationDuration=onArr.count*0.1;
    }
    _imgBg.animationRepeatCount=1;
    [_imgBg startAnimating];
//    [self showImage];
    [self performSelector:@selector(showImage) withObject:nil afterDelay:1.5];
}

-(void)showImage{
    if (isOff) {//NO表示关闭,YES开启
        _tagView.tagColorArray=@[colorArr[1]];
        _lbTitle.textColor=colorArr[1];
        _lbTitle.text=@"您可能访问到这些网站:";
        [_tagView reloadAllTags];
        _imgShow.image=[UIImage imageNamed:@"hm_anniu02"];
        _btnStart.hidden=NO;
        _startView.hidden=YES;
       _imgBg.image=onArr[0];
    }else{
        _tagView.tagColorArray=@[colorArr[0]];
        _lbTitle.textColor=colorArr[0];
        _lbTitle.text=@"您将无法访问这些网站:";
        [_tagView reloadAllTags];
        _imgShow.image=[UIImage imageNamed:@"hm_anniu"];
        _btnStart.hidden=YES;
        _startView.hidden=NO;
       _imgBg.image=offArr[0];
    }
    PSLog(@"----结束----");
}

-(void)onTypeClick:(CCButton *)sendar{
    if (sendar.tag==1) {
        NetBackPwdViewController *pwdController=[[NetBackPwdViewController alloc]init];
        [self.navigationController pushViewController:pwdController animated:YES];
    }else{
        isOff=NO;
        [self show:isOff];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    NSUserDefaults *use=[NSUserDefaults standardUserDefaults];
    [use setObject:@(isOff) forKey:ISNET];
    [use synchronize];
}

@end
