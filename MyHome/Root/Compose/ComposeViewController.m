//
//  ComposeViewController.m
//  MyHome
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ComposeViewController.h"
#import "CCTextView.h"
#import "PhotosView.h"
#import "REPhoto.h"
#import "PhotoSelectController.h"
#import "PiFiiBaseNavigationController.h"
#import "MJPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "RoutingDown.h"
#define HEIGHT 150

@interface ComposeViewController ()<UITextViewDelegate,PhotosViewDelegate,PiFiiBaseViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray  *_photoArr;
    MBProgressHUD           *stateView;
    NSString *pathArchtive;
    NSMutableOrderedSet     *_saveSet;
    NSMutableDictionary *params;
    NSInteger downCount;
    NSString *resultPath;
}

@property(nonatomic,weak)CCTextView *textView;
@property(nonatomic,weak)PhotosView *photosView;
@property(nonatomic,weak)CCScrollView *rootScrollView;
@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _photoArr=[NSMutableArray array];
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTextView];
    [self createPhotosView];
    if (self.type==ComposeCamera) {
        [self pushData];
    }
    if (_arrPhoto) {
        [self addImage:_arrPhoto];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void)pushData{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
//                    photo.image = [UIImage imageWithCGImage:result.aspectRatioThumbnail];//高清
                    NSString *fileName=[[result defaultRepresentation]filename];
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    [datasource addObject:photo];
                }
            }];
        } else {
            [datasource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                REPhoto *item1=(REPhoto *)obj1;
                REPhoto *item2=(REPhoto *)obj2;
                return [item2.photoDate compare:item1.photoDate];
            }];
           [self addImage:datasource[0]];
        }
    } failureBlock:^(NSError *error) {
        
    }];

}

-(void)coustomNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"时光发送";
}

-(void)createTextView{
    // 1.添加
    CCTextView *textView = [[CCTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor=RGBCommon(72, 72, 72);
    textView.placeholderColor=RGBCommon(181, 181, 181);
    
    textView.frame = CGRectMake(7, 0, CGRectGetWidth(self.view.frame)-15, HEIGHT);
//    textView.textContainerInset=UIEdgeInsetsMake(15, 10, 0, 10);
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"这一刻的想法...";
    [self.view addSubview:textView];
    self.textView = textView;
}

-(void)createPhotosView{
    CCScrollView *scrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-HEIGHT), self, NO);
    scrollView.bounces=YES;
    self.rootScrollView=scrollView;
    [self.view addSubview:scrollView];
    
    PhotosView *photosView = [[PhotosView alloc] init];
    photosView.frame = CGRectMake(0, 0, CGRectGetWidth(self.rootScrollView.frame), CGRectGetHeight(self.rootScrollView.frame));
    self.photosView = photosView;
    photosView.delegate=self;
    [self.rootScrollView addSubview:photosView];

    
//    [photosView addImage:[UIImage imageNamed:@"hm_zengjjiad"]];
    
}

-(void)onAddTap:(id)sendar{
    PSLog(@"--add--");
    
}

-(void)photosTapWithIndex:(NSInteger)index{
    PSLog(@"--add--[%d]",index);
    if(index==-1){
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
        [action showInView:self.view];
//        [self openLibaray];
    }else{
        MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
        photo.currentPhotoIndex=index-1;
        photo.photos=_photoArr;
        photo.pifiiDelegate=self;
        [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO]  forKey:@"animation"];
        [self.navigationController pushViewController:photo animated:NO];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://未知
            //拍照
            [self openCamera];
            break;
        case 1://男
            [self openLibaray];
            break;
    }
}


#pragma -mark 打开相机
- (void)openCamera {
    UIImagePickerController *imagePicker =  [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.showsCameraControls = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 2.去的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        PSLog(@"%@",[error description]);
    }else{
        [self pushData];
    }
}

-(void)pushViewDataSource:(id)dataSource{
    [self addImage:dataSource];
}

-(void)removeViewDataSources:(id)dataSource{
    _photoArr=[NSMutableArray array];
    for (UIImageView *image in self.photosView.totalImages) {
        [image removeFromSuperview];
    }
    [self addImage:dataSource];
}

-(void)addImage:(id)dataSource{
    if ([dataSource isKindOfClass:[NSArray class]]) {
        for (REPhoto *photo in dataSource) {
            [self.photosView addImage:photo.image duration:photo.duration];
            [_photoArr addObject:photo];
        }
    }else{
        REPhoto *photo=dataSource;
        [self.photosView addImage:photo.image duration:photo.duration];
        [_photoArr addObject:photo];
    }
    CGFloat gh=self.photosView.subviews.count/4*80+HEIGHT;
    self.photosView.size=CGSizeMake(CGRectGetWidth(self.rootScrollView.frame), gh);
    self.rootScrollView.contentSize=CGSizeMake(0, gh);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
    
}

/*
 * 打开相册
 */
-(void)openLibaray{
    PhotoSelectController *photoController=[[PhotoSelectController alloc]init];
    photoController.pifiiDelegate=self;
    //    [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionPush upDown:YES] forKey:@"animation"];
    //    [self.navigationController pushViewController:photoController animated:NO];
    PiFiiBaseNavigationController *nav=[[PiFiiBaseNavigationController alloc]initWithRootViewController:photoController];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self exitCurrentController];
}

