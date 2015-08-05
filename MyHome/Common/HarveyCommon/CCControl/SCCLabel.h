//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentMiddle = 0,// default
    VerticalAlignmentTop,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface SCCLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

- (void)addAction:(SEL)action runObject:(id)obj;

@end
