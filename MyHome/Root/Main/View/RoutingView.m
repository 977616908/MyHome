//
//  LeafScrollView.m
//  LeafScrollView
//
//  Created by Wang on 14-5-12.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import "RoutingView.h"

#define TOP_BG_HIDE 35.0f
#define TOP_FLAG_HIDE 55.0f
#define RATE 2
#define SWITCH_Y -TOP_FLAG_HIDE
#define ORIGINAL_POINT CGPointMake(self.bounds.size.width/2, -20)
#define TOP_SCROLL_SPACE 120.0f

@interface RoutingView()<UIScrollViewDelegate>{
    CGFloat angle;
    BOOL stopRotating;
}

@property (weak, nonatomic) IBOutlet  UIScrollView *scrollView;

//@property (weak, nonatomic)  UIView *containerView;
@end

@implementation RoutingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"RoutingView" owner:nil options:nil][0];
        [self initView];
    }
    return self;
}


-(void)initView{
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate  = self;
    self.scrollView.scrollsToTop = NO;
    self.backgroundColor=[UIColor clearColor];
    [self prepare];
}

#pragma scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat rate = point.y/scrollView.contentSize.height;
    if(point.y+TOP_BG_HIDE>5){
        self.topImg.frame = CGRectMake(0, (-TOP_BG_HIDE)*(1+rate*RATE), self.topImg.frame.size.width, self.topImg.frame.size.height);
    }
    if(!_isLoading){
        if(scrollView.dragging){
            self.refreshImgView.transform = CGAffineTransformMakeRotation(rate*30);
        }else{
            //判断位置
            if(point.y<SWITCH_Y){//触发刷新状态
                [self startRotate];
            }
        }
    }
}


#pragma method
-(void)prepare{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+1);
}
-(void)setRefreshImage:(UIImage *)image{
    self.refreshImgView.image = image;
}
-(void)setBgImage:(UIImage *)image{
    if(image){
    
        self.topImg.image = image;
        CGSize size = image.size;
        CGRect rect = self.topImg.frame;
        rect.size.width = self.bounds.size.width;
        rect.size.height = self.bounds.size.width * (size.height/size.width);
        self.topImg.frame = rect;
    }
}
-(void)setContentView:(UIView *)contentView{
    if(contentView){
        _contentView = contentView;
        [self addSubview:contentView];
    }
}

-(void)startRotate{
    _isLoading = YES;
    stopRotating = NO;
    angle = 0;
    [self rotateRefreshImage];
    if(self.beginUpdatingBlock){
        self.beginUpdatingBlock(self);
    }
}

-(void)endUpdating{
    stopRotating = YES;
}


-(void)rotateRefreshImage{
    self.refreshImgView.alpha = 1.0;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.refreshImgView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 10;
        if(!stopRotating){
            [self rotateRefreshImage];
        }else{
            //上升隐藏
            [UIView animateWithDuration:0.2 animations:^{
                self.refreshImgView.alpha = 0.0;
            } completion:^(BOOL finished) {
                _isLoading = NO;
            }];
        }
    }];
}

@end
