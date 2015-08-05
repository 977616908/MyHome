//
//  DimensionalCodeReaderViewController.h
//  BarcodeDemo
//
//  Created by Harvey on 13-10-15.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DimensionalCode.h"

@protocol DimensionalCodeReaderViewControllerDelegate < NSObject >
@required
- (void)DimensionalCodeReaderWithContent:(NSString *)myContent
                                                             fromImage:(UIImage *)image;

@end


@interface DimensionalCodeReaderViewController : UIViewController<ZBarReaderViewDelegate>
{
    CGSize viewSize;
    ZBarReaderView *_readview;
    id<DimensionalCodeReaderViewControllerDelegate> _scanDelegate;
    UIView *_scanLine;
}

@property (nonatomic,strong) ZBarReaderView *readview;
@property (nonatomic,strong) id<DimensionalCodeReaderViewControllerDelegate> scanDelegate;
@property (nonatomic,assign) BOOL  isEnbleScanLine;
@property (nonatomic,strong)  UIView *scanLine;

@end
