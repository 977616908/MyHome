//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import "REPhoto.h"
#import <AVFoundation/AVFoundation.h>
//#define kPadding 10
#define kPadding 0
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)
#define BARHEIHGT 44

@interface MJPhotoBrowser () <MJPhotoViewDelegate, MJPhotoToolbarDelegate,SDWebImageManagerDelegate>
{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    NSMutableArray * _removePhoto;
    // 工具条
    MJPhotoToolbar * _toolbar;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    SDWebImageManager *manager;
    NSInteger downCount;
    NSInteger moveLeng;
    MBProgressHUD           *stateView;
    NSString                *pathArchtive;
    ALAssetsLibrary         *library;
    AVPlayer *_player;
    AVPlayerLayer *playerLayer;
}

@property(nonatomic,weak)CCView *navTopView;

@end

@implementation MJPhotoBrowser

#pragma mark - Lifecycle
//- (void)loadView
//{
//    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
//    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    self.view = [[UIView alloc] init];
//    self.view.frame = [UIScreen mainScreen].bounds;
//	self.view.backgroundColor = [UIColor whiteColor];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view = [[UIView alloc] init];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view.frame=CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    [self.view setBackgroundColor:[UIColor whiteColor]];
    manager=[SDWebImageManager sharedManager];
    manager.delegate=self;
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    library=[[ALAssetsLibrary alloc]init];
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
    // 3.创建导航栏
    [self createCoustomNav];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}


#pragma mark 创建工具条
- (void)createToolbar
{
    //    CGFloat barHeight = 0;
    CGFloat barY = CGRectGetHeight(self.view.frame) - BARHEIHGT;
    _toolbar = [[MJPhotoToolbar alloc] init];
    if (self.photos==PhotoShowNone) {
        _toolbar.isPhoto=YES;
    }else{
        _toolbar.isPhoto=NO;
    }

    //    _toolbar.backgroundColor=[UIColor grayColor];
    _toolbar.backgroundColor=RGBCommon(63, 205, 225);
    _toolbar.Delegate = self;
    _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), BARHEIHGT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    
    [self updateTollbarState];
}


- (void)createCoustomNav
{
    _statusBarHiddenInited = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationNone];
    CGFloat gh=0;
    NSString *backImage = @"hm_bg00_iOS6";
    if (is_iOS7()) {
        gh=20;
        backImage = @"hm_bg00";
    }
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44+gh) backgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backImage]]]; // RGBCommon(73, 170, 231)
//    [navTopView addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(10, 11.75+gh, 9, 16))];
    NSString *prasentTitle  = @" 返回";
    CCButton *btnBack = CCButtonCreateWithValue(CGRectMake(10, gh, 60,44), @selector(exitCurrentController), self);
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btnBack setImage:[UIImage imageNamed:@"ht_return"] forState:UIControlStateNormal];
    [btnBack alterNormalTitle:prasentTitle];
    [btnBack alterNormalTitleColor:RGBWhiteColor()];
    [btnBack alterFontSize:18];
    
    [navTopView addSubview:btnBack];
    
    CCLabel *_labTitle = CCLabelCreateWithNewValue(@"图片预览", 20, CGRectMake(CGRectGetWidth(self.view.frame)/2-40, gh, 80, 44));
    _labTitle.textColor = RGBWhiteColor();
    _labTitle.backgroundColor = RGBClearColor();
    [navTopView addSubview:_labTitle];
    
    [self.view addSubview:navTopView];
    self.navTopView=navTopView;
}

