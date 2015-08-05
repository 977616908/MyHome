//
//  feedbackViewController.m
//  FlowTT_Home
//
//  Created by HXL on 14-4-25.
//  Copyright (c) 2014年 HXL. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CCTextField.h"
#import "CCTextView.h"

@interface FeedBackViewController ()<UITextViewDelegate>{
    MBProgressHUD *stateView;
}

@property (weak, nonatomic) CCTextView *feedbackText;
@property (weak, nonatomic) CCTextField *txtMsg;

@end

@implementation FeedBackViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor=RGBCommon(237, 237, 237);
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(0,0, 60,30), @selector(onSendClick), self);
    [sendBut alterFontSize:18];
    [sendBut alterNormalTitle:@"发送"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sendBut];
    // Do any additional setup after loading the view from its nib.
    [self createView];
}

-(void)createView{
    CCScrollView *scrollView=CCScrollViewCreateNoneIndicatorWithFrame(self.view.frame, nil, NO);
    [self.view addSubview:scrollView];
    
    CCLabel *title=CCLabelCreateWithNewValue(@"您遇到的问题或改进意见:", 16.0f, CGRectMake(10, 15, CGRectGetWidth(self.view.frame), 20));
    title.textColor=RGBCommon(52, 52, 52);
    [scrollView addSubview:title];
    
    CCTextView *text=[[CCTextView alloc]initWithFrame:CGRectMake(0, 42, CGRectGetWidth(self.view.frame), 147)];
    text.backgroundColor=[UIColor whiteColor];
    text.textColor=RGBCommon(52, 52, 52);
    text.placeholder=@"我们将为您不断改进";
    text.font=[UIFont systemFontOfSize:16.0f];
    self.feedbackText=text;
    [scrollView addSubview:text];
    
    CCLabel *msg=CCLabelCreateWithNewValue(@"您的联系方式:(手机号码、邮箱或者QQ)", 16.0f, CGRectMake(10, CGRectGetMaxY(self.feedbackText.frame)+15, CGRectGetWidth(self.view.frame), 20));
    msg.textColor=RGBCommon(52, 52, 52);
    [scrollView addSubview:msg];
    
    CCTextField *txtMsg=[[CCTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(msg.frame)+10, CGRectGetWidth(self.view.frame), 44)];
    txtMsg.font=[UIFont systemFontOfSize:16.0];
    txtMsg.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"方便我们给您答复" attributes:@{NSForegroundColorAttributeName:RGBCommon(181, 181, 181)}];
    txtMsg.textColor=RGBCommon(52, 52, 52);
    txtMsg.backgroundColor=[UIColor whiteColor];
    txtMsg.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.txtMsg=txtMsg;
    [scrollView addSubview:txtMsg];
}

- (void)backAction
{
    [self exitCurrentController];
}



//点击发送
-(void)onSendClick
{
    [self.feedbackText resignFirstResponder];
    if ([_feedbackText.text isEqualToString:@""]||[_feedbackText.text isEqualToString:@"我们将为您不断改进"]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的反馈建议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }else{
        [self updateSql];
    }
}

-(void)updateSql
{
    stateView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.removeFromSuperViewOnHide = YES;
    stateView.labelText = @"正在提交...";
    NSDictionary *userData=[[NSUserDefaults standardUserDefaults] objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    NSString *contactinfo=[NSString stringWithFormat:@"%@",_txtMsg.text];
    [self initPostWithPath:@"feedBack"
                     paras:@{@"tradeCode": @(1103),
                             @"user": userPhone,
                             @"platfrom": @(2),
                              @"advice": _feedbackText.text,
                             @"version":[App shortVersion],
                             @"contactinfo":contactinfo}
                      mark:@"feek"
               autoRequest:YES];
    PSLog(@"updateSql--%@",userPhone);
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    NSInteger stateCode = [[response objectForKey:@"returnCode"] integerValue];
    if (stateCode == 200) {
        stateView.labelText = @"反馈成功！";
        [stateView hide:YES afterDelay:1];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    }
    PSLog(@"%@",response);
}


- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    stateView.labelText = @"反馈失败,网络异常!";
    [stateView hide:YES afterDelay:1];
    [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:0.5];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
