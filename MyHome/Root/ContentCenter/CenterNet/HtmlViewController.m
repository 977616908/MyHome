//
//  HtmlViewController.m
//  FlowTT_Home
//
//  Created by HXL on 14-4-30.
//  Copyright (c) 2014年 HXL. All rights reserved.
//

#import "HtmlViewController.h"
//#import <AVFoundation/AVFoundation.h>
@interface HtmlViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *_avc;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UILabel *sourceName;

- (IBAction)downloadAction:(id)sender;

@end

@implementation HtmlViewController

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
    self.sourceName.text =self.myTitle;
   // _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:[NSURLRequest requestWithURL:[self.url urlInstance]]];
   // [self.view addSubview:_webView];
   // self.underView.frame= CGRectMake(0,XL_ScreenHeight-40, XL_ScreenWidth, 40);
    
  // [self.view insertSubview:self.underView aboveSubview:self.webView];
    _avc = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    _avc.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _avc.color = [UIColor grayColor];
    [_avc startAnimating];
    
   
    [self.view addSubview:_avc];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断加载的网站
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        NSURL *url=[request URL];
        NSString *curUrl=[url absoluteString];
        PSLog(@"-----%@",curUrl);
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_avc stopAnimating];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_avc stopAnimating];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self clearWebViewWithCookie];
}

- (IBAction)downloadAction:(id)sender {
    PSLog(@"下载视频");
}

-(void)exitCurrentController{
    if ([_avc isAnimating]) {
        [_avc stopAnimating];
        [super exitCurrentController];
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [super exitCurrentController];
        }
    }

  
}

@end