- (void)exitCurrentController
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.type = kCATransitionFade;//101
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    if (![self.navigationController popViewControllerAnimated:NO]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

#pragma mark 删除图片
-(void)DeleteThisImage:(NSInteger)ThisImageIndex
{
    
    
    PSLog(@"ThisImageIndex---%d", ThisImageIndex );
    PSLog(@"_currentPhotoIndex---%d", _currentPhotoIndex );
    
    if ( ThisImageIndex == 0 ) {
        _currentPhotoIndex = 1;
    }else if ( ThisImageIndex == _currentPhotoIndex ) {
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }else{
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }
//    if(_isPhoto){
//    }else{
//        [self deleteWithPhoto:_photos[ThisImageIndex]];
//        [self deletePhoto:_removePhoto[ThisImageIndex]];
//    }
    if (self.photoType==PhotoShowRouter) {
        [self deleteWithPhoto:_photos[ThisImageIndex]];
    }else if(self.photoType==PhotoShowCamera){
        [self deletePhoto:_removePhoto[ThisImageIndex]];
    }else{
        MJPhoto *photo=_photos[ThisImageIndex];
        [library assetForURL:photo.url resultBlock:^(ALAsset *asset)
                   {
                       //在这里使用asset来获取图片
                       if(asset.isEditable) {
                           //再删除这张图片，如果不执行这行代码，在你的默认相册里面会多一张照片出来
                           [asset setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                               PSLog(@"Asset url %@ should be deleted. (Error %@)", assetURL, error);
                           }];
                       }
                   }
                          failureBlock:^(NSError *error)
                   {}];
    }
    [_photos removeObjectAtIndex: ThisImageIndex];
    [self setCurrentPhotoIndex: _currentPhotoIndex ];
    if ([self.pifiiDelegate respondsToSelector:@selector(removeViewDataSources:)]) {
        [_removePhoto removeObjectAtIndex:ThisImageIndex];
        [self.pifiiDelegate removeViewDataSources:_removePhoto];
        if (_removePhoto.count==0) {
            [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:0.2];
        }
    }

}

-(void)deleteWithPhoto:(MJPhoto *)photo{
    NSDictionary *param=@{@"path":photo.path,@"root":@"syncbox"};
    [self initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:@"delete" autoRequest:YES];
    
}

-(void)deletePhoto:(REPhoto *)photo{
    NSDictionary *param=@{
                          @"resId":photo.imageName,
                          @"timeId":photo.routingId};
    [self initPostWithURL:MyHomeURL path:@"deleteFiles" paras:param mark:@"delete" autoRequest:YES];
}

#pragma -mark 备份图片
-(void)UpLoadThisImage:(NSInteger)ThisImageIndex{
    PSLog(@"--%d--",ThisImageIndex);
    if(![self setMacBounds])return;
    
    MJPhoto *photo=_photos[ThisImageIndex];
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.removeFromSuperViewOnHide=NO;
    stateView.hidden=NO;
    stateView.labelText=[NSString stringWithFormat:@"正在备份...请稍候!"];
    if (!photo.isVedio) {
        [self uploadWithImage:photo.image Vedio:nil Photo:photo];
    }else{
        [library assetForURL:photo.url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            PSLog(@"[%lld]",rep.size);
            const int bufferSize = 1024 * 1024;
            Byte *buffer=(Byte *)malloc(bufferSize);
            NSUInteger read=0,offSet=0;
            NSError *error=nil;
            NSMutableData *data=[NSMutableData data];
            if (rep.size!=0) {
                do {
                    read = [rep getBytes:buffer fromOffset:offSet length:bufferSize error:&error];
                    [data appendBytes:buffer length:read];
                    offSet += read;
                } while (read!=0&&!error);
            }
            
            // 释放缓冲区，关闭文件
            free(buffer);
            buffer = NULL;
            if (is_iOS7()) {
                [self uploadWithVedio:data Photo:photo];
            }else{
                [self uploadWithImage:nil Vedio:data Photo:photo];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
}

-(void)uploadWithImage:(UIImage *)image Vedio:(NSData *)data Photo:(MJPhoto *)photo{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"overwrite"] = @"false";
    params[@"token"] = [GlobalShare getToken];
    NSString *url=ROUTER_FILE_UPDOWN;
    if(photo.isVedio){
        url=ROUTER_FILE_UPVEDIO;
    }
    // 3.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 在发送请求之前调用这个block
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.name mimeType:@"image/jpeg"];
            }
        }else{
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.name mimeType:@"video/mp4"];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PSLog(@"--%@--",responseObject);
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
        NSMutableOrderedSet *orderSet=[NSMutableOrderedSet orderedSetWithArray:array];
        [orderSet addObject:photo.name];
        [NSKeyedArchiver archiveRootObject:orderSet.array toFile:pathArchtive];
        stateView.labelText=@"备份成功";
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSLog(@"--%@--",error);
        stateView.labelText=@"备份失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }];
}

