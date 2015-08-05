//
//  CCSegmentedControl.h
//  FlowTT_Home
//
//  Created by Harvey on 14-5-7.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Segment : CCView

@property (nonatomic,strong) CCLabel *lab;
@property(nonatomic,assign) BOOL isSelect;

- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize title:(NSString *)title;
- (void)setSelectedBackColor:(UIColor *)backColor textColor:(UIColor *)textColor;
- (void)setNormalBackColor:(UIColor *)backColor textColorl:(UIColor *)textColor;

@end



@protocol CCSegmentedControlDelegate <NSObject>

- (void)changeSelectIndex:(id)obj;

@end

@interface CCSegmentedControl : UIView

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) id delegate;

- (id)initWithFrame:(CGRect)frame borderColor:(UIColor *)broderColor titleFontSize:(CGFloat)fontSize item:(NSArray *)titleItems;
- (void)setSelectedBackColor:(UIColor *)backColor textColor:(UIColor *)textColor;
- (void)setNormalBackColor:(UIColor *)backColor textColorl:(UIColor *)textColor;

@end
