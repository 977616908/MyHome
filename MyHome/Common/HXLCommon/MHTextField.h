//
//  MHTextField.h
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;
typedef enum{
   TextFieldNone,
   TextFieldTel,
   TextFieldDate
}TextFieldType;

@protocol MHTextFieldDelegate <NSObject>

@required
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

@end

@interface MHTextField : UITextField

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) TextFieldType type;
@property (nonatomic,copy)NSString *dateStyle;
@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;

-(NSString *)getText;

-(void)setTxt:(NSString *)text;

@end
