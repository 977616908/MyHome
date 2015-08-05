//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REPhotoCollectionController.h"
#import "REPhotoThumbnailsCell.h"
#import "UIImageView+WebCache.h"
#import "REPhotoController.h"
#import "REPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJRefresh.h"
#define BARHEIGHT 44
typedef enum{
    CLICKVISIT=0x01,
    CLICKDOWN,
    CLICKDELETE
}CLICKTYPE;
@interface REPhotoCollectionController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MJRefreshBaseViewDelegate>{
    NSMutableArray  *arrImg;
    NSMutableArray  *arrRefresh;
    NSMutableArray  *arrAddress;
    UITableView     *tableImg;
    MBProgressHUD   *stateView;
    BOOL          isAdd;
    NSString *pathArchtive;
    NSString *saveArchtive;
    BOOL          isRefresh;
    UIView       *_toolbar;
    NSMutableOrderedSet *_deleteArr;
    NSMutableOrderedSet *_saveSet;
    BOOL isDelete;
    NSInteger deleteCount;
}

@property(nonatomic,weak)MJRefreshHeaderView *header;
@property(nonatomic,assign)CLICKTYPE type;
@property(nonatomic,weak)CCButton *btnSelect;
@end

@implementation REPhotoCollectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"云图片";
    pathArchtive= pathInCacheDirectory(@"AppCache/Photo.archiver");
    saveArchtive=pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    [self createView];
//    [self getRequest];
    PSLog(@"--viewDidLoad--");
}

-(void)createView{
    CGFloat gh=44;
    if (is_iOS7()) {
        gh+=20;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    tableImg=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    tableImg.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableImg.showsVerticalScrollIndicator=NO;
    tableImg.delegate=self;
    tableImg.dataSource=self;
    [self.view addSubview:tableImg];
    
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.removeFromSuperViewOnHide=YES;
    stateView.hidden=YES;
    
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(addPhotoListener:), self);
    [sendBut alterNormalTitle:@"选择"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    self.btnSelect=sendBut;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    
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
    
    self.arrTag=@[visitBtn,downBtn,deleteBtn];
    arrImg=[NSMutableArray array];
    _deleteArr=[NSMutableOrderedSet orderedSet];
    _saveSet=[NSMutableOrderedSet orderedSet];
    //    arrAddress=[NSMutableArray arrayWithObjects:ROUTER_FOLDER_BASEURL(@"Data"),ROUTER_FOLDER_BASEURL(@"Photo"), nil];
    //    arrAddress=[NSMutableOrderedSet orderedSetWithArray:@[ROUTER_FOLDER_BASEURL(@"Data"),ROUTER_FOLDER_BASEURL(@"Data/download")]];
    [self setupRefreshView];
}


-(void)onClick:(UIButton *)sendar{
    PSLog(@"--图片--%d",sendar.tag);
    UIActionSheet *action=nil;
    switch (sendar.tag) {
        case 1:
            _type=CLICKVISIT;
            action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
            [action showInView:self.view];
            break;
        case 2:
            _type=CLICKDOWN;
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载到本地" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"下载%d张到本地",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
        case 3:
            _type=CLICKDELETE;
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil];
            }else{
               action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
    }
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PSLog(@"--viewWillAppear--");
    [_btnSelect alterNormalTitle:@"选择"];
    self.title=@"云图片";
    [self toolBarWithAnimation:YES];
    isDelete=NO;
    [self getRequest];
}

