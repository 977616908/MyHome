//
//  ZeroCenterViewCtr.m
//  MyHome
//
//  Created by HXL on 14-6-5.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MediaCenterViewController.h"
#import "VedioHtmlController.h"
#import "MusicHtmlController.h"
#import "REPhotoCollectionController.h"
#import "VideoMusicViewController.h"
#import "DocumentsViewController.h"
#import "DownLoadViewController.h"
#import "MusicViewController.h"
#import "VedioViewController.h"


@interface MediaCenterViewController ()
@property (nonatomic,weak)CCScrollView *rootScrollView;
@end

@implementation MediaCenterViewController

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
    PSLog(@"--%f--%f",CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
    CGFloat gh=44;
    if(is_iOS7()){
        gh+=20;
    }
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), nil, NO);
    rootScrollView.contentSize=CGSizeMake(0, 568-gh);
    _rootScrollView=rootScrollView;
    [self.view addSubview:rootScrollView];
    
    [self createView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createView{
    CGFloat hg=15;
    UIView *oneView=[[UIView alloc]initWithFrame:CGRectMake(10, hg, CGRectGetWidth(self.view.frame)-20, 134)];
    oneView.backgroundColor=RGBCommon(215, 234, 240);
    oneView.layer.masksToBounds=YES;
    oneView.layer.cornerRadius=5;
    [self.rootScrollView addSubview:oneView];
    
    CCImageView *imgIcon=CCImageViewCreateWithNewValue(@"0605hm_wlicon", CGRectMake(6, 5.5, 29, 29));
    CCLabel *lbTitle=CCLabelCreateWithBlodNewValue(@"网络", 18, CGRectMake(CGRectGetMaxX(imgIcon.frame)+6, 10, 80, 20));
    [lbTitle alterFontColor:RGBCommon(38, 38, 38)];
    [oneView addSubview:imgIcon];
    [oneView addSubview:lbTitle];
    
    NSArray *imageArray = @[@"0605hm_spicon",@"0605hm_yyicon"];
    NSArray * nameLable = @[@"视频",@"音乐"];
    for (NSInteger i=0 ;i<nameLable.count; i++) {
        int rowX=i%2;
        int rowY=i/2;
        UIView *bgView=[[UIView alloc]init];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.frame=CGRectMake(150*rowX, 95*rowY+40, 149.5, 94.5);
        if (![nameLable[i] isEqualToString:@""]) {
            UIButton * hxlButton = [UIButton buttonWithType:UIButtonTypeCustom];
            hxlButton.tag =i;
            hxlButton.frame = CGRectMake(45,15,60, 40);
            [hxlButton setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
            [hxlButton addTarget:self action:@selector(oneClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel * hxlLabel = [[UILabel alloc]initWithFrame:CGRectMake(hxlButton.origin.x, hxlButton.bottom+5, 60, 16)];
            hxlLabel.font = [UIFont systemFontOfSize:16.0f];
            hxlLabel.textColor = RGBCommon(68, 68, 68);
            hxlLabel.backgroundColor = [UIColor clearColor];
            hxlLabel.textAlignment = NSTextAlignmentCenter;
            hxlLabel.text = [nameLable objectAtIndex:i];
            [bgView addSubview:hxlLabel];
            [bgView  addSubview:hxlButton];
        }
        [oneView addSubview:bgView];
    }
    if (ScreenHeight()>480) {
        hg=15*2;
    }
    
    UIView *secondView=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(oneView.frame)+hg, CGRectGetWidth(self.view.frame)-20, 325-95)];
    secondView.backgroundColor=RGBCommon(215, 234, 240);
    secondView.layer.masksToBounds=YES;
    secondView.layer.cornerRadius=5;
    [self.rootScrollView addSubview:secondView];
    
    CCImageView *imgIcon2=CCImageViewCreateWithNewValue(@"0605hm_lyccicon", CGRectMake(6, 5.5, 29, 29));
    CCLabel *lbTitle2=CCLabelCreateWithBlodNewValue(@"路由存储", 18, CGRectMake(CGRectGetMaxX(imgIcon.frame)+6, 10, 80, 20));
    [lbTitle alterFontColor:RGBCommon(38, 38, 38)];
    [secondView addSubview:imgIcon2];
    [secondView addSubview:lbTitle2];
    NSArray *imageArray2 = @[@"0605hm_tp",@"0605hm_yy",@"0605hm_sp",@"0605hm_wd"];
    NSArray * nameLable2 = @[@"云图片",@"云音乐",@"云视频",@"云文档"];
    for (NSInteger i=0 ;i<nameLable2.count; i++) {
        int rowX=i%2;
        int rowY=i/2;
        UIView *bgView=[[UIView alloc]init];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.frame=CGRectMake(150*rowX, 95*rowY+40, 149.5, 94.5);
        if (![nameLable2[i] isEqualToString:@""]) {
            UIButton * hxlButton = [UIButton buttonWithType:UIButtonTypeCustom];
            hxlButton.tag =i;
            hxlButton.frame = CGRectMake(45,15,60, 40);
            [hxlButton setImage:[UIImage imageNamed:[imageArray2 objectAtIndex:i]] forState:UIControlStateNormal];
            [hxlButton addTarget:self action:@selector(secondClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel * hxlLabel = [[UILabel alloc]initWithFrame:CGRectMake(hxlButton.origin.x, hxlButton.bottom+5, 60, 16)];
            hxlLabel.font = [UIFont systemFontOfSize:16.0f];
            hxlLabel.textColor = RGBCommon(68, 68, 68);
            hxlLabel.backgroundColor = [UIColor clearColor];
            hxlLabel.textAlignment = NSTextAlignmentCenter;
            hxlLabel.text = [nameLable2 objectAtIndex:i];
            [bgView addSubview:hxlLabel];
            [bgView  addSubview:hxlButton];
        }
        [secondView addSubview:bgView];
    }
    
}


-(void)oneClick:(UIButton *)sendar{
    switch (sendar.tag) {
        case 0:
            [self.navigationController pushViewController:[VedioHtmlController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[MusicHtmlController new] animated:YES];
            break;
    }
}

-(void)secondClick:(UIButton *)sender
{
    if(![self setMacBounds])return;
    
    switch (sender.tag) {
//        case 0:
//            
//            [self.navigationController pushViewController:[[DownLoadViewController alloc]init] animated:YES];
//
//            break;
        case 0:{
    
            REPhotoCollectionController *imgVC = [[REPhotoCollectionController alloc]init];
            [self.navigationController pushViewController:imgVC animated:YES];
        }
            break;
        case 1:{
                MusicViewController *vam = [[MusicViewController alloc]init];
                [self.navigationController pushViewController:vam animated:YES];
        }
            break;
        case 2:{
//            VideoMusicViewController *vam = [[VideoMusicViewController alloc]init];
//            vam.dataModel = DataModelVideo;
            VedioViewController *vam=[[VedioViewController alloc]init];
            [self.navigationController pushViewController:vam animated:YES];
        }
            break;
        case 3:{
            
            DocumentsViewController *imgVC = [DocumentsViewController new];
//            imgVC.viewModel = ViewModelDocument;
            [self.navigationController pushViewController:imgVC animated:YES];
        }
            break;
        case 4:
        {
            
            DocumentsViewController *imgVC = [DocumentsViewController new];
//            imgVC.viewModel = ViewModelOhter;
            [self.navigationController pushViewController:imgVC animated:YES];
        }

            break;
        default:
            break;
    }
    
}

@end
