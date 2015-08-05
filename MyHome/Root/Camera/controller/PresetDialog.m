//
//  PresetDialog.m
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import "PresetDialog.h"
#import "obj_common.h"
@implementation PresetDialog
@synthesize diaDelegate;
@synthesize btnCall;
@synthesize btnSet;
- (id)initWithFrame:(CGRect)frame Num:(int)num
{
    self = [super initWithFrame:frame];
    
    
    
    int width=frame.size.width;
    int height=frame.size.height;
    
//    UIView *bg=[[UIView alloc]init];
//    bg.frame=CGRectMake(0, 0,width, 20);
//    bg.backgroundColor=[UIColor  colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1];
//    [self addSubview:bg];
//    [bg release];
    
    btnCall=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCall.frame=CGRectMake(0, 0, width/2, 40);
    btnCall.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    btnCall.tag=101;
    [btnCall addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnCall setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    btnCall.selected=YES;
    [btnCall setTitle:@"调用" forState:UIControlStateNormal];
    [self addSubview:btnCall];
    
   
    
    btnSet=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSet.frame=CGRectMake( width/2, 0, width/2, 40);
    btnSet.tag=102;
    btnSet.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [btnSet addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSet setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    [btnSet setTitle:@"设置" forState:UIControlStateNormal];
    [self addSubview:btnSet];
    
    height-=40;
    int btnWidth=(width-5*(num+1))/num;
    int btnHeight=(height-5*(num+1))/num;
    
    
    int n=0;
    if (self) {
        for (int i=0; i<num; i++) {
            for (int j=0; j<num; j++) {
                n++;
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom]; 
                btn.frame=CGRectMake(5*(j+1)+btnWidth*j,40+5*(i+1)+btnHeight*i,btnWidth,btnHeight);
                btn.tag=n;
                [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
                
                btn.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
                [btn setTitle:[NSString stringWithFormat:@"%d",n] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
    return self;
}
-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    switch (tag) {
        case 101:
            btnSet.selected=NO;
            btnCall.selected=YES;
           
            break;
        case 102:
            btnSet.selected=YES;
            btnCall.selected=NO;
            
            break;
        default:
            break;
    }
    [diaDelegate presetDialogOnClick:tag];
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