-(void)addPhotoListener:(CCButton*)sendar{
    if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
        isDelete=YES;
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        self.title=@"选择项目";
        UIButton *btn01=(UIButton *)self.arrTag[0] ;
        UIButton *btn02=(UIButton *)self.arrTag[1] ;
        UIButton *btn03=(UIButton *)self.arrTag[2] ;
        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
        [btn02 setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
        [btn03 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
        btn01.enabled=YES;
        btn02.enabled=NO;
        btn03.enabled=NO;
    }else{
        isDelete=NO;
        [sendar alterNormalTitle:@"选择"];
        [self toolBarWithAnimation:YES];
        self.title=@"云图片";
    }
    [_deleteArr removeAllObjects];
    [tableImg reloadData];
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            if (self.type==CLICKVISIT) {
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.delegate = self;
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                //            ipc.allowsEditing=YES;
                [self presentViewController:ipc animated:YES completion:nil];
            }else if(self.type==CLICKDELETE){
                if (_deleteArr.count>0) {
                    stateView.hidden=NO;
                    deleteCount=_deleteArr.count;
                    stateView.labelText=[NSString stringWithFormat:@"正在删除(0/%d)",deleteCount];
                    for (int i=0; i<_deleteArr.count; i++) {
                        [self deleteWithPhoto:_deleteArr[i] mark:[NSString stringWithFormat:@"%d",i+1]];
                    }
                }
            }else{
                PSLog(@"正在下载...");
                [self downImage];
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

#pragma mark 删除图片
-(void)deleteWithPhoto:(REPhoto *)photo mark:(NSString *)mark{
    NSDictionary *param=@{@"path":photo.imageUrl,@"root":@"syncbox"};
    if ([_saveSet containsObject:photo.imageName]) {
        [_saveSet removeObject:photo.imageName];
    }
    [self initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:mark autoRequest:YES];
}

-(void)deleteWithPhoto:(NSInteger)index{
    for (REPhotoGroup *group in arrImg) {
        if ([group.items containsObject:_deleteArr[index-1]]) {
            NSMutableArray *arr=[NSMutableArray arrayWithArray:group.items];
            [arr removeObject:_deleteArr[index-1]];
            group.items=arr;
            break;
        }
    }
    deleteCount--;
    stateView.labelText=[NSString stringWithFormat:@"正在删除(%d/%d)",_deleteArr.count-deleteCount,_deleteArr.count];
    if (deleteCount==0) {
        stateView.labelText=@"删除成功";
        [_btnSelect alterNormalTitle:@"选择"];
        self.title=@"云图片";
        [self toolBarWithAnimation:YES];
        isDelete=NO;
        [tableImg reloadData];
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        [NSKeyedArchiver archiveRootObject:arrImg toFile:pathArchtive];
        [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
    }
}

#pragma mark 下载图片
-(void)downImage{
    stateView.hidden=NO;
    deleteCount=_deleteArr.count;
    stateView.labelText=[NSString stringWithFormat:@"正在下载(0/%d)",deleteCount];
//    ALAssetsLibrary *libray=[[ALAssetsLibrary alloc]init];
    NSArray *downArr=_deleteArr.array;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (REPhoto *photo in downArr) {
            NSURL *url=ROUTER_FILE_WHOLEDOWNLOAD(photo.imageUrl).encodedString.urlInstance;
            NSData *data=[NSData dataWithContentsOfURL:url];
            if (data) {
//                [libray writeImageDataToSavedPhotosAlbum:data metadata:@{} completionBlock:^(NSURL *assetURL, NSError *error) {
//                    [_deleteArr removeObject:photo];
//                    [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:error waitUntilDone:NO];
//                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_deleteArr removeObject:photo];
                    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                });
            }else{
                [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:[[NSError alloc]init] waitUntilDone:NO];
                break;
            }
        }
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (_deleteArr.count==0) {
        stateView.labelText=@"下载完成";
        [_btnSelect alterNormalTitle:@"选择"];
        self.title=@"云图片";
        [self toolBarWithAnimation:YES];
        isDelete=NO;
        [tableImg reloadData];
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }else{
        stateView.labelText=[NSString stringWithFormat:@"正在下载(%d/%d)",deleteCount-_deleteArr.count,deleteCount];
    }
}

- (void)imageSavingWithError:(NSError *)error
{
    if (error) {
        stateView.labelText=@"下载失败";
        [tableImg reloadData];
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
//    else {
//        if (_deleteArr.count==0) {
//            stateView.labelText=@"下载完成";
//            [_btnSelect alterNormalTitle:@"选择"];
//            self.title=@"云图片";
//            [self toolBarWithAnimation:YES];
//            isDelete=NO;
//            [tableImg reloadData];
//            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
//        }else{
//            stateView.labelText=[NSString stringWithFormat:@"正在下载(%d/%d)",deleteCount-_deleteArr.count,deleteCount];
//        }
//    }
}


#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 2.去的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    PSLog(@"info-->%d",[image hash]);
    [self sendWithImage:image name:[NSString stringWithFormat:@"%d.jpg",[image hash]]];
}

/**
 *  分享图片
 */
- (void)sendWithImage:(UIImage *)image name:(NSString *)name
{
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.removeFromSuperViewOnHide=YES;
    stateView.hidden=NO;
    stateView.labelText=@"正在分享...";
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"overwrite"] = @"false";
    params[@"token"] = [GlobalShare getToken];
    //
    // 3.发送请求
    [mgr POST:ROUTER_FILE_UPDOWN parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 在发送请求之前调用这个block
        // 必须在这里说明要分享哪些文件
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        stateView.labelText=@"分享成功";
        isRefresh=YES;
        [self getRequest];
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        stateView.labelText=@"分享失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }];
}


- (void)showPhotoCollectionController:(NSMutableArray *)datasource
{
    REPhotoController *photoController = [[REPhotoController alloc] init];
    [photoController setDatasource:datasource];
    photoController.type=SelectPhoto;
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)cameraRollButtonPressed
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    REPhoto *photo = [[REPhoto alloc] init];
//                    获取缩略图：
//                    CGImageRef  ref = [result thumbnail];
//                    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
//                    获取全屏相片：
//                    CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
//                    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
//                    获取高清相片：
//                    CGImageRef ref = [[result  defaultRepresentation]fullResolutionImage];
//                    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
                    photo.imageName=[[result defaultRepresentation]filename];
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
//                    photo.image=[UIImage imageWithCGImage:result.aspectRatioThumbnail];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
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



#pragma mark 网络请求
- (void)getRequest
{
    arrAddress=[NSMutableArray arrayWithArray:@[ROUTER_FOLDER_BASEURL(@"Photo")]];
    isAdd=YES;
    arrRefresh=[NSMutableArray array];
    if(isRefresh){
        [self initWithRequestAll];
    }else{
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
        if (array&&array.count>0) {
            arrImg=[NSMutableArray arrayWithArray:array];
            [tableImg reloadData];
        }else{
            stateView.hidden=NO;
            //    stateView.labelText=@"正在加载...请稍候";
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
        [self updateWithArray:arrRefresh];
        if(!isRefresh){
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            isRefresh=YES;
        }
    }
    
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    if ([mark isEqualToString:@"list"]) {
        NSArray *fileInfo = [response objectForKey:@"contents"];
        for (NSDictionary *info in fileInfo) {
            NSString *path = [info objectForKey:@"path"];
            NSNumber *isDir=[info objectForKey:@"is_dir"];
            NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
            if (![name hasPrefix:@"."]) {
                NSRange range=[name rangeOfString:@"."];
                if (range.location!=NSNotFound&&![isDir boolValue]) {
                    NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                    BOOL isMyNeed =[self isImageWithFileSuffix:suffix];
                    if (isMyNeed) {
                        REPhoto *photo = [[REPhoto alloc]init];
                        photo.imageName=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        photo.imageUrl=path;
                        photo.date=[CCDate timeIntervalConvertDate:[[info objectForKey:@"modified_lts"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
                        [arrRefresh addObject:photo];
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
    }else{
        [self deleteWithPhoto:[mark intValue]];
    }
}


-(void)updateWithArray:(NSMutableArray *)sorted{
    //    arr=[arr subarrayWithRange:NSMakeRange(0, 20)];
    [sorted sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        REPhoto *item1=(REPhoto *)obj1;
        REPhoto *item2=(REPhoto *)obj2;
        return [item2.date compare:item1.date];
    }];
    [arrImg removeAllObjects];
//    [_saveSet removeAllObjects];
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:saveArchtive];
    if (arr&&arr.count>0){
        [_saveSet removeAllObjects];
        for (NSString *name in arr) {
            if (![self isImageWithFileSuffix:[[name componentsSeparatedByString:@"."] lastObject]]) {
                [_saveSet addObject:name];
            }
        }
    }
    for (REPhoto *photo in sorted) {
        [_saveSet addObject:photo.imageName];
        NSArray *arrDate=[photo.date componentsSeparatedByString:@"-"];
        NSUInteger year = [arrDate[0] integerValue];
        NSUInteger month = [arrDate[1] integerValue];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in arrImg) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month=month;
            group.year=year;
            [group.items addObject:photo];
            [arrImg addObject:group];
        }else {
            [group.items addObject:photo];
        }
    }
//    for (REPhotoGroup *group in arrImg) {
//        group.itemAll=group.items;
//        group.count=group.items.count;
//        if (group.items.count>19) {
//            group.items=[NSMutableArray arrayWithArray:[group.items subarrayWithRange:NSMakeRange(0, 19)]];
//        }
//    }
    
    [NSKeyedArchiver archiveRootObject:arrImg toFile:pathArchtive];
    [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:saveArchtive];
    
    if(isRefresh){
        isRefresh=NO;
        if(_header.isRefreshing)[_header endRefreshing];
    }else{
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }
//    [_deleteArr removeAllObjects];
    [tableImg reloadData];
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    if (isDelete) {
      stateView.labelText=@"删除失败!";
    }else{
      stateView.labelText=@"访问失败!";
    }
    
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    PSLog(@"%@:%@",mark,error);
    if (isRefresh) {
        isRefresh=NO;
        if(_header.isRefreshing)[_header endRefreshing];
    }
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}

#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = tableImg;
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
    isDelete=NO;
    [_btnSelect alterNormalTitle:@"选择"];
    [self toolBarWithAnimation:YES];
    [self getRequest];
    
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([arrImg count] == 0) return 0;
    
    if ([self tableView:tableImg numberOfRowsInSection:[arrImg count] - 1] == 0) {
        return [arrImg count] - 1;
    }
    return [arrImg count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[arrImg objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.superController=self;
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[arrImg objectAtIndex:indexPath.section];
    if (group) {
        NSArray *array=group.items;
        int startIndex = indexPath.row * 4;
        int endIndex = startIndex + 4;
        if (endIndex > [array count])
            endIndex = [array count];
        [cell removeAllPhotos];
        for (int i = startIndex; i < endIndex; i++) {
            REPhoto *photo = [group.items objectAtIndex:i];
            [cell addPhoto:photo];
        }
        cell.arryGroup=group.items;
        if (isDelete) {
            cell.selectOrder=_deleteArr;
            cell.photoType=REPhotoMore;
        }else{
            cell.photoType=REPhotoNone;
        }
//        cell.detailTitle=[NSString stringWithFormat:@"%d年%d月 共%d张",group.year,group.month,[group.itemAll count]];
//        cell.detailTitle=@{@"year":@(group.year),@"month":@(group.month)};
        [cell refresh];
        //        [cell addPhotoWithArray:group.itemAll];
        
    }
    
    //    NSArray *arrPhoto=group.items;
    //    [cell addPhotoWithArray:arrPhoto];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PSLog(@"---tableview----");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[arrImg objectAtIndex:section];
    NSString *content=[NSString stringWithFormat:@"%d年%d月 共%d张",group.year,group.month,group.items.count];
    return content;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//-(void)exitCurrentController{
//    [super exitCurrentController];
//    [self clearImageWithCookie];
//}

-(void)dealloc{
    [self.header free];
}

@end
