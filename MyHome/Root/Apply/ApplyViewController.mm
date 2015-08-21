//
//  ApplyViewController.m
//  MyHome
//
//  Created by HXL on 15/6/10.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ApplyViewController.h"
#import "MediaCenterViewController.h"
#import "ApplyView.h"
#import "CameraViewController.h"
#import "NetSaveViewController.h"
#import "NetWorkViewController.h"
#import "NetInstallController.h"
#import "AlbumInstallController.h"
#import "RoutingListController.h"
#include "MyAudioSession.h"
#import "PlayViewController.h"
#import "CameraListMgt.h"
#import "PPPPDefine.h"
#import "CameraMessage.h"
#import "RoutingCameraController.h"
#import "AppleViewCell.h"
#import "AppleStatue.h"


@interface ApplyViewController ()<PiFiiBaseViewDelegate,PPPPStatusProtocol,UITableViewDataSource,UITableViewDelegate>{
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    CameraListMgt *m_pCameraListMgt;
    CPPPPChannelManagement *pPPPPChannelMgt;
    NSCondition *ppppChannelMgntCondition;
    BOOL isCamera;
    BOOL isDefaultServer;
    NSMutableArray *arrDevice;
    NSString *pathArchive;
}
@property(nonatomic,weak) IBOutlet UITableView *tableApp;
@property(nonatomic,weak) IBOutlet UIImageView *imgBg;
@property (nonatomic,weak)ApplyView *applyView;

@property (nonatomic,strong)CameraMessage *cameraMsg;

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [PSNotificationCenter addObserver:self selector:@selector(StopPPPP) name:@"enterbackground" object:nil];
    [PSNotificationCenter addObserver:self selector:@selector(startCamera) name:@"becomeActive" object:nil];
    [self createCamera];
}

-(void)coustomNav{
    [self baseData];
    self.tableApp.backgroundColor=RGBCommon(237, 237, 237);
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(10, 0, 30, 20), @selector(onAddClick:), self);
    sendBut.tag=1;
    [sendBut setImage:[UIImage imageNamed:@"hm_add"] forState:UIControlStateNormal];
    [sendBut setImage:[UIImage imageNamed:@"hm_add_select"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
  
}

-(void)baseData{
    isDefaultServer=YES;
    pathArchive=pathInCacheDirectory(@"AppCache/ApplyDevice.archiver");
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchive];
    if (arr) {
        arrDevice=[NSMutableArray arrayWithArray:arr];
    }else{
        arrDevice=[NSMutableArray array];
    }
    [self isHidden];
}


-(void)isHidden{
    if (arrDevice.count>0) {
        self.tableApp.hidden=NO;
        self.imgBg.hidden=YES;
    }else{
        self.tableApp.hidden=YES;
        self.imgBg.hidden=NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
    self.navigationController.navigationBarHidden=NO;
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBarController.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    if (!self.cameraMsg) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *userData= [user objectForKey:USERDATA];
        NSString *userPhone=userData[@"userPhone"];
        [self initPostWithURL:ROUTINGCAMERA path:@"getCamera" paras:@{@"username":userPhone} mark:@"user" autoRequest:YES];
    }
//    [UIView setAnimationsEnabled:YES];
}


