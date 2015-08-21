//
//  NetSaveViewController.m
//  MyHome
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CameraViewController.h"
#import "PFDownloadIndicator.h"
#import "ScannerViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CameraMessage.h"
#import "CameraSearchViewController.h"
#import "PPPPChannelManagement.h"
#import "WifiParamsProtocol.h"
#import "PPPPDefine.h"
#import "AppleStatue.h"

@interface CameraViewController ()<ScannerMacDelegate,SearchAddCameraInfoProtocol,WifiParamsProtocol>{
    CGFloat downloadedBytes;
    NSTimer *timer;
    BOOL isConnect;
    NSMutableArray *arrSteps;
    CPPPPChannelManagement *m_pPPPPChannelMgt;
}
@property(nonatomic,weak)PFDownloadIndicator *downIndicator;
@property(nonatomic,weak)CCLabel *downMsg;
@property(nonatomic,weak)CCButton *btnStart;
@property(nonatomic,weak)CCButton *btnSearch;
@property(nonatomic,weak)CCLabel *lbMsg;
@property(nonatomic,strong)CameraMessage *cameraMsg;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
//    [self showConnect];
}

-(void)createNav{
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    PSLog(@"%f",CGRectGetHeight(self.view.frame));
    CGRect bgRect=CGRectMake(0, gh, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh);
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(bgRect, nil, NO);
    rootScrollView.backgroundColor=[UIColor whiteColor];
    rootScrollView.contentSize=CGSizeMake(0, 568-gh);
    [self.view addSubview:rootScrollView];
    //    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rootScrollView.frame), CGRectGetHeight(rootScrollView.frame))];
    //
    //    [rootScrollView addSubview:bgView];
    CGFloat hg=-20;
    if(ScreenHeight()<=480){
        hg-=5;
    }
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, hg, 80, 44) backgroundColor:[UIColor clearColor]];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_return"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navTopView addSubview:btnBack];
    [rootScrollView addSubview:navTopView];
    
    
    CCLabel *title=CCLabelCreateWithNewValue(@"连接智能摄像头", 16, CGRectMake(0,CGRectGetMaxY(navTopView.frame)+10+hg,CGRectGetWidth(rootScrollView.frame),16));
    title.textColor=RGBCommon(63, 205, 225);
    title.textAlignment=NSTextAlignmentCenter;
    [rootScrollView addSubview:title];
    
    CCLabel *msg=CCLabelCreateWithNewValue(@"接通电源，设备指示灯闪 烁时点击下一步", 13, CGRectMake(0,CGRectGetMaxY(title.frame)+10,CGRectGetWidth(rootScrollView.frame),14));
    msg.textColor=RGBCommon(155, 155, 155);
    msg.textAlignment=NSTextAlignmentCenter;
    self.lbMsg=msg;
    [rootScrollView addSubview:msg];
    
    CCImageView *img=CCImageViewCreateWithNewValue(@"hm_camera", CGRectMake(132,CGRectGetMaxY(msg.frame)+60, 56, 76));
    [rootScrollView addSubview:img];
    
    PFDownloadIndicator *downIndicator = [[PFDownloadIndicator alloc]initWithFrame:CGRectMake(90, CGRectGetMaxY(msg.frame)+30, 140, 140) type:kRMClosedIndicator];
    [downIndicator setBackgroundColor:[UIColor clearColor]];
    [downIndicator setFillColor:RGBCommon(201, 201, 201)];
    [downIndicator setStrokeColor:RGBCommon(63, 205, 225)];
    downIndicator.radiusPercent = 0.45;
    
    self.downIndicator=downIndicator;
    //    downIndicator.hidden=YES;
    [rootScrollView addSubview:downIndicator];
    [downIndicator loadIndicator];
    
    CCLabel *downMsg=CCLabelCreateWithNewValue(@"正在为您下载模板中...", 15, CGRectMake(0,CGRectGetMaxY(downIndicator.frame)+10,CGRectGetWidth(rootScrollView.frame),15));
    downMsg.textColor=RGBCommon(123, 123, 123);
    downMsg.textAlignment=NSTextAlignmentCenter;
    self.downMsg=downMsg;
    //    downMsg.hidden=YES;
    [rootScrollView addSubview:downMsg];
    
    UIView *stepView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downMsg.frame), 320, 150)];
    CCImageView *imgConn=CCImageViewCreateWithNewValue(@"hm_camera_conn", CGRectMake(20, 0, 320, 150));
    [stepView addSubview:imgConn];
    CCLabel *lbMsg=CCLabelCreateWithBlodNewValue(@"配制摄像头步骤:", 13.0, CGRectMake(15, 20, 100, 14));
    lbMsg.textColor=RGBCommon(155, 155, 155);
    [stepView addSubview:lbMsg];
    NSArray *arr=@[@" 1.扫描二维码或局域网搜索设备",@" 2.连接“IPCAM-XXX”的WIFI",@" 3.连接摄像头",@" 4.设置摄像头WIFI",@" 5.重启摄像头"];
    arrSteps=[NSMutableArray array];
    for(int i=0;i < arr.count;i++){
        CGFloat hg=40+i*15;
        CCButton *btn=CCButtonCreateWithFrame(CGRectMake(14, hg, 180, 14));
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn alterFontSize:11.0];
        [btn setImage:[UIImage imageNamed:@"rt_gou"] forState:UIControlStateSelected];
        [btn alterNormalTitle:arr[i]];
        [btn alterNormalTitleColor:RGBCommon(155, 155, 155)];
        [stepView addSubview:btn];
        [arrSteps addObject:btn];
    }
    [rootScrollView addSubview:stepView];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(stepView.frame)+5, CGRectGetWidth(rootScrollView.frame)-40, 42), @selector(onTypeClick:), self);
    btnStart.backgroundColor=RGBCommon(63, 205, 225);
    btnStart.tag=1;
    [btnStart alterFontSize:20];
    [btnStart alterNormalTitle:@"扫描二维码"];
    self.btnStart=btnStart;
    [rootScrollView addSubview:btnStart];
    
    CCButton *btnSearch=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(btnStart.frame)+10, CGRectGetWidth(rootScrollView.frame)-40, 42), @selector(onTypeClick:), self);
    btnSearch.backgroundColor=RGBCommon(63, 205, 225);
    btnSearch.tag=2;
    [btnSearch alterFontSize:20];
    [btnSearch alterNormalTitle:@"局域网搜索"];
    self.btnSearch=btnSearch;
    [rootScrollView addSubview:btnSearch];
    
    
    self.cameraMsg=[[CameraMessage alloc]init];
    self.cameraMsg.camwifiname=[[NSUserDefaults standardUserDefaults]objectForKey:ROUTERNAME];
    [PSNotificationCenter addObserver:self selector:@selector(showConnect) name:@"becomeActive" object:nil];
    m_pPPPPChannelMgt = new CPPPPChannelManagement();
    m_pPPPPChannelMgt->pCameraViewController=self;
    
}



