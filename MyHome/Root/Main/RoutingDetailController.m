//
//  ComposeViewController.m
//  RoutingTime
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingDetailController.h"
#import "PhotoSelectController.h"
#import "CCTextView.h"
#import "PhotosView.h"
#import "MJPhotoBrowser.h"
#import "RoutingEditController.h"
#import "PiFiiBaseNavigationController.h"
#import "REPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RoutingMsg.h"
#import "RoutingTime.h"
#import <ShareSDK/ShareSDK.h>
#define HEIGHT 200
#define BARHEIGHT 44


@interface RoutingDetailController ()<UITextViewDelegate,PhotosViewDelegate,PiFiiBaseViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray  *_photoArr;
    NSMutableArray  *_vedioArr;
    NSMutableArray  *_imageArr;
    MBProgressHUD           *stateView;
    NSString *pathArchtive;
    NSMutableOrderedSet     *_saveSet;
    NSMutableOrderedSet     *_deleteArr;
    NSMutableDictionary *params;
    NSInteger downCount;
    UIView       *_toolbar;
    BOOL  isDelete;
    NSInteger deleteCount;
}

@property(nonatomic,weak)CCTextView *textView;
@property(nonatomic,weak)PhotosView *photosView;
@property(nonatomic,weak)CCScrollView *rootScrollView;
@property(nonatomic,weak)CCLabel *lbDate;
@property(nonatomic,weak)CCButton *btnSelect;
@end

@implementation RoutingDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"时光片段";
    _photoArr=[NSMutableArray array];
    _vedioArr=[NSMutableArray array];
    _deleteArr=[NSMutableOrderedSet orderedSet];
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    [self createPhotosView];
    [self createTextView];
    [self createView];
    if (_routingTime) {
        _imageArr=[NSMutableArray arrayWithArray:_routingTime.rtSmallPaths];
        [self addImage:_imageArr];
        _textView.text=_routingTime.rtTitle;
        _lbDate.text=[NSString stringWithFormat:@"创建时间: %@",_routingTime.rtDate];
        for (int i=0; i<_routingTime.rtPaths.count; i++) {
            RoutingMsg *msg=_routingTime.rtPaths[i];
            REPhoto *photo=[[REPhoto alloc]init];
            photo.routingId=[NSString stringWithFormat:@"%d",_routingTime.rtId];
            photo.imageUrl=msg.msgPath;
            photo.date=_routingTime.rtDate;
            photo.isVedio=[_routingTime.rtSmallPaths[i] isVedio];
            photo.imageName=msg.msgNum;
            if (photo.isVedio) {
                [_vedioArr addObject:photo];
            }else{
                [_photoArr addObject:photo];
            }
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)createPhotosView{
    CCScrollView *scrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 5, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-HEIGHT), self, NO);
    scrollView.bounces=YES;
    self.rootScrollView=scrollView;
    [self.view addSubview:scrollView];
    
    PhotosView *photosView = [[PhotosView alloc] init];
    photosView.isAdd=YES;
    photosView.frame = CGRectMake(0, 0, CGRectGetWidth(self.rootScrollView.frame), CGRectGetHeight(self.rootScrollView.frame));
    self.photosView = photosView;
    photosView.delegate=self;
    [self.rootScrollView addSubview:photosView];
    
}