-(void)onAddClick:(id)sendar{
    if (!_applyView) {
        CGFloat gh=0;
        if(is_iOS7())gh=50;
        ApplyView *applyView=[[ApplyView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
        self.applyView=applyView;
        [self.view addSubview:applyView];
    }
    [self.applyView moveTransiton:YES];
    __weak typeof(self) weakSelf=self;
    _applyView.type=^(NSInteger tag){
        PSLog(@"---[%d]---",tag);
        BOOL isBound=[GlobalShare isBindMac];
        switch (tag) {
            case 0:{
                AlbumInstallController  *albumController=[[AlbumInstallController alloc]init];
                albumController.pifiiDelegate=weakSelf;
                [weakSelf.navigationController pushViewController:albumController animated:YES];
            }
                break;
            case 1:{
                if (isBound) {
                    weakSelf.cameraMsg=nil;
                    CameraViewController *cameraController=[[CameraViewController alloc]init];
                    cameraController.pifiiDelegate=self;
                    [weakSelf.navigationController pushViewController:cameraController animated:YES];
                }else{
                    [weakSelf showToast:@"未绑定路由，请绑定路由再添加" Long:1.5];
                }
            }
                break;
            case 2:{
                if (isBound) {
                    NetInstallController *netController=[[NetInstallController alloc]init];
                    netController.pifiiDelegate=self;
                    [weakSelf.navigationController pushViewController:netController animated:YES];
                }else{
                    [weakSelf showToast:@"未绑定路由，请绑定路由再添加" Long:1.5];
                }
    
            }
                break;
            default:
                break;
        }
        [weakSelf.applyView moveTransiton:NO];
    };
    
}


-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@:%@",response,mark);
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if ([mark isEqualToString:@"user"]) {
        if ([returnCode intValue]==200) {
            NSDictionary *data=response[@"data"];
            CameraMessage *msg=[[CameraMessage alloc]initWithData:data];
            PSLog(@"%@",msg);
            if(msg.isOpen){
//                UIImageView *image=_imgArr[0];
//                if (image.tag!=1) {
//                    image.tag=1;
//                    [self startAnimation:image];
//                }
//                self.lbMsg.hidden=NO;
//                self.lbMsg.textColor=RGBCommon(210, 79, 86);
//                self.lbMsg.text=@"在线";
//                self.cameraMsg=msg;
//                m_pCameraListMgt = [[CameraListMgt alloc] init];
//                [m_pCameraListMgt selectP2PAll:YES];
//                [m_pCameraListMgt AddCamera:@"WIFICAM" DID:msg.camid User:msg.camname Pwd:msg.campas Snapshot:nil];
//                [self performSelector:@selector(start) withObject:nil afterDelay:.25];
            }
        }
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startController:(NSInteger)tag{
    switch (tag) {
        case 1:{
            isCamera=YES;
            [self startPlayer];
        }
            break;
            
        case 2:{
            MediaCenterViewController *mediaController=[[MediaCenterViewController alloc]init];
            mediaController.title=@"应用中心";
            [self.navigationController pushViewController:mediaController animated:YES];
        }
            break;
        case 3:{
//            RoutingListController *routingController=[[RoutingListController alloc]init];
//            [self.navigationController pushViewController:routingController animated:YES];
            
            RoutingCameraController *routingController;
            if (ScreenHeight()>480) {
                routingController=[[RoutingCameraController alloc]initWithNibName:@"RoutingCameraController" bundle:nil];
            }else{
                routingController=[[RoutingCameraController alloc]initWithNibName:@"RoutingCameraController640x960" bundle:nil];
            }
            routingController.arrCamera=[NSMutableArray array];
//            routingController.dateStr=sb;
            [self presentViewController:routingController animated:YES completion:nil];
        }
            break;
        case 4:{
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            id password=[user objectForKey:NETPASSWORD];
            if ([password length]>0) {
                NetSaveViewController *saveController=[[NetSaveViewController alloc]init];
                [self.navigationController pushViewController:saveController animated:YES];
            }else{
                NetWorkViewController *workController=[[NetWorkViewController alloc]init];
                [self.navigationController pushViewController:workController animated:YES];
            }
            //                [self setMacBounds];
        }
            break;
            
    }
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrDevice.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppleViewCell *cell=[AppleViewCell cellWithTableView:tableView];
    cell.state=arrDevice[indexPath.row];
    [cell setViewStyle:indexPath.row%2];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppleStatue *statue=arrDevice[indexPath.row];
    [self startController:statue.appTag];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}




#pragma -mark 跳转摄像头
-(void)startPlayer{
        NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:0];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    //    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
    //        return;
    //    }
    //    NSLog(@"---%d---",[nPPPPStatus integerValue]);
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            [self showToast:@"摄像头不在线，重新启动..." Long:1.5];

    
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
            
            return;
        }
    
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.isP2P=YES;
    playViewController.cameraName = @"时光路游";
    
    playViewController.strDID = strDID;
    playViewController.m_nP2PMode = 1;
    [self presentViewController:playViewController animated:YES completion:nil];
}


#pragma -mark 传递数据处理
-(void)pushViewDataSource:(id)dataSource{
    BOOL isAdd=NO;
    for (AppleStatue *statue in arrDevice) {
        if (statue.appTag ==[dataSource appTag]) {
            isAdd=YES;
            break;
        }
    }
    if (!isAdd) {
        [arrDevice addObject:dataSource];
        [self isHidden];
        [self.tableApp reloadData];
        [NSKeyedArchiver archiveRootObject:arrDevice toFile:pathArchive];
    }

}


/**
 * 判断是否绑定与连接PIFii路由
 */
-(BOOL)setMacBounds{
    BOOL isBound=[GlobalShare isBindMac];
    if (!isBound) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常或未绑定PiFii路由" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        BOOL isConnect=[[[NSUserDefaults standardUserDefaults]objectForKey:ISCONNECT]boolValue];
        if (!isConnect) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"未连接绑定PiFii路由" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            isBound=NO;
        }
    }
    return isBound;
}

