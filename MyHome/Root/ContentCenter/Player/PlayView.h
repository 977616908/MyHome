//
//  PlayView.h
//  MyHome
//
//  Created by Harvey on 14-8-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView

@property (nonatomic,strong) CCLabel *title;
@property (nonatomic,strong) CCImageView *preview;
@property (nonatomic,strong) CCImageView *backView;

@end



@interface MusicCell : UICollectionViewCell

@property (nonatomic,strong) PlayView *pv;

@end