-(void)onTypeClick:(CCButton *)sendar{
//    [self showToast:@"暂未找到可连接的设置" Long:1.5];
    if(sendar.tag==2){
        CameraSearchViewController *cameraSearch=[[CameraSearchViewController alloc]init];
        cameraSearch.SearchAddCameraDelegate=self;
        cameraSearch.title=@"局域网搜索";
        [self.navigationController pushViewController:cameraSearch animated:YES];
    }else{
        if (isConnect) {
            self.btnStart.enabled=NO;
            CGFloat duration=0.1;
            if (self.cameraMsg.isOpen) {
                [self createCamera];
            }else{
                duration=0.3;
                [self setCameraWifiPwd:self.cameraMsg.camid];
            }
            [self startAnimation:duration];
            
        }else{
            [self.navigationController.view.layer addAnimation:[self customAnimation1:self.view upDown:YES] forKey:@"animation1"];
            ScannerViewController *svc = [[ScannerViewController alloc]init];
            svc.type=ScannerOther;
            svc.delegate=self;
            [self.navigationController pushViewController:svc animated:NO];
        }
    }
}

#pragma -mark 判断是否连接当前摄像头
-(void)showConnect{
    NSString *wifiiName=[self getWifiName];
    if ([wifiiName hasPrefix:@"IPCAM-"]&&![self.cameraMsg.camid isEqualToString:@""]) {
        isConnect=YES;
        self.cameraMsg.camdevicewifiname=wifiiName;
        [self setStepsCount:2];
        self.btnSearch.hidden=YES;
        [self.btnStart alterNormalTitle:@"开始智能连接"];
        [self start:self.cameraMsg.camid];
    }else{
        [self showToast:@"设备不正确或未连接“IPCAM-XXX”的WIFI" Long:1.5];
    }
    NSLog(@"---[%@]---",wifiiName);
}


