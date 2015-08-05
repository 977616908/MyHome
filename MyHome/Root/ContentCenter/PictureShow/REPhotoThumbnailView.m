//
// REPhotoThumbnailView.m
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

#import "REPhotoThumbnailView.h"
#define ID  @"thumbID"
@interface REPhotoThumbnailView()

@property(nonatomic,weak)UIImageView *selectImg;
@end
@implementation REPhotoThumbnailView

@synthesize borderColor = _borderColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        _reImage = [[UIImageView alloc] init];
        _reImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) );
        _reImage.userInteractionEnabled = YES;
        // 内容模式
        _reImage.clipsToBounds = YES;
        _reImage.contentMode = UIViewContentModeScaleAspectFill;
        _reImage.tag=self.tag;
        _reImage.image=@"hm_tupian".imageInstance;
        
        
        UIImageView *selectImg=[[UIImageView alloc]init];
        _isSelect=NO;
        UIImage *image=@"ImageSelectedOn".imageInstance;
        CGSize size=image.size;
        selectImg.frame=CGRectMake(CGRectGetWidth(_reImage.frame)-size.width, CGRectGetHeight(_reImage.frame)-size.height, size.width, size.height);
        selectImg.tag=_reImage.tag;
        selectImg.image=image;
        selectImg.restorationIdentifier=@"";
        _selectImg=selectImg;
        selectImg.hidden=YES;
        [_reImage addSubview:selectImg];
        
        UIView *bgVedio=[[UIView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(_reImage.frame)-16, CGRectGetWidth(_reImage.frame), 16)];
        bgVedio.hidden=YES;
        bgVedio.backgroundColor=[UIColor clearColor];
        self.txtDuration=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, CGRectGetWidth(bgVedio.frame)-5, 12)];
        self.txtDuration.backgroundColor=[UIColor clearColor];
        self.txtDuration.textColor = [UIColor whiteColor];
        self.txtDuration.textAlignment = NSTextAlignmentRight;
        self.txtDuration.font=[UIFont systemFontOfSize:12.0f];
        self.txtDuration.text=@"0.01";
        [bgVedio addSubview:self.txtDuration
         ];
        UIImageView *imgVedio=[[UIImageView alloc]initWithFrame:CGRectMake(5, 1, 14, 14)];
        imgVedio.image=[UIImage imageNamed:@"hm_vedio"];
        [bgVedio addSubview:imgVedio];
        self.bgVedio=bgVedio;
        [_reImage addSubview:bgVedio];
        
        UIImageView *backupImg=[[UIImageView alloc]init];
        UIImage *imgback=@"hm_ybf".imageInstance;
        backupImg.image=imgback;
        CGSize sizeback=imgback.size;
        backupImg.frame=CGRectMake(0, CGRectGetMaxY(_reImage.frame)-sizeback.height, sizeback.width, sizeback.height);
        backupImg.hidden=NO;
        _backupImg=backupImg;
        [_reImage addSubview:backupImg];

        [self addSubview:_reImage];
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
////    _backupImg.hidden=!_isBackup;
//}


-(void)clearImg{
    _selectImg.hidden=YES;
    _reImage.alpha=1.0;
}

-(void)showImg{
    _selectImg.hidden=NO;
    _reImage.alpha=0.7;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    CGContextStrokeRect(context, rect);
}


@end
