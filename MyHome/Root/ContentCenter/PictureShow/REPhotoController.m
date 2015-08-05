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

#import "REPhotoController.h"
#import "REPhotoThumbnailsCell.h"
#import "MLKMenuPopover.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define BARHEIGHT 44

@interface REPhotoController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MLKMenuPopoverDelegate>{
    UITableView     *tableImg;
    NSMutableArray *_photoArr;
    NSMutableOrderedSet  *_upArray;
    MBProgressHUD  *stateView;
    NSInteger  upCount;
    UIView         *_toolbar;
    BOOL isUpdate;
    NSString *pathArchtive;
    NSMutableOrderedSet *_saveSet;
}

@property(nonatomic,weak)CCButton *btnSelect;
@property(nonatomic,weak)MLKMenuPopover *menuPopover;

@end

@implementation REPhotoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat gh=44;
    if (is_iOS7()) {
        gh+=20;
    }
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    _photoArr=[NSMutableArray array];
    _upArray=[NSMutableOrderedSet orderedSet];
    tableImg=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    tableImg.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableImg.showsVerticalScrollIndicator=NO;
    tableImg.delegate=self;
    tableImg.dataSource=self;
    [self.view addSubview:tableImg];
    
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(upDownListener:), self);
    sendBut.tag=1;
    [sendBut alterNormalTitle:@"选择"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    self.btnSelect=sendBut;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    
    UIView *bgPow=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 125, 44)];
    CCButton *btnPow=CCButtonCreateWithValue(CGRectMake(0, 0, CGRectGetWidth(bgPow.frame), 44), @selector(upDownListener:), self);
    self.btnPopover=btnPow;
    if (self.type==SelectNone) {
        btnPow.titleLabel.textAlignment=NSTextAlignmentRight;
        btnPow.tag=2;
        [btnPow setImage:[UIImage imageNamed:@"hm_xiala02"] forState:UIControlStateNormal];
        btnPow.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
        btnPow.imageEdgeInsets=UIEdgeInsetsMake(12,102,12,0);
        MLKMenuPopover *menuPopover=[[MLKMenuPopover alloc]initWithFrame:CGRectMake(70, 0, 180, 200) menuItems:@[@"手机全部",@"手机相册",@"手机视频"]];
        self.menuPopover=menuPopover;
        menuPopover.menuPopoverDelegate=self;
    }else{
        btnPow.enabled=NO;
    }
  
    [btnPow alterFontUseBoldWithSize:20.0f];
    [bgPow addSubview:btnPow];
    bgPow.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView=bgPow;
    
    _toolbar=[[UIView alloc]init];
    _toolbar.backgroundColor=RGBCommon(73, 170, 231);
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *visitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    visitBtn.frame=CGRectMake(20, 0, BARHEIGHT, BARHEIGHT);
    visitBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [visitBtn setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
    visitBtn.tag=1;
    [visitBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:visitBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(CGRectGetWidth(self.view.frame)-20-BARHEIGHT, 0, BARHEIGHT, BARHEIGHT);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
    deleteBtn.tag=2;
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
    self.arrTag=@[visitBtn,deleteBtn];
    [self setTitleButton];
}

-(void)setTitleButton{
    UIButton *btn01=(UIButton *)self.arrTag[0] ;
    UIButton *btn02=(UIButton *)self.arrTag[1] ;
    if(_upArray.count>0){
        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
        [btn02 setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
        btn01.enabled=YES;
        btn02.enabled=YES;
         [self.btnPopover alterNormalTitle:@"选择项目"];
    }else{
        [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan_selector"] forState:UIControlStateNormal];
        [btn02 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
        btn01.enabled=NO;
        btn02.enabled=NO;
        if (self.type==SelectPhoto) {
            [self.btnPopover alterNormalTitle:@"手机相册"];
        }else if(self.type==SelectVedio){
            [self.btnPopover alterNormalTitle:@"手机视频"];
        }else{
            [self.btnPopover alterNormalTitle:@"手机全部"];
        }
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PSLog(@"--viewWillAppear--");
  
    [self toolBarWithAnimation:YES];
    isUpdate=NO;
    [self reloadData];
}

-(void)upDownListener:(CCButton *)sendar{
    if (sendar.tag==1) {
        [_upArray removeAllObjects];
        if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
            [sendar alterNormalTitle:@"取消"];
            [self toolBarWithAnimation:NO];
            isUpdate=YES;
        }else{
            [sendar alterNormalTitle:@"选择"];
            [self toolBarWithAnimation:YES];
            isUpdate=NO;
        }
        [self setTitleButton];
        [tableImg reloadData];
    }else{
//        [self.menuPopover dismissMenuPopover];
        [self.menuPopover showInView:self.navigationController.view];
//        [self.menuPopover showInView:self.view];
        [sendar setImage:[UIImage imageNamed:@"hm_xiala"] forState:UIControlStateNormal];
    }
    
    
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    PSLog(@"---[%d]--",selectedIndex);
    [_btnPopover setImage:[UIImage imageNamed:@"hm_xiala02"] forState:UIControlStateNormal];
    [self.menuPopover dismissMenuPopover];
    if(selectedIndex==-1)return;
    switch (selectedIndex) {
        case 0:
            self.type=SelectNone;
            break;
        case 1:
            self.type=SelectPhoto;
            break;
        case 2:
            self.type=SelectVedio;
            break;

    }
    [_upArray removeAllObjects];
    [self setTitleButton];
    [self reloadData];
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
    UIActionSheet *action=nil;
    if (sendar.tag==1) {
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"上传%d张照片",_upArray.count] otherButtonTitles:nil, nil];
    }else{
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_upArray.count] otherButtonTitles:nil, nil];
    }
    action.tag=sendar.tag;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (actionSheet.tag==1) {
            PSLog(@"正在备份...");
            if (_upArray.count>0) {
                [self setTitleButton];
                if (!stateView) {
                    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                }
                stateView.hidden=NO;
                upCount=_upArray.count;
                stateView.labelText=[NSString stringWithFormat:@"正在备份(0/%d)",upCount];
                stateView.removeFromSuperViewOnHide=YES;
                [self upImgWithPhoto:_upArray[0]];
            }
        }else{
            PSLog(@"正在删除...");
            for (int i=0; i<_upArray.count; i++) {
                [self deleteWithPhoto:_upArray[i]];
                for (REPhotoGroup *group in _photoArr) {
                    if ([group.items containsObject:_upArray[i]]) {
                        [group.items removeObject:_upArray[i]];
                    }
                }
            }
            [_upArray removeAllObjects];
            [tableImg reloadData];
        }
        
    }
}

