//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCameraController.h"
#import "RoutingShareController.h"
#import "ContentController.h"
#import "RTSlider.h"
#import "RoutingCamera.h"
#import "JCFlipPageView.h"
#import "JCFlipPage.h"

@interface RoutingCameraController ()<UIPageViewControllerDataSource,JCFlipPageViewDataSource,PiFiiBaseViewDelegate>{
    NSInteger valueChange;
    BOOL isPage;
    NSMutableArray *arrControllers;
}

@property (weak, nonatomic) IBOutlet RTSlider *slider;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIView *fligView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

@property (nonatomic, strong) JCFlipPageView *flipPage;
@property (nonatomic,weak)UIPageViewController *pageController;

- (IBAction)onSaveClick:(id)sender;

- (IBAction)onClick:(id)sender;

- (IBAction)onSilderChange:(id)sender;

@end

@implementation RoutingCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self initBase];
    [self initView];
    
}

-(void)initBase{
//    _arrCamera=[NSMutableArray array];
//    for (int i=0; i<26; i++) {
//        RoutingCamera *rc=[[RoutingCamera alloc]init];
//        rc.rtContent=[NSString stringWithFormat:@"第%d条测试数据,hellow word!!!",i+1];
//        rc.rtDate=@"2015-6-20";
//        rc.rtTag=i;
//        rc.rtPath=[NSString stringWithFormat:@"rt_test0%d",arc4random()%2];
//        [_arrCamera addObject:rc];
//    }
    

}

-(void)setArrCamera:(NSMutableArray *)arrCamera{
    if (arrCamera) {
        _arrCamera=[NSMutableArray arrayWithArray:arrCamera];
    }else{
        _arrCamera=[NSMutableArray array];
    }
    if(arrCamera.count%2!=0){
        RoutingCamera *title=[[RoutingCamera alloc]init];
        title.rtTag=-3;
        [_arrCamera addObject:title];
    }
    RoutingCamera *start=[[RoutingCamera alloc]init];
    start.rtTag=-1;
    RoutingCamera *end=[[RoutingCamera alloc]init];
    end.rtTag=-2;
    [_arrCamera insertObject:start atIndex:0];
    [_arrCamera addObject:end];
}

