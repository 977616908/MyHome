//
//  VideoAndMusicViewController.m
//  MyHome
//
//  Created by Harvey on 14-7-30.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "VideoMusicViewController.h"
#import "VideoAndMusicGridCell.h"
#import "MJRefresh.h"
#import "MusicPlayViewController.h"
#import "VideoPlayerViewController.h"
#import "FileInfo.h"

#define CELLID @"HarveyID"
#define BARHEIGHT 44

@interface VideoMusicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate>{
    MBProgressHUD *stateView;
    NSMutableArray *_files;
    NSMutableArray *arrRefresh;
    NSMutableArray *arrAddress;
//    VideoPlayerViewController *_playerController;
    NSString *mUrl;
    NSMutableOrderedSet *_saveSet;
    BOOL          isAdd;
    NSString *pathArchtive;
    NSString *saveArchtive;
    BOOL          isRefresh;
    UIView       *_toolbar;
}
@property (nonatomic,weak) UICollectionView *gridView;
@property(nonatomic,weak)  MJRefreshHeaderView *header;

@end

@implementation VideoMusicViewController

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
    if (is_iOS7()) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _files = [NSMutableArray array];
    if (self.dataModel==DataModelVideo) {
        self.navigationItem.title = @"云视频";
        _saveSet=[NSMutableOrderedSet orderedSet];
        saveArchtive=pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
        [self createNav];
    }else{
        self.navigationItem.title = @"云音乐";
    }
    [self createView];
    [self getRequest];
    
}

-(void)createView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat hg=[[UIScreen mainScreen]bounds].size.height-64;
    UICollectionView *collectionVM=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), hg) collectionViewLayout:layout];
    collectionVM.showsVerticalScrollIndicator=NO;
    collectionVM.backgroundColor=[UIColor clearColor];
    collectionVM.dataSource=self;
    collectionVM.delegate=self;
    collectionVM.alwaysBounceVertical=YES;
    [collectionVM registerClass:[VideoAndMusicGridCell class] forCellWithReuseIdentifier:CELLID];
    self.gridView=collectionVM;
    [self.view addSubview:collectionVM];
    //    _musicPlayer = [[NCMusicEngine alloc] init];
    [self setupRefreshView];
}

-(void)createNav{
    CCButton *sendBtn=CCButtonCreateWithValue(CGRectMake(-10, 0, 50, 44), @selector(onSelectListener:), self);
    [sendBtn alterFontSize:16];
    [sendBtn alterNormalTitle:@"选择"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    
    _toolbar = [[UIView alloc] init];
    _toolbar.backgroundColor=RGBCommon(73, 170, 231);
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *visitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    visitBtn.frame=CGRectMake(20, 0, BARHEIGHT, BARHEIGHT);
    visitBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [visitBtn setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
    visitBtn.tag=1;
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [visitBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:visitBtn];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame=CGRectMake((CGRectGetWidth(self.view.frame)-BARHEIGHT)/2, 0, BARHEIGHT, BARHEIGHT);
    downBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    downBtn.tag=2;
    [downBtn setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:downBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(CGRectGetWidth(self.view.frame)-20-BARHEIGHT, 0, BARHEIGHT, BARHEIGHT);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
    deleteBtn.tag=3;
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
    
    
}

-(void)onSelectListener:(CCButton *)sendar{
    if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
//        isDelete=YES;
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        self.title=@"选择项目";
//        UIButton *btn01=(UIButton *)self.arrTag[0] ;
//        UIButton *btn02=(UIButton *)self.arrTag[1] ;
//        UIButton *btn03=(UIButton *)self.arrTag[2] ;
//        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
//        [btn02 setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
//        [btn03 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
//        btn01.enabled=YES;
//        btn02.enabled=NO;
//        btn03.enabled=NO;
    }else{
//        isDelete=NO;
        [sendar alterNormalTitle:@"选择"];
        [self toolBarWithAnimation:YES];
        self.title=@"云图片";
    }
//    [_deleteArr removeAllObjects];
//    [tableImg reloadData];
    PSLog(@"--%@--",sendar.titleLabel.text);
}

-(void)toolBarWithAnimation:(BOOL)isHidden{
    CGFloat barY=0;
    if (isHidden) {
        barY=CGRectGetHeight(self.view.frame);
    }else{
        barY=CGRectGetHeight(self.view.frame)-BARHEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), BARHEIGHT);
    }];
}

-(void)onClick:(UIButton *)sendar{
    
}

- (void)getRequest
{
    isAdd=YES;
    if (self.dataModel==DataModelMusic) {
        arrAddress=[NSMutableArray arrayWithArray:@[ROUTER_FOLDER_BASEURL(@"Music")]];
        pathArchtive=pathInCacheDirectory(@"AppCache/Music.archiver");
    }else{
        arrAddress=[NSMutableArray arrayWithArray:@[ROUTER_FOLDER_BASEURL(@"Video")]];
        pathArchtive=pathInCacheDirectory(@"AppCache/Video.archiver");
    }
    BOOL isSave=NO;
    if (isRefresh) {
        arrRefresh=[NSMutableArray array];
        [self initWithRequestAll];
        isSave=YES;
    }else{
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
        if (array&&array.count>0) {
            [_files addObjectsFromArray:array];
            [_gridView reloadData];
        }else{
            if (!stateView) {
                stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            stateView.removeFromSuperViewOnHide=YES;
            //        stateView.labelText=@"正在加载...请稍候";
            [self initWithRequestAll];
            isSave=YES;
        }
    }
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:saveArchtive];
    if (isSave) {
        if (arr&&arr.count>0){
            [_saveSet removeAllObjects];
            for (NSString *name in arr) {
                if (![self isVideoWithFileSuffix:[[name componentsSeparatedByString:@"."] lastObject]]) {
                    [_saveSet addObject:name];
                }
            }
        }
    }else{
        if (arr&&arr.count>0)[_saveSet addObjectsFromArray:arr];
    }
}