#pragma -mark 备份视频
-(void)uploadWithVedio:(NSData *)data Photo:(MJPhoto *)photo{
    NSString *url=ROUTER_FILE_UPVEDIO;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:photo.name mimeType:@"video/mp4"];
    } error:nil];
    AFURLSessionManager *managers = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [managers uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            PSLog(@"Error: %@", error);
            stateView.labelText=@"备份失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        } else {
            NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
            NSMutableOrderedSet *orderSet=[NSMutableOrderedSet orderedSetWithArray:array];
            [orderSet addObject:photo.name];
            [NSKeyedArchiver archiveRootObject:orderSet.array toFile:pathArchtive];
            stateView.labelText=@"备份成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            PSLog(@"%@ %@--[%@]", response, responseObject,progress);
        }
    }];
    [progress addObserver:self
               forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
    [uploadTask resume];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSProgress *progress = object;
        CGFloat fraction= progress.fractionCompleted;
        NSString *localized=progress.localizedDescription;
        NSString *additional=progress.localizedAdditionalDescription;
        int progressDuration=fraction*100;
        stateView.labelText=[NSString stringWithFormat:@"正在备份...(%d%%)",progressDuration];
//        if (progressDuration>=100) {
//            [progress removeObserver:self forKeyPath:keyPath context:context];
//        }
        PSLog(@"[%f]--[%@]--[%@]",fraction,localized,additional);
    }];
}

#pragma -mark 下载图片
-(void)DownThisImage:(NSInteger)ThisImageIndex{
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    stateView.labelText=[NSString stringWithFormat:@"正在下载...请稍候!"];
    MJPhoto *photo = _photos[ThisImageIndex];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data=[NSData dataWithContentsOfURL:photo.url];
        //        UIImage *img=[UIImage imageWithData:data];
        if (data) {
            //            [library writeImageDataToSavedPhotosAlbum:data metadata:@{} completionBlock:^(NSURL *assetURL, NSError *error) {
            //                [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:error waitUntilDone:NO];
            //            }];
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }else{
            if (photo.image) {
                //                [library writeImageToSavedPhotosAlbum:photo.image.CGImage metadata:@{} completionBlock:^(NSURL *assetURL, NSError *error) {
                //                    [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:error waitUntilDone:NO];
                //                }];
                UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }else{
                [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:[[NSError alloc]init] waitUntilDone:NO];
            }
            
        }
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        stateView.labelText=@"下载成功";
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    });
}

- (void)imageSavingWithError:(NSError *)error
{
    if (error) {
        stateView.labelText=@"下载失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    } else {
        stateView.labelText=@"下载成功";
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }
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
        
    }];
}
#pragma -mark 网络处理
-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"response:%@",response);
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    if(is_iOS7())frame.origin.y=-20;
    //    frame.size.height=CGRectGetHeight(frame)-44;
    
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
    //    if (_currentPhotoIndex == 0) {
    [self showPhotos:NO];
    downCount=_currentPhotoIndex;
    moveLeng=0;
    //    [self loadImageNearIndex:downCount];
    //    }
}

- (void)setPhotos:(NSMutableArray *)photos
{
    //    _photos = photos;
    NSMutableArray *arr=[NSMutableArray array];
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<photos.count; i++) {
        REPhoto *rePhoto=photos[i];
        MJPhoto *photo = [[MJPhoto alloc]init];
        photo.index = i;
        photo.path=rePhoto.imageUrl;
        if (self.photoType==PhotoShowNone) {
            photo.isVedio=rePhoto.isVedio;
            photo.url=[NSURL URLWithString:rePhoto.imageUrl];
            photo.name=rePhoto.imageName;
            photo.save=rePhoto.isBackup;
        }else{
            if ([rePhoto.imageUrl hasPrefix:@"http://"]) {
                photo.url=rePhoto.imageUrl.encodedString.urlInstance;
            }else{
                photo.url=ROUTER_FILE_WHOLEDOWNLOAD(rePhoto.imageUrl).encodedString.urlInstance;
            }
            
        }
        photo.firstShow = i == _currentPhotoIndex;
        [arr addObject:photo];
    }
    _removePhoto=[NSMutableArray arrayWithArray:photos];
    _photos=arr;
}