-(void)createTextView{
    CCLabel *lbDate=CCLabelCreateWithNewValue(@"", 12, CGRectMake(5, CGRectGetMaxY(_rootScrollView.frame), CGRectGetWidth(self.view.frame), 15));
    lbDate.textColor=RGBCommon(181, 181, 181);
    self.lbDate=lbDate;
    [self.view addSubview:lbDate];
    CGFloat hg=HEIGHT-20;
    if (is_iOS7()) {
        hg-=64;
    }
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbDate.frame), CGRectGetWidth(self.view.frame), hg)];
    bgView.backgroundColor=[UIColor whiteColor];
    // 1.添加
    CCTextView *textView = [[CCTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor=RGBCommon(52, 52, 52);
    textView.placeholderColor=RGBCommon(181, 181, 181);
    textView.frame = CGRectMake(5, -5, CGRectGetWidth(bgView.frame)-10, CGRectGetHeight(bgView.frame)-32);
    //    textView.textContainerInset=UIEdgeInsetsMake(15, 10, 0, 10);
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.editable=NO;
    //    textView.placeholder = @"这一刻的想法...";
    self.textView = textView;
    textView.backgroundColor=[UIColor clearColor];
    [bgView addSubview:textView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame)-31, CGRectGetWidth(bgView.frame), 1)];
    line.backgroundColor=RGBCommon(181, 181, 181);
    [bgView addSubview:line];
    
    UIView *bgTool=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame)-30, CGRectGetWidth(bgView.frame), 30)];
    CCButton *btnComment=CCButtonCreateWithValue(CGRectMake(0, 0, CGRectGetWidth(bgTool.frame)/2, 30), @selector(onCommentClick:), self);
    btnComment.tag=1;
    [btnComment alterFontSize:12];
    [btnComment alterNormalTitleColor:RGBCommon(52, 52, 52)];
    [btnComment setImage:[UIImage imageNamed:@"hm_share"] forState:UIControlStateNormal];
    [btnComment alterNormalTitle:@" 分享"];
    [bgTool addSubview:btnComment];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(bgTool.frame)/2, 0, 1, CGRectGetHeight(bgTool.frame))];
    line2.backgroundColor=RGBCommon(181, 181, 181);
    [bgTool addSubview:line2];
    
    CCButton *btnEdit=CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(bgTool.frame)/2+1, 0, CGRectGetWidth(bgTool.frame)/2, 30), @selector(onCommentClick:), self);
    btnEdit.tag=2;
    [btnEdit alterFontSize:12];
    [btnEdit alterNormalTitleColor:RGBCommon(52, 52, 52)];
    [btnEdit setImage:[UIImage imageNamed:@"hm_edit"] forState:UIControlStateNormal];
    [btnEdit alterNormalTitle:@" 编辑"];
    [bgTool addSubview:btnEdit];
    [bgView addSubview:bgTool];
    
    
    [self.view addSubview:bgView];
}


-(void)createView{
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(addPhotoListener:), self);
    [sendBut alterNormalTitle:@"选择"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    self.btnSelect=sendBut;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    _toolbar = [[UIView alloc] init];
    _toolbar.backgroundColor=RGBCommon(63, 205, 225);
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame=CGRectMake(20, 0, BARHEIGHT, BARHEIGHT);
    downBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    downBtn.tag=1;
    [downBtn setImage:[UIImage imageNamed:@"hm_baocun"] forState:UIControlStateNormal];
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:downBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(CGRectGetWidth(self.view.frame)-20-BARHEIGHT, 0, BARHEIGHT, BARHEIGHT);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
    deleteBtn.tag=2;
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
    
    
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.hidden=YES;
}

