//
//  ThreeViewController.m
//  MyHome
//
//  Created by HXL on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MusicHtmlController.h"
#import "ThreeCell.h"
#import "HtmlViewController.h"
#import "HomeModel.h"

#define MUSICID @"MUSICID"
@interface MusicHtmlController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong ,nonatomic)NSMutableArray * mydataArray;

@end

@implementation MusicHtmlController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =@"音乐";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initbaseData];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    CGFloat hg=[[UIScreen mainScreen]bounds].size.height-64;
    UICollectionView *collectionMusic=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), hg) collectionViewLayout:layout];
    collectionMusic.backgroundColor=[UIColor whiteColor];
    collectionMusic.delegate=self;
    collectionMusic.dataSource=self;
    collectionMusic.showsVerticalScrollIndicator=NO;
    [collectionMusic registerClass:[ThreeCell class] forCellWithReuseIdentifier:MUSICID];
    [self.view addSubview:collectionMusic];
    
}

-(void)initbaseData
{
    
    NSArray *tempimage =   @[@"0605hm_baiduyy",@"0605hm_kugou",@"0605hm_kuwo"];
    NSArray *label1 =   @[@"百度音乐",@"酷狗音乐",@"酷我音乐"];
    NSArray *label2 =   @[@"http://mp3.baidu.com",@"http://web.kugou.com/",@"http://m.kuwo.cn/?f=qqliulanqi"];
    self.mydataArray =[NSMutableArray new];
    for (int i=0; i<tempimage.count; i++) {
        HomeModel *hxlmodel = [[HomeModel alloc]init];
        hxlmodel.image1 = tempimage[i];
        hxlmodel.item1 =  label1[i];
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
    ThreeCell *cell = (ThreeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MUSICID forIndexPath:indexPath];
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
    web.title=mymodels.item1;
    [self.navigationController pushViewController:web animated:YES];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
