//
//  ZeroCenterViewCtr.m
//  MyHome
//
//  Created by HXL on 14-6-5.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WoSetViewController.h"
#import "LoginRegisterController.h"


#define BUTTONHEIGHT 75

@interface WoSetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSArray *_arrTitle;
    MBProgressHUD *stateView;
}
@property (nonatomic,weak)CCTableView *woTable;

@end

@implementation WoSetViewController

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
    self.title=@"设置";
    _arrTitle=@[/*@{@"icon":@"hm_shezhi",@"title":@"路由设置"},*/
                @{@"title":@"WiFi设置",@"icon":@"hm_wifisz"},
                @{@"title":@"重启路由器",@"icon":@"hm_cqlyq"},
                @{@"icon":@"hm_icon",@"title":@"快速上网"},
                @{@"icon":@"hm_zhuxiao",@"title":@"注销"},
                @{@"icon":@"hm_wotupian",@"title":@"上传原图片"},
                @{@"icon":@"hm_icon02",@"title":@"意见反馈"}];
    CGFloat gh=44;
    if(is_iOS7()){
        gh+=20;
    }
    CCTableView *woTable=CCTableViewCreateStyleGroup(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), self);
    woTable.backgroundColor=[UIColor clearColor];
    self.woTable=woTable;
    woTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:woTable];
}


-(UIView *)createUpdate:(CGRect)frame{
    UIView *bgView=[[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor=[UIColor whiteColor];
    CCLabel *titleLabel=CCLabelCreateWithNewValue(@"点击升级", 16.0, CGRectMake(0, 10, CGRectGetWidth(frame),20));
    titleLabel.textColor=RGBCommon(52, 52, 52);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    CCLabel *contentLabel=CCLabelCreateWithNewValue(@"当前版本:1.0 最新版本:1.0", 14.0, CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, CGRectGetWidth(frame), 18));
    contentLabel.textColor=RGBCommon(109, 109, 109);
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:contentLabel];
    return bgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _arrTitle.count;
    }else{
        return 1;
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
    }
    NSInteger section=indexPath.section;
    if (section==0) {
        NSDictionary *param=_arrTitle[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:param[@"icon"]];
        cell.textLabel.text=param[@"title"];
        if (indexPath.row==4) {
            UISwitch *select=[[UISwitch alloc]init];
            select.onTintColor=RGBCommon(63, 205, 225);
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [select setOn:[[user objectForKey:ISHDPICTURE]boolValue]];
            [select addTarget:self action:@selector(onSelectClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=select;
        }
    }else{
        cell.accessoryView.hidden=YES;
        cell.backgroundView=[self createUpdate:cell.frame];
    }
    return cell;
}

-(void)onSelectClick:(UISwitch *)sendar{
    PSLog(@"---select---");
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if (sendar.isOn) {
        [user setObject:@(YES) forKey:ISHDPICTURE];
    }else{
        [user setObject:@(NO) forKey:ISHDPICTURE];
    }
    [user synchronize];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    if (section==0) {
        NSLog(@"---[%d]--",indexPath.row);
        if (indexPath.row==3) {
             [[[UIAlertView alloc]initWithTitle:@"注销" message:@"注销并返回登录界面?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil]show];
        }else if(indexPath.row==4){
            
        }else{
            NSArray *pushControllers = @[@"WiFiSetNameViewController",@"ResetStartViewController",@"NetSetViewController",@"",@"",@"FeedBackViewController"];
            id  vcInstance = [[pushControllers objectAtIndex:indexPath.row] instance];
            [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
            [vcInstance setCustomAnimation:YES];
            [self.navigationController pushViewController:vcInstance animated:NO];
        }
    }else{
//        [self onCheckVersion];
        if (!stateView) {
            stateView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        stateView.hidden=NO;
        [self performSelector:@selector(showDialog) withObject:nil afterDelay:1.5];

    }
}

-(void)showDialog{
    stateView.hidden=YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    if (section==0) {
        return 44.0f;
    }else{
        return 61.0f;
    }
}


#pragma mark 检测版本升级
-(void)onCheckVersion{
    NSDictionary *info=[[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion=[info objectForKey:@"CFBundleVersion"];
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=682185259"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];;
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:REQUESTTIMEOUT];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (recervedData||[urlResponse statusCode]==200) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:kNilOptions error:nil];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if (![lastVersion isEqualToString:currentVersion]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10001;
                [alert show];
            }
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常，暂时无法更新!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0f;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag==10000) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }else{
            [self clearUserMessage];
            [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
            //推入
            LoginRegisterController *loginController=[[LoginRegisterController alloc]init];
            [loginController setCustomAnimation:YES];
            [self.navigationController pushViewController:loginController animated:NO];
        }
    }
}

#pragma -mark 注销用户信息
-(void)clearUserMessage{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:NETPASSWORD];
    [user removeObjectForKey:ISLOGIN];
    [user removeObjectForKey:TOKEN];
    [user removeObjectForKey:ROUTERIP];
    [user removeObjectForKey:ROUTERMAC];
    [user removeObjectForKey:ROUTERNAME];
    [user removeObjectForKey:BOUNDMAC];
    [user removeObjectForKey:@"APPDEVICE"];
}

@end
