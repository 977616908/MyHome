//
//  AccessDeviceViewController.m
//  PiFiiHome
//
//  Created by Harvey on 14-5-9.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "AccessDeviceViewController.h"
#import "AccessDeviceCell.h"
#import "MBProgressHUD.h"
//#import "AccessDeviceDetailViewController.h"

@interface AccessDeviceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray      *_devices;
    MBProgressHUD       *_loadStateView;
    NSTimer             *_timer ;
    int                 index;
}

@property (nonatomic,weak) UICollectionView *deviceList;
@end

@implementation AccessDeviceViewController

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
    self.title=@"访客列表";
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    PSLog(@"--[%@]--[%@]-",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat hg=44;
    if (is_iOS7()) {
        hg+=20;
    }
    UICollectionView *deviceList=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-hg) collectionViewLayout:layout];
    deviceList.showsVerticalScrollIndicator=NO;
    deviceList.backgroundColor=[UIColor clearColor];
    deviceList.dataSource=self;
    deviceList.delegate=self;
    deviceList.alwaysBounceVertical=YES;
    self.deviceList=deviceList;
    [self.view addSubview:deviceList];
    
    [self.deviceList registerClass:[AccessDeviceCell class] forCellWithReuseIdentifier:@"Harvey"];
    _devices = [NSMutableArray new];
    [self getWifiList];
}

-(void)setDeviceArr:(NSArray *)deviceArr{
    if (deviceArr) {
        for (NSDictionary *info in deviceArr) {
            DeviceItem *item = [DeviceItem new];
            item.deviceName = [info objectForKey:@"host"];
            item.deviceIP = [info objectForKey:@"ip"];
            item.deviceMac = [info objectForKey:@"mac"];
            [_devices addObject:item];
        }
        [_deviceList reloadData];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AccessDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Harvey" forIndexPath:indexPath];
    NSInteger cellIndex = indexPath.section *3 + indexPath.row;
    if (cellIndex < _devices.count) {
        
        DeviceItem *item = [_devices objectAtIndex:cellIndex];
        cell.wifiName.text = item.deviceName;
        cell.wifiLolo.image = @"0730sb".imageInstance;
    }
    return cell;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
////    return _devices.count%3==0 ? _devices.count/3:_devices.count/3+1;
//    return 2;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 3;
    return _devices.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexSelect = indexPath.section * 3 + indexPath.row;
    
    if (indexSelect<_devices.count) {
        
//        AccessDeviceDetailViewController *advc = [[AccessDeviceDetailViewController alloc] init];
//        advc.item = [_devices objectAtIndex:indexSelect];
//        [self.navigationController pushViewController:advc animated:YES];
    }
//    index = indexPath.row;
//    [[[UIAlertView alloc] initWithTitle:nil message:@"确定剔除该设备?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil] show];
}

-(void)repeatUpdate
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getWifiList) userInfo:nil repeats:YES];
    }
 }

- (void)getWifiList{
    [self initGetWithURL:ROUTINGBASEURL
                    path:@"module/wifi_client_list"
                   paras:[NSDictionary dictionaryWithObjectsAndKeys:[GlobalShare getToken],@"token", nil]
                    mark:@"device" autoRequest:YES];
}

- (void)HTTPRequest
{
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self repeatUpdate];
//    [self loadCoustomSetting];
    
//    _loadStateView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _loadStateView.removeFromSuperViewOnHide = YES;
//    _loadStateView.labelText = @"正在读取设备信息...";
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    if ([mark isEqualToString:@"device"]) {
         [_loadStateView hide:YES];
        if ([response isKindOfClass:[NSArray class]]) {
            
            if ([(NSArray *)response count] == 0) {
                
                return;
            }
            [_devices removeAllObjects];
            for (NSDictionary *info in response) {
                
                DeviceItem *item = [DeviceItem new];
                item.deviceName = [info objectForKey:@"host"];
                item.deviceIP = [info objectForKey:@"ip"];
                item.deviceMac = [info objectForKey:@"mac"];
                [_devices addObject:item];
            }
            [_loadStateView hide:YES];
            [_deviceList reloadData];
        }
    }else if ([mark isEqualToString:@"remove"]) {
        _loadStateView.labelText = @"踢除成功";
        [_loadStateView hide:YES];
        NSLog(@"%@",response);
        
        [self initGetWithURL:ROUTINGBASEURL path:@"module/lan_kick_get" paras:@{@"token": [GlobalShare getToken]} mark:@"list" autoRequest:YES];
//        [self initGetWithURL:ROUTINGBASEURL path:@"ifidc/whitelist_get" paras:@{@"token":[GlobalShare getToken]} mark:@"list" autoRequest:YES];
    }else if ([mark isEqualToString:@"list"]) {
        NSLog(@"黑名单%@",response);
    }
   
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    NSLog(@"error :%@",error);
    if ([mark isEqualToString:@"device"]) {
    
         _loadStateView.labelText = @"读取失败";
    }else if ([mark isEqualToString:@"remove"]) {
       
        _loadStateView.labelText = @"踢除失败";
    }
    [_loadStateView hide:YES];
    NSLog(@"失败: %@",error);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    _loadStateView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _loadStateView.removeFromSuperViewOnHide = YES;
    _loadStateView.labelText = @"正在踢除...";
    
    DeviceItem *item = [_devices objectAtIndex:index];
    [self initGetWithURL:ROUTINGBASEURL
                     path:@"module/lan_kick_set"
                    paras:@{@"token":[GlobalShare getToken],@"mac": item.deviceMac,
                            @"option":@"-"}/**< +表示永久断开与路由器的连接; -表示允许连接*/
                     mark:@"remove"
              autoRequest:YES];
//        [self initGetWithURL:ROUTINGBASEURL path:@"ifidc/whitelist_set" paras:@{@"token":[GlobalShare getToken],@"ip":@[item.deviceIP]} mark:@"remove" autoRequest:YES];
//        [self initGetWithURL:ROUTINGBASEURL path:@"ifidc/timeout_get" paras:@{@"token":[GlobalShare getToken]} mark:@"remove" autoRequest:YES];
    NSLog(@"remove %d",index);
}

}

- (void)initStyle
{
    //self.view.backgroundColor = @"hm_bg".colorInstance;
    self.navigationItem.title = @"设备接入";
    if (is_iOS7()) {
        self.edgesForExtendedLayout=UIRectEdgeNone;//不会穿过UINavigationBar,指家延伸的方向
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(95, 95);
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 20, 5);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (_timer) {
        [_timer invalidate];
        _timer=NULL;
    }

}

@end
