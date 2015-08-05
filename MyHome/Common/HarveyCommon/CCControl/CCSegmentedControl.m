//
//  CCSegmentedControl.m
//  FlowTT_Home
//
//  Created by Harvey on 14-5-7.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "CCSegmentedControl.h"

@interface Segment  ()
{
    UIColor *_sBackColor;
    UIColor *_sTextColor;
    UIColor *_nBackColor;
    UIColor *_nTextColor;
    
    id      _delegate;
    SEL     _action;
}
@end

@implementation Segment

- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lab = CCLabelCreateWithNewValue(title, fontSize, self.bounds);
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.backgroundColor = RGBClearColor();
        [self addSubview:self.lab];
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect
{
    if (isSelect) {
        
        self.backgroundColor = _sBackColor;
        self.lab.textColor = _sTextColor;
    }else {
        
        self.backgroundColor = _nBackColor;
        self.lab.textColor = _nTextColor;
    }
    
}

- (void)setSelectedBackColor:(UIColor *)backColor textColor:(UIColor *)textColor
{
    _sBackColor = backColor;
    _sTextColor =textColor;
}

- (void)setNormalBackColor:(UIColor *)backColor textColorl:(UIColor *)textColor
{
    _nBackColor = backColor;
    _nTextColor =textColor;
}

- (void)addAction:(SEL)action runTarget:(id)target
{
    _delegate = target;
    _action = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMe)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)touchMe
{
    [_delegate performSelector:_action withParameter:self];
}

@end



@interface CCSegmentedControl ()
{
    NSArray             *_itemTitles;
    UIColor             *_borderColor;
    NSMutableArray      *_items;
    CGFloat             _fontSize;
}
@end

@implementation CCSegmentedControl

- (id)initWithFrame:(CGRect)frame borderColor:(UIColor *)broderColor titleFontSize:(CGFloat)fontSize item:(NSArray *)titleItems
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _items = [NSMutableArray new];
        _borderColor = broderColor;
        _itemTitles = titleItems;
        _fontSize = fontSize;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        [self createItem];
    }
    return self;
}

- (void)createItem
{
    CGFloat width = (self.frame.size.width - _itemTitles.count + 1)/(_itemTitles.count*1.0);
    for (int i=0; i<_itemTitles.count; i++) {
        
        Segment *s = [[Segment alloc] initWithFrame:CGRectMake((width + 1)*i, 0, width, self.frame.size.height) fontSize:_fontSize title:[_itemTitles objectAtIndex:i]];
        s.tag = i;
        [self addSubview:s];
        [s addAction:@selector(selectCurrent:) runTarget:self];
        [_items addObject:s];
        if (i < _itemTitles.count - 1) {
            
            [self addSubview:[CCView createWithFrame:CGRectMake((width+1)*i + width, 0, 1, self.frame.size.height) backgroundColor:_borderColor]];
        }
    }
}

- (void)selectCurrent:(Segment *)seg
{
    self.selectIndex = seg.tag;
    [self.delegate changeSelectIndex:self];
}

- (void)setSelectedBackColor:(UIColor *)backColor textColor:(UIColor *)textColor
{
    for (Segment *s in _items) {
        
        [s setSelectedBackColor:backColor textColor:textColor];
    }
}

- (void)setNormalBackColor:(UIColor *)backColor textColorl:(UIColor *)textColor
{
    for (Segment *s in _items) {
        
        [s setNormalBackColor:backColor textColorl:textColor];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    for (Segment *s in _items) {
        
        s.isSelect = NO;
        if (s.tag == selectIndex) {
            
            s.isSelect = YES;
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
