//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingWrittinController.h"
#import "RTSlider.h"
#import "CCTextView.h"
#import "RoutingCamera.h"

@interface RoutingWrittinController ()
- (IBAction)onClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,weak) IBOutlet UIButton *btnOK;
@property (nonatomic,weak) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) CCTextView *txtContent;
@end

@implementation RoutingWrittinController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    CGRect bgRect=self.bgView.bounds;
    if (ScreenWidth()<=480) {
        self.lbTitle.transform=CGAffineTransformMakeTranslation(-44, 0);
        self.btnOK.transform=CGAffineTransformMakeTranslation(-88, 0);
        bgRect.size.width=450;
    }
    CCTextView *txtContent=[[CCTextView alloc]initWithFrame:bgRect];
    txtContent.placeholder=@"点击这里编辑文字...";
    txtContent.placeholderColor=RGBCommon(171, 171, 171);
    txtContent.textColor=RGBCommon(52, 52, 52);
    txtContent.font=[UIFont systemFontOfSize:16.0f];
    txtContent.alwaysBounceVertical=YES;
    self.txtContent=txtContent;
    [self.bgView addSubview:txtContent];
    if (![[self.dataObject rtStoryId]isEqualToString:@"0"]) {
        txtContent.text=[self.dataObject rtStory];
        [txtContent textDidChange];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

#pragma -mark 网络请求
-(void)getRequest{

    NSString *content=self.txtContent.text;
    if (![content isEqualToString:@""]&&![content isEqualToString:[self.dataObject rtStory]]) {
        if ([[self.dataObject rtStoryId] isEqualToString:@"0"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSDictionary *userData= [user objectForKey:USERDATA];
            NSString *userPhone=userData[@"userPhone"];
            if (userPhone&&![userPhone isEqualToString:@""]) {
//              addOrModifyDetails?resId =20&story=写下这一天的故事&username=18500646286
                NSDictionary *param=@{@"resId":[self.dataObject rtId],
                                      @"story":content,
                                      @"username":userPhone};
               [self initPostWithURL:MyHomeURL path:@"addOrModifyDetails" paras:param mark:@"add" autoRequest:YES];
            }
        }else{
            //   addOrModifyDetails?story=写下这一天的故事&storyId=1&resId=0001
            NSDictionary *param=@{@"story":content,
                                  @"storyId":[self.dataObject rtStoryId],
                                  @"resId":[self.dataObject rtId]};
            [self initPostWithURL:MyHomeURL path:@"addOrModifyDetails" paras:param mark:@"make" autoRequest:YES];
        }
        [self.dataObject setRtStory:content];
    }

    
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    if ([mark isEqualToString:@"add"]) {
        NSNumber *code=response[@"returnCode"];
        if ([code integerValue]==200) {
            NSDictionary *param=response[@"data"][0];
            NSString *storyId=[param[@"resid"] stringValue];
            [self.dataObject setRtStoryId:storyId];
        }
    }
    PSLog(@"%@:%@",mark,response);
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    PSLog(@"%@:%@",mark,error);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



- (IBAction)onClick:(id)sender {
    if ([sender tag]==2) {
        [self getRequest];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