-(void)onCommentClick:(CCButton *)sendar{
    PSLog(@"--评论--%d",sendar.tag);
    if (sendar.tag==1) {
        [self shareSDK];
    }else{
        RoutingEditController *editController=[[RoutingEditController alloc]init];
        editController.routingTime=_routingTime;
        editController.pifiiDelegate=self;
        PiFiiBaseNavigationController *nav=[[PiFiiBaseNavigationController alloc]initWithRootViewController:editController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)onClick:(UIButton *)sendar{
    UIActionSheet *action=nil;
    switch (sendar.tag) {
        case 1:
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载到本地" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"下载%d张到本地",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
        case 2:
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
    }
    action.tag=sendar.tag;
}

-(void)addPhotoListener:(CCButton*)sendar{
    if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        self.title=@"选择项目";
        isDelete=YES;
    }else{
        [sendar alterNormalTitle:@"选择"];
        [self toolBarWithAnimation:YES];
        self.title=@"时光片段";
        isDelete=NO;
        for (UIImageView *delImg in _photosView.totalImages) {
            if(delImg.subviews.count>0&&delImg.alpha<1.0)[[delImg.subviews lastObject] removeFromSuperview];
            delImg.alpha=1.0;
        }
    }
    [_deleteArr removeAllObjects];
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


-(void)photosTapWithIndex:(NSInteger)index{
    PSLog(@"--add--[%d]",index);
    if(index==-1){
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
        action.tag=index;
        [action showInView:self.view];
        //        [self openLibaray];
    }else{
        RoutingMsg *msg=_imageArr[index-1];
        if (isDelete) {
            UIImageView *delImg=self.photosView.totalImages[index-1];
            REPhoto *photo;
            if (msg.isVedio) {
                //            photo=_vedioArr[index-1];
                for(photo in _vedioArr){
                    if([photo.imageName isEqualToString:msg.msgNum]){
                        break;
                    }
                }
            }else{
                for(photo in _photoArr){
                    if([photo.imageName isEqualToString:msg.msgNum]){
                        break;
                    }
                }
            }
            if ([_deleteArr containsObject:photo]) {
                delImg.alpha=1.0;
                [_deleteArr removeObject:photo];
                [[delImg.subviews lastObject] removeFromSuperview];
            }else{
                [_deleteArr addObject:photo];
                UIImageView *selectImg=[[UIImageView alloc]init];
                UIImage *image=@"ImageSelectedOn".imageInstance;
                CGSize size=image.size;
                selectImg.frame=CGRectMake(CGRectGetWidth(delImg.frame)-size.width, CGRectGetHeight(delImg.frame)-size.height, size.width, size.height);
                selectImg.image=image;
                [delImg addSubview:selectImg];
                delImg.alpha=0.7;
            }
        }else{
            if (msg.isVedio) {
                MPMoviePlayerViewController *playerController=[[MPMoviePlayerViewController alloc]init];
                NSURL *url=[_routingTime.rtPaths[index-1] msgPath].urlInstance;
                playerController.moviePlayer.contentURL = url;
                playerController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
                [playerController.moviePlayer prepareToPlay];
                [self presentMoviePlayerViewControllerAnimated:playerController];
            }else{
                MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
                photo.photoType=PhotoShowCamera;
                NSInteger count=0;
                for (int i=0; i<_photoArr.count; i++) {
                    if ([[_photoArr[i] imageName]isEqualToString:msg.msgNum]) {
                        count=i;
                        break;
                    }
                }
                photo.currentPhotoIndex=count;
                photo.photos=_photoArr;
                photo.pifiiDelegate=self;
                [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO]  forKey:@"animation"];
                [self.navigationController pushViewController:photo animated:NO];
            }
        }
    }
  
}




-(void)addImage:(id)dataSource{
    for (RoutingMsg *msg in dataSource) {
        NSString *path=msg.msgPath;
        //        [cell.imgView setImageWithURL:[path urlInstance]];
        if (hasCachedImageWithString(path)) {
            UIImage *image=[UIImage imageWithContentsOfFile:pathForString(path)];
            //            UIImage *scaleImag=[[ImageCacher defaultCacher]scaleImage:image size:CGSizeMake(144, 144)];
            UIImage *scaleImag=[[ImageCacher defaultCacher]imageByScalingAndCroppingForSize:CGSizeMake(144, 144) sourceImage:image];
            [self.photosView addImage:scaleImag duration:msg.msgDuration];
        }else{
            UIImageView *image=[self.photosView addImage:nil duration:msg.msgDuration];
            //            NSValue *size=[NSValue valueWithCGSize:image.frame.size];
            NSValue *size =[NSValue valueWithCGSize:CGSizeMake(268, 150)];
            NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
    CGFloat gh=(self.photosView.subviews.count/4+1)*80;
    self.photosView.size=CGSizeMake(CGRectGetWidth(self.rootScrollView.frame), gh);
    self.rootScrollView.contentSize=CGSizeMake(0, gh);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark 删除图片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==-1) {
        switch (buttonIndex) {
            case 0://未知
                //拍照
                [self openCamera];
                break;
            case 1://男
                [self openLibaray];
                break;
        }
        
    }else{
        if (buttonIndex==0) {
            if (actionSheet.tag==1) {
                PSLog(@"下载");
                if (_deleteArr.count>0) {
                    [self downImageWithVedio];
                    for (UIImageView *delImg in _photosView.totalImages) {
                        if(delImg.subviews.count>0&&delImg.alpha<1.0){
                            delImg.alpha=1.0;
                            [[delImg.subviews lastObject] removeFromSuperview];
                        }
                    }
                }
                
            }else{
                PSLog(@"删除图片");
                NSMutableString *sb=[NSMutableString string];
                if (_deleteArr.count>0) {
                    for (int i=0; i<_deleteArr.count; i++) {
                        REPhoto *photo=_deleteArr[i];
                        if (i!=0) {
                            [sb appendString:@","];
                        }
                        [sb appendString:photo.imageName];
                    }
                }
                NSDictionary *param=@{
                                      @"resId":sb,
                                      @"timeId":@(_routingTime.rtId)};
                [self initPostWithURL:MyHomeURL path:@"deleteFiles" paras:param mark:@"delete" autoRequest:YES];
            }
        }

    }

}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    if ([[response objectForKey:@"returnCode"]integerValue]==200) {
        NSInteger count=_photoArr.count+_vedioArr.count;
        if (_deleteArr.count==count) {
            [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
        }else{
//            NSMutableArray *arrImg=[NSMutableArray array];
            for (REPhoto *photo in _deleteArr) {
                if (photo.isVedio) {
                    [_vedioArr removeObject:photo];
                }else{
                    [_photoArr removeObject:photo];
                }
                for (RoutingMsg *msg in _imageArr) {
                    if ([msg.msgNum isEqualToString:photo.imageName]) {
                        [_imageArr removeObject:msg];
                        break;
                    }
                }

            }
            [_deleteArr removeAllObjects];
            for (UIImageView *delImg in _photosView.totalImages) {
                if(delImg.subviews.count>0&&delImg.alpha<1.0)[delImg removeFromSuperview];
            }
        }
        [self.pifiiDelegate removeViewDataSources:nil];
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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


#pragma -mark 下载
-(void)downImageWithVedio{
    stateView.hidden=NO;
    deleteCount=_deleteArr.count;
    stateView.labelText=[NSString stringWithFormat:@"正在下载(0/%d)",deleteCount];
    NSArray *downArr=_deleteArr.array;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (REPhoto *photo in downArr) {
            if (photo.isVedio) {//下载视频
                
            }else{//下载图片
                NSURL *url=photo.imageUrl.urlInstance;
                NSData *data=[NSData dataWithContentsOfURL:url];
                if (data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_deleteArr removeObject:photo];
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    });
                }else{
                    [self performSelectorOnMainThread:@selector(imageSavingWithError:) withObject:[[NSError alloc]init] waitUntilDone:NO];
                    break;
                }
                
            }
        }
        [_deleteArr removeAllObjects];
    });

    
}

