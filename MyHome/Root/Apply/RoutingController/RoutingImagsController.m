//
//  ExampleViewController.m
//  Swipe to Select GridView
//
//  Created by Philip Yu on 4/18/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import "RoutingImagsController.h"
//#import "RoutingCameraController.h"
#import "ImagsCell.h"
#import "RoutingTime.h"
#import "RoutingMsg.h"
#import "RoutingCamera.h"

#define selectedTag 100
#define cellSize 72
#define textLabelHeight 20
#define cellAAcitve 1.0
#define cellADeactive 0.7
#define cellAHidden 0.0
#define defaultFontSize 10.0
#define HEIGHT 150
#define WEITH 268

@interface RoutingImagsController ()
{
    NSIndexPath *lastAccessed;
    CGPoint dragStartPt;
    bool dragging;
    NSMutableDictionary *selectedIdx;
    MBProgressHUD   *stateView;
    NSMutableArray *_datasource;
    NSMutableArray *_photoArr;
}
@property(nonatomic,weak)IBOutlet UICollectionView *collectionView;
- (IBAction)onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (nonatomic,weak) IBOutlet UIButton *btnOK;
@end

@implementation RoutingImagsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _photoArr=[NSMutableArray array];
    selectedIdx = [[NSMutableDictionary alloc] init];
    if (ScreenWidth()<=480) {
        self.lbTitle.transform=CGAffineTransformMakeTranslation(-44, 0);
        self.btnOK.transform=CGAffineTransformMakeTranslation(-88, 0);
    }
    
    
    [self.collectionView registerClass:[ImagsCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.type==ContentType) {
        self.lbTitle.text=@"已选择0/支持1~2张照片";
    }else{
        self.lbTitle.text=@"已选择0/支持25～37张照片";
    }
    [self getRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    return reusableview;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    ImagsCell *cell = (ImagsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    RoutingCamera *camera=_photoArr[indexPath.row];
    if (camera) {
        NSString *path=camera.rtSmallPath;
        //        [cell.imgView setImageWithURL:[path urlInstance]];
        CGSize imgSize=cell.imgView.frame.size;
        if (hasCachedImageWithString(path)) {
            UIImage *img=[UIImage imageWithContentsOfFile:pathForString(path)];
            if (img.size.width>(imgSize.width+10)||img.size.height>(imgSize.height+10)) {
                cell.imgView.image=[[ImageCacher defaultCacher]imageByScalingAndCroppingForSize:CGSizeMake(imgSize.width*2, imgSize.height*2) sourceImage:img];
            }else{
                cell.imgView.image=img;
            }
        }else{
            NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH, HEIGHT)];
            NSDictionary *dict=@{@"url":path,@"imageView":cell.imgView,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
    
    bool cellSelected = [selectedIdx objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    [self setCellSelection:cell selected:cellSelected];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellSize, cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedIdx setValue:@"1" forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self setCellSelection:cell selected:YES];
    

}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedIdx removeObjectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self setCellSelection:cell selected:NO];
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (ScreenWidth()<=480) {
       return UIEdgeInsetsMake(0, 20, 0, 108);
    }else{
       return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
}

- (void) setCellSelection:(UICollectionViewCell *)cell selected:(bool)selected
{
    ImagsCell *imgCell=(ImagsCell *)cell;
    if(selected){
        imgCell.imgView.alpha=cellADeactive;
        imgCell.selectImg.hidden=NO;
    }else{
        imgCell.imgView.alpha=cellAAcitve;
        imgCell.selectImg.hidden=YES;
    }
//    cell.backgroundView.alpha = selected ? cellAAcitve : cellADeactive;
//    [cell viewWithTag:selectedTag].alpha = selected ? cellAAcitve : cellAHidden;
    if (self.type==ContentType) {
        self.lbTitle.text=[NSString stringWithFormat:@"已选择%d/支持1~2张照片",selectedIdx.count];
    }else{
       self.lbTitle.text=[NSString stringWithFormat:@"已选择%d/支持25～37张照片",selectedIdx.count];
    }
    
}


- (void) resetSelectedCells
{
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        [self deselectCellForCollectionView:self.collectionView atIndexPath:[self.collectionView indexPathForCell:cell]];
    }
}

- (void) handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{    
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;

    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *touchOver = [self.collectionView indexPathForCell:cell];
            
            if (lastAccessed != touchOver)
            {
                if (cell.selected)
                    [self deselectCellForCollectionView:self.collectionView atIndexPath:touchOver];
                else
                    [self selectCellForCollectionView:self.collectionView atIndexPath:touchOver];
            }
            
            lastAccessed = touchOver;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }
}

