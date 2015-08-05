//
//  CCScrollView.m
//  Own
//
//  Created by Harvey on 13-9-8.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import "CCScrollView.h"

@implementation CCScrollView

+ (CCScrollView *)createWithFrame:(CGRect)frame
{
    CCScrollView *scrollView = [[self alloc] initWithFrame:frame];
    return scrollView;
}

UIKIT_EXTERN CCScrollView *CCScrollViewCreateNoneIndicatorWithFrame(CGRect frame,id target,BOOL pagingEnabled)
{
    CCScrollView *_scrollView = [CCScrollView createWithFrame:frame];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = target;
    _scrollView.pagingEnabled = pagingEnabled;
    return _scrollView;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging)
    {
        [[self nextResponder]touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
    [self.touchDelegate scrollViewWithTouch:touches withEvent:event scrollView:self];
}

@end
