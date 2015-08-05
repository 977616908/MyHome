//
//  ZeroCenterViewCtr.m
//  MyHome
//
//  Created by HXL on 14-6-5.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WowoViewController.h"
#import "WoEditViewController.h"
#import "RoutingOrderViewController.h"
#import "HtmlViewController.h"
#import "WoButton.h"
#import "BindView.h"
#import "ScannerViewController.h"
#import "WoSetViewController.h"
#import "RoutingFootprintController.h"
#import "WoUser.h"
#import <ShareSDK/ShareSDK.h>

#define BUTTONHEIGHT 75

@interface WowoViewController ()<UITableViewDataSource,UITableViewDelegate,ScannerMacDelegate>{
    NSArray *_arrTitle;
    MBProgressHUD           *stateView;
    BOOL    isMacBounds;
}
@property (nonatomic,weak)CCTableView     *woTable;
@property (nonatomic,weak)BindView        *bindView;
@property (nonatomic,strong)DeviceEcho    *echo;
@property (nonatomic,weak)CCButton        *btnWifii;
@property (nonatomic,weak)UIImageView *imgUser;
@property (nonatomic,weak)UILabel  *lbName;
@property (nonatomic,strong)WoUser *user;

@end

@implementation WowoViewController

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
    _arrTitle=@[@{@"icon":@"hm_sgly",@"title":@"时光路游"},
                @{@"icon":@"hm_tjgpy",@"title":@"推荐给朋友"},
                @{@"icon":@"hm_shezhi",@"title":@"设置"}];
    isMacBounds=[GlobalShare isBindMac];
    
}

-(void)coustomNav{
    CGFloat gh=44+50;
    if(is_iOS7()){
        gh+=20;
    }
    CCTableView *woTable=CCTableViewCreateStyleGroup(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), self);
    self.woTable=woTable;
    woTable.backgroundColor=[UIColor clearColor];
    woTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:woTable];
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.hidden=YES;
}

