//
//  ImageAndDocumentViewController.m
//  MyHome
//
//  Created by Harvey on 14-7-31.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "VedioViewController.h"
#import "MusicPlayViewController.h"
#import "VideoPlayerViewController.h"
#import "ImageAndDocumentCell.h"
#import "REPhotoController.h"
#import "MJRefresh.h"
#import "FileInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "REPhotoController.h"
#import "REPhoto.h"
#import "AFDownloadRequestOperation.h"

#define VEDIOSUB    @[@"mp4",@"3gp",@"mov",@"m4v"]

#define BARHEIGHT 44
typedef enum{
    CLICKVISIT=0x01,
    CLICKDOWN,
    CLICKDELETE
}CLICKTYPE;
@interface VedioViewController () <MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray *_arrTag;
    NSMutableArray *files;
    NSMutableArray *refreshArr;
    NSMutableOrderedSet *arrAddress;
    NSString *pathArchive;
    NSString *saveArchtive;
    NSString *savePath;
    NSInteger downCount;
 
    UIView *_toolbar;
    NSMutableOrderedSet *_saveSet;
    NSMutableOrderedSet *_selectSet;
    
    BOOL          isAdd;
    BOOL          isRefresh;
    BOOL          isSelect;
    
    AFDownloadRequestOperation *downOperation;
}
@property(nonatomic,strong)MBProgressHUD *stateView;
@property(nonatomic,weak)MJRefreshHeaderView *header;
@property (nonatomic,weak)UITableView *rootTableView;
@property(nonatomic,assign)CLICKTYPE type;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@end

@implementation VedioViewController

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
    self.navigationItem.title =@"云视频";
    _saveSet=[NSMutableOrderedSet orderedSet];
    _selectSet=[NSMutableOrderedSet orderedSet];
    files = [NSMutableArray array];
    saveArchtive=pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    savePath=[NSString stringWithFormat:@"%@/Library/Caches/",NSHomeDirectory()];
    CGFloat hg=[[UIScreen mainScreen]bounds].size.height-64;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), hg)];
    tableView.dataSource=self;
    tableView.delegate=self;
    _rootTableView=tableView;
    [self.view addSubview:tableView];
    [self createNav];
    [self setupRefreshView];
    MBProgressHUD *stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.hidden=YES;
    _stateView=stateView;
    [self  getRequest];
}

#pragma -mark 工具条
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
    _arrTag=@[visitBtn,downBtn,deleteBtn];
    [self.view addSubview:_toolbar];
    
    
}

-(void)onSelectListener:(CCButton *)sendar{
    [_selectSet removeAllObjects];
    if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
        isSelect=YES;
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        [self setSelectStatue];
    }else{
        isSelect=NO;
        [sendar alterNormalTitle:@"选择"];
        [self toolBarWithAnimation:YES];
        self.title=@"云视频";
    }
    [_rootTableView reloadData];
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

