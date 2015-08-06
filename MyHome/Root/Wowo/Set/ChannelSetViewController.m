//
//  MedicalOrderViewController.m
//  PiFiiHome_01
//
//  Created by HXL on 14/11/10.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ChannelSetViewController.h"
#import "LiveDownView.h"
@interface ChannelSetViewController (){
    LiveDownView *liveView;
    UIButton *btnDown;
    MBProgressHUD *stateView;
    NSMutableArray *arrSelect;
}
- (IBAction)onSelect:(UIButton *)sender;

- (IBAction)onClick:(UIButton *)sender;

@end

@implementation ChannelSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"信道设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    arrSelect=[NSMutableArray arrayWithArray:@[@(4),@(3)]];
    liveView=[[LiveDownView alloc]initWithFrame:CGRectMake(0, 0, 290, 0)];;
    typeof(self) weakSelf=self;
    liveView.liveDown= ^ (NSString * str) {
        [weakSelf setLiveDown:str];
    };
    [self.view addSubview:liveView];
}

-(void)setLiveDown:(NSString *)str{
    arrSelect[btnDown.tag-1]=@([liveView.arrayList indexOfObject:str]);
    [btnDown setTitle:str forState:UIControlStateNormal];
    [liveView showHidden:YES];
}

- (IBAction)onSelect:(UIButton *)sender {
    NSLog(@"---%@---",sender.titleLabel.text);
    if (btnDown!=sender) {
        liveView.isHidden=NO;
        btnDown=sender;
    }else{
         liveView.isHidden=!liveView.isHidden;
    }
    NSArray *arr=@[];
    switch (sender.tag) {
        case 1:
            arr=@[@"自动",@"信道1",@"信道2",@"信道3",@"信道4",@"信道5",@"信道6",@"信道7",@"信道8",@"信道9",@"信道10",@"信道11",@"信道12",@"信道13",@"信道14"];
            break;
        case 2:
            arr=@[@"低",@"中",@"高",@"最大"];
            break;
    }
    liveView.frame=CGRectMake(sender.frame.origin.x, sender.frame.origin.y+40, CGRectGetWidth(liveView.frame), CGRectGetHeight(liveView.frame));
    liveView.arrayList=arr;
    [liveView showHidden:liveView.isHidden];
}


-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@ : %@",mark,response);
    NSNumber *code=response[@"returnCode"];
    if ([code integerValue]==200) {
        stateView.labelText=@"保存成功";
    }else{
        stateView.labelText=response[@"desc"];
    }
    [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    PSLog(@"%@ : %@",mark,error);
    stateView.labelText=@"网络异常,请检测网络";
    [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
}

- (IBAction)onClick:(UIButton *)sender {
//    PSLog(@"%@",arrSelect);
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.removeFromSuperViewOnHide=YES;
    stateView.labelText=@"正在保存...";
//    routerSetChannel?user=15625152222&channel=0&power=0
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    [self initGetWithURL:FLOWTTBASEURL path:@"routerSetChannel" paras:@{@"user": userPhone,@"channel":arrSelect[0],@"power":arrSelect[1]} mark:@"set" autoRequest:YES];
}
@end
