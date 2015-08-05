//
//  PiFiiBaseViewController.m
//  FlowTT_Home
//
//  Created by Harvey on 14-4-21.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "PiFiiBaseViewController.h"
#import "AFHTTPCilent.h"

/*  后缀名管理   [如果缺少相应后缀, 在相应的数组后加该后缀即可]*/
#define DOCUMENTSUFFIX  @[@"doc", @"xls", @"pdf", @"ppt",@"txt"]
#define VIDEOSUFFIX     @[@"mp4", @"avi", @"rmvb", @"flv", @"mkv",@"3gp",@"mov",@"m4v"]
#define MUSICSUFFIX     @[@"mp3"]
#define IMAGESUFFIX     @[@"jpg", @"png", @"jepg", @"gif"]


@interface PiFiiBaseViewController ()<UIAlertViewDelegate>
{
    NSMutableOrderedSet              *_requestSet;
}
@end

@implementation PiFiiBaseViewController

@synthesize navigationBarButtomLineColor = _navigationBarButtomLineColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  判断文件是否是文档
 *
 *  @return YES:是文档; NO:不是文档
 */
- (BOOL)isDocumentWithFileSuffix:(NSString *)suffix
{
    for (NSString *suffixValue in DOCUMENTSUFFIX) {
        
        if ([suffix.lowercaseString hasPrefix:suffixValue]) {
            
            return YES;
        }
    }
    return NO;
}

/**
 *  判断文件是否是音乐文件
 *
 *  @return YES:是音乐文件; NO:不是音乐文件
 */
- (BOOL)isMusicWithFileSuffix:(NSString *)suffix
{
    for (NSString *suffixValue in MUSICSUFFIX) {
        
        if ([suffix.lowercaseString hasPrefix:suffixValue]) {
            
            return YES;
        }
    }
    return NO;
}

/**
 *  判断文件是否是视频文件
 *
 *  @return YES:是视频文件; NO:不是视频文件
 */
- (BOOL)isVideoWithFileSuffix:(NSString *)suffix
{
    for (NSString *suffixValue in VIDEOSUFFIX) {
        
        if ([suffix.lowercaseString hasPrefix:suffixValue]) {
            
            return YES;
        }
    }
    return NO;
}

/**
 *  判断文件是否是图片文件
 *
 *  @return YES:是图片文件; NO:不是图片文件
 */
- (BOOL)isImageWithFileSuffix:(NSString *)suffix
{
    for (NSString *suffixValue in IMAGESUFFIX) {
        
        if ([suffix.lowercaseString hasPrefix:suffixValue]) {
            
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self coustomNav];
    [self loadCoustomSetting];
    
}

- (void)coustomNav
{
    UIBarButtonItem *negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (is_iOS7()^1) {//低于ios7执行
        negativeSpacer.width=5;
    }else{
        negativeSpacer.width=-5;
    }
    self.navigationController.hidesBottomBarWhenPushed = YES;
    CCView *rigViewNav = [CCView createWithFrame:CGRectMake(0, 0, 49, 44) backgroundColor:RGBClearColor()];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCurrentController)];
    [rigViewNav addGestureRecognizer:tap];
    
    [rigViewNav addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(0, 11.75, 12, 20.5))];
    NSString *praentTitle  = @"返回";
    CCLabel *_labTitle = CCLabelCreateWithNewValue(praentTitle, 18, CGRectMake(15, 0, 50, 44));
    _labTitle.textColor = RGBWhiteColor();
    _labTitle.backgroundColor = RGBClearColor();
    [rigViewNav addSubview:_labTitle];
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:rigViewNav];
    //       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigViewNav];
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,leftBarItem];
}

