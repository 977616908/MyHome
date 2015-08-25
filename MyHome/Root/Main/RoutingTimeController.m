//
//  RoutingTimeController.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingTimeController.h"
#import "RoutingCell.h"
#import "ComposeViewController.h"
#import "PhotoSelectController.h"
#import "PiFiiBaseNavigationController.h"
#import "LoginRegisterController.h"
#import "MJRefresh.h"
#import "PECropViewController.h"
typedef enum{
    CameraNone,
    CameraPhoto
}CameraType;

@interface RoutingTimeController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PiFiiBaseViewDelegate,PECropViewControllerDelegate>{
    CGFloat lastScrollOffset;
    CGFloat angle;
    CADisplayLink *link;
    NSInteger pageCount;
    NSMutableArray *_arrTime;
    NSArray *arrImgs;
    MBProgressHUD           *stateView;
    BOOL isRefresh;
    NSString *pathArchive;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titileArr;
@property (weak, nonatomic) IBOutlet UIView *bgLoad;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnWifii;
@property (weak, nonatomic) IBOutlet UITableView *rootTable;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;


@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,assign)CameraType type;

@property(nonatomic,weak)MJRefreshHeaderView *header;

@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, weak) UIActivityIndicatorView *startView;

@end

@implementation RoutingTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    pathArchive=pathInCacheDirectory(@"AppCache/RoutingTime.archiver");
    if(ScreenHeight()<=480){
        self.rootTable.height=CGRectGetHeight(self.rootTable.frame)-88;
    }
    [self createCustomNav];
    [self setupRefreshView];
    [self judgeWithLogin];
    [self createImage];
    pageCount=1;
    [self getRequestPage:1 mark:@"home"];
}


-(void)createCustomNav{
    CGFloat gh=0;
    NSString *backImage = @"hm_bg001_iOS6";
    if (is_iOS7()) {
        gh=20;
        backImage = @"hm_bg001";
    }
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44+gh) backgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backImage]]]; // RGBCommon(73, 170, 231)
    //    [navTopView addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(10, 11.75+gh, 9, 16))];
    NSString *prasentTitle  = @" 返回";
    CCButton *btnBack = CCButtonCreateWithValue(CGRectMake(10, gh, 60,44), @selector(exitCurrentController), self);
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btnBack setImage:[UIImage imageNamed:@"ht_return"] forState:UIControlStateNormal];
    [btnBack alterNormalTitle:prasentTitle];
    [btnBack alterNormalTitleColor:RGBWhiteColor()];
    [btnBack alterFontSize:18];
    
    [navTopView addSubview:btnBack];
    
    CCLabel *_labTitle = CCLabelCreateWithNewValue(@"时光相册", 19, CGRectMake(CGRectGetWidth(self.view.frame)/2-40, gh, 80, 44));
    _labTitle.textColor = RGBCommon(52, 52, 52);
    _labTitle.backgroundColor = [UIColor clearColor];
    [navTopView addSubview:_labTitle];
    
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(self.view.frame)-45, gh+10, 30,25), @selector(onCameraClick:), self);
    sendBut.tag=1;
    [sendBut setImage:[UIImage imageNamed:@"hm_shangchuan"] forState:UIControlStateNormal];
    [sendBut setImage:[UIImage imageNamed:@"hm_shangchuan_select"] forState:UIControlStateSelected];
    [navTopView addSubview:sendBut];
    
    [self.view addSubview:navTopView];
}

-(void)createImage{
    self.topImg.userInteractionEnabled=YES;
    [self.topImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCameraClick:)]];
    //    UIImage *image=[[UIImage imageNamed:@"hm_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0,  130, 0) resizingMode:UIImageResizingModeStretch];
//    self.topImg.image=[UIImage imageNamed:@"hm_top"];
    //    _rootScrollView.contentSize=CGSizeMake(0, CGRectGetHeight(self.view.frame)+14);
    _rootScrollView.contentSize=CGSizeMake(0, CGRectGetHeight(self.view.frame)-14);
    _rootScrollView.delegate=self;
    _rootScrollView.delaysContentTouches=NO;
    
    UIActivityIndicatorView *start=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    start.frame=CGRectMake(97, CGRectGetHeight(self.showImg.frame)-22, 10, 10);
    start.transform=CGAffineTransformMakeScale(0.6, 0.6);
