//
// REPhotoThumbnailsCell.m
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

#import "REPhotoThumbnailsCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "REPhotoCollectionController.h"
#import "REPhotoMoreController.h"
#import "REPhotoController.h"
#import "PhotoSelectController.h"
#import "RoutingListController.h"
#define ID @"ThumbID"
//static NSMutableArray *_selectArr;
@interface  REPhotoThumbnailsCell(){
    NSArray *arrayThumb;
    
}
@property(nonatomic,weak)REPhotoThumbnailView *thumbImg1;
@property(nonatomic,weak)REPhotoThumbnailView *thumbImg2;
@property(nonatomic,weak)REPhotoThumbnailView *thumbImg3;
@property(nonatomic,weak)REPhotoThumbnailView *thumbImg4;

@end
@implementation REPhotoThumbnailsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //        for (int i=0; i < 4; i++) {
        //            REPhotoThumbnailView *thumbnailView = [[REPhotoThumbnailView alloc] initWithFrame:CGRectMake(6+(72 * i + 6 * i), 6, 72, 72)];
        //            [thumbnailView setHidden:YES];
        //            thumbnailView.tag = i;
        //            [self addSubview:thumbnailView];
        //        }
        [self initView];
    }
    return self;
}

-(void)initView{
    REPhotoThumbnailView *thumbnailView1 = [[REPhotoThumbnailView alloc] initWithFrame:CGRectMake(7, 6, 72, 72)];
    thumbnailView1.tag=0;
    thumbnailView1.hidden=YES;
    
    REPhotoThumbnailView *thumbnailView2 = [[REPhotoThumbnailView alloc] initWithFrame:CGRectMake(13+72, 6, 72, 72)];
    thumbnailView2.tag=1;
    thumbnailView2.hidden=YES;
    
    REPhotoThumbnailView *thumbnailView3 = [[REPhotoThumbnailView alloc] initWithFrame:CGRectMake(19+72*2, 6, 72, 72)];
    thumbnailView3.tag=2;
    thumbnailView3.hidden=YES;
    
    REPhotoThumbnailView *thumbnailView4 = [[REPhotoThumbnailView alloc] initWithFrame:CGRectMake(25+72*3, 6, 72, 72)];
    thumbnailView4.tag=3;
    thumbnailView4.hidden=YES;
    
    _thumbImg1=thumbnailView1;
    _thumbImg2=thumbnailView2;
    _thumbImg3=thumbnailView3;
    _thumbImg4=thumbnailView4;
    arrayThumb=@[_thumbImg1,_thumbImg2,_thumbImg3,_thumbImg4];
//    if (!_selectArr) {
//        _selectArr=[NSMutableArray array];
//    }
    [self addSubview:thumbnailView1];
    [self addSubview:thumbnailView2];
    [self addSubview:thumbnailView3];
    [self addSubview:thumbnailView4];
}


- (void)addPhoto:(REPhoto *)photo{
    [_photos addObject:photo];
}

- (void)addPhotoWithArray:(NSArray *)arr;{
    if (arr) {
        [self removeAllPhotos];
        [_photos addObjectsFromArray:arr];
    }
}

- (void)removeAllPhotos
{
    [_photos removeAllObjects];
}