#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * _photos.count, 0);
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos:NO];
    }
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
//}
//
//-(BOOL)prefersStatusBarHidden{
//    return _statusBarHiddenInited;
//}


#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    _statusBarHiddenInited=!_statusBarHiddenInited;
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationNone];
    CGFloat gh=0;
    if (!is_iOS7()) {
        gh=20;
    }else{
        if (_statusBarHiddenInited) {
            _photoScrollView.frame=CGRectMake(0, 0, CGRectGetWidth(_photoScrollView.frame), CGRectGetHeight(_photoScrollView.frame));
        }else{
            _photoScrollView.frame=CGRectMake(0, -20, CGRectGetWidth(_photoScrollView.frame), CGRectGetHeight(_photoScrollView.frame));
        }
        //        [self prefersStatusBarHidden];
        //        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    PSLog(@"--palyer[%d]--%d",photoView.isPlay,photoView.photo.isVedio);
    if(photoView.photo.isVedio)[self playVedio:photoView];
//    MJPhoto *photo=photoView.photo;
//    _player=[AVPlayer playerWithURL:photo.url];
//    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//    playerLayer.frame=_photoScrollView.frame;
//    [photoView.layer addSublayer:playerLayer];
//    [_player play];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.bounds;
        if (_statusBarHiddenInited) {
            [self.view setBackgroundColor:[UIColor blackColor]];
            frame.size.height=CGRectGetHeight(frame);
            self.navTopView.frame=CGRectMake(0, -CGRectGetHeight(self.navTopView.frame)-gh, CGRectGetWidth(frame), CGRectGetHeight(self.navTopView.frame));
        }else{
            [self.view setBackgroundColor:[UIColor whiteColor]];
            frame.size.height=CGRectGetHeight(frame)-BARHEIHGT;
            self.navTopView.frame=CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(self.navTopView.frame));
        }
        _toolbar.frame=CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), BARHEIHGT);
    }];
    
}


- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
    [self loadImageNearIndex:downCount];
}

#pragma -mark 播放视频
-(void)playVedio:(MJPhotoView *)photoView{
    if (photoView.isPlay) {
        MJPhoto *photo=photoView.photo;
        if (_player) {
            [_player pause];
            [playerLayer removeFromSuperlayer];
            _player=nil;
        }
        _player=[AVPlayer playerWithURL:photo.url];
        playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//        playerLayer.frame=_photoScrollView.frame;
        playerLayer.frame=[[UIScreen mainScreen]bounds];
//        playerLayer.frame=CGRectMake(0, CGRectGetMinY(_photoScrollView.frame), CGRectGetWidth(photoView.frame), CGRectGetHeight(photoView.frame));
        if (_photos.count==1) {
            [_photoScrollView.layer addSublayer:playerLayer];
        }else{
            [photoView.layer addSublayer:playerLayer];
        }
        [_player play];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }else{
        if (_player&&_photos.count==1) {
            [_player pause];
            [playerLayer removeFromSuperlayer];
            _player=nil;
        }
    }
}

