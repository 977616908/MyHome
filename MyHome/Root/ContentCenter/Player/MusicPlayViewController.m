//
//  MusicPlayViewController.m
//  MyHome
//
//  Created by Harvey on 14-8-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "FileInfo.h"
#import "PlayView.h"
#import "NCMusicEngine.h"
#import <MediaPlayer/MediaPlayer.h>

#define PLAYVIEWITEM_WIDTH 106
#define PLAYVIEWITEM_HEIGHT1 307
#define PLAYVIEWITEM_HEIGHT 110
#define PLAYVIEWITEM_TOP_HEIGHT 100
#define PLAYVIEWITEM_LEFT_X 14
#define ORDERTYPE @"orderType"
#define RANDOM @"random"

@interface MusicPlayViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NCMusicEngineDelegate>{
    BOOL isRandom;//随机
    int orderType;//顺序
    NSUserDefaults *defaults;
    NCMusicEngine       *_musicPlayer;
    MBProgressHUD       *_statusTip;
    BOOL                 _restart;
}

@property (strong, nonatomic) IBOutlet UISlider *playProgressBar;

@property (nonatomic,strong) IBOutlet UILabel           *currentTime;
@property (nonatomic,strong) IBOutlet UILabel           *totalTime;
@property (nonatomic,strong) IBOutlet UIView            *topView;
@property (nonatomic,strong) IBOutlet UIView            *controlView;
@property (nonatomic,strong) IBOutlet UIView            *middleView;
@property (nonatomic,strong) IBOutlet UICollectionView  *musicList;
@property (nonatomic,strong) IBOutlet UILabel           *titleStatus;
@property (nonatomic,strong) IBOutlet UIButton          *playBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgSuiji;
@property (strong, nonatomic) IBOutlet UIImageView *imgXunh;

@end

@implementation MusicPlayViewController

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
    [self initStyle];
    [self.musicList registerClass:[MusicCell class] forCellWithReuseIdentifier:@"Harvey"];
    self.musicList.contentOffset = CGPointMake(106*self.currentPlayIndex, 0);
    [self initPlayerAndPlayWithPath];
}

- (void)initStyle
{
    CGFloat h = ScreenHeight() - 20;
    CGFloat gap = 20;
    
    if (is_iOS7() ^ 1) {
        
        gap = 0;
    }
    self.topView.frame = CGRectMake(0, gap, 320, 45);
    self.controlView.frame = CGRectMake(0, h - 115 +gap, 320, 115);
    self.middleView.frame = CGRectMake(0, 45 + gap, 320, 300);
    [_playProgressBar setMinimumTrackImage:[UIImage imageNamed:@"hm_jindutiao"] forState:UIControlStateNormal];
    [_playProgressBar setMaximumTrackImage:[UIImage imageNamed:@"hm_jindutiao02"] forState:UIControlStateNormal];
    [_playProgressBar setThumbImage:[UIImage imageNamed:@"hm_jindu_player"] forState:UIControlStateNormal];
    _playProgressBar.minimumValue=0;
    [_playProgressBar addTarget:self action:@selector(durationChange:) forControlEvents:UIControlEventValueChanged];
    self.view.backgroundColor = @"Player".colorInstance;
    self.navigationController.navigationBarHidden = YES;
    //保存显示的播放方式
    defaults=[NSUserDefaults standardUserDefaults];
    orderType=[defaults integerForKey:ORDERTYPE];
    orderType=orderType==0?1:orderType;
    isRandom=[defaults boolForKey:RANDOM];
    [self showOrderType:orderType];
    [self showImgSuijiBool:isRandom animate:NO];
}

#pragma -mark 加载数据
- (void)initPlayerAndPlayWithPath
{
    FileInfo *info = [self.musicInfo objectAtIndex:self.currentPlayIndex];
    if (_musicPlayer) {
        
        [_musicPlayer stop];
        _musicPlayer = nil;
    }
    // init
    
        self.titleStatus.text = [[info.fileName componentsSeparatedByString:@"."]firstObject];
        [self.playBtn setImage:@"hm_bofang".imageInstance forState:UIControlStateNormal];
        self.currentTime.text = @"00:00";
        self.totalTime.text = @"00:00";
        _playProgressBar.minimumValue=0;
        _restart = YES;
  
        if (!_musicPlayer) {
            _musicPlayer = [[NCMusicEngine alloc] init];
            _musicPlayer.delegate = self;
        }
        [_musicPlayer playUrl:ROUTER_FILE_WHOLEDOWNLOAD(info.filePath).encodedString.urlInstance ];
    

}