//    start.color=[UIColor blackColor];
    self.startView=start;
    [self.showImg addSubview:start];
    for (int i=0; i<_titileArr.count; i++) {
        ((UILabel *)_titileArr[i]).font=[UIFont fontWithName:@"Hagin Caps Medium" size:14.0];
    }
    UISwipeGestureRecognizer *swipeGesture;
    swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.topView addGestureRecognizer:swipeGesture];
    
    swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.topView addGestureRecognizer:swipeGesture];
//    self.topView.userInteractionEnabled=YES;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction==UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"---down---");
        [UIView animateWithDuration:0.35 animations:^{
            _rootScrollView.contentOffset=CGPointMake(0, -64);
        }];
    }else{
//        NSLog(@"---up---");
        [UIView animateWithDuration:0.5 animations:^{
            _rootScrollView.contentOffset=CGPointMake(0, 35);
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self setNavBackground];
    self.navigationController.navigationBarHidden=YES;
    BOOL isMacBouds=[GlobalShare isBindMac];
    if (isMacBouds) {
        NSString *pifiiTitle=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERNAME];
        [self.btnWifii setTitle:[NSString stringWithFormat:@" %@",pifiiTitle] forState:UIControlStateNormal];
    }else{
        [self.btnWifii setTitle:@" 未绑定" forState:UIControlStateNormal];
    }
}


-(void)initBase{
    NSString *jsonPath=[[NSBundle mainBundle]pathForResource:@"json" ofType:@"plist"];
    NSDictionary *json=[[NSDictionary alloc]initWithContentsOfFile:jsonPath];
    arrImgs=json[@"Imgs"];
    _arrTime=[NSMutableArray array];
}