-(void)refresh{
//    if([_photos count]==_thumbImg4.tag&&_arryGroup.count>19&&_photoType==REPhotoNone){
//        [_thumbImg4 setHidden:NO];
//        _thumbImg4.reImage.image=[UIImage imageNamed:@"hm_gengduo"];
//        [_thumbImg4.reImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreClick:)] ];
//    }else{
        for (REPhotoThumbnailView *view in arrayThumb) {
            view.restorationIdentifier=@"";
            view.hidden=YES;
        }
//    }
    for(int i=0;i<_photos.count;i++){
        REPhoto *photo=_photos[i];
        NSString *path=photo.imageUrl;
        REPhotoThumbnailView *thumbnailView=arrayThumb[i];
        thumbnailView.reImage.tag=thumbnailView.tag;
        thumbnailView.restorationIdentifier=ID;
        thumbnailView.hidden=NO;
        thumbnailView.backupImg.hidden=!photo.isBackup;
        if (photo.isVedio) {
            thumbnailView.bgVedio.hidden=NO;
            thumbnailView.txtDuration.text=photo.duration;
        }else{
            thumbnailView.bgVedio.hidden=YES;
        }
        if (_selectOrder) {
//            if([_selectOrder indexOfObject:photo]!= NSNotFound){
//                [thumbnailView showImg];
//            }else{
//                [thumbnailView clearImg];
//            }
            if ([_selectOrder containsObject:photo]) {
                [thumbnailView showImg];
            }else{
                [thumbnailView clearImg];
            }
        }
        if (photo.image) {
            [thumbnailView.reImage setImage:photo.image];
        }else{
            if (hasCachedImageWithString(path)) {
                if (_photoType==REPhotoSelect) {
                    UIImage *image=[UIImage imageWithContentsOfFile:pathForString(path)];
                    //            UIImage *scaleImag=[[ImageCacher defaultCacher]scaleImage:image size:CGSizeMake(144, 144)];
                    photo.image=[[ImageCacher defaultCacher]imageByScalingAndCroppingForSize:CGSizeMake(144, 144) sourceImage:image];
                    [thumbnailView.reImage setImage:photo.image];
                }else{
                    photo.image=[UIImage imageWithContentsOfFile:pathForString(path)];
                    [thumbnailView.reImage setImage:photo.image];
                }
            }else{
                NSDictionary *dict;
                if (_photoType==REPhotoSelect) {
                    NSValue *size =[NSValue valueWithCGSize:CGSizeMake(268, 150)];
                    dict=@{@"url":path,@"imageView":thumbnailView.reImage,@"size":size};
                }else{
                    dict=@{@"url":path,@"imageView":thumbnailView.reImage};
                }
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
        }
        if (_photoType==REPhotoNone||_photoType==REPhotoOther) {
            [thumbnailView.reImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBtnClick:)] ];
        }else{
            [thumbnailView.reImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImgClick:)] ];
        }
    }
}