#pragma -mark 选中的状态
-(void)setSelectStatue{
    UIButton *btn01=(UIButton *)_arrTag[0] ;
    UIButton *btn02=(UIButton *)_arrTag[1] ;
    UIButton *btn03=(UIButton *)_arrTag[2] ;
    if (_selectSet.count>0) {
        self.title=[NSString stringWithFormat:@"已选择%d项",_selectSet.count];
        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan_selector"] forState:UIControlStateNormal];
        [btn02 setImage:[UIImage imageNamed:@"hm_baocun"] forState:UIControlStateNormal];
        [btn03 setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
        btn01.enabled=NO;
        btn02.enabled=YES;
        btn03.enabled=YES;
    }else{
        self.title=@"选择项目";
        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
        [btn02 setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
        [btn03 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
        btn01.enabled=YES;
        btn02.enabled=NO;
        btn03.enabled=NO;
    }
}

-(void)onClick:(UIButton *)sendar{
    UIActionSheet *action=nil;
    switch (sendar.tag) {
        case 1:
            _type=CLICKVISIT;
            action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"录频" otherButtonTitles:@"从手机录频中选择", nil];
            [action showInView:self.view];
            break;
        case 2:
            _type=CLICKDOWN;
            if (_selectSet.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载到本地" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"下载%d张到本地",_selectSet.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
        case 3:
            _type=CLICKDELETE;
            if (_selectSet.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_selectSet.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            if (self.type==CLICKVISIT) {
               [self presentViewController:self.imagePicker animated:YES completion:nil];
            }else if(self.type==CLICKDELETE){
                if (_selectSet.count>0) {
                    _stateView.hidden=NO;
                    _stateView.labelText=[NSString stringWithFormat:@"正在删除...(0/%d)",_selectSet.count];
//                    for (int i=0; i<_selectSet.count; i++) {
//                        [self deleteFileInfo:_selectSet[i]];
//                    }
                    downCount=_selectSet.count;
                    [self deleteFileInfo:_selectSet[0]];
                }
            }else{
                PSLog(@"正在下载...");
                _stateView.hidden=NO;
                downCount=_selectSet.count;
                _stateView.labelText=[NSString stringWithFormat:@"正在下载...(0/%d)",downCount];
                [self downVedio];
            }
            
        }
            break;
        case 1:
            PSLog(@"--从手机相册中选择--");
            //            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentViewController:ipc animated:YES completion:nil];
            if (self.type==CLICKVISIT) {
                [self cameraRollButtonPressed];
            }else if(self.type==CLICKDELETE){
                PSLog(@"---删除---");
            }
            
            break;
        case 2:
            PSLog(@"--取消--");
            break;
    }
}
#pragma -mark 下载视频
-(void)downVedio{
    FileInfo *info =_selectSet[0];
    [_selectSet removeObject:info];
    NSString *url = ROUTER_FILE_WHOLEDOWNLOAD(info.filePath);
    PSLog(@"down:%@",url);
    __weak typeof(self) weakSelf=self;
    savePath=[savePath stringByAppendingFormat:@"%@",info.fileName];
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:savePath]) {
        [manager removeItemAtPath:savePath error:nil];
    }
    NSMutableURLRequest *mRequest=[NSMutableURLRequest requestWithURL:url.urlInstance];
    mRequest.timeoutInterval=REQUESTTIMEOUT;
    int count=_selectSet.count;
    int talCount=downCount;
    downOperation=[[AFDownloadRequestOperation alloc]initWithRequest:mRequest targetPath:savePath shouldResume:NO];
    [downOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf saveVedio];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSLog(@"下载失败:%@",error);
        weakSelf.stateView.labelText=@"下载失败";
        [weakSelf performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }];
    [downOperation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        //            int bt=(int)(totalBytesRead/1024)/(totalBytesExpected/1024)*100;
        CGFloat readLong=totalBytesRead/1024.0;
        CGFloat totalLong=totalBytesExpected/1024.0;
        int bt=readLong/totalLong*100;
        weakSelf.stateView.labelText=[NSString stringWithFormat:@"正在下载...(%d/%d)%d%%",talCount-count,talCount,bt];
        PSLog(@"测试文件大小:%.f KB   %.fMB 进度条:%d%%",totalBytesExpected/1024.,totalBytesRead/1024./1024.,bt);
        //            [weakSelf perfo]
    }];
    [downOperation start];
}

-(void)saveVedio{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:savePath]
        completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                _stateView.labelText=@"保存失败";
//                [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
                PSLog(@"Save video fail:%@",error);
            } else {
                _stateView.labelText=@"保存成功";
                PSLog(@"Save video succeed.");
            }
//            PSLog(@"--[%d]--",isDelete);
            if (_selectSet.count==0) {
                self.stateView.labelText=@"下载完成";
                [[NSFileManager defaultManager]removeItemAtPath:savePath error:nil];
                [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            }else{
                self.stateView.labelText=[NSString stringWithFormat:@"正在下载...(%d/%d)",downCount-_selectSet.count,downCount];
                [self downVedio];
            }
    }];
}

