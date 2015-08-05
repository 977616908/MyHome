//
//  RoutingCell.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCell.h"
#import "RoutingMsg.h"
#import "REPhoto.h"
#import "RoutingDetailController.h"
#import "RoutingTimeController.h"
#import "MJPhotoBrowser.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RoutingCell (){
    NSArray *arrImgs;
}
#define HEIGHT 150
#define WEITH 268
#define DOWNPROGRESS @"DOWNPROGRESS"

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbMM;
@property (weak, nonatomic) UILabel *lbProgress;
@property (weak, nonatomic) UIView *lbView;
@property(nonatomic,strong)id superController;
@property (weak, nonatomic) IBOutlet UIImageView *imageAdd;
- (IBAction)onDetailClick:(id)sender;

@end

@implementation RoutingCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTarget:(id)target tableView:(UITableView *)tableView {
   static NSString *ID=@"RoutingTime";
    RoutingCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[RoutingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.superController=target;
    }
    cell.bgView.layer.masksToBounds=YES;
    cell.bgView.layer.cornerRadius=2.5;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"RoutingCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoutingTime:(RoutingTime *)routingTime{
    _routingTime=routingTime;
    self.lbTitle.text=routingTime.rtTitle;
    self.lbCount.text=routingTime.rtNums;
    self.lbMM.text=[self getDate:routingTime.rtDate type:@"MM月"];
    self.lbDay.text=[self getDate:routingTime.rtDate type:@"dd"];
    NSArray *arr=routingTime.rtSmallPaths;
    if (arr&&arr.count>0) {
        [self addImageCount:arr.count];
        for (int i=0; i<arrImgs.count; i++) {
            UIImageView *image=arrImgs[i];
            image.tag=i;
            image.userInteractionEnabled=YES;
            [image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)]];
            RoutingMsg *msg=routingTime.rtSmallPaths[i];
            if (msg.isVedio) {
                [self addVedioImg:image duration:msg.msgDuration];
            }
            NSString *path=msg.msgPath;
            //        [cell.imgView setImageWithURL:[path urlInstance]];
            CGSize imgSize=image.frame.size;
            if (hasCachedImageWithString(path)) {
                UIImage *img=[UIImage imageWithContentsOfFile:pathForString(path)];
////                image.image=img;
                if (img.size.width>(imgSize.width+10)||img.size.height>(imgSize.height+10)) {
                    //                    image.image=[[ImageCacher defaultCacher]scaleImage:img size:CGSizeMake(imgSize.width, imgSize.height)];
                    //                   image.image=[[ImageCacher defaultCacher]compressImage:img sizewidth:imgSize.width*2];
                    //                image.image=[[ImageCacher defaultCacher]compressImage:img sizeheight:imgSize.height*2];
                    image.image=[[ImageCacher defaultCacher]imageByScalingAndCroppingForSize:CGSizeMake(imgSize.width*2, imgSize.height*2) sourceImage:img];
                }else{

                    image.image=img;
                }
            }else{
                NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH, HEIGHT)];
//                NSValue *size=[NSValue valueWithCGSize:imgSize];
                NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
        }
    }
}

