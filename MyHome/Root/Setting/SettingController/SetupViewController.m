//
//  SettingViewController.m
//  MyHome
//
//  Created by Harvey on 14-6-4.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "SetupViewController.h"
#define TABHEIGH 49.0

@interface SetupViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleTexts;
}

@property (nonatomic,weak) CCLabel         *routingVer;
@property (nonatomic,weak) CCLabel         *MyHome;
@end

@implementation SetupViewController

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
    self.navigationItem.title = @"设置";
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(onClick:), self);
    [sendBut alterNormalTitle:@"注销"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    sendBut.hidden=YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    [self createView];
}


-(void)createView{
    CCImageView *wifiiImg=CCImageViewCreateWithNewValue(@"hm_wifii", CGRectMake(CGRectGetWidth(self.view.frame)/2-31, 20, 62, 62));
    [self.view addSubview:wifiiImg];
    
    CCLabel *lbTime=CCLabelCreateWithNewValue(@"运行时间:00", 16.0, CGRectMake(0, CGRectGetMaxY(wifiiImg.frame)+15, CGRectGetWidth(self.view.frame), 20));
    lbTime.textColor=RGBCommon(0, 74, 111);
    lbTime.textAlignment=NSTextAlignmentCenter;
    self.MyHome=lbTime;
    [self.view addSubview:lbTime];
    
    CCLabel *lbVer=CCLabelCreateWithNewValue(@"系统版本:1.0", 16.0, CGRectMake(0, CGRectGetMaxY(lbTime.frame), CGRectGetWidth(self.view.frame), 20));
    lbVer.textColor=RGBCommon(0, 74, 111);
    lbVer.textAlignment=NSTextAlignmentCenter;
    self.routingVer=lbVer;
    [self.view addSubview:lbVer];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbVer.frame)+30, CGRectGetWidth(self.view.frame), TABHEIGH*2-1)];
    tableView.separatorColor=RGBCommon(1, 107, 160);
    tableView.backgroundColor=RGBCommon(26, 141, 198);
    tableView.delegate=self;
    tableView.dataSource=self;
    [tableView setScrollEnabled:NO];
    [self.view addSubview:tableView];
}

-(void)HTTPRequest{
    [self initGetWithURL:ROUTINGBASEURL path:@"module/systat_get" paras:@{@"token": [GlobalShare getToken]} mark:@"getling" autoRequest:YES];
//    NSString *path=[NSString stringWithFormat:@"module/systat_get?token=%@",[GlobalShare getToken]];
//    [self initPostWithURL:ROUTINGBASEURL path:path paras:nil mark:@"getling" autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@=%@",mark,response);
    if(response){
        NSString *version=response[@"version"];
        NSString *time=response[@"time"];
        _MyHome.text=[NSString stringWithFormat:@"运行时间:%@",[self getNowTime:time]];
        _routingVer.text=[NSString stringWithFormat:@"系统版本:%@",version];
    }
}


-(NSString *)getNowTime:(NSString *)sinceTime{
    //创建日期格式化对象
    NSDate *oldDate=[NSDate dateWithTimeIntervalSince1970:[sinceTime doubleValue]];
    NSDate *newDate=[NSDate date];
    NSTimeInterval time=[newDate timeIntervalSinceDate:oldDate];
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minus=((int)time)%(3600*24)/60;
    NSString *nowType;
    if (days>0) {
        if (((int)days/30)>0) {
            nowType=[NSString stringWithFormat:@"%d月前",(int)(days/30)];
        }else{
            nowType=[NSString stringWithFormat:@"%d天前",days];
        }
    }else{
        if (hours>0) {
            nowType=[NSString stringWithFormat:@"%d小时前",hours];
        }else{
            if (minus>0) {
                nowType=[NSString stringWithFormat:@"%d分钟前",minus];
            }else{
                nowType=@"刚刚";
            }
        }
    }
    return nowType;
}


-(void)onClick:(id)sendar{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定注销?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
}

- (void)initBase
{
    _titleTexts = @[@{@"name":@"WiFi设置",@"img":@"hm_wifisz"},
                    @{@"name":@"重启路由器",@"img":@"hm_cqlyq"}];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID = @"Harvey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (isNIL(cell)) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = RGBCommon(26, 141, 198);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_jinru02"]];
    }
    NSDictionary *param=_titleTexts[indexPath.row];
    cell.textLabel.text=param[@"name"];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:param[@"img"]];
    return cell;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [GlobalShare clearMac];
        NSString *path=pathInCacheDirectory(@"AppCache");
        NSFileManager *manager=[NSFileManager defaultManager];
        if([manager fileExistsAtPath:path]){
            [manager removeItemAtPath:path error:nil];
        }
        [self exitCurrentController];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
    NSArray *secondPages = @[@"WiFiSetNameViewController",                  /**<wifi设置*/
                             @"ResetStartViewController"];  /**<重启设置*/
    id instance=[[secondPages objectAtIndex:indexPath.row] instance];
    [instance setCustomAnimation:YES];
    [self.navigationController pushViewController:instance animated:NO];

    PSLog(@"select %d",(NSInteger)indexPath.row);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABHEIGH;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