-(void)upImgWithPhoto:(REPhoto *)photo{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:photo.imageUrl] resultBlock:^(ALAsset *asset)
     {
         //在这里使用asset来获取图片
         if (photo.isVedio) {//上传视频
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
             if(is_iOS7()){
                 [self uploadWithVedio:data Photo:photo];
             }else{
               [self uploadWithImage:nil Vedio:data Photo:photo];
             }
         }else{ // 上传图片
             UIImage *image = [[UIImage alloc]initWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
             if (image) {
                 [self uploadWithImage:image Vedio:nil Photo:photo];
             }
         }
     }
            failureBlock:^(NSError *error)
     {}];
}

#pragma -mark 备份图片
-(void)uploadWithImage:(UIImage *)image Vedio:(NSData *)data Photo:(REPhoto *)photo{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"overwrite"] = @"false";
    params[@"token"] = [GlobalShare getToken];
    NSString *url=ROUTER_FILE_UPDOWN;
    if (photo.isVedio) {
        url=ROUTER_FILE_UPVEDIO;
    }
    // 3.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 在发送请求之前调用这个block
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"image/jpeg"];
            }
        }else{
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"video/mp4"];
            }
        }
        //        NSURL *url=[[NSBundle mainBundle]URLForResource:photo.imageUrl withExtension:@"jpg"];
        //        [formData appendPartWithFileURL:url name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PSLog(@"--%@--",responseObject);
        photo.isBackup=YES;
        [_upArray removeObject:photo];
        stateView.labelText=[NSString stringWithFormat:@"正在备份(%d/%d)",(upCount-_upArray.count),upCount];
        [_saveSet addObject:photo.imageName];
        [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:pathArchtive];
        if (_upArray.count<=0) {
            stateView.labelText=@"备份成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        }else{
            [self upImgWithPhoto:_upArray[0]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSLog(@"--%@--",error);
        stateView.labelText=@"备份失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }];
}

#pragma -mark 备份视频
-(void)uploadWithVedio:(NSData *)data Photo:(REPhoto *)photo{
    NSString *url=ROUTER_FILE_UPVEDIO;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"video/mp4"];
    } error:nil];
    AFURLSessionManager *managers = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [managers uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            PSLog(@"Error: %@", error);
            stateView.labelText=@"备份失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        } else {
            photo.isBackup=YES;
            [_upArray removeObject:photo];
            stateView.labelText=[NSString stringWithFormat:@"正在备份(%d/%d)",(upCount-_upArray.count),upCount];
            [_saveSet addObject:photo.imageName];
            [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:pathArchtive];
            if (_upArray.count<=0) {
                stateView.labelText=@"备份成功";
                [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            }else{
                [self upImgWithPhoto:_upArray[0]];
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
        NSString *localized=progress.localizedDescription;
        NSString *additional=progress.localizedAdditionalDescription;
        int progressDuration=fraction*100;
        stateView.labelText=[NSString stringWithFormat:@"正在备份(%d/%d)%d%%",(upCount-_upArray.count),upCount,progressDuration];
        PSLog(@"[%f]--[%@]--[%@]",fraction,localized,additional);
    }];
}



