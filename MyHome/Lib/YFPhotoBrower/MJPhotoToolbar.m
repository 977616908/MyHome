//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
//#import "AppDelegate.h"

@interface MJPhotoToolbar()<UIActionSheetDelegate>
{
//    AppDelegate * app;
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_deleteBtn;
}
@end

@implementation MJPhotoToolbar

@synthesize Delegate;
@synthesize DeleteImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    if (_isPhoto) {
        _saveImageBtn.hidden=YES;//暂时隐藏
        [_saveImageBtn setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
    }else{
        [_saveImageBtn setImage:[UIImage imageNamed:@"hm_baocun"] forState:UIControlStateNormal];
    }
//    [_saveImageBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
  
    [self addSubview:_saveImageBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deleteBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-20-btnWidth, 0, btnWidth, btnWidth);
    _deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
//    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [_deleteBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden=NO;//暂时隐藏
    [self addSubview:_deleteBtn];
    
}

-(void)deleteImage
{
    PSLog(@"--删除--");
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil];
    [action showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"删除照片"]) {
        if ( [Delegate respondsToSelector:@selector(DeleteThisImage:)] ) {
            [Delegate DeleteThisImage:_currentPhotoIndex];
        }
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"下载到本地"]){
        if ([Delegate respondsToSelector:@selector(DownThisImage:)]) {
            [Delegate DownThisImage:_currentPhotoIndex];
            MJPhoto *photo = _photos[_currentPhotoIndex];
            photo.save = YES;
            _saveImageBtn.enabled = NO;
        }
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"备份到云端"]){
        if ([Delegate respondsToSelector:@selector(UpLoadThisImage:)]) {
            [Delegate UpLoadThisImage:_currentPhotoIndex];
            MJPhoto *photo = _photos[_currentPhotoIndex];
            photo.save = YES;
            _saveImageBtn.enabled = NO;
        }
    }
}

- (void)saveImage
{
    UIActionSheet *action;
    if (_isPhoto) {
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"备份到云端" otherButtonTitles:nil];
    }else{
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载到本地" otherButtonTitles:nil];
    }
    [action showInView:self];
}


- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    int nowPage = (int)_currentPhotoIndex + 1;
    int totalPage = (int)_photos.count;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", nowPage,totalPage];
    if(_photos.count<=0||_photos.count==_currentPhotoIndex)return;
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = !photo.save;
    if (photo.save) {
        if (_isPhoto) {
            [_saveImageBtn setImage:[UIImage imageNamed:@"hm_shanchuan_selector"] forState:UIControlStateNormal];
        }else{
           [_saveImageBtn setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
        }
    }else{
        if (_isPhoto) {
            [_saveImageBtn setImage:[UIImage imageNamed:@"hm_shanchuan"] forState:UIControlStateNormal];
        }else{
            [_saveImageBtn setImage:[UIImage imageNamed:@"hm_baocun"] forState:UIControlStateNormal];
        }
    }
    
//    _deleteBtn.enabled=photo.image !=nil;
}

@end
