//
//  CustomToast.m
//  P2PCamera
//
//  Created by mac on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomToast.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomToast

+ (void)__show : (UIView*) aView {
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDidStopSelector:@selector(__animationDidStop:__finished:__context:)];
    aView.alpha = 1.0f;
    [UIView commitAnimations];
}

+ (void)__hide : (UIView*) aView {
    [self performSelectorOnMainThread:@selector(__hideThread:) withObject:aView waitUntilDone:NO];
    
}

+ (void)__hideThread : (UIView*) aView {
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationDidStopSelector:@selector(__animationDidStop:__finished:__context:)];
    aView.alpha = 0.0f;
    [UIView commitAnimations];
}

+ (void)__animationDidStop:(NSString *)animationID __finished:(NSNumber *)finished __context:(void *)context {
//    UIView *aView = (UIView*)context;
    if ([animationID isEqualToString:@"hide"]) {
        //NSLog(@"hide....");
//        [aView removeFromSuperview];
//        [aView release];
    }
    else if ([animationID isEqualToString:@"show"]) {
        // NSLog(@"show...");
        //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(__hide:) userInfo:aView repeats:NO];
        [self performSelector:@selector(__hide:) withObject:nil afterDelay:1];
    }
}

+ (void) showWithText: (NSString*) strText superView: (UIView*) superView bLandScap:(BOOL) bLandScap
{
    float screenWidth, screenHeight;
    if (!bLandScap) {
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    }else {
        screenWidth = [UIScreen mainScreen].bounds.size.height;
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    }    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)] ;
    [textLabel setNumberOfLines:0];    
    UIFont *font = [UIFont systemFontOfSize:15];
    //CGSize size = CGSizeMake(170,100); 
//    textLabel.lineBreakMode = UILineBreakModeWordWrap; 
    //CGSize labelsize = [strText sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGSize labelsize = [strText sizeWithFont:font];
    
    float width = labelsize.width + 10;
    float height = labelsize.height;
    float x = floor((screenWidth - width) / 2.0f);
    float y = floor(screenHeight - height - 40.0f);
    
    if (!bLandScap) {
        y -= 10.0f;
    }
    
    [textLabel setFrame: CGRectMake(x, y, width, height)];
    textLabel.text = strText;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = font;
    textLabel.layer.masksToBounds = YES;
    textLabel.layer.cornerRadius = 5.0;
    textLabel.backgroundColor = [UIColor blackColor];  
    textLabel.alpha = 1.0f;
    [superView addSubview:textLabel];
    
    [self __show:textLabel];
    //[textLabel release];
}



@end
