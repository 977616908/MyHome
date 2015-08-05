//
//  ContentViewController.m
//  MyHome
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentController.h"
#import "RoutingContentController.h"
#import "RoutingCamera.h"
#import "HgView.h"
#import "WgView.h"
#import "UIImageView+WebCache.h"
#import "RoutingWrittinController.h"

@interface ContentController ()<SDWebImageManagerDelegate>{
        SDWebImageManager *manager;
}
@property(nonatomic,weak)UIView *bgView;

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initView];
}

-(void)initView{
    CGFloat moveX=20;
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[UIColor clearColor];
    if (self.viewHg<=186) {
        bgView.frame=CGRectMake(0, 0, 211, 185);
        moveX=15;
    }else{
        bgView.frame=CGRectMake(0, 0, 250, 225);
    }
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.color=[UIColor grayColor];
    activityView.center=bgView.center;
    self.bgView=bgView;
    [bgView addSubview:activityView];
    [self.view addSubview:bgView];
    
    manager=[SDWebImageManager sharedManager];
    manager.delegate=self;
    RoutingCamera *routing=self.dataObject;
    if (routing) {
        if (routing.rtTag==-1) { //第一张
            UIView *startView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame)-moveX, CGRectGetHeight(self.bgView.frame))];
//            startView.backgroundColor=RGBCommon(247, 250, 236);
            startView.backgroundColor=[UIColor whiteColor];
            UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rt_ybright"]];
            img.frame=CGRectMake(0, 0, 75, CGRectGetHeight(startView.frame));
            [startView addSubview:img];
            _imageShow=[self getRoutingImage:startView];
            [self.bgView addSubview:startView];
        }else if(routing.rtTag==-2){ //最后一张
            UIView *endView=[[UIView alloc]initWithFrame:CGRectMake(moveX, 0, CGRectGetWidth(self.bgView.frame)-moveX, CGRectGetHeight(self.bgView.frame))];
//            endView.backgroundColor=RGBCommon(247, 250, 236) ;
            endView.backgroundColor=[UIColor whiteColor];
            UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rt_ybleft"]];
            img.frame=CGRectMake(CGRectGetWidth(endView.frame)-75, 0, 75, CGRectGetHeight(endView.frame));
            [endView addSubview:img];
            _imageShow=[self getRoutingImage:endView];
            [self.bgView addSubview:endView];
        }else if(routing.rtTag==-3){ //扉页
            UIView *pageView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame)-moveX, CGRectGetHeight(self.bgView.frame))];
            pageView.backgroundColor=[UIColor whiteColor];
            UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rt_pageleft"]];
            img.frame=pageView.bounds;
            [pageView addSubview:img];
            _imageShow=[self getRoutingImage:pageView];
            [self.bgView addSubview:pageView];
        }else{
            NSURL *smallUrl=[NSURL URLWithString:routing.rtSmallPath];
            if ([manager diskImageExistsForURL:smallUrl]) {
                UIImage *image= [manager.imageCache imageFromDiskCacheForKey:routing.rtSmallPath];
                [self showRouting:routing Image:image];
            }else{
                NSURL *pathUrl=[NSURL URLWithString:routing.rtPath];
                if ([manager diskImageExistsForURL:pathUrl]) {
                    UIImage *image= [manager.imageCache imageFromDiskCacheForKey:routing.rtPath];
                    [self showRouting:routing Image:image];
                }else{
                    [NSThread detachNewThreadSelector:@selector(downImage:) toTarget:self withObject:smallUrl];
                }
                //            [self downImage:url];
             
            }
        }

        
    }
    
}


-(void)downImage:(NSURL *)url{
    //    __weak MJPhotoView *photoView = self;
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *img=[UIImage imageWithData:data];
    CGFloat count=1;
    if (img.size.width>640) {
        count=img.size.width/640;
    }
    CGFloat wh=img.size.width/count;
    CGFloat hg=img.size.height/count;
    PSLog(@"--%f--%f",wh,hg);
    [manager downloadWithURL:url options:0 width:wh height:hg progress:^(NSUInteger receivedSize, long long expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (receivedSize > kMinProgress) {
//                _photoLoadingView.progress = (float)receivedSize/expectedSize;
//            }
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                [self showRouting:_dataObject Image:image];
            }
        });
    }];
}

-(void)showRouting:(RoutingCamera *)routing Image:(UIImage*)image{
    CGFloat moveX=0;
    if (!self.isLeft) {
        if(self.viewHg<=186){
           moveX=15;
        }else{
           moveX=20;
        }
        
    }
    UITapGestureRecognizer *imgGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGestureListener:)];
    UITapGestureRecognizer *txtGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGestureListener:)];
    if (image.size.width>image.size.height) {
        WgView *wgView=[[WgView alloc]initWithFrame:self.bgView.bounds];
        wgView.moveX=moveX;
        wgView.imgIcon.image=image;
        if (![routing.rtStory isEqualToString:@""]) {
            wgView.lbTitle.text=routing.rtStory;
        }else{
            wgView.lbTitle.hidden=YES;
        }
        wgView.lbDate.text=routing.rtDate;
        
        wgView.imgView.userInteractionEnabled=YES;
        [wgView.imgView addGestureRecognizer:imgGesture];
        
        wgView.lbTitle.tag=2;
        wgView.lbTitle.userInteractionEnabled=YES;
        [wgView.lbTitle addGestureRecognizer:txtGesture];
        _imageShow=[self getRoutingImage:wgView.bgView];
        wgView.lbTitle.hidden=NO;
        [self.bgView addSubview:wgView];
    }else{
        HgView *hgView=[[HgView alloc]initWithFrame:self.bgView.bounds];
        hgView.moveX=moveX;
        hgView.imgIcon.image=image;
        if (![routing.rtStory isEqualToString:@""]) {
            hgView.lbTitle.text=routing.rtStory;
        }else{
            hgView.lbTitle.hidden=YES;
        }
        hgView.lbDate.text=routing.rtDate;
        
        hgView.imgView.userInteractionEnabled=YES;
        [hgView.imgView addGestureRecognizer:imgGesture];
        
        hgView.lbTitle.tag=2;
        hgView.lbTitle.userInteractionEnabled=YES;
        [hgView.lbTitle addGestureRecognizer:txtGesture];
        _imageShow=[self getRoutingImage:hgView.bgView];
        hgView.lbTitle.hidden=NO;
        [self.bgView addSubview:hgView];
    }
}


-(void)onGestureListener:(UIGestureRecognizer *)gesture{
    if ([gesture.view tag]==2) {
        RoutingWrittinController *writtinController=[[RoutingWrittinController alloc]init];
        writtinController.dataObject=self.dataObject;
        [self presentViewController:writtinController animated:YES completion:nil];
    }else{
        RoutingContentController *contentController;
        if (self.viewHg<=186) {
            contentController=[[RoutingContentController alloc]initWithNibName:@"RoutingContentController640x960" bundle:nil];
        }else{
            contentController=[[RoutingContentController alloc]initWithNibName:@"RoutingContentController" bundle:nil];
        }
        contentController.animView=gesture.view;
        [contentController show];
//        [self presentViewController:contentController animated:NO completion:nil];
    }
}


#pragma -mark 获取当前屏幕内容
-(UIImage *)getRoutingImage:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 3);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    return image;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