-(void)durationChange:(UISlider *)sendar{
//    _musicPlayer.playerMusic.currentTime=sendar.value;
    NSTimeInterval time = sendar.value;
    [_musicPlayer.playerMusic seekToTime:CMTimeMakeWithSeconds(time, 1)];
    self.currentTime.text = [self convertFormatter:time];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.musicInfo.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Harvey" forIndexPath:indexPath];
    
    cell.pv.title.text = @"歌曲的名字";
    cell.pv.backView.alpha = 0;
    cell.pv.transform = CGAffineTransformIdentity;
    
    if (indexPath.row == 0 || indexPath.row == self.musicInfo.count+1) {
        
        cell.pv.title.text = indexPath.row==0 ? @"最前面了":@"最后面了";
    }else {
        
        FileInfo *item = [self.musicInfo objectAtIndex:indexPath.row - 1];
        cell.pv.title.text = [[item.fileName componentsSeparatedByString:@"."]firstObject];
    }
    
     CATransform3D _3d = CATransform3DIdentity;
    _3d.m34 = 0.005;
    
    if (indexPath.row == self.currentPlayIndex + 1) {
        
        cell.pv.backView.alpha = 1;
        _3d = CATransform3DRotate(_3d, 0, 0, 1, 0);
        _3d = CATransform3DScale(_3d, 1.5, 1.5, 1);
    }else if (indexPath.row < self.currentPlayIndex+1) {
        
         _3d = CATransform3DRotate(_3d, radian(-25), 0, 1, 0);
    }else if (indexPath.row > self.currentPlayIndex + 1) {
        
         _3d = CATransform3DRotate(_3d, radian(25), 0, 1, 0);
    }
    
    cell.pv.layer.transform = _3d;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PSLog(@"点击");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/106;
    MusicCell *cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+1 inSection:0]];
    
    CATransform3D _3DEffect = CATransform3DIdentity;
    _3DEffect.m34 = 0.005;
    
    CATransform3D _3DInstance = CATransform3DIdentity;
    
    CGFloat factor = (scrollView.contentOffset.x - self.currentPlayIndex*106)/106*0.5;
    factor = factor*100>50 ? 0.5:factor;
    
    if (index == self.currentPlayIndex && self.currentPlayIndex*106 <scrollView.contentOffset.x) {
        
        _3DInstance = CATransform3DRotate(_3DEffect, radian(-factor*50), 0, 1, 0);
        _3DInstance = CATransform3DScale(_3DInstance, 1.5-factor, 1.5-factor, 1);
        cell.pv.layer.transform = _3DInstance;
        cell.pv.backView.alpha = 1 - 2*factor;
        
        cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+2 inSection:0]];
        _3DInstance = CATransform3DRotate(_3DEffect, radian(25.-factor*50.), 0, 1, 0);
        _3DInstance = CATransform3DScale(_3DInstance, 1.0+factor, 1.0+factor, 1);
        cell.pv.layer.transform = _3DInstance;
        cell.pv.backView.alpha = factor * 2;
    }else if(index < self.currentPlayIndex){
        
        _3DInstance = CATransform3DRotate(_3DEffect, radian(-factor*50), 0, 1, 0);
        _3DInstance = CATransform3DScale(_3DInstance, 1.5-factor, 1.5-factor, 1);
        cell.pv.layer.transform = _3DInstance;
        cell.pv.backView.alpha = 1 - 2*factor;
        
        cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex-1 inSection:0]];
        _3DInstance = CATransform3DRotate(_3DEffect, radian(25.-factor*50.), 0, 1, 0);
        _3DInstance = CATransform3DScale(_3DInstance, 1.0+factor, 1.0+factor, 1);
        cell.pv.layer.transform = _3DInstance;
        cell.pv.backView.alpha = factor * 2;
    }
    
}

#pragma -mark 监听滑动事件
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    [self plaingEnd];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self plaingEnd];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     PSLog(@"减速结束");
    NSInteger index = scrollView.contentOffset.x/106;
    
    if (index != self.currentPlayIndex) {
        
        self.currentPlayIndex = index;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == 0) {
        NSInteger index = scrollView.contentOffset.x/106;
        if (index != self.currentPlayIndex) {
            
            self.currentPlayIndex = index;
            [self resetLayout];
        }
    }
}