#pragma -mark 启动摄像头

-(void)createCamera{
    if (isDefaultServer) {
        NSString *filePath=[self serverFilePath];
        NSString *strServer=nil;
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
            NSArray *array=[[NSArray alloc]initWithContentsOfFile:filePath];
            strServer=[array objectAtIndex:0];
            isDefaultServer=[(NSNumber *)[array objectAtIndex:1]boolValue];
        }
        if (isDefaultServer) {
            strServer=@"EBGAEOBOKHJMHMJMENGKFIEEHBMDHNNEGNEBBCCCBIIHLHLOCIACCJOFHHLLJEKHBFMPLMCHPHMHAGDHJNNHIFBAMC";
            isDefaultServer=NO;
        }else{
            PSLog(@"使用更改的服务器地址");
        }
        PSLog(@"strServer=%@",strServer);
        PPPP_Initialize((char *)[strServer UTF8String]);
    }

//    usleep(1000000);
//    st_PPPP_NetInfo NetInfo;
//    PPPP_NetworkDetect(&NetInfo, 0);
}

-(void)start{
    isCamera=NO;
    NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:0];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    ppppChannelMgntCondition = [[NSCondition alloc] init];
    pPPPPChannelMgt = new CPPPPChannelManagement();
    pPPPPChannelMgt->pCameraViewController=self;
    m_pPicPathMgt = [[PicPathManagement alloc] init];
    m_pRecPathMgt = [[RecPathManagement alloc] init];
//        netWorkUtile=[[NetWorkUtiles alloc]init];
//        netWorkUtile.userProtocol=self;
    
    
    pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
    pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 0, self);
    InitAudioSession();
    [ppppChannelMgntCondition lock];
    [NSThread detachNewThreadSelector:@selector(startCamera) toTarget:self withObject:nil];
    [ppppChannelMgntCondition unlock];

}

-(void)startCamera{
    if (pPPPPChannelMgt) {
        NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:0];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
    }
}

-(NSString *)serverFilePath{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                      , YES);
    NSString *paths=[path objectAtIndex:0];
    return[paths stringByAppendingPathComponent:@"server"];
}

#pragma mark -停用摄像头
- (void) StopPPPP
{
    [ppppChannelMgntCondition lock];
    if (pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }
    pPPPPChannelMgt->StopAll();
    [ppppChannelMgntCondition unlock];
}


- (void) StopPPPPByDID:(NSString*)did
{
//    self.lbMsg.textColor=RGBCommon(128, 128, 128);
//    self.lbMsg.text=@"正在连接";
    pPPPPChannelMgt->Stop([did UTF8String]);
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [UIView setAnimationsEnabled:NO];
    if (!isCamera) {
        if (pPPPPChannelMgt) {
            NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:0];
            NSString *strDID = [cameraDic objectForKey:@STR_DID];
            [self StopPPPPByDID:strDID];
        }
    }
}

