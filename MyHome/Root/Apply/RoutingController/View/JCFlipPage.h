//
//  JCFlipPage.h
//  JCFlipPageView
//
//  Created by ThreegeneDev on 14-8-8.
//  Copyright (c) 2014年 JimpleChen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString const* kJCFlipPageDefaultReusableIdentifier = @"kJCFlipPageDefaultReusableIdentifier";


@interface JCFlipPage : UIView

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,weak)UIImageView *startImg;
@property (nonatomic,weak)UIImageView *endImg;
@property (nonatomic,strong)id superController;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

@end