- (void)resetLayout
{
//    [self plaingEnd];
    [self initPlayerAndPlayWithPath];
    self.musicList.contentOffset = CGPointMake(106*self.currentPlayIndex, 0);
    
    MusicCell *cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+1 inSection:0]];
    CATransform3D _3DEffect = CATransform3DIdentity;
    _3DEffect.m34 = 0.005;
    
    CATransform3D _3DInstance = CATransform3DIdentity;
    _3DInstance = CATransform3DRotate(_3DEffect, 0, 0, 1, 0);
    _3DInstance = CATransform3DScale(_3DInstance, 1.5, 1.5, 1);
    cell.pv.layer.transform = _3DInstance;
    cell.pv.backView.alpha = 1;
    
    cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+2 inSection:0]];
    _3DInstance = CATransform3DRotate(_3DEffect, radian(25), 0, 1, 0);
    _3DInstance = CATransform3DScale(_3DInstance, 1, 1, 1);
    cell.pv.layer.transform = _3DInstance;
    cell.pv.backView.alpha = 0;
    
    cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex inSection:0]];
    _3DInstance = CATransform3DRotate(_3DEffect, radian(-25), 0, 1, 0);
    _3DInstance = CATransform3DScale(_3DInstance, 1, 1, 1);
    cell.pv.layer.transform = _3DInstance;
    cell.pv.backView.alpha = 0;
}


#pragma -mark  播放控制(播放、暂停)
- (IBAction)playMusic:(id)sender
{
    PSLog(@"%d",_musicPlayer.playState);
    if (_musicPlayer.playState == NCMusicEnginePlayStatePaused) {
        [_musicPlayer resume];
        [self.playBtn setImage:@"hm_zanting".imageInstance forState:UIControlStateNormal];
        PSLog(@"恢复播放");
        
    }else {
        
        [self.playBtn setImage:@"hm_bofang".imageInstance forState:UIControlStateNormal];
        [self plaingEnd];
        [_musicPlayer pause];
         PSLog(@"暂停播放");
    }
}

#pragma -mark 展示锁屏上
-(void)showPlayingCenter:(FileInfo *)info{
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        // 标题(音乐名称)
        songInfo[MPMediaItemPropertyTitle] = info.fileName;
        // 作者
        //        songInfo[MPMediaItemPropertyArtist] = music.singer;
        
        // 专辑
                songInfo[MPMediaItemPropertyAlbumTitle] = @"云音乐";
        // 图片
        songInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"Player"]];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}

- (void)plaingEnd
{
     MusicCell *cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+1 inSection:0]];
    [cell.pv.layer removeAllAnimations];
}

- (void)plaingState
{
    
    MusicCell *cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+1 inSection:0]];
    NSString *key = @"transform.scale";
    CAAnimation *animation=[cell.pv.layer animationForKey:key];
    if (!animation) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:key];
        basicAnimation.fromValue = [NSNumber numberWithFloat:1];
        basicAnimation.toValue = [NSNumber numberWithFloat:1.8];
        basicAnimation.duration = 1.5;
        basicAnimation.repeatCount = INT32_MAX;
        basicAnimation.autoreverses = YES;
        [cell.pv.layer addAnimation:basicAnimation forKey:key];
        
        cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex inSection:0]];
        [cell.pv.layer removeAllAnimations];
        
        cell = (MusicCell *)[self.musicList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPlayIndex+2 inSection:0]];
        [cell.pv.layer removeAllAnimations];
        [self showPlayingCenter:self.musicInfo[self.currentPlayIndex]];
    }
    //transform.scale
}

#pragma -mark 上一首
- (IBAction)prevMusic:(id)sender
{
    [self plaingEnd];
    if (isRandom) {
        self.currentPlayIndex=[self randomCount:_musicInfo];
        [self resetLayout];
    }else{
        if (self.currentPlayIndex == 0) {
            if (orderType==2) {
                self.currentPlayIndex=_musicInfo.count-1;
                [self resetLayout];
            }else{
                [self showWarningToUserWithText:@"已经是第一首歌了"];
            }
        }else {
            self.currentPlayIndex--;
            [self resetLayout];
            //[self initPlayerAndPlayWithPath];
        }
    }
   
   PSLog(@"上一首");
}

#pragma mark 下一首
- (IBAction)nextMusic:(id)sender
{
    [self playNextMusic];
}

-(void)playNextMusic{
    [self plaingEnd];
    if (isRandom) {
        self.currentPlayIndex=[self randomCount:_musicInfo];
        [self resetLayout];
    }else{
        if (self.currentPlayIndex == self.musicInfo.count - 1) {
            if (orderType==2) {
                self.currentPlayIndex=0;
                [self resetLayout];
            }else{
                [self showWarningToUserWithText:@"已经是最后一首歌了"];
            }
        }else {
            self.currentPlayIndex++;
            [self resetLayout];
            //[self initPlayerAndPlayWithPath];
        }
    }
}

