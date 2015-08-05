//
//  ResouceCtr.m
//  MyHome
//
//  Created by HXL on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "VedioHtmlController.h"
#import "ContentOneCell.h"
#import "HtmlViewController.h"

@interface VedioHtmlController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong ,nonatomic)NSMutableArray * mydataArray;
@property(strong,nonatomic)NSArray * mytitle;

@end

@implementation VedioHtmlController

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
    self.title = @"视频";
    [self initbaseData];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat hg=[[UIScreen mainScreen]bounds].size.height-64;
    UICollectionView *collectionVedio=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), hg) collectionViewLayout:layout];
    collectionVedio.delegate=self;
    collectionVedio.dataSource=self;
    collectionVedio.backgroundColor=[UIColor whiteColor];
    collectionVedio.showsVerticalScrollIndicator=NO;
    [collectionVedio registerClass:[ContentOneCell class] forCellWithReuseIdentifier:@"JAMNEYID"];// 注册可重用视图
    [self.view addSubview:collectionVedio];
}

-(void)initbaseData
{
    
    NSArray *tempimage =   @[@"hm_youku",@"hm_baidu",@"hm_leshi",@"hm_PPTV",@"hm_qiyi",@"hm_tengxun"];
    self.mytitle =   @[@"优酷",@"百度视频",@"乐视",@"PPTV聚力",@"爱奇艺",@"腾讯视频"];
    NSArray *label2 =   @[@"http://www.youku.com",@"http://v.baidu.com",@"http://m.letv.com/",@"http://www.pptv.com",@"http://www.qiyi.com",@"http://v.qq.com"];
    self.mydataArray =[NSMutableArray array];
    for (int i=0; i<6; i++) {
        HomeModel *hxlmodel = [[HomeModel alloc]init];
        hxlmodel.image1 = tempimage[i];
        hxlmodel.item1 =  self.mytitle[i];
        hxlmodel.item2 =  label2[i];
        [self.mydataArray addObject:hxlmodel];
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mydataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentOneCell *cell = (ContentOneCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"JAMNEYID" forIndexPath:indexPath];
    HomeModel *mymodels = [self.mydataArray objectAtIndex:indexPath.row];
    cell.mymodel =mymodels;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    return cell;
}
//选中跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PSLog(@"didSelectItemAtIndexPath:%d-》%d", (int)indexPath.section, (int)indexPath.row);
    HomeModel *mymodels = [self.mydataArray objectAtIndex:indexPath.row];
    PSLog(@"select----->%@",mymodels.item1);
    HtmlViewController * web =[[HtmlViewController alloc]init];
    web.url = mymodels.item2;
    web.title =self.mytitle[indexPath.row];
    web.myTitle =self.mytitle[indexPath.row];
    [self.navigationController pushViewController:web animated:YES];
    
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(160, 115);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end