-(void)initView{
    self.slider.minimumValue = 1;
    self.slider.maximumValue = _arrCamera.count-2;
    self.slider.value = 1;
    valueChange=0;
    //    _steppedSlider.labelOnThumb.hidden = YES;
    self.slider.labelAboveThumb.font = [UIFont systemFontOfSize:16.0];
    self.slider.labelAboveThumb.hidden=YES;
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
    UIPageViewController *pageController=[[UIPageViewController alloc]initWithTransitionStyle:(UIPageViewControllerTransitionStylePageCurl) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:options];
    pageController.dataSource=self;
    pageController.view.frame=self.pageView.bounds;
    [pageController becomeFirstResponder];
    [self createControllers];
    ContentController * initialViewController = [self viewCintrollerAtIndex:0];
    ContentController * endViewController = [self viewCintrollerAtIndex:1];
    
    NSArray *viewControllers=@[initialViewController,endViewController];
    [pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    [self addChildViewController:pageController];
    self.pageController=pageController;
    [self.pageView addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    
    JCFlipPageView *flipPage = [[JCFlipPageView alloc] initWithFrame:self.fligView.bounds];
    flipPage.dataSource = self;
    isPage=YES;
    [flipPage reloadData];
    self.flipPage=flipPage;
    [self.fligView addSubview:flipPage];
    

}

-(void)pushViewDataSource:(id)dataSource{
    NSArray *arr=dataSource;
    self.dateStr=arr[0];
    [self setArrCamera:arr[1]];
    [self.pageController.view removeFromSuperview];
    [self.flipPage removeFromSuperview];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)onSaveClick:(id)sender {
    RoutingShareController *shareController=[[RoutingShareController alloc]init];
    [shareController show];
}

- (IBAction)onClick:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onSilderChange:(id)sender {
//    _slider 
    int value=(int)floor(_slider.value+0.5);
    if (value!=valueChange) {
        PSLog(@"---[%d]---[%d]",[sender tag],(int)_slider.value);
        [self showView:NO];
//        if(value==_slider.maximumValue){
//           value=_slider.maximumValue-1;
//        }else{
//            
//        }
        if(value%2!=0)value-=1;
        NSArray *viewControllers=@[[self viewCintrollerAtIndex:value],[self viewCintrollerAtIndex:value+1]];
        if (value<valueChange) {
            [self.pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
            ;
        }else{
            [self.pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
            ;
        }
    }
    valueChange=value;
}

#pragma 创建Controllers

-(void)createControllers{
    arrControllers=[NSMutableArray array];
    for (int i=0; i<_arrCamera.count; i++) {
        ContentController * dataViewController =[[ContentController alloc]init];
        if (i%2==0) {
            dataViewController.isLeft=YES;
        }else{
            dataViewController.isLeft=NO;
        }
        dataViewController.viewHg=CGRectGetHeight(self.pageView.frame);
        dataViewController.dataObject = [_arrCamera objectAtIndex:i];
        [arrControllers addObject:dataViewController];
    }
}


- (ContentController *)viewCintrollerAtIndex:(NSUInteger)index{
    if ([_arrCamera count] == 0 || (index >= [_arrCamera count])) {
        return nil;
    }
    ContentController * dataViewController =arrControllers[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ContentController*)viewController{
    return  [_arrCamera indexOfObject:viewController.dataObject];
}

#pragma mark 翻页Controller

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentController *)viewController];
    if (index == 0 || (index == NSNotFound)) {
        isPage=YES;
        [self showView:isPage];
        [UIView animateWithDuration:0.5 animations:^{
            [self.flipPage flipToPageAtIndex:0 animation:YES];
        }];
        return nil;
    }
    index--;
    [UIView animateWithDuration:0.2 animations:^{
        self.slider.value=index;
    }];
    return [self viewCintrollerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [_arrCamera count]) {
        isPage=YES;
        [self showView:isPage];
        [UIView animateWithDuration:0.5 animations:^{
            [self.flipPage flipToPageAtIndex:1 animation:YES];
        }];
        return nil;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.slider.value=index;
    }];
    
    return [self viewCintrollerAtIndex:index];
}

#pragma mar - JCFlipPageViewDataSource
- (NSUInteger)numberOfPagesInFlipPageView:(JCFlipPageView *)flipPageView
{
    return 2;
}
- (JCFlipPage *)flipPageView:(JCFlipPageView *)flipPageView pageAtIndex:(NSUInteger)index
{
    static NSString *kPageID = @"numberPageID";
    JCFlipPage *page = [flipPageView dequeueReusablePageWithReuseIdentifier:kPageID];
    if (!page)
    {
        page = [[JCFlipPage alloc] initWithFrame:flipPageView.bounds reuseIdentifier:kPageID];
        page.dateStr=self.dateStr;
        page.superController=self;
    }
    page.backgroundColor=[UIColor clearColor];

//    [self onShowPage];
    if (!self.flipPage.isFlipPage) {
        if (index%2==0) {
            page.endImg.hidden=YES;
            page.startImg.hidden=NO;
            self.slider.labelOnThumb.text=@"封面";
        }else{
            self.slider.labelOnThumb.text=@"封底";
            page.endImg.hidden=NO;
            page.startImg.hidden=YES;
        }
        [self showView:isPage];
        isPage=NO;
    }
    return page;
}

-(void)showView:(BOOL)isShow{
    if (!isShow) {
        self.slider.labelOnThumb.text=[NSString stringWithFormat:@"%d/%d",(int)floor(self.slider.value+0.5),(int)self.slider.maximumValue];
    }
    [UIView animateWithDuration:0.7 animations:^{
        CGFloat al = isShow?1.0:0;
        CGFloat bl = al==0?1.0:0;
        self.flipPage.alpha=al;
        self.pageView.alpha=bl;
        self.imgBg.alpha=bl;
    } completion:^(BOOL finished) {
        self.flipPage.alpha=1.0;
        self.pageView.alpha=1.0;
        self.imgBg.alpha=1.0;
        self.flipPage.hidden=!isShow;
        self.imgBg.hidden=isShow;
        self.pageView.hidden=isShow;
    }];

}


@end
