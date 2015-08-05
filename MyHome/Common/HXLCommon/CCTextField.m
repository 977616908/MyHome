//
//  CCTextField.m
//  MyHome
//
//  Created by HXL on 14/11/17.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CCTextField.h"
@interface CCTextField()
@end
@implementation CCTextField




//控制 placeHolder 的位置，左右缩 15
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

// 按制文本的位置，左右缩 15
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

@end