-(void)moviePlayDidEnd:(NSNotification *)not{
    if (_player) {
        [_player pause];
        [playerLayer removeFromSuperlayer];
        _player=nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark 显示照片
- (void)showPhotos:(BOOL)isFast
{
    int photoCount = (int)_photos.count;
    // 只有一张图片
    if (photoCount == 1) {
        [self showPhotoViewAtIndex:0 fast:NO];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= photoCount) firstIndex = photoCount - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= photoCount) lastIndex = photoCount - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }

    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    if (isFast) {
        for (int index = firstIndex; index <= lastIndex; index++) {
            if (![self isShowingPhotoViewAtIndex:index]) {
                [self showPhotoViewAtIndex:index fast:isFast];
            }
        }
    }else{
        if (firstIndex==lastIndex) {
            for (MJPhotoView *photoView in _visiblePhotoViews) {
                if (kPhotoViewIndex(photoView) == firstIndex) {
                    [photoView removeFromSuperview];
                }
            }
            [self showPhotoViewAtIndex:firstIndex fast:isFast];
        }
    }
    
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index fast:(BOOL)isFast
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        if (self.photoType==PhotoShowNone) {
             photoView.isPhotoImg=YES;
        }else{
             photoView.isPhotoImg=NO;
        }
       
        photoView.photoViewDelegate = self;
//        btnPlayer=CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(_photoScrollView.frame)/2-35, CGRectGetHeight(_photoScrollView.frame)/2-35, 70, 70), @selector(playVedio), self);
//        btnPlayer=CCButtonCreateWithValue(CGRectMake(0, 0, 70, 70), @selector(playVedio), self);
//        btnPlayer.center=photoView.center;
//        [btnPlayer alterNormalBackgroundImage:@"hm_bofansp"];
//        [photoView addSubview:btnPlayer];
    }
    if (_photos.count<=0)return;
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    photoView.frame = photoViewFrame;
    MJPhoto *photo = _photos[index];
    photo.isFast=isFast;
    photoView.photo = photo;
    [_visiblePhotoViews addObject:photoView];
    PSLog(@"----[%d]",photo.isVedio);
    [_photoScrollView addSubview:photoView];
    downCount=index;
    //    [self loadImageNearIndex:index];
}


#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (index > 0) {
            MJPhoto *photo = _photos[index - 1];
            [self downImageWithUrl:photo];
        }
        if (index < _photos.count - 1) {
            MJPhoto *photo = _photos[index + 1];
            [self downImageWithUrl:photo];
        }
    });
}


-(void)downImageWithUrl:(MJPhoto *)photo{
    if (photo.image)return;
    NSURL *url=photo.url;
    if (self.photoType==PhotoShowNone) {
        [library assetForURL:url resultBlock:^(ALAsset *asset)
         {
             //在这里使用asset来获取图片
             UIImage *image = [[UIImage alloc]initWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
             if (image) {
                 photo.image=image;
             }
         }
                failureBlock:^(NSError *error)
         {}];
    }else{
        if (![manager diskImageExistsForURL:url]) {
            PSLog(@"---downImageWithUrl--");
            NSData *data=[NSData dataWithContentsOfURL:url];
            UIImage *img=[UIImage imageWithData:data];
            if (img) {
                photo.image=img;
                CGFloat count=1;
                if (img.size.width>640) {
                    count=img.size.width/640;
                }
                CGFloat wh=img.size.width/count;
                CGFloat hg=img.size.height/count;
                [manager downloadWithURL:url options:0 width:wh height:hg progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    
                }];
            }
            
        }
    }
    
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat moveX=_photoScrollView.contentOffset.x-moveLeng;
    //    int move=floor(moveX/CGRectGetWidth(_photoScrollView.frame) +1);
    //    BOOL isFast=YES;
    //    if((move<=2&&move>=-1)||downCount==0){
    //        //        PSLog(@"==%d===%d",downCount,move);
    //        isFast=NO;
    //    }
    if ((moveX<=-10||moveX>=10)&&_player) {
        [_player pause];
        [playerLayer removeFromSuperlayer];
        _player=nil;
    }
    if (_photos.count>1) {
        [self showPhotos:YES];
        [self updateTollbarState];
    }

    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    moveLeng = _photoScrollView.contentOffset.x;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    PSLog(@"--scrollViewDidEndDecelerating--");
    if (moveLeng!=_photoScrollView.contentOffset.x) {
        [self showPhotos:NO];
        moveLeng=_photoScrollView.contentOffset.x;
    }
    //    moveLeng = _photoScrollView.contentOffset.x;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}


-(UIImage*)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL width:(NSInteger)w height:(NSInteger)h {
    //缩放图片
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,w, h)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_visiblePhotoViews removeAllObjects];
    [_reusablePhotoViews removeAllObjects];
    for (REPhoto *photo in _photos) {
        photo.image=nil;
    }
    [[SDImageCache sharedImageCache] clearDisk];
}

-(void)dealloc{
    [_visiblePhotoViews removeAllObjects];
    [_reusablePhotoViews removeAllObjects];
    for (REPhoto *photo in _photos) {
        photo.image=nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end