- (void)imageSavingWithError:(NSError *)error
{
    if (error) {
        stateView.labelText=@"下载失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        PSLog(@"%@",[error description]);
        stateView.labelText=@"下载失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }else{
        if (_deleteArr.count==0) {
            stateView.labelText=@"下载完成";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        }else{
            stateView.labelText=[NSString stringWithFormat:@"正在下载(%d/%d)",deleteCount-_deleteArr.count,deleteCount];
        }
//        [self showToast:@"下载成功" Long:1.5];
    }
}


#pragma -mark 分享信息
-(void)shareSDK{
    SSPublishContentMediaType contentType;
    NSString *content=_textView.text;//@"要分享的内容"
    RoutingMsg *msg=_imageArr[0];
    REPhoto *photo;
    if (msg.isVedio) {
        contentType=SSPublishContentMediaTypeVideo;
        photo=_vedioArr[0];
//        for(photo in _vedioArr){
//            if([photo.imageName isEqualToString:msg.msgNum]){
//                break;
//            }
//        }
    }else{
        contentType=SSPublishContentMediaTypeImage;
        photo=_photoArr[0];
//        for(photo in _photoArr){
//            if([photo.imageName isEqualToString:msg.msgNum]){
//                break;
//            }
//        }
    }
    NSString *url=photo.imageUrl;
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认内容"
                                                image:[ShareSDK imageWithUrl:msg.msgPath]
                                                title:@"时光路游 - 美好记忆的开始"
                                                  url:url
                                          description:@"来自于www.pifii.com"
                                            mediaType:contentType];
    //1+创建弹出菜单容器（iPad必要）
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                    message:nil
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
                                    [self showToast:@"分享成功" Long:2];
                                }
                                else if (state == SSResponseStateFail)
                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
                                    [self showToast:[NSString stringWithFormat:@"分享失败(%@)",[error errorDescription]] Long:2];
                                }
                            }];
}


-(void)pushViewDataSource:(id)dataSource{
    if ([dataSource isKindOfClass:[RoutingTime class]]) {
        _routingTime=dataSource;
        self.textView.text=_routingTime.rtTitle;
    }else{
        
    }
}


-(void)removeViewDataSources:(id)dataSource{
    NSInteger count=_imageArr.count-_vedioArr.count;
    if ([dataSource count]!=count) {
        NSMutableArray *arrImg=[NSMutableArray array];
        for (RoutingMsg *msg in _imageArr) {
            if (msg.isVedio) {
                [arrImg addObject:msg];
            }
        }
        for (int i=0; i<[dataSource count]; i++) {
            REPhoto *photo=dataSource[i];
            for (int j=0; j<_imageArr.count; j++) {
                RoutingMsg *msg=_imageArr[j];
                if ([msg.msgNum isEqualToString:photo.imageName]) {
                    [arrImg addObject:msg];
                    break;
                }
            }
        }
        for (UIImageView *image in self.photosView.totalImages) {
            [image removeFromSuperview];
        }
        _imageArr=arrImg;
        [self addImage:_imageArr];
        [self.pifiiDelegate removeViewDataSources:nil];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
    
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


@end
