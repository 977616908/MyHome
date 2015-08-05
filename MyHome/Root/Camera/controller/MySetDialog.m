//
//  MySetDialog.m
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import "MySetDialog.h"
#import <QuartzCore/QuartzCore.h>
@implementation MySetDialog
@synthesize btnArr;
@synthesize diaDelegate;
@synthesize mType;
- (id)initWithFrame:(CGRect)frame Btn:(int)num
{
//    CGSize contentSize=CGSizeMake(frame.size.width,frame.size.height);
//    CGRect viewFrame;
//    if (frame.size.height>200) {
//        viewFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 300); 
//    }else{
//        viewFrame=frame;
//    }
    self = [super initWithFrame:frame];
//    UIView *view=[[UIView alloc]init];
//    [self addSubview:view];
//    UIScrollView *scrollView=[[UIScrollView alloc]init];
//    scrollView.frame=CGRectMake(100, 10, viewFrame.size.width, viewFrame.size.height);
//    scrollView.scrollEnabled=YES;
//    scrollView.userInteractionEnabled=YES;
//    scrollView.showsVerticalScrollIndicator=YES;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    [scrollView setContentSize:contentSize];
//    scrollView.backgroundColor=[UIColor blueColor];
    btnArr=[[NSMutableArray alloc]init];
    
    if (self) {
        int width=frame.size.width;
        int height=frame.size.height;
        int btnHeight=(height-5*(num+1))/num;
        int btnWidth=width-10;
        for (int i=0; i<num; i++) {
//            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *btn=[[UIButton alloc]init];
//            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(5,5*(i+1)+btnHeight*i,btnWidth,btnHeight);
            btn.tag=i;
            btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
           // [btn setTitle:@"2222" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [btnArr addObject:btn];

        }
        
       //[(UIButton *)[btnArr objectAtIndex:2] setTitle:<#(NSString *)#> forState:<#(UIControlState)#>]
    }
    
    
    return self;
}

-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    int tag=btn.tag;
    NSLog(@"tag=%d mType=%d",tag,mType);
    
    switch (tag) {
        case 0:{

            [diaDelegate mySetDialogOnClick:0 Type:mType];
        }
            break;
        case 1:
        {
//            ((UIButton *)[btnArr objectAtIndex:1]).selected=YES;
//            ((UIButton *)[btnArr objectAtIndex:0]).selected=NO;
            [diaDelegate mySetDialogOnClick:1 Type:mType];
        }
            break;
        case 2:
            [diaDelegate mySetDialogOnClick:2 Type:mType];
            break;
        case 3:
            [diaDelegate mySetDialogOnClick:3 Type:mType];
            break;
        case 4:
            [diaDelegate mySetDialogOnClick:4 Type:mType];
            break;
        case 5:
            [diaDelegate mySetDialogOnClick:5 Type:mType];
            break;
        case 6:
            [diaDelegate mySetDialogOnClick:6 Type:mType];
            break;
        case 7:
            [diaDelegate mySetDialogOnClick:7 Type:mType];
            break;
        case 8:
            [diaDelegate mySetDialogOnClick:8 Type:mType];
            break;
        default:
            break;
    }
}
-(void)setBtnImag:(UIImage *)img Index:(int)index{
    [[btnArr objectAtIndex:index] setImage:img forState:UIControlStateNormal];
}
-(void)setBtnTitle:(NSString *)title Index:(int)index{
    [[btnArr objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
}
-(void)setBtnBackgroundColor:(UIColor *)color Index:(int)index{
    ((UIButton*)[btnArr objectAtIndex:index]).backgroundColor=color;
}

-(void)setBtnSelected:(BOOL)flag Index:(int)index{
    ((UIButton*)[btnArr objectAtIndex:index]).selected=flag;
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