#pragma -mark 加载视频
- (void)showPhotoCollectionController:(NSMutableArray *)datasource
{
    REPhotoController *photoController = [[REPhotoController alloc] init];
    [photoController setDatasource:datasource];
    photoController.type=SelectVedio;
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)cameraRollButtonPressed
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
               if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
                    NSString *fileName=[[result defaultRepresentation]filename];
                    if ([_saveSet containsObject:fileName]) {
                        photo.isBackup=YES;
                    }
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    photo.isVedio=YES;
                    NSTimeInterval duration=[[result valueForProperty:ALAssetPropertyDuration] doubleValue];
                    int hours=((int)duration)%(3600*24)/3600;
                    int minus=((int)duration)%(3600*24)/60;
                    int mt=((int)duration)%(3600*24)%60;
                    if (hours==0) {
                        photo.duration=[NSString stringWithFormat:@"%d:%02d",minus,mt];
                    }else{
                        photo.duration=[NSString stringWithFormat:@"%d%d:%02d",hours,minus,mt];
                    }
                    PSLog(@"--[%@]--",fileName);
                    [datasource addObject:photo];
                }
            }];
        } else {
            [self performSelectorOnMainThread:@selector(showPhotoCollectionController:) withObject:datasource waitUntilDone:NO];
        }
    } failureBlock:^(NSError *error) {
        PSLog(@"Failed.");
    }];
}

#pragma -mark 录制视频
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}

#pragma mark - UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
//        }
    [self dismissViewControllerAnimated:YES completion:nil];
    NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
    NSString *urlStr=[url path];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    if (data) {
        _stateView.hidden=NO;
        _stateView.labelText=@"正在分享...";
        [self uploadWithVedio:data name:[NSString stringWithFormat:@"IMG_0%d.MOV",arc4random()%1000]];
    }
    PSLog(@"--%@--",urlStr);
}

#pragma -mark 备份视频
-(void)uploadWithVedio:(NSData *)data name:(NSString *)name{
    NSString *url=ROUTER_FILE_UPVEDIO;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"video/mp4"];
    } error:nil];
    AFURLSessionManager *managers = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [managers uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            PSLog(@"Error: %@", error);
            _stateView.labelText=@"分享失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        } else {
            _stateView.labelText=@"分享成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            isRefresh=YES;
            [self getRequest];
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
        _stateView.labelText=[NSString stringWithFormat:@"正在分享...(%d%%)",progressDuration];
        PSLog(@"[%f]--[%@]--[%@]",fraction,localized,additional);
    }];
}

#pragma -mark 加载网络
- (void)getRequest
{
    refreshArr=[NSMutableArray array];
    arrAddress=[NSMutableOrderedSet orderedSetWithArray:@[ROUTER_FOLDER_BASEURL(@"Video")]];
    isAdd=YES;
    if (isRefresh) {
        [self initWithRequestAll];
    }else{
        pathArchive=pathInCacheDirectory(@"AppCache/Video.archiver");
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchive];
        if (array&&array.count>0) {
            [files addObjectsFromArray:array];
            [_rootTableView reloadData];
        }else{
            _stateView.hidden=NO;
            [self initWithRequestAll];
        }
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
                        mark:@"list"
                 autoRequest:YES];
    }else{
        [self updateWithData];
    }
    
}