-(void)setStepsCount:(NSInteger)count{
    for (int i=0; i<count; i++) {
        [arrSteps[i] setSelected:YES];
    }
}


-(void)cameraConnect:(NSString *)msg{
    [self setStepsCount:1];
    self.lbMsg.text=[NSString stringWithFormat:@"连接摄像机设备ID:%@",msg];
    //        /platports/pifii/plat/plug/getCamera?camid=HDXQ-005664-CEGGN
    [self initPostWithURL:ROUTINGCAMERA path:@"getCamera" paras:@{@"camid":msg} mark:@"user" autoRequest:YES];
}

-(void)createCamera{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    if (self.cameraMsg) {
        NSDictionary *params=@{@"username":userPhone,
                               @"camdevice":_cameraMsg.camdevice,
                               @"camdevicewifiname":_cameraMsg.camdevicewifiname,
                               @"camid":_cameraMsg.camid,
                               @"camname":_cameraMsg.camname,
                               @"campas":_cameraMsg.campas,
                               @"camwifiname":_cameraMsg.camwifiname,
                               @"isopen":@(1)};
        [self initPostWithURL:ROUTINGCAMERA path:@"initalizeCamera" paras:params mark:@"camera" autoRequest:YES];
    }
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@:%@",response,mark);
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if ([mark isEqualToString:@"user"]) {
        if ([returnCode intValue]==200) {
            NSDictionary *data=response[@"data"];
            CameraMessage *msg=[[CameraMessage alloc]initWithData:data];
            PSLog(@"%@",msg);
            if(msg&&msg.isOpen){
                self.cameraMsg=msg;
                isConnect=YES;
                [self setStepsCount:5];
                self.btnSearch.hidden=YES;
                [self.btnStart alterNormalTitle:@"开始智能连接"];
            }else{
                [self showConnect];
            }
        }
    }

}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    PSLog(@"%@:%@",error,mark);
    [self showConnect];
}



#pragma -mark 代码事件

-(void)scannerMessage:(NSString *)msg{
    if (![msg isEqualToString:@""]) {
        [self cameraConnect:msg];
        self.cameraMsg.camid=msg;
    }
    
}

-(void)AddCameraInfo: (NSString*) strCameraName DID: (NSString*) strDID IP:(NSString *)strIP Port:(NSString *)port{
    PSLog(@"%@->%@->%@",strCameraName,strDID,strIP);
    if (strDID&&![strDID isEqualToString:@""]) {
        self.cameraMsg.camid=strDID;
        [self cameraConnect:strDID];
    }
    
}



#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    NSLog(@"PPPPStatus ..... strDID: %@, statusType: %d, status: %d", strDID, statusType, status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED||statusType==PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
            return;
        }
        if (status==PPPP_STATUS_ON_LINE) {//
            NSLog(@"用户在线，去获取权限");
            // [self performSelector:@selector(updateAuthority:) withObject:strDID afterDelay:1];
            //[self performSelectorOnMainThread:@selector(updateAuthority:) withObject:strDID waitUntilDone:NO];
            //[self updateAuthority:strDID];
            [NSThread detachNewThreadSelector:@selector(setCameraWifi:) toTarget:self withObject:strDID];
        }
        
    }
}

-(void)start:(NSString *)strDID{
    NSCondition *ppppChannelMgntCondition = [[NSCondition alloc] init];
    m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
    m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 0, self);
    [ppppChannelMgntCondition lock];
    [NSThread detachNewThreadSelector:@selector(startCamera:) toTarget:self withObject:strDID];
    [ppppChannelMgntCondition unlock];
    //    [self updateAuthority:strDID];
    
}

-(void)startCamera:(NSString *)strDID{
    if (m_pPPPPChannelMgt) {
        //        NSString *strDID = [cameraDic objectForKey:@""];
        NSString *strUser = @"admin";
        NSString *strPwd = @"admin";
        m_pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
    }
}

-(void)setCameraWifi:(NSString *)strDID{
    [self setStepsCount:3];
    m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[strDID UTF8String], self);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
}


-(void)setCameraWifiPwd:(NSString *)m_strDID{
    [self setStepsCount:4];
    NSString *wifiName=self.cameraMsg.camwifiname;
    NSString *pwd=@"88888888";
    m_pPPPPChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[wifiName UTF8String], 1, 0, 2, 0, 0, 0, (char*)"", (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, (char*)[pwd UTF8String]);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
}

