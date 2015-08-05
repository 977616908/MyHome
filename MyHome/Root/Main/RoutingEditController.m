//
//  ComposeViewController.m
//  RoutingTime
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingEditController.h"
#import "CCTextView.h"
#import "RoutingTime.h"
#define HEIGHT 250


@interface RoutingEditController ()<UITextViewDelegate>{
    MBProgressHUD           *stateView;

}

@property(nonatomic,weak)CCTextView *textView;

@end

@implementation RoutingEditController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTextView];
    if (_routingTime) {
        self.textView.text=_routingTime.rtTitle;
        [self.textView textDidChange];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void)coustomNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onComplete)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"编辑描述";
}

-(void)createTextView{
    // 1.添加
    CCTextView *textView = [[CCTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:18];
    textView.placeholderColor=RGBCommon(181, 181, 181);
    
    textView.frame = CGRectMake(7, 5, CGRectGetWidth(self.view.frame)-15, HEIGHT);
//    textView.textContainerInset=UIEdgeInsetsMake(15, 10, 0, 10);
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"这一刻的想法...";
    [self.view addSubview:textView];
    self.textView = textView;
    [self.textView becomeFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
    
}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self exitCurrentController];
}

/**
 *  完成
 */
- (void)onComplete
{
    [self.view endEditing:YES];
//    http://58.67.196.187:8080/platports/pifii/plat/timeRouter/updateRecordTitle?timeId =20&title=外出郊游
    if(!stateView){
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    stateView.labelText=@"正在编辑...";
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userData= [user objectForKey:USERDATA];
//    NSString *userPhone=userData[@"userPhone"];
//    if (userPhone&&![userPhone isEqualToString:@""]) {
//        
//    }
    _routingTime.rtTitle=_textView.text;
    NSDictionary *params=@{@"timeId":@(_routingTime.rtId),
                           @"title":_routingTime.rtTitle};
    [self initPostWithURL:MyHomeURL path:@"updateRecordTitle" paras:params mark:@"edit" autoRequest:YES];
   
   
}


-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@",response);
    if ([[response objectForKey:@"returnCode"]integerValue]==200) {
        [self.pifiiDelegate pushViewDataSource:_routingTime];
    }
    [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.2];
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.2];
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
        // 关闭控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