#pragma -mark 删除手机相册
-(void)deleteWithPhoto:(REPhoto *)photo{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
    [library assetForURL:[NSURL URLWithString:photo.imageUrl] resultBlock:^(ALAsset *asset)
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

-(void)setStateView:(NSString *)state{
    [tableImg reloadData];
    [UIView animateWithDuration:0.7 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}

#pragma mark -
#pragma mark UITableViewController functions

- (void)setDatasource:(NSMutableArray *)datasource
{
    _datasource = datasource;
}

- (void)reloadData
{
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    [_datasource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        REPhoto *item1=(REPhoto *)obj1;
        REPhoto *item2=(REPhoto *)obj2;
        return [item2.photoDate compare:item1.photoDate];
    }];
    [_photoArr removeAllObjects];
    NSMutableArray *arrType=[NSMutableArray array];
    for (REPhoto *photo in _datasource) {
        if (self.type==SelectVedio) {
            if(photo.isVedio)[arrType addObject:photo];
        }else if (self.type==SelectPhoto){
            if(!photo.isVedio)[arrType addObject:photo];
        }else{
            [arrType addObject:photo];
        }
    }
    for (REPhoto *photo in arrType) {
        if ([_saveSet containsObject:photo.imageName]) {
            photo.isBackup=YES;
        }
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.photoDate];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in _photoArr) {
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
            [_photoArr addObject:group];
        }else {
            [group.items addObject:photo];
        }
    }
    //    REPhotoGroup *group=_photoArr[0];
    //    [_upArray addObject:group.items[0]];
    [tableImg reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_photoArr count] == 0) return 0;
    if ([self tableView:tableImg numberOfRowsInSection:[_photoArr count] - 1] == 0) {
        return [_photoArr count] - 1;
    }
    return [_photoArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.superController=self;
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:indexPath.section];
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
        cell.arryGroup=array;
        if (isUpdate) {
            cell.photoType=REPhotoPicker;
            cell.selectOrder=_upArray;
        }else{
            cell.photoType=REPhotoOther;
        }
        
        [cell refresh];
        //        [cell addPhotoWithArray:group.itemAll];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    NSString *content=[NSString stringWithFormat:@"%d年%d月 共%d张",group.year,group.month,[group.items count]];
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

@end