-(void)initWithRequestAll{
    if (arrAddress.count==0&&isAdd) {
        isAdd=NO;
        [arrAddress addObjectsFromArray:@[ROUTER_FOLDER_BASEURL(@"Data"),ROUTER_FOLDER_BASEURL(@"Data/download")]];
    }
    if (arrAddress.count>0) {
        NSString *path=arrAddress[0];
        [arrAddress removeObject:path];
        [self initGetWithURL:path
                        path:nil
                       paras:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"list", [GlobalShare getToken], @"token", nil]
                        mark:@"tesk"
                 autoRequest:YES];
    }else{
        [self updateWithData];
    }
    
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    PSLog(@"%@",response);
    NSArray *fileInfo = [response objectForKey:@"contents"];
    for (NSDictionary *info in fileInfo) {
//        NSString *path=[[info objectForKey:@"path"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *path=[info objectForKey:@"path"];
        NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
        if (![name hasPrefix:@"."]) {
            NSNumber *isDir=[info objectForKey:@"is_dir"];
            NSRange range=[name rangeOfString:@"."];
            if (range.location!=NSNotFound&&![isDir boolValue]) {
                NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                BOOL isMyNeed = self.dataModel==DataModelMusic ? [self isMusicWithFileSuffix:suffix]:[self isVideoWithFileSuffix:suffix];
                //        PSLog(@"%@",ROUTER_FILE_WHOLEDOWNLOAD(path));
                if (isMyNeed) {
                    FileInfo *item = [[FileInfo alloc]init];
                    name=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    if(self.dataModel==DataModelVideo)[_saveSet addObject:name];
                    item.fileName = [[name componentsSeparatedByString:@"."] firstObject];;
                    item.fileSuffix = suffix;
                    item.filePath = path;
                    item.fileSize = [info objectForKey:@"size"];
                    //                item.fileUpDate = [info objectForKey:@"modified"];
                    item.fileUpDate = [CCDate timeIntervalConvertDate:[[info objectForKey:@"modified_lts"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
                    item.isCanPlayOrOpen = (self.dataModel==DataModelMusic ? [suffix.lowercaseString isEqualToString:@"mp3"]:[suffix.lowercaseString isEqualToString:@"mp4"]||[suffix.lowercaseString isEqualToString:@"mov"]);
                    if (isRefresh) {
                        [arrRefresh addObject:item];
                    }else{
                        [_files addObject:item];
                    }
                }
            }else{
                if (isAdd) {
                    PSLog(@"%@",ROUTER_FOLDER_BASEURL(path));
                    NSString *address=[ROUTER_FOLDER_BASEURL(path) encodedString];
                    [arrAddress addObject:address];
                }
            }

        }
    }
    [self initWithRequestAll];
}

-(void)updateWithData{
    if (isRefresh){
        _files=arrRefresh;
        [_header endRefreshing];
    }else{
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }
    [_files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FileInfo *item1=(FileInfo *)obj1;
        FileInfo *item2=(FileInfo *)obj2;
        return [item2.fileUpDate compare:item1.fileUpDate];
    }];
    [NSKeyedArchiver archiveRootObject:_files toFile:pathArchtive];
    if (self.dataModel==DataModelVideo){
        [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
    }
    [self.gridView reloadData];
   
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@:%@",mark,error);
    stateView.labelText=@"加载失败!";
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    if (isRefresh) {
        [_header endRefreshing];
    }
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
//        if ([state isEqualToString:@"fail"]) {
//            [self exitCurrentController];
//        }
    }];
}

#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.gridView;
    header.delegate = self;
    self.header = header;
    isRefresh=NO;
}
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
    //        [self loadMoreData];
    //    } else { // 下拉刷新
    //        [self loadNewData];
    //    }
    //    [self initBase];
    isRefresh=YES;
    [self getRequest];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _files.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoAndMusicGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.filePreview.image = (self.dataModel==DataModelMusic ? @"0730music":@"0730video").imageInstance;
    FileInfo *info = [_files objectAtIndex:indexPath.row];
    if (info) {
        cell.fileName.text = info.fileName;
        if (!info.isCanPlayOrOpen) {
            cell.filePreview.image = (self.dataModel==DataModelMusic ? @"0730music02":@"0730video02").imageInstance;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (self.dataModel == DataModelVideo) {
        FileInfo *info = [_files objectAtIndex:indexPath.row];
        NSString *url = ROUTER_FILE_WHOLEDOWNLOAD(info.filePath);
        if (info.isCanPlayOrOpen) {
            MPMoviePlayerViewController *playerController=[[MPMoviePlayerViewController alloc]init];
            playerController.moviePlayer.contentURL = url.encodedString.urlInstance;
            playerController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
            //        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
            //        playerController.view.transform = landscapeTransform;
            //        _playerController.moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
            [playerController.moviePlayer prepareToPlay];
            [self presentMoviePlayerViewControllerAnimated:playerController];
        }else{
            VideoPlayerViewController *videoController = [[VideoPlayerViewController alloc] init];
            videoController.title=@"云视频";
            videoController.info=info;
            [self.navigationController pushViewController:videoController animated:YES];
        }
     
    }else {
        MusicPlayViewController *mpc = [[MusicPlayViewController alloc] init];
        mpc.musicInfo = [NSArray arrayWithArray:_files];
        mpc.currentPlayIndex = indexPath.section*2 + indexPath.row;
        [self.navigationController pushViewController:mpc animated:YES];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(150, 110);
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 0, 5);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_musicPlayer stop];
//    _musicPlayer = nil;
}

-(void)dealloc{
    [_header removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