/**
 *  分享
 */
- (void)send
{
    [self.view endEditing:YES];
    if(!stateView){
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    stateView.labelText=@"正在分享...";
    downCount=_photoArr.count;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    params = [NSMutableDictionary dictionary];
    params[@"username"] = userPhone;
    params[@"title"]=_textView.text;
    //    params[@"date"]=@"2015-5-28";
    //    params[@"date"]=@"20150529150816";
    params[@"date"]=[self getDate];
//    params[@"totalCount"]=@(downCount);
    RoutingDown *down=[[RoutingDown alloc]init];
    down.params=params;
    down.downList=_photoArr;
    
    [self.pifiiDelegate pushViewDataSource:down];
  
    [self uploadWithPhoto:_photoArr[0]];
    [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.2];
   
}


-(void)uploadWithPhoto:(REPhoto *)photo{
    if (photo.isVedio) {
        [self convertVedio:[photo.imageUrl urlInstance] block:^(AVAssetExportSession * session) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    break;
                    
                default:
                    break;
            }
            CGFloat length=[self getFileSize:resultPath];
            if (length>0) {
                [self uploadVedio:[NSData dataWithContentsOfFile:resultPath] photo:photo];
            }
            NSLog(@"%@:%f",resultPath,length);
            
        }];
//        [library assetForURL:[NSURL URLWithString:photo.imageUrl] resultBlock:^(ALAsset *asset)
//         {
//             //在这里上传视频
//             ALAssetRepresentation *rep = [asset defaultRepresentation];
//             PSLog(@"[%lld]",rep.size);
//             const int bufferSize = 1024 * 1024;
//             Byte *buffer=(Byte *)malloc(bufferSize);
//             NSUInteger read=0,offSet=0;
//             NSError *error=nil;
//             NSMutableData *data=[NSMutableData data];
//             if (rep.size!=0) {
//                 do {
//                     read = [rep getBytes:buffer fromOffset:offSet length:bufferSize error:&error];
//                     [data appendBytes:buffer length:read];
//                     offSet += read;
//                 } while (read!=0&&!error);
//             }
//             
//             // 释放缓冲区，关闭文件
//             free(buffer);
//             buffer = NULL;
//             [self uploadVedio:data photo:photo];
//
//         }
//                failureBlock:^(NSError *error)
//         {}];

    }else{
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[NSURL URLWithString:photo.imageUrl] resultBlock:^(ALAsset *asset)
         {
             UIImage *image;
             //在这里使用asset来获取图片
             if ([GlobalShare isHDPicture]) {//高清图片
                 image=[[UIImage alloc]initWithCGImage:[[asset defaultRepresentation]fullResolutionImage]];
             }else{
                 image = [[UIImage alloc]initWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
             }
             [self uploadVedio:UIImageJPEGRepresentation(image, 1) photo:photo];
         }
                failureBlock:^(NSError *error)
         {}];

    }

}

#pragma mark 视频压缩
-(void)convertVedio:(NSURL *)path block:(void (^)(AVAssetExportSession*))handler{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:path options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [self getDate]];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             handler(exportSession);
         }];
    }
}

- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

#pragma -mark 备份视频
-(void)uploadVedio:(NSData *)data photo:(REPhoto *)photo{
    NSString *url=[NSString stringWithFormat:@"%@/uploadFiles",MyHomeURL];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (data) {
            if (photo.isVedio) {
                [formData appendPartWithFileData:data name:@"files" fileName:photo.imageName mimeType:@"video/mp4"];
                [[NSFileManager defaultManager]removeItemAtPath:resultPath error:nil];
            }else{
                 [formData appendPartWithFileData:data name:@"files" fileName:photo.imageName mimeType:@"image/jpeg"];
            }
        }
        
    } error:nil];
    AFURLSessionManager *managers = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [managers uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(progress)[progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
        if (error) {
            PSLog(@"Error: %@", error);
            [PSNotificationCenter postNotificationName:@"UPDATE" object:nil userInfo:params];
        } else {
            photo.isBackup=YES;
            [_saveSet addObject:photo.imageName];
            [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:pathArchtive];
            [_photoArr removeObject:photo];
            if (_photoArr.count>0) {
                [self uploadWithPhoto:_photoArr[0]];
            }else{
                PSLog(@"下载完成:%@",params);
               [PSNotificationCenter postNotificationName:@"UPDATE" object:nil userInfo:params];
            }
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
        NSDictionary *param=@{@"count":@(_photoArr.count),
                              @"totalCount":@(downCount),
                              @"progress":@(fraction*100),
                              @"date":params[@"date"]};
        [PSNotificationCenter postNotificationName:@"DOWNPROGRESS" object:nil userInfo:param];
//        PSLog(@"[%f]--[%@]--[%@]",fraction,localized,additional);
    }];
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
        // 关闭控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(NSString *)getDate{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    [sdf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [sdf stringFromDate:[NSDate date]];
}


-(CATransition *)customAnimationType:(NSString *)type upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.type = type;//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromTop;
    }else{
        animation.subtype = kCATransitionFromBottom;
    }
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    return animation;
}


-(void)exitCurrentController{
    [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionPush upDown:NO] forKey:@"animation"];
    if (![self.navigationController popViewControllerAnimated:NO]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


@end