#pragma mark 网络请求
- (void)getRequest{
    if(!stateView){
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        stateView.removeFromSuperViewOnHide=YES;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    [self initPostWithURL:MyHomeURL path:@"getAllPhotosByUserName" paras:@{@"username":userPhone} mark:@"routing" autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if([returnCode integerValue]==200){
        NSArray *data=[response objectForKey:@"data"];
        NSMutableArray *arr=[NSMutableArray array];
        for (NSDictionary *param in data) {
            RoutingTime *time=[[RoutingTime alloc]initWithSmallData:param];
            [arr addObject:time];
        }
        PSLog(@"---[%d---]",arr.count);
        [self reloadData:arr];
        //        [_arrTime addObjectsFromArray:arr];
    }
    [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
}



- (void)reloadData:(NSArray *)data
{
    [_photoArr removeAllObjects];
    for (RoutingTime *time in data) {
        for (int i=0; i<time.rtSmallPaths.count; i++) {
            RoutingMsg *msg=time.rtSmallPaths[i];
            RoutingCamera *camera=[[RoutingCamera alloc]init];
            camera.rtDate=time.rtDate;
            camera.rtId=msg.msgNum;
            camera.rtStory=[time.rtPaths[i] msgStory];
            camera.rtStoryId=[time.rtPaths[i] msgStroyId];
            camera.rtPath=[time.rtPaths[i] msgPath];
            camera.rtSmallPath=msg.msgPath;
            [_photoArr addObject:camera];
        }
    }
    NSString *dateStr=[self stringDateWithArray:_photoArr compare:YES];
    self.lbDate.text=[NSString stringWithFormat:@"时光相册(%@)",dateStr];
    [self.collectionView reloadData];
}


-(NSString *)stringDateWithArray:(NSArray *)array compare:(BOOL)isCompare{
    NSString *dateStr;
    NSInteger count=array.count;
    if (count>0) {
        NSDate *date=[CCDate timeDate:[array[0] rtDate] formatter:@"yyyy-MM-dd HH:mm:ss"];
        dateStr=[CCDate stringFromDate:date formatter:@"yyyy/MM/dd"];
        if (count>1) {
            NSDate *date1=[CCDate timeDate:[array[count-1] rtDate] formatter:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate=[CCDate stringFromDate:date1 formatter:@"yyyy/MM/dd"];
            if (![strDate isEqualToString:dateStr]) {
                if (isCompare) {
                   dateStr=[NSString stringWithFormat:@"%@ - %@",strDate,dateStr];
                }else{
                    dateStr=[NSString stringWithFormat:@"%@ - %@",dateStr,strDate];
                }
            }
        }
    }
    return dateStr;
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}

- (void) selectCellForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
}

- (void) deselectCellForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    [collection deselectItemAtIndexPath:indexPath animated:YES];
    [self collectionView:collection didDeselectItemAtIndexPath:indexPath];
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (IBAction)onClick:(id)sender {
    if (self.type==ContentType) {
   
    }else{
        if ([sender tag]==2) {
            NSArray *selectArr=selectedIdx.allKeys;
            if (selectArr.count<=0) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择25～37张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                return;
            }
            NSMutableArray *arr=[NSMutableArray array];
            for (int i=0; i<selectArr.count; i++){
                NSInteger count=[selectArr[i] integerValue];
                [arr addObject:_photoArr[count]];
            }
            NSArray *arrCamera=[arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                RoutingCamera *item1=(RoutingCamera *)obj1;
                RoutingCamera *item2=(RoutingCamera *)obj2;
                return [item1.rtDate compare:item2.rtDate];
            }];
            NSString *dateStr=[self stringDateWithArray:arrCamera compare:NO];
            [self.pifiiDelegate pushViewDataSource:@[dateStr,arrCamera]];
        }
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.view.origin=CGPointMake(0, CGRectGetHeight(self.view.frame));
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

@end