#pragma -mark 网络加载
-(void)getRequestPage:(NSInteger)page mark:(NSString *)mark{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    if (userPhone&&![userPhone isEqualToString:@""]) {
        [self initPostWithURL:MyHomeURL path:@"mainPageVideo" paras:@{@"username":userPhone,@"page":@(page)} mark:mark autoRequest:YES];
    }
  
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if([mark isEqualToString:@"header"]){
        if ([returnCode integerValue]==200) {
            NSArray *data=[response objectForKey:@"data"];
//            [self removeRoutingClass:[RoutingDown class]];
            [_arrTime removeAllObjects];
            for (NSDictionary *param in data) {
                RoutingTime *time=[[RoutingTime alloc]initWithData:param];
                [_arrTime addObject:time];
            }
            NSString *path=[response objectForKey:@"logo_bg"];
            if (hasCachedImageWithString(path)) {
                self.topImg.image=[UIImage imageWithContentsOfFile:pathForString(path)];
            }else{
                NSValue *size=[NSValue valueWithCGSize:self.topImg.frame.size];
                NSDictionary *dict=@{@"url":path,@"imageView":self.topImg,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
            NSInteger count=[[response objectForKey:@"pages"]integerValue];
            if (pageCount==count||pageCount>count) {
                pageCount=-1;
            }else{
                pageCount=2;
            }
            [self saveRoutingTime:response];
        }
        [self performSelector:@selector(updateMark:) withObject:mark afterDelay:.2];
    }else if([mark isEqualToString:@"footer"]){
        if ([returnCode integerValue]==200) {
            NSArray *data=[response objectForKey:@"data"];
            NSMutableArray *arr=[NSMutableArray array];
            for (NSDictionary *param in data) {
                RoutingTime *time=[[RoutingTime alloc]initWithData:param];
                [arr addObject:time];
            }
            [_arrTime addObjectsFromArray:arr];
            NSInteger count=[[response objectForKey:@"pages"]integerValue];
            if (pageCount==count||pageCount>count) {
                pageCount=-1;
            }else{
                pageCount+=1;
            }
            [self saveRoutingTime:response];
        }
        [self performSelector:@selector(updateMark:) withObject:mark afterDelay:.2];
    }else{
        if ([returnCode integerValue]==200) {
            NSString *path=[response objectForKey:@"logo_bg"];
            //            self.topImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
            if (hasCachedImageWithString(path)) {
                self.topImg.image=[UIImage imageWithContentsOfFile:pathForString(path)];
            }else{
                NSValue *size=[NSValue valueWithCGSize:self.topImg.frame.size];
                NSDictionary *dict=@{@"url":path,@"imageView":self.topImg,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
            
            NSArray *data=[response objectForKey:@"data"];
//            [self removeRoutingClass:[RoutingDown class]];
            NSMutableArray *arrs=[NSMutableArray array];
            for (id obj in _arrTime) {
                if ([obj isKindOfClass:[RoutingDown class]]) {
                    [arrs addObject:obj];
                }
            }
            if (arrs.count>0)return;
            [_arrTime removeAllObjects];
//            [_arrTime addObjectsFromArray:arrs];
            for (NSDictionary *param in data) {
                RoutingTime *time=[[RoutingTime alloc]initWithData:param];
                [_arrTime addObject:time];
            }
            NSArray *arr=@[[NSString stringWithFormat:@"时光片段 %@",response[@"item_counts"]],
                           [NSString stringWithFormat:@"照片 %@",response[@"picture_counts"]],
                           [NSString stringWithFormat:@"视频 %@",response[@"video_counts"]]];
            for (int i=0; i<arr.count; i++) {
                ((UILabel *)_titileArr[i]).text=arr[i];
            }
            NSInteger count=[[response objectForKey:@"pages"]integerValue];
            if (pageCount==count||pageCount>count) {
                pageCount=-1;
            }else{
                pageCount+=1;
            }
            [self.rootTable reloadData];
            if (_arrTime.count<=0)[self setLoading:NO];
            [self saveRoutingTime:response];
        }

    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    [self performSelector:@selector(updateMark:) withObject:mark afterDelay:.2];
    if (_arrTime.count<=0) {
        NSDictionary *params=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchive];
        NSString *path=[params objectForKey:@"logo_bg"];
        //            self.topImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        if (hasCachedImageWithString(path)) {
            self.topImg.image=[UIImage imageWithContentsOfFile:pathForString(path)];
        }else{
            NSValue *size=[NSValue valueWithCGSize:self.topImg.frame.size];
            NSDictionary *dict=@{@"url":path,@"imageView":self.topImg,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
        NSArray *arr=@[[NSString stringWithFormat:@"时光片段 %@",params[@"item_counts"]],
                       [NSString stringWithFormat:@"照片 %@",params[@"picture_counts"]],
                       [NSString stringWithFormat:@"视频 %@",params[@"video_counts"]]];
        for (int i=0; i<arr.count; i++) {
            ((UILabel *)_titileArr[i]).text=arr[i];
        }
        NSArray *arrTime=params[@"arrTime"];
        [_arrTime addObjectsFromArray:arrTime];
        [self.rootTable reloadData];
    }
    [self showToast:@"似乎已断开与互连网的连接" Long:1.5];
}

-(void)saveRoutingTime:(NSDictionary *)response{
    NSMutableArray *arrs=[NSMutableArray array];
    for (id obj in _arrTime) {
        if ([obj isKindOfClass:[RoutingTime class]]) {
            [arrs addObject:obj];
        }
    }
    NSDictionary *param=@{@"item_counts":response[@"item_counts"],
                          @"picture_counts":response[@"picture_counts"],
                          @"video_counts":response[@"video_counts"],
                          @"logo_bg":response[@"logo_bg"],
                          @"arrTime":arrs};
    [NSKeyedArchiver archiveRootObject:param toFile:pathArchive];
}

//-(void)removeRoutingClass:(Class)class{
//    NSMutableArray *arrs=[NSMutableArray array];
//    for (id obj in _arrTime) {
//        if ([obj isKindOfClass:class]) {
//            [arrs addObject:obj];
//        }
//    }
//    [_arrTime removeAllObjects];
//    [_arrTime addObjectsFromArray:arrs];
//}

-(void)updateMark:(NSString *)mark{
    if ([mark isEqualToString:@"header"]) {
        [self.header endRefreshing];
    }else{
        isRefresh=NO;
        [self.footer endRefreshing];
    }
    [self.rootTable reloadData];
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
}

#pragma -mark  登录方法
-(void)judgeWithLogin
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [[userDefaultes objectForKey:ISLOGIN] boolValue];
    if (!isLogin){
        //推入
        [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
        //推入
        LoginRegisterController *loginController=[[LoginRegisterController alloc]init];
        [loginController setCustomAnimation:YES];
        [self.navigationController pushViewController:loginController animated:NO];
    }

}

-(void)setLoading:(BOOL)isLoad{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isLoading=[[userDefaultes objectForKey:ISLOADING]boolValue];
    if(isLoading){
        if (isLoad) {
            self.bgLoad.hidden=YES;
            [userDefaultes setObject:@NO forKey:ISLOADING];
            [userDefaultes synchronize];
        }else{
            self.bgLoad.hidden=NO;
        }
    }else{
        self.bgLoad.hidden=YES;
    }
}

-(void)onCameraClick:(id)sendar{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
    self.type=CameraNone;
    if (![sendar isKindOfClass:[CCButton class]]&&[[sendar view] tag]!=10) {
        _type=CameraPhoto;
    }
    [action showInView:self.view];
    if (!self.bgLoad.isHidden) {
        [self setLoading:YES];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_arrTime.count==0){
        return 1;
    }else{
        return _arrTime.count;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutingCell *cell=[RoutingCell cellWithTarget:self tableView:tableView];
    if (_arrTime.count>0) {
        id data=_arrTime[indexPath.row];
        if ([data isKindOfClass:[RoutingDown class]]) {
            [cell setRoutingDown:data];
        }else{
            [cell setRoutingTime:data];
        }
    }else{
        cell.isAdd=YES;
    }

    cell.imgName=arrImgs[indexPath.row%6];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 189.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"--[%d]---[%d]",actionSheet.tag,buttonIndex);
    switch (buttonIndex) {
        case 0://未知
            //拍照
            [self openCamera];
            break;
        case 1://男
            //选择相册
            if (self.type==CameraNone) {
                PhotoSelectController *photoController=[[PhotoSelectController alloc]init];
                photoController.pifiiDelegate=self;
                PiFiiBaseNavigationController *nav=[[PiFiiBaseNavigationController alloc]initWithRootViewController:photoController];
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [self openPics];
            }
            break;
    }
}

#pragma -mark 传递数据

-(void)pushViewDataSource:(id)dataSource{
    if ([dataSource isKindOfClass:[NSArray class]]) {
        [self performSelector:@selector(startIntent:) withObject:dataSource afterDelay:.2];
    }else{
        RoutingDown *down=dataSource;
        [_arrTime insertObject:down atIndex:0];
        [self.rootTable reloadData];
        [PSNotificationCenter addObserver:self selector:@selector(updateDate:) name:@"UPDATE" object:nil];
    }
    PSLog(@"---pushView---");
}

-(void)removeViewDataSources:(id)dataSource{
//    NSInteger page=pageCount>1?pageCount:1;
//    [self getRequestPage:page mark:@"home"];
    [self getRequestPage:1 mark:@"home"];
}

-(void)updateDate:(NSNotification *)not{
    NSDictionary *param=not.userInfo;
    RoutingDown *down=nil;
    for (id obj in _arrTime) {
        if ([obj isKindOfClass:[RoutingDown class]]) {
            if([param isEqualToDictionary:[obj params]]){
                down=obj;
            }
        }
    }
    if(down){
       [_arrTime removeObject:down];
       PSLog(@"---移除成功----");
    }
//    [self removeRoutingClass:[RoutingTime class]];
    [self getRequestPage:1 mark:@"home"];
}

-(void)startIntent:(id)dataSource{
    ComposeViewController *cp=[[ComposeViewController alloc]init];
    cp.pifiiDelegate=self;
    if (dataSource) {
        cp.arrPhoto=dataSource;
    }else{
        cp.type=ComposeCamera;
    }
    
    PiFiiBaseNavigationController *nav=[[PiFiiBaseNavigationController alloc]initWithRootViewController:cp];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma -mark 拍照与相册
// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (_imagePicker == nil) {
            _imagePicker =  [[UIImagePickerController alloc] init];
        }
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.showsCameraControls = YES;
//        if (self.type!=CameraNone)_imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

// 打开相册
- (void)openPics {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    _imagePicker = nil;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
            
        }
        PSLog(@"--[%f]--[%f]",theImage.size.width,theImage.size.height);
        if (self.type!=CameraNone) {
            [self performSelector:@selector(startCropImage:) withObject:theImage];
        }else{
            UIImageWriteToSavedPhotosAlbum(theImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }

    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        PSLog(@"%@",[error description]);
    }else{
        [self performSelector:@selector(startIntent:) withObject:nil];
    }
}

#pragma -mark 头像的编辑

-(void)startCropImage:(UIImage *)image{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    controller.navigationItem.title=@"截取图片";
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = self.topImg.frame.size.width/self.topImg.frame.size.height;
    controller.toolbarHidden = YES;
    PiFiiBaseNavigationController *nav=[[PiFiiBaseNavigationController alloc]initWithRootViewController:controller];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(!stateView){
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    stateView.labelText=@"正在更换封面...";
    //                CGSize size=self.topImg.frame.size;
    //            UIImage *customImg=[[ImageCacher defaultCacher]scaleImage:theImage size:size];
    //            UIImage *customImg=[[ImageCacher defaultCacher]compressImage:theImage sizeheight:size.height*2];
    //                ImageCacher *cacher=[ImageCacher defaultCacher];
    //                cacher.isCenter=YES;
    //                UIImage *customImg=[cacher imageByScalingAndCroppingForSize:CGSizeMake(size.width*2, size.height*2) sourceImage:theImage];
    [self uploadImage:croppedImage];
    //            self.topImg.image=theImage;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isMemberOfClass:[_rootScrollView class]]) {
        [self moveAnimation:YES];
        CGFloat y=scrollView.contentOffset.y;
        if (y>lastScrollOffset) {
            //        PSLog(@"--向下滚动--");
            angle=angle>0?angle:-angle;
        }else{
            //        PSLog(@"--向上滚动--");
            angle=angle>0?-angle:angle;
        }
        lastScrollOffset=y;
        [self startAnimation];
        [self scrollViewBottomScroll:scrollView];
    }else{
        [self scrollViewTopScroll:scrollView];
    }
   
}


-(void)scrollViewBottomScroll:(UIScrollView*)aScrollView{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        if (pageCount!=-1&&pageCount!=0&&!isRefresh&&!self.header.isRefreshing) {
            isRefresh=YES;
            [self.footer beginRefreshing];
            [self getRequestPage:pageCount mark:@"footer"];
        }
    }
}

-(void)scrollViewTopScroll:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
//    UIEdgeInsets inset = scrollView.contentInset;
//    float y=offset.y+inset.top+50;
    float y=offset.y+114;
    if (y<=0) {
        if (!self.startView.isAnimating) {
            PSLog(@"--到顶部了---");
            [self.startView startAnimating];
            pageCount=1;
            [self getRequestPage:1 mark:@"home"];
        }
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (![scrollView isMemberOfClass:[_rootScrollView class]]) {
        [UIView animateWithDuration:0.5 animations:^{
            _rootScrollView.contentOffset=CGPointMake(0, 35);
        }];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self moveAnimation:NO];
    [self stopAnimation];
    [self.startView stopAnimating];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self moveAnimation:NO];
        [self stopAnimation];
    }
    
}

-(void)scrollViewWithTouch:(NSSet *)touches withEvent:(UIEvent *)event scrollView:(id)scrollView{
    PSLog(@"--scrollView--");
    _rootScrollView.scrollEnabled=YES;
//    _rootScrollView.contentOffset=[[touches anyObject]locationInView:self.view];
}


#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    UIScrollView *scrollView=self.rootTable;
    scrollView.frame=CGRectMake(200, 0, CGRectGetWidth(self.rootTable.frame)+100, CGRectGetHeight(self.rootTable.frame));
    header.scrollView = scrollView;
    header.delegate = self;
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView=scrollView;
    footer.delegate=self;
    self.footer=footer;
}
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        [self getRequestPage:1 mark:@"header"];
    }else{
        [refreshView endRefreshing];
    }
    
    
}

