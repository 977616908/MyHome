//
//  DocumentPreviewViewController.m
//  MyHome
//
//  Created by Harvey on 14-8-5.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "DocumentHtmlViewController.h"

@interface DocumentHtmlViewController ()<UIWebViewDelegate>
{
    UIWebView       *_webView;
    MBProgressHUD   *_loadState;
}


@end

@implementation DocumentHtmlViewController

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
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
//    [_webView loadRequest:[NSURLRequest requestWithURL:self.url.encodedString.urlInstance]];
    NSURL *urlPath=self.url.encodedString.urlInstance;
    NSData *data=[NSData dataWithContentsOfURL:urlPath];
    [_webView loadData:data MIMEType:@"text/txt" textEncodingName:@"GBK" baseURL:urlPath];
    _webView.dataDetectorTypes=UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
    
    _loadState = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    PSLog(@"load error :%@",error);
    _loadState.labelText=@"加载失败!";
    [_loadState hide:YES afterDelay:0.5];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadState hide:YES afterDelay:0.5];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self clearWebViewWithCookie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