//- (void)refresh
//{
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:[REPhotoThumbnailView class]]) {
//            REPhotoThumbnailView *thumbnailView = (REPhotoThumbnailView *)view;
//            if (thumbnailView.tag < [_photos count]) {
//                [thumbnailView setHidden:NO];
//                REPhoto *photo=_photos[thumbnailView.tag];
////                NSURL *paths =ROUTER_FILE_WHOLEDOWNLOAD(photo.imageUrl).encodedString.urlInstance;
//                if (_photoType==REPhotoPicker) {
//                    if (photo.image) {
//                        [thumbnailView.reImage setImage:photo.image];
//                    }
//                }else{
//                    NSString *path=photo.imageUrl;
//                    //                PSLog(@"%@",paths);
//                    if (hasCachedImageWithString(path)) {
//                        //                    NSString *hasCached=hashCodeForString(path);
//                        if (photo.image) {
//                            PSLog(@"----Test-----");
//                            [thumbnailView.reImage setImage:photo.image];
//                        }else{
//                            NSString *pathStr=pathForString(path);
//                            //                    PSLog(@"---%@---",pathStr);
//                            photo.image=[UIImage imageWithContentsOfFile:pathStr];
//                            [thumbnailView.reImage setImage:photo.image];
//                            //                        [photo setValue:pathStr forKey:hasCached];
//                        }
//
//                    }else{
//                        NSDictionary *dict=@{@"url":path,@"imageView":thumbnailView.reImage};
//                        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
//
//                    }
//                    thumbnailView.reImage.tag=thumbnailView.tag;
//                    [thumbnailView.reImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBtnClick:)] ];
//                }
//            }else if(thumbnailView.tag==[_photos count]&&_arryGroup.count>19&&_photoType==REPhotoNone){
//                [thumbnailView setHidden:NO];
//                thumbnailView.reImage.image=[UIImage imageNamed:@"hm_gengduo"];
//                [thumbnailView.reImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreClick:)] ];
//            }
//            else{
//                [thumbnailView setHidden:YES];
//            }
//
//        }
//    }
//}

-(void)onBtnClick:(UITapGestureRecognizer *)imageTap{
    REPhoto *rePhoto=_photos[imageTap.view.tag];
    MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
    if(_photoType==REPhotoOther){
       photo.photoType=PhotoShowNone;
    }else if(_photoType==REPhotoSelect){
       photo.photoType=PhotoShowCamera;
    }else{
       photo.photoType=PhotoShowRouter;
    }
    photo.currentPhotoIndex=[_arryGroup indexOfObject:rePhoto];
    photo.photos=[NSMutableArray arrayWithArray:_arryGroup];
    photo.navigationItem.title=@"图片预览";
    REPhotoCollectionController *controller=(REPhotoCollectionController*)self.superController;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.type = kCATransitionFade;//101
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [controller.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    [controller.navigationController pushViewController:photo animated:NO];
    PSLog(@"imageTag==%d", (int)imageTap.view.tag );
}


-(void)onImgClick:(UITapGestureRecognizer *)gesture{
    UIImageView *reImg = (UIImageView *)gesture.view;
    REPhoto *rePhoto=_photos[reImg.tag];
    UIImageView *selectImg=[reImg subviews][0];
    selectImg.hidden=!selectImg.isHidden;
    if (selectImg.isHidden) {
        reImg.alpha=1.0;
        [_selectOrder removeObject:rePhoto];
    }else{
        reImg.alpha=0.7;
        [_selectOrder addObject:rePhoto];
    }
    if(self.photoType==REPhotoPicker){
        REPhotoController *controller=(REPhotoController*)self.superController;
        UIButton *btn01=(UIButton *)controller.arrTag[0] ;
        UIButton *btn02=(UIButton *)controller.arrTag[1] ;
        if(_selectOrder.count==0){
            [controller.btnPopover alterNormalTitle:@"选择项目"];
            [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan_selector"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
            btn01.enabled=NO;
            btn02.enabled=NO;
        }else{
            [controller.btnPopover alterNormalTitle:[NSString stringWithFormat:@"已选%d项",_selectOrder.count]];
            [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
            btn01.enabled=YES;
            btn02.enabled=YES;
        }
    }else if(self.photoType==REPhotoSelect){
        if ([self.superController isKindOfClass:[PhotoSelectController class]]) {
            PhotoSelectController *controller=(PhotoSelectController*)self.superController;
            if(_selectOrder.count==0){
                [controller.btnPopover alterNormalTitle:@"选择项目"];
                controller.navigationItem.rightBarButtonItem.enabled = NO;
            }else{
                controller.navigationItem.rightBarButtonItem.enabled = YES;
                [controller.btnPopover alterNormalTitle:[NSString stringWithFormat:@"已选%d项",_selectOrder.count]];
            }
        }else{
            RoutingListController *controller=(RoutingListController*)self.superController;
            if(_selectOrder.count==0){
                controller.lbSelect.text=@"请选择25张照片";
            }else{
                controller.lbSelect.text=[NSString stringWithFormat:@"已选%d/25张照片",_selectOrder.count];
            }
        }
       
    }else{
        REPhotoCollectionController *controller=(REPhotoCollectionController*)self.superController;
        UIButton *btn01=(UIButton *)controller.arrTag[0] ;
        UIButton *btn02=(UIButton *)controller.arrTag[1] ;
        UIButton *btn03=(UIButton *)controller.arrTag[2] ;
        if(_selectOrder.count==0){
            controller.title=@"选择项目";
            [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
            btn01.enabled=YES;
            btn02.enabled=NO;
            btn03.enabled=NO;
        }else{
            controller.title=[NSString stringWithFormat:@"已选择%d张照片",_selectOrder.count];
            [btn01 setImage:[UIImage imageNamed:@"hm_shanchuan_selector"] forState:UIControlStateNormal];
            [btn02 setImage:[UIImage imageNamed:@"hm_baocun"] forState:UIControlStateNormal];
            [btn03 setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
            btn01.enabled=NO;
            btn02.enabled=YES;
            btn03.enabled=YES;
        }
    }
}

-(void)onMoreClick:(UITapGestureRecognizer *)imageTap{
    PSLog(@"---onMore---");
    REPhotoMoreController *moreController=[[REPhotoMoreController alloc]init];
    moreController.moreImageArr=_arryGroup;
    moreController.detailTitle=self.detailTitle;
    REPhotoCollectionController *controller=(REPhotoCollectionController*)self.superController;
    [controller.navigationController pushViewController:moreController animated:YES];
    
}

//-(void)prepareForReuse{
//    //    [self removeAllPhotos];
//    for (int i=0; i<arrayThumb.count; i++) {
//        REPhotoThumbnailView *thumbnailView=arrayThumb[i];
//        if (![thumbnailView.restorationIdentifier isEqualToString:ID]&&thumbnailView.isHidden) {
//            [thumbnailView removeFromSuperview];
//        }
//    }
//    [super prepareForReuse];
//    PSLog(@"----prepareForReuse----");
//    
//    ////    [self refresh];
//}

@end
