//
//  CCDownloadViewController.m
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "DownLoadViewController.h"
#import "FileInfo.h"

@interface DownLoadViewController (){
        BOOL isFinish;
        NSMutableArray          *_totalDatas;
        NSMutableArray          *finshTesk;
        NSMutableArray          *nFinshTesk;
        MBProgressHUD           *loadingProgress;
        
        NSTimer                 *_timer;
        
        CCImageView             *_floatLayout;
        
        NSDictionary            *_errorDict;
}

@property (nonatomic,weak) UIView         *bgLine;
@property (nonatomic,weak) CCScrollView   *rootScrollView;
@property (nonatomic,weak) CCDownloadView *downLoadView;
@property (nonatomic,weak) CCDownloadView *downFinishView;

@end

@implementation DownLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)monitorDownloadInfoStop:(BOOL)isStop
{
    [self myHTTPRequest];
    isFinish=isStop;
    if (isStop) {
        [self monitorDownloadInfo];
        PSLog(@"继续监控");
    }else {
        [_timer invalidate];
        _timer = nil;
        PSLog(@"停止监控");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"云下载";
    [self createView];
}


-(void)createView{
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 37)];
    bgView.layer.borderWidth=0.5;
    bgView.layer.borderColor=[RGBCommon(2, 137, 193) CGColor];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    CCButton *btnDownLoad=CCButtonCreateWithValue(CGRectMake(0, 0, 160, 37), @selector(onClick:), self);
    btnDownLoad.tag=1;
    [btnDownLoad alterFontSize:18.0f];
    [btnDownLoad alterNormalTitle:@"下载中"];
    [btnDownLoad alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnDownLoad];
    
    CCButton *btnDownFinish=CCButtonCreateWithValue(CGRectMake(160, 0, 160, 37), @selector(onClick:), self);
    btnDownFinish.tag=2;
    [btnDownFinish alterFontSize:18.0f];
    [btnDownFinish alterNormalTitle:@"已下载"];
    [btnDownFinish alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnDownFinish];
    
    UIView *bgLine=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 160, 2)];
    bgLine.backgroundColor=RGBCommon(2, 137, 193);
    self.bgLine=bgLine;
    [bgView addSubview:bgLine];
    
    CGFloat hg=64;
    hg=[UIScreen mainScreen].bounds.size.height-hg-37;
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 37, CGRectGetWidth(self.view.frame), hg), self, YES);
    rootScrollView.bounces=YES;
    rootScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame)*2, 0);
    self.rootScrollView=rootScrollView;
    [self.view addSubview:rootScrollView];
    
    CCDownloadView *downLoadView = [[CCDownloadView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(_rootScrollView.frame))];
    downLoadView.downType = CCDownTypeNotFinish;
    downLoadView.superController = self;
    self.downLoadView=downLoadView;
    [_rootScrollView addSubview:downLoadView];
    
    CCDownloadView *finishLoadView = [[CCDownloadView alloc] initWithFrame:CGRectMake(320, 0, 320, CGRectGetHeight(_rootScrollView.frame))];
    finishLoadView.downType = CCDownTypeFinish;
    finishLoadView.superController = self;
    self.downFinishView=finishLoadView;
    [_rootScrollView addSubview:finishLoadView];
}

-(void)initBase{
    _totalDatas = [NSMutableArray new];
    finshTesk = [NSMutableArray new];
    nFinshTesk = [NSMutableArray new];
    if (self.url) {
        [self requestDownloadVideo];
    }else{
        [self myHTTPRequest];
        [self monitorDownloadInfo];
    }
    _errorDict = @{
                   @(103): @"非法任务",
                   @(105): @"处理请求出错",
                   @(106): @"下载链接已存在",
                   @(150): @"请求超时",
                   @(151): @"找不到资源",
                   @(154): @"下载磁盘空间不足",
                   @(156): @"重复的下载任务",
                   @(165): @"远程服务器不可用",
                   @(187): @"下载出错"};
}

- (void)onClick:(CCButton *)sendar
{
    BOOL isLeft=sendar.tag==1?YES:NO;
    PSLog(@"======刷新clickMe---%d---",isLeft);
    [self moveLine:isLeft];
}