-(void)updateAuthority:(NSString *)did{
    //NSLog(@"updateAuthority  00000  did=%@",did);
    
    sleep(1);
    pPPPPChannelMgt->SetUserPwdParamDelegate((char*)[did UTF8String], self);
    pPPPPChannelMgt->PPPPSetSystemParams((char*)[did UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

-(void)reloadCamera{
    NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:0];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
//    self.lbMsg.textColor=RGBCommon(128, 128, 128);
//    switch ([nPPPPStatus integerValue]) {
//        case PPPP_STATUS_UNKNOWN://未知
//            self.lbMsg.text=@"离线";
//            break;
//        case PPPP_STATUS_CONNECTING://正在连接
//             self.lbMsg.text=@"正在连接";
//            break;
//        case PPPP_STATUS_INITIALING://正在初始化
//             self.lbMsg.text=@"正在初始化";
//            break;
//        case PPPP_STATUS_CONNECT_FAILED://连接失败
//             self.lbMsg.text=@"连接失败";
//            break;
//        case PPPP_STATUS_DISCONNECT://连接断开
//             self.lbMsg.text=@"连接断开";
//            break;
//        case PPPP_STATUS_INVALID_ID://无效ID
//             self.lbMsg.text=@"离线";
//            break;
//        case PPPP_STATUS_ON_LINE://在线
//            self.lbMsg.textColor=RGBCommon(210, 79, 86);
//             self.lbMsg.text=@"在线";
//            break;
//        case PPPP_STATUS_DEVICE_NOT_ON_LINE://摄像机不在线
//             self.lbMsg.text=@"离线";
//            break;
//        case PPPP_STATUS_CONNECT_TIMEOUT://连接超时
//            self.lbMsg.text=@"连接超时";
//            break;
//    }

}

#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    NSLog(@"PPPPStatus ..... strDID: %@, statusType: %d, status: %d", strDID, statusType, status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {
        NSInteger index = [m_pCameraListMgt UpdatePPPPMode:strDID mode:status];
        if ( index >= 0){
            //   [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
        }
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        NSInteger index = [m_pCameraListMgt UpdatePPPPStatus:strDID status:status];
        if ( index >= 0){
            // [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
            if (status==PPPP_STATUS_ON_LINE) {//
                NSLog(@"用户在线，去获取权限");
                // [self performSelector:@selector(updateAuthority:) withObject:strDID afterDelay:1];
                //[self performSelectorOnMainThread:@selector(updateAuthority:) withObject:strDID waitUntilDone:NO];
                //[self updateAuthority:strDID];
                [NSThread detachNewThreadSelector:@selector(updateAuthority:) toTarget:self withObject:strDID];
            }else{
                NSLog(@"状态改变");
                //                [self performSelectorOnMainThread:@selector(notifyCameraStatusChange:) withObject:strDID waitUntilDone:NO];
            }
           [self performSelectorOnMainThread:@selector(reloadCamera) withObject:nil waitUntilDone:NO];
        }
        
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED||statusType==PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
        }
        
    }
}

- (void)dealloc
{
    //NSLog(@"IpCameraClientAppDelegate dealloc");
    m_pCameraListMgt = nil;
    //[cameraListMgt release];
    //cameraListMgt = nil;
    //[self StopPPPP];
    if (pPPPPChannelMgt!=nil) {
        pPPPPChannelMgt->pCameraViewController = nil;
    }
    SAFE_DELETE(pPPPPChannelMgt);
    if(ppppChannelMgntCondition){
        ppppChannelMgntCondition=nil;
    }
    
    [PSNotificationCenter removeObserver:self name:@"enterbackground" object:nil];
    [PSNotificationCenter removeObserver:self name:@"becomeActive" object:nil];
//    [PSNotificationCenter removeObserver:self forKeyPath:@"enterbackground"];
//    [PSNotificationCenter removeObserver:self forKeyPath:@"becomeActive"];
}

@end