-(void)setRoutingDown:(RoutingDown *)routingDown{
    _routingDown=routingDown;
    NSDictionary *param=routingDown.params;
    self.lbTitle.text=param[@"title"];
    self.lbCount.text=[NSString stringWithFormat:@"%d",routingDown.downList.count];
    self.lbMM.text=[self getDate:nil type:@"MM月"];
    self.lbDay.text=[self getDate:nil type:@"dd"];
    NSArray *arr=_routingDown.downList;
    if (arr) {
        [self addImageCount:arr.count];
        for (int i=0; i<arrImgs.count; i++) {
            UIImageView *image=arrImgs[i];
            REPhoto *photo=arr[i];
            CGSize size=image.frame.size;
//            UIImage *scaleImg=[[ImageCacher defaultCacher]scaleImage:photo.image size:CGSizeMake(size.width*2, size.height*2)];
            image.image=[[ImageCacher defaultCacher]imageByScalingAndCroppingForSize:CGSizeMake(size.width*2, size.height*2) sourceImage:photo.image];
//            image.image=scaleImg;
            if (photo.isVedio) {
                [self addVedioImg:image duration:photo.duration];
            }
        }
    }
    UIView *lbView=[[UIView alloc]initWithFrame:CGRectMake(2, 2, CGRectGetWidth(self.bgView.frame)-5, 15)];
    lbView.backgroundColor=RGBAlpha(0, 0, 0, 0.7);
    UIActivityIndicatorView *start=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    start.frame=CGRectMake(5, 2, 10, 10);
    start.transform=CGAffineTransformMakeScale(0.5, 0.5);
    [start startAnimating];
    [lbView addSubview:start];
    UILabel *lbDown=[[UILabel alloc]initWithFrame:CGRectMake(20, 0,CGRectGetWidth(self.bgView.frame), CGRectGetHeight(lbView.frame))];
    [lbDown setFont:[UIFont systemFontOfSize:10.0]];
    lbDown.textColor=[UIColor whiteColor];
    lbDown.text=@"上传中...";
    self.lbProgress=lbDown;
    [lbView addSubview:lbDown];
    self.lbView=lbView;
    [self.bgView addSubview:lbView];
    [PSNotificationCenter addObserver:self selector:@selector(onProgressChange:) name:DOWNPROGRESS object:nil];
}

-(void)addImageCount:(NSInteger)count{
    NSMutableArray *imags=[NSMutableArray array];
    if (count==1) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH, HEIGHT)];
        image.image=[UIImage imageNamed:@"hm_tupian_da"];
        [self.bgView addSubview:image];
        [imags addObject:image];
    }else if(count==2){
        for (int i=0; i<2; i++) {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2+(WEITH/2)*i,2 ,WEITH/2-1, HEIGHT)];
            image.image=[UIImage imageNamed:@"hm_tupian_center"];
            [self.bgView addSubview:image];
            [imags addObject:image];
        }
    }else{
        for (int i=0; i<3; i++) {
            if (i==0) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH/2-1, HEIGHT-1)];
                image.image=[UIImage imageNamed:@"hm_tupian_center"];
                [self.bgView addSubview:image];
                [imags addObject:image];
            }else{
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(WEITH/2+2,2+(HEIGHT/2)*(i-1), WEITH/2, HEIGHT/2-1)];
                image.image=[UIImage imageNamed:@"hm_tupian_small"];
                [self.bgView addSubview:image];
                [imags addObject:image];
            }
        }
    }
    arrImgs=imags;
}


-(void)addVedioImg:(UIImageView *)image duration:(NSString *)duration{
    UIView *bgVedio=[[UIView alloc]initWithFrame:CGRectMake(2, 2, CGRectGetWidth(image.frame), 16)];
    bgVedio.backgroundColor=[UIColor clearColor];
    UIImageView *imgVedio=[[UIImageView alloc]initWithFrame:CGRectMake(2, 0, 14, 14)];
    imgVedio.image=[UIImage imageNamed:@"hm_vedio"];
    [bgVedio addSubview:imgVedio];
    UILabel *txtDuration=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgVedio.frame)+5,0, CGRectGetWidth(bgVedio.frame), 12)];
    txtDuration.backgroundColor=[UIColor clearColor];
    txtDuration.textColor = [UIColor whiteColor];
    txtDuration.font=[UIFont systemFontOfSize:12.0f];
    txtDuration.text=duration;
    [bgVedio addSubview:txtDuration];
    
    [image addSubview:bgVedio];
}

-(void)setIsAdd:(BOOL)isAdd{
    if (isAdd) {
        self.imageAdd.hidden=!isAdd;
        self.lbMM.text=[self getDate:nil type:@"MM月"];
        self.lbDay.text=[self getDate:nil type:@"dd"];
        self.imageAdd.userInteractionEnabled=YES;
        self.imageAdd.tag=10;
        RoutingTimeController *controller=self.superController;
        [self.imageAdd addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:controller.self action:NSSelectorFromString(@"onCameraClick:")]];
    }
}