#pragma mark 删除文件
-(void)deleteFileInfo:(FileInfo *)info{
    if ([_saveSet containsObject:info.fileName]) {
        [_saveSet removeObject:info.fileName];
    }
    if ([_selectSet containsObject:info]) {
        [_selectSet removeObject:info];
        [files removeObject:info];
    }
    
    NSDictionary *param=@{@"path":info.filePath,@"root":@"syncbox"};
    [self initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:@"delete" autoRequest:YES];
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    PSLog(@"%@",response);
    if ([mark isEqualToString:@"list"]) {
        NSArray *fileInfo = [response objectForKey:@"contents"];
        for (NSDictionary *info in fileInfo) {
            NSString *path = [info objectForKey:@"path"];
            NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
            if (![name hasPrefix:@"."]){
                NSNumber *isDir=[info objectForKey:@"is_dir"];
                NSRange range=[name rangeOfString:@"."];
                if (range.location!=NSNotFound&&![isDir boolValue]) {
                    NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                    BOOL isMyNeed =[self isVideoWithFileSuffix:suffix];
                    //        PSLog(@"%@",ROUTER_FILE_WHOLEDOWNLOAD(path));
                    if (isMyNeed) {
                        FileInfo *item = [[FileInfo alloc]init];
//                        name=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                        item.fileName = [[name componentsSeparatedByString:@"."] firstObject];
                        item.fileName=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        item.fileSuffix = suffix;
                        item.filePath = path;
                        item.fileSize = [info objectForKey:@"size"];
                        //                item.fileUpDate = [info objectForKey:@"modified"];
                        item.fileUpDate = [CCDate timeIntervalConvertDate:[[info objectForKey:@"modified_lts"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
                        item.isCanPlayOrOpen = [VEDIOSUB containsObject:suffix.lowercaseString];
                        if (isRefresh) {
                            [refreshArr addObject:item];
                        }else{
                            [files addObject:item];
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
    }else if([mark isEqualToString:@"delete"]){
        [NSKeyedArchiver archiveRootObject:files toFile:pathArchive];
        [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
        if (_selectSet.count==0) {
            _stateView.labelText=@"删除成功";
             [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            [_rootTableView reloadData];
        }else{
            _stateView.labelText=[NSString stringWithFormat:@"正在删除...(%d/%d)",downCount-_selectSet.count,downCount];
            [self deleteFileInfo:_selectSet[0]];
        }
    }

}

-(void)updateWithData{
    if (isRefresh) {
        isRefresh=NO;
        [self.header endRefreshing];
        [files removeAllObjects];
        files=refreshArr;
        [_selectSet removeAllObjects];
        [self setSelectStatue];
    }else{
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }
    [files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FileInfo *item1=(FileInfo *)obj1;
        FileInfo *item2=(FileInfo *)obj2;
        return [item2.fileUpDate compare:item1.fileUpDate];
    }];
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:saveArchtive];
    if (arr&&arr.count>0){
        [_saveSet removeAllObjects];
        for (NSString *name in arr) {
            if (![self isVideoWithFileSuffix:[[name componentsSeparatedByString:@"."] lastObject]]) {
                [_saveSet addObject:name];
            }
        }
    }
    for (FileInfo *info in files) {
        [_saveSet addObject:info.fileName];
    }
    [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
    [NSKeyedArchiver archiveRootObject:files toFile:pathArchive];
    [self.rootTableView reloadData];
    PSLog(@"----%d----",self.header.isRefreshing);

   
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    if (isRefresh) {
        [self.header endRefreshing];
        isRefresh=NO;
    }else{
        _stateView.labelText=@"访问失败!";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
    PSLog(@"%@:%@",mark,error);
}

#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.rootTableView;
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
    isRefresh=YES;
    [self getRequest];
    
}

-(void)dealloc{
    [self.header free];
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        _stateView.alpha=0;
    } completion:^(BOOL finished) {
        _stateView.alpha=1;
        _stateView.hidden=YES;
//        if ([state isEqualToString:@"fail"]) {
//            [self exitCurrentController];
//        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Harvey";
    ImageAndDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (isNIL(cell)) {
        cell=[[ImageAndDocumentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    FileInfo *item = [files objectAtIndex:indexPath.row];
    cell.filePreview.image = (item.isCanPlayOrOpen?@"hm_sppliebiao":@"hm_sppliebiao02").imageInstance;
    cell.fileName.text = item.fileName;
    cell.fileSize.text = [NSString stringWithFormat:@"大小: %@",item.fileSize];
    cell.fileUpDate.text = [NSString stringWithFormat:@"更新时间:%@",item.fileUpDate];
    cell.selectImg.hidden=!isSelect;
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return files.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileInfo *info = [files objectAtIndex:indexPath.row];
    if(isSelect){
        ImageAndDocumentCell *cell=(ImageAndDocumentCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([_selectSet containsObject:info]) {
            cell.selectImg.image=[UIImage imageNamed:@"hm_xuanze01"];
            [_selectSet removeObject:info];
        }else{
            cell.selectImg.image=[UIImage imageNamed:@"hm_xuanze02"];
            [_selectSet addObject:info];
        }
        [self setSelectStatue];
    }else{

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
        }
        else{
            VideoPlayerViewController *videoController = [[VideoPlayerViewController alloc] init];
            videoController.title=@"云视频";
            videoController.info=info;
            [self.navigationController pushViewController:videoController animated:YES];
        }
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        PSLog(@"已删除...");
        FileInfo *info = [files objectAtIndex:indexPath.row];
        [self deleteFileInfo:info];
        [files removeObject:info];
        [self.rootTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