-(UIView *)createNameView:(CGRect)frame{
    UIView *bgView=[[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
    imageView.layer.masksToBounds=YES;
    imageView.layer.cornerRadius=25;
    imageView.image=[UIImage imageNamed:@"hm_touxiang"];
    self.imgUser=imageView;
    [bgView addSubview:imageView];
    UILabel *lbName=[[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 30, 100, 20)];
    lbName.textColor=RGBCommon(52, 52, 52);
    lbName.font=[UIFont systemFontOfSize:16];
    lbName.text=@"用户名";
    self.lbName=lbName;
    [bgView addSubview:lbName];
    return bgView;
}

-(UIView *)createButtonView:(CGRect)frame{
    UIView *bgView=[[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor=[UIColor whiteColor];
    NSArray *iconArr=@[@"hm_sggj",@"hm_sgjy",@"hm_ddgl"];
    NSArray *titleArr=@[@"时光赶集",@"时光脚印",@"订单管理"];
    for (int i=0; i<iconArr.count; i++) {
        WoButton *btn=[[WoButton alloc]initWithFrame:CGRectMake((BUTTONHEIGHT+15)*i+30, 15, BUTTONHEIGHT, BUTTONHEIGHT)];
        btn.tag=i;
        [btn setImageName:iconArr[i] Title:titleArr[i]];
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(onWoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return bgView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequestUser];
}

-(void)onWoClick:(id)sendar{
    PSLog(@"onClick:%d",[sendar tag]);
    switch ([sendar tag]) {
        case 0:{
            HtmlViewController * web =[[HtmlViewController alloc]init];
            web.url = @"http://ipifii.wxshidai.com/index/list?id=27066";
            web.title =@"时光赶集";
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 1:{
            RoutingFootprintController *fontController=[[RoutingFootprintController alloc]init];
            [self.navigationController pushViewController:fontController animated:YES];
        }
            break;
        case 2:{
            RoutingOrderViewController *orderController=[[RoutingOrderViewController alloc]init];
            [self.navigationController pushViewController:orderController animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma -mark 获取个人信息
-(void)getRequestUser{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    if (userPhone&&![userPhone isEqualToString:@""]) {
        [self initPostWithURL:MyHomeURL path:@"queryUserInfo" paras:@{@"username":userPhone} mark:@"user" autoRequest:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        return _arrTitle.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_jiantou"]];
 
        NSInteger section=indexPath.section;
        if (section==0) {
            cell.backgroundView=[self createNameView:cell.frame];
        }else if(section==1){
            cell.accessoryView.hidden=YES;
        //        [cell insertSubview:[self createButtonView:cell.frame] atIndex:0];
            [cell addSubview:[self createButtonView:cell.frame]];
        }else{
            NSDictionary *param=_arrTitle[indexPath.row];
            if (indexPath.row==0) {
                CCButton *btnWifi=CCButtonCreateWithFrame(CGRectMake(0, 12, CGRectGetWidth(cell.frame)-30, 20));
                btnWifi.backgroundColor=[UIColor clearColor];
                btnWifi.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [btnWifi alterFontSize:14.0];
                [btnWifi alterNormalTitleColor:RGBCommon(109, 109, 109)];
                if (isMacBounds) {
                    btnWifi.imageView.hidden=NO;
                    NSString *pifiiTitle=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERNAME];
                    [btnWifi alterNormalTitle:[NSString stringWithFormat:@" %@",pifiiTitle]];
                    [btnWifi setImage:[UIImage imageNamed:@"hm_wfp"] forState:UIControlStateNormal];
                }else{
                    btnWifi.imageView.hidden=NO;
                    [btnWifi alterNormalTitle:@" 未绑定"];
                    [btnWifi setImage:nil forState:UIControlStateNormal];
                }
                
                [btnWifi addTarget:self action:@selector(bindMacListener:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnWifi];
            }
            cell.imageView.image=[UIImage imageNamed:param[@"icon"]];
            cell.textLabel.text=param[@"title"];
            cell.textLabel.textColor=RGBCommon(52, 52, 52);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    if (section==0) {
        WoEditViewController *editController=[[WoEditViewController alloc]init];
        editController.user=self.user;
        [self.navigationController pushViewController:editController animated:YES];
    }else if(section==2){
        NSLog(@"---[%d]--",indexPath.row);
        switch (indexPath.row) {
            case 0://绑定
//                [self bindMac];
                break;
            case 1://分享
                [self shareSDK];
                break;
            case 2:{
                WoSetViewController *setController=[[WoSetViewController alloc]init];
                [self.navigationController pushViewController:setController animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma -mark 分享信息
-(void)shareSDK{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"hm_bg.png" ofType:nil];
    NSString *content=@"时光路游:可分享图片、视频等功能，快来点击下载分享吧!!";//@"要分享的内容"
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认内容"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"时光路游 - 美好记忆的开始"
                                                  url:@"http://www.pifii.com"
                                          description:@"来自时光路游"
                                            mediaType:SSPublishContentMediaTypeNews];
    //1+创建弹出菜单容器（iPad必要）
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                    message:nil
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
//                                    
                                    [self showToast:@"推荐成功" Long:2];
                                }
                                else if (state == SSResponseStateFail)
                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
                                    [self showToast:[NSString stringWithFormat:@"推荐失败(%@)",[error errorDescription]] Long:2];
                                }
                            }];
}


#pragma -mark 绑定与未绑定
-(void)bindMacListener:(CCButton *)sendar{
    self.btnWifii=sendar;
    if (!self.bindView) {
        CGFloat gh=0;
        if(is_iOS7())gh=50;
        BindView *bindView=[[BindView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
        self.bindView=bindView;
        [self.view addSubview:bindView];
    }
    self.bindView.isBind=isMacBounds;
    [self.bindView moveTransiton:YES];
    self.bindView.type=^(NSInteger tag,NSString *statue){
        switch (tag) {
            case 1://扫一扫
            {
                [self.navigationController.view.layer addAnimation:[self customAnimation1:self.view upDown:YES] forKey:@"animation1"];
                ScannerViewController *svc = [[ScannerViewController alloc]init];
                svc.type=ScannerMac;
                svc.delegate=self;
                [self.navigationController pushViewController:svc animated:NO];
            }
                break;
            case 2://绑定
                if (!_echo) {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请扫一扫要绑定路由设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                    return;
                }
                [_bindView moveTransiton:NO];
                [self routerBind:NO Statue:nil];
                
                break;
            case 3://解绑
                [_bindView moveTransiton:NO];
                [self routerBind:YES Statue:statue];
                break;
            default:
                [_bindView moveTransiton:NO];
                break;
        }
        
    };
}


#pragma mark -绑定与解绑
-(void)routerBind:(BOOL)isBind Statue:(NSString *)statue{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    stateView.hidden=NO;
    if (isBind) { //解绑
        stateView.labelText=[NSString stringWithFormat:@"正在解绑...请稍候!"];
        [self initPostWithPath:@"routerUnBind"
                         paras:@{@"tradeCode": @(1006),
                                 @"user":userPhone,
                                 @"password":statue
                                 }
                          mark:@"unBind"
                   autoRequest:YES];
    }else{ //绑定
        stateView.labelText=[NSString stringWithFormat:@"正在绑定...请稍候!"];
        NSString *mac=[[self.echo.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""]uppercaseString];
        [self initPostWithPath:@"routerBind"
                         paras:@{@"tradeCode": @(1005),
                                 @"user":userPhone,
                                 @"mac":mac,
                                 @"wifiname":self.echo.name
                                 }
                          mark:@"bind"
                   autoRequest:YES];
    }
    
}

-(void)scannerMacWithDeviceEcho:(DeviceEcho *)echo{
    PSLog(@"-----[%@]-",echo);
    if (echo) {
        self.echo=echo;
        [_bindView.btnScanner setImage:[UIImage imageNamed:@"hm_wifiblack"] forState:UIControlStateNormal];
        [_bindView.btnScanner setTitle:[NSString stringWithFormat:@" %@",echo.name] forState:UIControlStateNormal];
    }
}

#pragma mark 成功返回数据处理 mark是标识 response结果
- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    //    PSLog(@"--%@--%@",mark,response);
   if ([mark isEqualToString:@"bind"]) {
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            [self bindMac:YES DeviceEcho:self.echo];
            self.echo=nil;
            stateView.labelText=@"绑定成功";
            self.bindView=nil;
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:1.5];
        }else{
            NSString *msg=[response objectForKey:@"desc"];
            if (isNIL(msg)) {
                msg=@"网络异常，请检查网络!";
            }
            stateView.labelText=msg;
            [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
        }
    }else if([mark isEqualToString:@"unBind"]){
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            [self bindMac:NO DeviceEcho:nil];
            self.bindView=nil;
            stateView.labelText=@"解绑成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:1.5];
        }else{
            NSString *msg=[response objectForKey:@"desc"];
            if (isNIL(msg)) {
                msg=@"网络异常，请检查网络!";
            }
            stateView.labelText=msg;
            [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
        }
    }else{
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            NSDictionary *data=response[@"Data"];
            if (data.count>0) {
                WoUser *user=[[WoUser alloc]initWithData:data];
                self.user=user;
                self.lbName.text=user.nickname;
                NSString *path=user.facephotoUrl;
                //        [cell.imgView setImageWithURL:[path urlInstance]];
                if (hasCachedImageWithString(path)) {
                    UIImage *image=[UIImage imageWithContentsOfFile:pathForString(path)];
                    self.imgUser.image=image;
                }else{
                    NSValue *size=[NSValue valueWithCGSize:self.imgUser.frame.size];
                    NSDictionary *dict=@{@"url":path,@"imageView":self.imgUser,@"size":size};
                    [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
                }
            }
        }
    }
    
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    NSDictionary *param=error.userInfo;
    if ([mark isEqualToString:@"bind"]) {
        stateView.labelText=[NSString stringWithFormat:@"%@,绑定失败",param[@"error"]];
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }else if([mark isEqualToString:@"unBind"]){
        stateView.labelText=[NSString stringWithFormat:@"%@,解绑失败",param[@"error"]];
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
    PSLog(@"失败: %@",error);
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:0.3 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    if (section==0) {
        return 80.0f;
    }else if(section==1){
        return 105.0f;
    }else{
        return 44.0f;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(ScreenHeight()>480){
        if (section==0) {
            return 10.0f;
        }else{
            return 15.0f;
        }
    }else{
        return 0.5f;
    }

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


-(void)bindMac:(BOOL)isBind DeviceEcho:(DeviceEcho *)deviceEcho{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (isBind) {
        [self.btnWifii alterNormalTitle:[NSString stringWithFormat:@" %@",deviceEcho.name]];
        [self.btnWifii setImage:[UIImage imageNamed:@"hm_wfp"] forState:UIControlStateNormal];
        [user setObject:deviceEcho.token forKey:TOKEN];
        [user setObject:deviceEcho.hostIP forKey:ROUTERIP];
        [user setObject:deviceEcho.macAddr forKey:ROUTERMAC];
        [user setObject:deviceEcho.name forKey:ROUTERNAME];
        [user setObject:@YES forKey:BOUNDMAC];
        [user setObject:@YES forKey:ISCONNECT];
        [user synchronize];
    }else{
        [self.btnWifii setImage:nil forState:UIControlStateNormal];
        [self.btnWifii alterNormalTitle:@" 未绑定"];
        [user removeObjectForKey:TOKEN];
        [user removeObjectForKey:ROUTERIP];
        [user removeObjectForKey:ROUTERMAC];
        [user removeObjectForKey:ROUTERNAME];
        [user removeObjectForKey:BOUNDMAC];
    }
    isMacBounds=isBind;
    //    [self getImg];//获取绑定的图片
}

@end
