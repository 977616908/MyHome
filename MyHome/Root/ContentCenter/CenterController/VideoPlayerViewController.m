//
//  VideoPlayerViewController.m
//  MyHome
//
//  Created by HXL on 14-9-15.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSString *contentStr=[NSString stringWithFormat:@"名字:%@\n大小:%@\n创建时间:%@",self.info.fileName,self.info.fileSize,self.info.fileUpDate];
    CCLabel *content=CCLabelCreateWithNewValue(contentStr, 18.0f, CGRectMake(10, 100, 300, 120));
    content.numberOfLines=0;
    [self.view addSubview:content];
    UIView *_toolbar = [[UIView alloc] init];
    _toolbar.backgroundColor=RGBCommon(73, 170, 231);
    CGFloat barY=CGRectGetHeight(self.view.frame)-44;
    _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), 44);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnWidth = _toolbar.bounds.size.height;
    deleteBtn.frame=CGRectMake((CGRectGetWidth(self.view.frame)-btnWidth)/2, 0, btnWidth, btnWidth);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteVedio) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
    
    
}

-(void)deleteVedio{
    PSLog(@"删除了...");
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [action showInView:self.view];
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