-(void)updateAuthority:(NSString *)did{
    //NSLog(@"updateAuthority  00000  did=%@",did);
    sleep(1);
    m_pPPPPChannelMgt->SetUserPwdParamDelegate((char*)[did UTF8String], self);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[did UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

- (void) StopPPPPByDID:(NSString*)did
{
    m_pPPPPChannelMgt->Stop([did UTF8String]);
}

- (NSString *)getWifiName

{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

#pragma mark - Update Views
- (void)startAnimation:(CGFloat)duration
{
    self.downMsg.hidden=NO;
    self.downIndicator.hidden=NO;
    downloadedBytes = 0;
    timer=[NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)updateView
{
    downloadedBytes+=arc4random()%5;
    downloadedBytes=downloadedBytes>100?100:downloadedBytes;
    _downMsg.text=[NSString stringWithFormat:@"正在为您连接摄像头...(%.0f%%)",downloadedBytes];
    if (downloadedBytes>=80&&!self.cameraMsg.isOpen) {
        [self setStepsCount:5];
        [self createCamera];
    }
    [_downIndicator updateWithTotalBytes:100 downloadedBytes:downloadedBytes];
    if(downloadedBytes>=100){
        [timer invalidate];
        timer=nil;
        self.btnStart.enabled=YES;
        _downMsg.text=@"摄像头连接成功";
        AppleStatue *statue=[[AppleStatue alloc]init];
        statue.appIcon=@"mh_sxtt";
        statue.appTitle=@"家用摄像头";
        statue.appTag=1;
        statue.appMsg=@"在线";
        [self.pifiiDelegate pushViewDataSource:statue];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:0.7];
    }
}

#pragma mark -
#pragma mark WifiParamsProtocol

- (void) WifiParams:(NSString *)strDID enable:(NSInteger)enable ssid:(NSString *)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString *)strKey1 strKey2:(NSString *)strKey2 strKey3:(NSString *)strKey3 strKey4:(NSString *)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString *)wpa_psk
{
    NSLog(@"WifiParams.....strDID: %@, enable:%d, ssid:%@, channel:%d, mode:%d, authtype:%d, encryp:%d, keyformat:%d, defkey:%d, strKey1:%@, strKey2:%@, strKey3:%@, strKey4:%@, key1_bits:%d, key2_bits:%d, key3_bits:%d, key4_bits:%d, wap_psk:%@", strDID, enable, strSSID, channel, mode, authtype, encryp, keyformat, defkey, strKey1, strKey2, strKey3, strKey4, key1_bits, key2_bits, key3_bits, key4_bits, wpa_psk);
    
//    m_strSSID = [[NSString alloc] initWithString:strSSID];
//    m_channel = channel;
//    m_authtype = authtype;
//    m_strWEPKey = strKey1;
//    m_strWPA_PSK = wpa_psk;
    
}

- (void) WifiScanResult:(NSString *)strDID ssid:(NSString *)strSSID mac:(NSString *)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd
{
    NSLog(@"WifiScanResult.....strDID:%@, ssid:%@, mac:%@, security:%d, db0:%d, db1:%d, mode:%d, channel:%d, bEnd:%d", strDID, strSSID, strMac, security, db0, db1, mode, channel, bEnd);
    
    NSString *ssid=[NSString stringWithFormat:@"%@",strSSID];
    if (ssid==nil||[ssid length]==0) {
        NSLog(@"strSSID==nil");
        return;
    }
    
//    NSNumber *nSecurity = [NSNumber numberWithInt:security];
//    NSNumber *nDB0 = [NSNumber numberWithInt:db0];
//    NSNumber *nChannel = [NSNumber numberWithInt:channel];
//    NSDictionary *wifiscan = [NSDictionary dictionaryWithObjectsAndKeys:ssid, @STR_SSID, nSecurity, @STR_SECURITY, nDB0, @STR_DB0, nChannel, @STR_CHANNEL, nil];
//    
//    [m_wifiScanResult addObject:wifiscan];
    
}


-(CATransition *)customAnimation1:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
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

-(void)exitCurrentController{

    if(!self.cameraMsg.isOpen){
        [self StopPPPPByDID:self.cameraMsg.camid];
    }
    if (m_pPPPPChannelMgt!=nil) {
        m_pPPPPChannelMgt->pCameraViewController = nil;
    }
    SAFE_DELETE(m_pPPPPChannelMgt);
    [PSNotificationCenter removeObserver:self name:@"becomeActive" object:nil];
    [super exitCurrentController];
}

@end
