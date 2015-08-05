//
//  PresetDialog.h
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import <UIKit/UIKit.h>
@protocol PresetDialogDelegate<NSObject>
-(void)presetDialogOnClick:(int)tag;
@end
@interface PresetDialog : UIView
@property (nonatomic,retain)UIButton *btnCall;
@property (nonatomic,retain)UIButton *btnSet;
@property (nonatomic,assign)id<PresetDialogDelegate> diaDelegate;
- (id)initWithFrame:(CGRect)frame Num:(int)num;
@end