- (void)exitCurrentController
{
    if (self.isCustomAnimation) {
        [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:NO] forKey:@"animation"];
        if (![self.navigationController popViewControllerAnimated:NO]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
        if (![self.navigationController popViewControllerAnimated:YES]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.navigationController.navigationBar) {
//        if (_navigationBarButtomLineColor) {
//            [self setNavigationBarButtomLineColor:_navigationBarButtomLineColor];
//        }
//    }
}

- (void)setNavigationBarButtomLineColor:(UIColor *)navigationBarButtomLineColor
{
    ((UIView *)[[(UIView *)[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews]
                lastObject]).backgroundColor =navigationBarButtomLineColor;
}


- (void)initGetWithPath:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest
{
    [self initRequestWithMethod:@"GET" URL:FLOWTTBASEURL path:path paras:paras mark:mark autoRequest:autoRequest];
}

- (void)initGetWithURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest
{
    [self initRequestWithMethod:@"GET" URL:url path:path paras:paras mark:mark autoRequest:autoRequest];
}


- (void)initPostWithPath:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest
{
    [self initRequestWithMethod:@"POST" URL:FLOWTTBASEURL path:path paras:paras mark:mark autoRequest:autoRequest];
}

- (void)initPostWithURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest
{
    [self initRequestWithMethod:@"POST" URL:url path:path paras:paras mark:mark autoRequest:autoRequest];
}

- (void)initRequestWithMethod:(NSString *)method URL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest
{
    if (!_requestSet) {
        _requestSet = [NSMutableOrderedSet orderedSet];
    }
    //    PSLog(@"---对象的个数:%d----",_requestSet.count);
    AFHTTPCilent *cilent = [[AFHTTPCilent alloc] initWithURL:url path:path mark:mark];
    cilent.method = method;
    cilent.paras = [NSMutableDictionary dictionaryWithDictionary:paras];
    cilent.delegate = self;
    [_requestSet addObject:cilent];
    if (autoRequest) {
        [cilent startAsynRequest];
    }
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    
}

- (void)startAsynRequestWihtMark:(NSString *)mark
{
    AFHTTPCilent *client = [self lookForRequestWithMark:mark];
    if ([client isExecuting]) {
        
        return;
    }
    [client startAsynRequest];
}

- (void)cancelRequestWihtMark:(NSString *)mark
{
    AFHTTPCilent *client = [self lookForRequestWithMark:mark];
    if (client) {
        [client cancelRequest];
        [_requestSet removeObject:client];
    }
}

- (void)setRequestParam:(id)param value:(id)value mark:(NSString *)mark
{
    AFHTTPCilent *client = [self lookForRequestWithMark:mark];
    if ([client canChangeParam] ^1) {
        
        return;
    }
    if ([param isKindOfClass:[NSDictionary class]]) {
        
        for (NSString *key in param) {
            
            [client.paras setObject:[param objectForKey:key] forKey:key];
        }
    }else if ([param isKindOfClass:[NSString class]]) {
        
        [client.paras setObject:value forKey:param];
    }
}

- (void)removeRequestParamWithKey:(NSString *)key mark:(NSString *)mark
{
    AFHTTPCilent *client = [self lookForRequestWithMark:mark];
    if ([client canChangeParam] ^1) {
        
        return;
    }
    [client.paras removeObjectForKey:key];
}

- (id)lookForRequestWithMark:(NSString *)mark
{
    for (AFHTTPCilent *client in _requestSet) {
        
        if ([client.mark isEqualToString:mark]) {
            
            return client;
        }
    }
    return nil;
}

- (void)removeRequestFromSetWithMark:(NSString *)mark
{
    AFHTTPCilent *client = [self lookForRequestWithMark:mark];
    if (client) {
        [client cancelRequest];
        [_requestSet removeObject:client];
    }
    //    PSLog(@"---剩余对象的个数:%d----",_requestSet.count);
}

- (void)removeNavigationBarButtomLine
{
    [((UIView *)[[(UIView *)[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews] lastObject]) removeFromSuperview];
}

- (void)loadCoustomSetting
{
//    if (self.isCustomSet) {
//        [self.view setBackgroundColor:RGBCommon(2, 124, 185)];
//        NSString *backImage = @"hm_bg001_iOS6";
//        if (is_iOS7()) {
//            backImage = @"hm_bg001";
//        }
    [((UIView *)[[(UIView *)[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews] lastObject]) removeFromSuperview];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:backImage] forBarMetrics:UIBarMetricsDefault];
//    }else{
        self.view.backgroundColor=RGBCommon(237, 237, 237);
        NSString *backImage = @"hm_bg00_iOS6";
        if (is_iOS7()) {
            backImage = @"hm_bg00";
        }
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:backImage] forBarMetrics:UIBarMetricsDefault];
        NSMutableDictionary *textAttrs=[[NSMutableDictionary alloc]init];
        textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
        textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
        textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:19.0];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 判断是否绑定与连接PIFii路由
 */
-(BOOL)setMacBounds{
    BOOL isBound=[GlobalShare isBindMac];
    if (!isBound) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常或未绑定PiFii路由" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        BOOL isConnect=[[user objectForKey:ISCONNECT]boolValue];
        if (!isConnect) {
            NSString *name=[user objectForKey:ROUTERNAME];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"未连接绑定[%@]路由",name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            isBound=NO;
        }
    }
    return isBound;
}

/**
 * 清理缓存
 */
-(void) clearWebViewWithCookie{
    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) clearImageWithCookie{
    [[NSFileManager defaultManager] removeItemAtPath:pathInCacheDirectory(@"com.pifii") error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.pifii") withIntermediateDirectories:YES attributes:nil error:nil];
}

/**
 * 清理网络问题
 */
-(void)clearRequestClient{
    if (_requestSet) {
        for (AFHTTPCilent *cilent in _requestSet) {
            if (cilent) {
                [cilent cancelRequest];
            }
        }
        [_requestSet removeAllObjects];
        _requestSet=nil;
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [self clearRequestClient];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self exitCurrentController];
}

-(CATransition *)customAnimation:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = @"pageCurl";//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

-(void)showToast:(NSString *)msg Long:(NSInteger)duration{
    UILabel *label=[[UILabel alloc]init];
    label.text=msg;
    label.font=[UIFont systemFontOfSize:15.0f];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor blackColor];
    label.frame=CGRectMake(0, 0, 250, 40);
    label.center=CGPointMake(160, CGRectGetHeight(self.view.frame)-80);
    label.alpha=0.0;
    label.layer.cornerRadius=5;
    label.clipsToBounds=YES;
    [self.view addSubview:label];
    [UIView animateWithDuration:duration animations:^{
        label.alpha=0.7;
    } completion:^(BOOL finished) {
        label.alpha=1.0;
        [UIView animateWithDuration:duration/2 delay:duration/2 options:UIViewAnimationOptionCurveLinear animations:^{
            label.alpha=0.0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


