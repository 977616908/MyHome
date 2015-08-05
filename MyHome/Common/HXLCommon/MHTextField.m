//
//  MHTextField.m
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "MHTextField.h"

@interface MHTextField()
{
    UITextField *_textField;
    BOOL _disabled;
}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;

//@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
//@property (nonatomic , strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) NSMutableArray *textFields;

@end

@implementation MHTextField

@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize invalid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
//    [self setTintColor:[UIColor blackColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    self.dateStyle=@"yyyy-MM-dd";
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 22);
    [toolbar setAlpha:0.8f];
    if (is_iOS7()){
        [toolbar setBarStyle:UIBarStyleDefault];
        [toolbar setTranslucent:YES];
    }else{
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    }
//    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"上一个" style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonIsClicked:)];
//    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonIsClicked:)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    CCButton *btnOk=CCButtonCreateWithValue(CGRectMake(0, 0, 32, 20), @selector(doneButtonIsClicked:), self);
    [btnOk alterFontSize:14.0f];
    [btnOk alterNormalTitle:@"完成"];
    [btnOk alterNormalTitleColor:RGBCommon(4, 183, 212)];
    UIBarButtonItem *doneBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnOk];
    NSArray *barButtonItems = @[flexBarButton, doneBarButton];
    
    toolbar.items = barButtonItems;
    
    self.textFields = [[NSMutableArray alloc]init];
    self.returnKeyType=UIReturnKeyDone;
    [self markTextFieldsWithTagInView:self.superview];
    [self addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
  
}

- (void)markTextFieldsWithTagInView:(UIView*)view
{
    int index = 0;
    if ([self.textFields count] == 0){
        for(UIView *subView in view.subviews){
            if ([subView isKindOfClass:[MHTextField class]]){
                MHTextField *textField = (MHTextField*)subView;
                textField.tag = index;
                [self.textFields addObject:textField];
                index++;
            }
        }
    }
}

- (void) doneButtonIsClicked:(id)sender
{
    [self setDoneCommand:YES];
    if(self.isFirstResponder)[self resignFirstResponder];
//    [self.superview endEditing:YES];
    [self setToolbarCommand:YES];
}

-(void) keyboardDidShow:(NSNotification *) notification
{
    if (_textField == nil) return;
    if (keyboardIsShown) return;
    if (![_textField isKindOfClass:[MHTextField class]]) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    
    [self scrollToField];
    
    self.keyboardIsShown = YES;
    
}

-(void) keyboardWillHide:(NSNotification *) notification
{
    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (_isDoneCommand)
             [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0) animated:NO];
     }];
    
    keyboardIsShown = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:self];
}


//- (void) nextButtonIsClicked:(id)sender
//{
//    NSInteger tagIndex = self.tag;
//    MHTextField *textField =  [self.textFields objectAtIndex:++tagIndex];
//    
//    while (!textField.isEnabled && tagIndex < [self.textFields count])
//        textField = [self.textFields objectAtIndex:++tagIndex];
//
//    [self becomeActive:textField];
//}

- (void) previousButtonIsClicked:(id)sender
{
    NSInteger tagIndex = self.tag;
    
    MHTextField *textField =  [self.textFields objectAtIndex:--tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--tagIndex];
    
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField
{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(int)tag
{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    for (int index = 0; index < [self.textFields count]; index++) {

        UITextField *textField = [self.textFields objectAtIndex:index];
    
        if (index < tag)
            previousBarButtonEnabled |= textField.isEnabled;
        else if (index > tag)
            nexBarButtonEnabled |= textField.isEnabled;
    }
    
//    self.previousBarButton.enabled = previousBarButtonEnabled;
//    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void) selectInputView:(UITextField *)textField
{
    if (self.type==TextFieldDate){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (![textField.text isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:self.dateStyle];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    }
}

-(void)editingChanged:(UITextField *)textField{
    if(self.type==TextFieldTel){
        NSString *phoneTel=[self getText];
        if (phoneTel.length>11) {
            phoneTel=[phoneTel substringWithRange:NSMakeRange(0, 11)];
        }
        if (phoneTel.length>3&&phoneTel.length<=7) {
            phoneTel=[NSString stringWithFormat:@"%@-%@",[phoneTel substringWithRange:NSMakeRange(0, 3)],[phoneTel substringWithRange:NSMakeRange(3, phoneTel.length-3)]];
        }else if(phoneTel.length>7&&phoneTel.length<=11){
            phoneTel=[NSString stringWithFormat:@"%@-%@-%@",[phoneTel substringWithRange:NSMakeRange(0, 3)],[phoneTel substringWithRange:NSMakeRange(3, 4)],[phoneTel substringWithRange:NSMakeRange(7, phoneTel.length-7)]];
        }
        [textField setText:phoneTel];
    }
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [
     dateFormatter setDateFormat:self.dateStyle];
    
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    
}

- (void)scrollToField
{
    CGRect textFieldRect = _textField.frame;
    
    CGRect aRect = self.window.bounds;
    
    aRect.origin.y = -scrollView.contentOffset.y;
    CGFloat height=74;
    aRect.size.height -= keyboardSize.height + self.toolbar.frame.size.height + height;
    
    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height+20);
   
    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y > 0) {
        CGPoint scrollPoint = CGPointMake(scrollView.contentOffset.x, self.superview.frame.origin.y + _textField.frame.origin.y + _textField.frame.size.height - aRect.size.height-30);
        
        if (scrollPoint.y < 0) scrollPoint.y = 0;
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled)
        [self setBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];
    
    _textField = textField;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setBarButtonNeedsDisplayAtTag:textField.tag];
    
    if ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        self.scrollView = (UIScrollView*)self.superview;
    
    [self selectInputView:textField];
    [self setInputAccessoryView:toolbar];
    
    [self setDoneCommand:NO];
    [self setToolbarCommand:NO];
}


-(NSString *)getText{
    if (self.type==TextFieldTel) {
        return [self.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }else if (self.type==TextFieldDate){
        return @"";
    }else{
        return self.text;
    }
}
-(void)setTxt:(NSString *)text{
    if(self.type==TextFieldTel){
        if (text.length>11) {
            text=[text substringWithRange:NSMakeRange(0, 11)];
        }
        if (text.length>3&&text.length<=7) {
            text=[NSString stringWithFormat:@"%@-%@",[text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(3, text.length-3)]];
        }else if(text.length>7&&text.length<=11){
            text=[NSString stringWithFormat:@"%@-%@-%@",[text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(3, 4)],[text substringWithRange:NSMakeRange(7, text.length-7)]];
        }
        
    }
    self.text=text;
//    [self editingChanged:self];
}

- (void)textFieldDidEndEditing:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];

    _textField = nil;
    
    if (self.type==TextFieldDate && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:self.dateStyle];
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