-(void)moveLine:(BOOL)isLeft{
    [self monitorDownloadInfoStop:isLeft];
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
    if (_rootScrollView.contentOffset.x<=0) {
        [self moveLine:YES];
    }else{
        [self moveLine:NO];
    }
}

- (void)monitorDownloadInfo
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(myHTTPRequest) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
  
}

- (void)myHTTPRequest
{
    [self initGetWithURL:ROUTINGBASEURL
                     path:@"extension/ext_download"
                    paras:[NSDictionary dictionaryWithObjectsAndKeys:[GlobalShare getToken],@"token",
                           [self convertJSONString:@"status" url:@""],@"json", nil]
                     mark:@"download"
              autoRequest:YES];
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@:%@",mark,error);
    if ([mark isEqualToString:@"add"]) {
        loadingProgress.labelText = @"添加失败";
        [self myHTTPRequest];
        [self monitorDownloadInfo];
        [loadingProgress hide:YES];
    }
}

#pragma mark 加载成功返回值

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    NSInteger error = [[response objectForKey:@"errcode"] integerValue];
    if (error > 0) {
        
        PSLog(@"%@=%@",mark,response);
    }
    
    if(!response || ![response isKindOfClass:[NSDictionary class]]) {
        
        return;
    }
    if ([mark isEqualToString:@"download"]) {
        if (isFinish) {
            [finshTesk removeAllObjects];
        }else{
            [nFinshTesk removeAllObjects];
        }
        NSDictionary *datasss = [response objectForKey:@"taskinfo"];
        for(NSString *key in datasss) {
            NSDictionary *dict = [datasss objectForKey:key];
            FileInfo *item = [FileInfo new];
            item.fileTaskID = [dict objectForKey:@"gid"];
            item.filePath = [dict objectForKey:@"dir"];// dir
            item.fileName = [dict objectForKey:@"name"];
            item.fileLength = [[dict objectForKey:@"totalLength"] integerValue];
            item.fileErrorCode = [[dict objectForKey:@"errorCode"] integerValue];
            item.fileDownloadProgress = [dict objectForKey:@"progress"];
            item.fileStatus = [dict objectForKey:@"status"];
            //        item.fileAddTime = [CCDate timeIntervalConvertDate:[[dict objectForKey:@"addtime"] longLongValue]];
            item.fileAddTime=[CCDate timeIntervalConvertDate:[[dict objectForKey:@"addtime"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
            item.fileFinishedSize = [[dict objectForKey:@"completedLength"] longLongValue];
            
            if ([item.fileStatus isEqualToString: @"complete"]||[item.fileDownloadProgress doubleValue]>=100) {
                [finshTesk addObject:item];
            }else  {
                [nFinshTesk addObject:item];
            }
        }
        if (isFinish) {
            _downFinishView.arrayList = nFinshTesk;
        }else{
            _downLoadView.arrayList = finshTesk;
        }
    }else if([mark isEqualToString:@"add"]){
         loadingProgress.labelText = @"添加成功";
        [self myHTTPRequest];
        [self monitorDownloadInfo];
        [loadingProgress hide:YES];
    }

}

- (void)requestDownloadVideo
{
    loadingProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingProgress.removeFromSuperViewOnHide = YES;
    loadingProgress.labelText = @"正在添加任务到下载队列";
    [self initPostWithURL:ROUTINGBASEURL path:[NSString stringWithFormat: @"extension/ext_download?token=%@",[GlobalShare getToken]] paras:@{@"json": [self convertJSONString:@"add" url:self.url]} mark:@"add" autoRequest:YES];
}

- (void)showTipWithText:(NSString *)text
{
    if (loadingProgress) {
        
        loadingProgress = nil;
    }
    
    loadingProgress = [[MBProgressHUD alloc] initWithView:self.view];
    loadingProgress.mode = MBProgressHUDModeText;
    loadingProgress.labelText = text;
    loadingProgress.removeFromSuperViewOnHide = YES;
    [loadingProgress showAnimated:YES whileExecutingBlock:^{
        
        sleep(1.5);
    }];
    [self.view addSubview:loadingProgress];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSString *)convertJSONString:(NSString *)cmd url:(NSString *)url
{
    NSString *jsons = [NSString stringWithFormat:@"{\"cmd\":\"%@\",\"param\":{\"link\":[\"%@\"],\"islocal\":\"0\"}}",cmd,url];
    return jsons;
}



@end