#pragma mark 随机播放
- (IBAction)randomMode:(id)sender
{
    isRandom=!isRandom;
    [self showImgSuijiBool:isRandom animate:YES];
}

-(void)exitCurrentController{
    PSLog(@"exit...");
}

-(void)showImgSuijiBool:(BOOL)isShow animate:(BOOL)animate{
    if (isShow) {
        _imgSuiji.image=[UIImage imageNamed:@"hm_suiji02"];
        if (animate) {
            [self showWarningToUserWithText:@"随机播放"];
        }
    }else{
//        _imgSuiji.image=[UIImage imageNamed:@"hm_suiji"];
        _imgSuiji.image=[UIImage imageNamed:@"hm_xunhuan"];
        if (animate) {
          [self showWarningToUserWithText:@"顺序播放"];
        }
    }
}

-(NSInteger)randomCount:(NSArray *)array{
    int count=arc4random()%array.count;
    return count==0?1:(count==array.count-1?count-2:count);
}

#pragma mark 顺序播放
- (IBAction)orderMode:(id)sender
{
    orderType=(orderType==3?1:orderType+1);
    [self showOrderType:orderType];
}

-(void)showOrderType:(int)type{
    switch (type) {
        case 1:
//            [self showWarningToUserWithText:@"顺序播放"];
            _imgXunh.image=[UIImage imageNamed:@"hm_xunhuan"];
            break;
        case 2:
//            [self showWarningToUserWithText:@"循环播放"];
            _imgXunh.image=[UIImage imageNamed:@"hm_xunhuan03"];
            break;
        case 3:
//            [self showWarningToUserWithText:@"单曲播放"];
            _imgXunh.image=[UIImage imageNamed:@"hm_xunhuan02"];
            break;
    }
}


- (IBAction)exitPlayer:(id)sender
{
    [defaults setBool:isRandom forKey:RANDOM];
    [defaults setInteger:orderType forKey:ORDERTYPE];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showWarningToUserWithText:(NSString *)text
{
    if (_statusTip) {
        
        _statusTip = nil;
    }
    _statusTip = [[MBProgressHUD alloc] initWithView:self.view];
    _statusTip.labelText = text;
    _statusTip.removeFromSuperViewOnHide = YES;
    _statusTip.mode = MBProgressHUDModeText;
    [self.view addSubview:_statusTip];
    [_statusTip showAnimated:YES whileExecutingBlock:^{
        
        sleep(1.5);
    }];
}


- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress
{
    NSTimeInterval time = [engine playerItemDuration] *progress;
    if ((NSInteger)time > (NSInteger)[self convertNSTimeInterval:self.currentTime.text]) {
        _playProgressBar.value=time;
        self.currentTime.text = [self convertFormatter:time];
        [self plaingState];
        [self playEngine:engine];
        if ([engine playerItemDuration]<=_playProgressBar.value+2) {
            PSLog(@"play state end...%g,%g",[engine playerItemDuration],_playProgressBar.value);
            if (orderType==3) {
                [self resetLayout];
            }else{
                [self playNextMusic];
            }
        }
    }
}

- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState
{
    [self playEngine:engine];
     PSLog(@"play state end...%g,%g",[engine playerItemDuration],_playProgressBar.value);
    if (playState == NCMusicEnginePlayStatePaused&&([engine playerItemDuration]<=_playProgressBar.value+2)) {
        PSLog(@"play state end...%g,%g",[engine playerItemDuration],_playProgressBar.value);
        if (orderType==3) {
            [self resetLayout];
        }else{
            [self playNextMusic];
        }
    }
 
}

-(void)playEngine:(NCMusicEngine *)engine{
    if (_restart && [engine playerItemDuration]>0) {
        [self.playBtn setImage:@"hm_zanting".imageInstance forState:UIControlStateNormal];
        self.totalTime.text = [self convertFormatter:[engine playerItemDuration]];
        _playProgressBar.maximumValue=[engine playerItemDuration];
        _restart = NO;
    }

}

- (NSString *)convertFormatter:(NSTimeInterval)time
{
    NSInteger second = time/60;
    NSInteger s = (NSInteger)time%60;
    PSLog(@"play %.2d:%.2d",second,s);
    return [NSString stringWithFormat:@"%.2d:%.2d",second,s];
}

- (NSTimeInterval)convertNSTimeInterval:(NSString *)text
{
    NSArray *array = [text componentsSeparatedByString:@":"];
    return [[array objectAtIndex:0] doubleValue]*60 + [[array lastObject] doubleValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_musicPlayer stop];
    _musicPlayer = nil;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