-(void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state{
    PSLog(@"---[%d]---",state);
}

- (void)startAnimation
{
//    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle/2 * (M_PI / 180.0f));
//    CGAffineTransform endAngle1 = CGAffineTransformMakeRotation(-angle * (M_PI / 180.0f));
//    [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        ((UIImageView *)_imgArr[0]).transform = endAngle;
//        ((UIImageView *)_imgArr[1]).transform = endAngle1;
//    } completion:^(BOOL finished) {
//        angle+=angle>0?10:-10;
//        [self startAnimation];
//    }];
    if (!link) {
        link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
}

/**
 *  8秒转一圈, 45°/s
 */
- (void)update
{
    // 1/60秒 * 45
    // 规定时间内转动的角度 == 时间 * 速度
    angle+=angle>0?10:-10;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle/2 * (M_PI / 180.0f));
    CGAffineTransform endAngle1 = CGAffineTransformMakeRotation(-angle * (M_PI / 180.0f));
    ((UIImageView *)_imgArr[0]).transform = endAngle;
    ((UIImageView *)_imgArr[1]).transform = endAngle1;
}

-(void)stopAnimation{
    [link invalidate];
    link = nil;
    ((UIImageView *)_imgArr[0]).transform = CGAffineTransformIdentity;
    ((UIImageView *)_imgArr[1]).transform = CGAffineTransformIdentity;
}


-(void)moveAnimation:(BOOL)isAnimation{
//    CGRect barRect=self.tabBarController.tabBar.frame;
//    CGRect bounds=[[UIScreen mainScreen]bounds];
//    if (isAnimation) {
//        barRect.origin.y=CGRectGetHeight(bounds);
//    }else{
//       barRect.origin.y=CGRectGetHeight(bounds)-CGRectGetHeight(barRect);
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        self.tabBarController.tabBar.frame=barRect;
//    }];
}

#pragma mark 旋转动画
-(void)addAnimation:(BOOL)isAniation{
    if (isAniation) {
        [((UIImageView *)_imgArr[0]).layer addAnimation:[self imageWithRouter:YES] forKey:@"animation"];
        [((UIImageView *)_imgArr[1]).layer addAnimation:[self imageWithRouter:NO] forKey:@"animation"];
    }else{
        [((UIImageView *)_imgArr[0]).layer addAnimation:[self imageWithRouter:NO] forKey:@"animation"];
        [((UIImageView *)_imgArr[1]).layer addAnimation:[self imageWithRouter:YES] forKey:@"animation"];
    }
    
}

-(void)removeAnimation{
    [((UIImageView *)_imgArr[0]).layer removeAllAnimations];
    [((UIImageView *)_imgArr[1]).layer removeAllAnimations];
}

-(CABasicAnimation *)imageWithRouter:(BOOL)isRouter{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (isRouter) {
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.duration = 1.5;
    }else{
        rotationAnimation.toValue = [NSNumber numberWithFloat:0];
        rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 1.2;
    }
    
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    return rotationAnimation;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    // 释放内存
    [self.header free];
    [self.footer free];
    [PSNotificationCenter removeObserver:self name:@"UPDATE" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self stopAnimation];
}

#pragma -mark 上传头像
-(void)uploadImage:(UIImage *)image{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    if (userPhone&&![userPhone isEqualToString:@""]) {
        // 1.创建对象
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        // 2.封装请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = userPhone;
        NSString *url=[NSString stringWithFormat:@"%@/uploadFiles",MyHomeURL];
        // 3.发送请求
        [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 在发送请求之前调用这个block
            if (image) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"files" fileName:@"logo_bg.png" mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        PSLog(@"-[ld]-%@--",operation.expectedContentLength,responseObject);
            //        [_dataImgArr removeObject:photo];
            //        [_centerView setImagePhoto:_dataImgArr];
            if ([responseObject[@"returnCode"] integerValue]==200) {
                stateView.labelText=@"更换成功";
                //            self.topImg.image=image;
                [self getRequestPage:1 mark:@"home"];
                
            }else{
                stateView.labelText=responseObject[@"desc"];
            }
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            PSLog(@"--%@--",error);
            stateView.labelText=@"更换失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        }];
    }
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:0.3 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}


@end