-(void)setImgName:(NSString *)imgName{
    _imgName=imgName;
    self.imgTag.image=[UIImage imageNamed:imgName];
}

-(NSString *)getDate:(NSString *)date type:type{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    NSDate *dt=[NSDate date];
    if (date) {
        [sdf setDateFormat:@"yyyy-MM-dd"];
        dt=[sdf dateFromString:date];
    }
    [sdf setDateFormat:type];
    return [sdf stringFromDate:dt];
}

-(void)onProgressChange:(NSNotification *)not{
//    @"count":@(_photoArr.count),
//    @"totalCount":@(10),
//    @"progress":@(fraction*100)
    NSDictionary *param=not.userInfo;
    NSInteger totalCount=[param[@"totalCount"] integerValue];
    NSInteger count=totalCount-[param[@"count"] integerValue]+1;
    CGFloat progress=[param[@"progress"] floatValue];
    NSString *date=param[@"date"];
    if ([date isEqualToString:_routingDown.params[@"date"]]) {
        self.lbProgress.text=[NSString stringWithFormat:@"上传中...(%d/%d)%.2f%%",totalCount,count,progress];
        if (progress>=100&&totalCount==count) {
            [PSNotificationCenter removeObserver:self name:DOWNPROGRESS object:nil];
            [self.lbView removeFromSuperview];
        }
//        PSLog(@"--[%d]--[%f]-[%d]",totalCount,progress,count);
    }
    //    lbDown.text=@"上传中...(2/1)37.0%";
  
}

-(void)onTapClick:(UITapGestureRecognizer *)gesture{
    RoutingMsg *msg=_routingTime.rtSmallPaths[gesture.view.tag];
    RoutingTimeController *controller=self.superController;
    if (msg.isVedio) {
        MPMoviePlayerViewController *playerController=[[MPMoviePlayerViewController alloc]init];
        NSURL *url=[_routingTime.rtPaths[gesture.view.tag] msgPath].urlInstance;
        playerController.moviePlayer.contentURL = url;
        playerController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
        [playerController.moviePlayer prepareToPlay];
        [controller presentMoviePlayerViewControllerAnimated:playerController];
    }else{
        NSMutableArray *arrPhoto=[NSMutableArray array];
        NSInteger tag=0;
        for (int i=0; i<_routingTime.rtPaths.count; i++) {
            if (![_routingTime.rtSmallPaths[i] isVedio]) {
                RoutingMsg *rtMsg=_routingTime.rtPaths[i];
                REPhoto *photo=[[REPhoto alloc]init];
                photo.imageUrl=rtMsg.msgPath;
                photo.date=_routingTime.rtDate;
                photo.isVedio=rtMsg.isVedio;
                photo.imageName=rtMsg.msgNum;
                photo.routingId=[NSString stringWithFormat:@"%d",_routingTime.rtId];
                if ([msg.msgNum isEqualToString:rtMsg.msgNum]) {
                    tag=arrPhoto.count;
                }
                [arrPhoto addObject:photo];
            }
        }
        NSLog(@"tap--[%d]",tag);
        MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
        photo.photoType=PhotoShowCamera;
        photo.currentPhotoIndex=tag;
        photo.photos=arrPhoto;
        photo.pifiiDelegate=self.superController;
        [controller.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO]  forKey:@"animation"];
        [controller.navigationController pushViewController:photo animated:NO];
    }
    
}

- (IBAction)onDetailClick:(id)sender {
    RoutingTimeController *controller=self.superController;
    if (_routingDown) {
        [controller showToast:@"时光片段正在分享..." Long:1.5];
        return;
    }
    RoutingDetailController *detailController=[[RoutingDetailController alloc]init];
    detailController.routingTime=_routingTime;
    detailController.pifiiDelegate=self.superController;
    [controller.navigationController pushViewController:detailController animated:YES];
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
