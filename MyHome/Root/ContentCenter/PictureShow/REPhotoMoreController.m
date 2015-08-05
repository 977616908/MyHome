//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REPhotoMoreController.h"
#import "REPhotoThumbnailsCell.h"
#import "UIImageView+WebCache.h"
#import "REPhoto.h"
#import "REPhotoGroup.h"
#import "MJRefresh.h"
#define BARHEIGHT 44

@interface REPhotoMoreController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MJRefreshBaseViewDelegate>{
    UITableView     *tableImg;
    MBProgressHUD   *stateView;
    UIView       *_toolbar;
    NSMutableOrderedSet *_deleteArr;
    BOOL isDelete;
    NSMutableArray *_morePhotoImg;
    NSMutableArray  *arrRefresh;
    NSMutableArray  *arrAddress;
    NSInteger deleteCount;
    BOOL          isAdd;
    NSString *pathArchtive;
    BOOL          isRefresh;
}
@property(nonatomic,weak)CCButton *btnEdit;
@property(nonatomic,weak)MJRefreshHeaderView *header;
@end

@implementation REPhotoMoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title=@"云图片";
//    self.title=@"2014年11月 共33张";
    CGFloat gh=44;
    if (is_iOS7()) {
        gh+=20;
    }
    _morePhotoImg=[NSMutableArray arrayWithArray:_moreImageArr];
    self.title=[NSString stringWithFormat:@"%@年%@月 共%d张",self.detailTitle[@"year"],self.detailTitle[@"month"],_morePhotoImg.count];
    pathArchtive= pathInCacheDirectory(@"AppCache/Photo.archiver");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    tableImg=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    tableImg.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableImg.showsVerticalScrollIndicator=NO;
    tableImg.delegate=self;
    tableImg.dataSource=self;
    [self.view addSubview:tableImg];
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(addPhotoListener:), self);
    [sendBut alterNormalTitle:@"编辑"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    _btnEdit=sendBut;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    isDelete=NO;
    _toolbar = [[UIView alloc] init];
    _toolbar.backgroundColor=RGBCommon(73, 170, 231);
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake((CGRectGetWidth(self.view.frame)-BARHEIGHT)/2, 0, BARHEIGHT, BARHEIGHT);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu"] forState:UIControlStateNormal];
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
    _deleteArr=[NSMutableOrderedSet orderedSet];
    [self setupRefreshView];
    [self getRequest];
}

-(void)addPhotoListener:(CCButton*)sendar{
    
    if ([sendar.titleLabel.text isEqualToString:@"编辑"]) {
        isDelete=YES;
        [sendar alterNormalTitle:@"完成"];
        [self toolBarWithAnimation:NO];
    }else{
       [sendar alterNormalTitle:@"编辑"];
        [self toolBarWithAnimation:YES];
        isDelete=NO;
    }
    [_deleteArr removeAllObjects];
    [tableImg reloadData];
    PSLog(@"--%@--",sendar.titleLabel.text);
}

-(void)toolBarWithAnimation:(BOOL)isHidden{
    CGFloat barY=0;
    if (isHidden) {
        barY=CGRectGetHeight(self.view.frame);
    }else{
        barY=CGRectGetHeight(self.view.frame)-BARHEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), BARHEIGHT);
    }];
}

-(void)deletePhoto{
    PSLog(@"---删除图片---");
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_deleteArr.count] otherButtonTitles:nil, nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (_deleteArr.count>0) {
            stateView.hidden=NO;
            deleteCount=_deleteArr.count;
            stateView.labelText=[NSString stringWithFormat:@"正在删除(0/%d)",deleteCount];
            for (int i=0; i<_deleteArr.count; i++) {
                [self deleteWithPhoto:_deleteArr[i] mark:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
    }
}

#pragma mark 删除图片
-(void)deleteWithPhoto:(REPhoto *)photo mark:(NSString *)mark{
    NSDictionary *param=@{@"path":photo.imageUrl,@"root":@"syncbox"};
    [self initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:mark autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"response:%@",response);
    if ([mark isEqualToString:@"list"]) {
        NSArray *fileInfo = [response objectForKey:@"contents"];
        for (NSDictionary *info in fileInfo) {
            NSString *path = [info objectForKey:@"path"];
            NSNumber *isDir=[info objectForKey:@"is_dir"];
            NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
            NSRange range=[name rangeOfString:@"."];
            if (range.location!=NSNotFound&&![isDir boolValue]) {
                NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                BOOL isMyNeed =[self isImageWithFileSuffix:suffix];
                if (isMyNeed) {
                    REPhoto *photo = [[REPhoto alloc]init];
                    photo.imageName=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    photo.imageUrl=path;
                    photo.date=[CCDate timeIntervalConvertDate:[[info objectForKey:@"modified_lts"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
                    if(isRefresh){
                        [arrRefresh addObject:photo];
                    }
                }
            }else{
                if (isAdd) {
                    PSLog(@"%@",ROUTER_FOLDER_BASEURL(path));
                    NSString *address=[ROUTER_FOLDER_BASEURL(path) encodedString];
                    [arrAddress addObject:address];
                }
            }
        }
        [self initWithRequestAll];
    }else{
        [self deleteWithPhoto:[mark intValue]];
    }

}


-(void)deleteWithPhoto:(NSInteger)index{
    [_morePhotoImg removeObject:_deleteArr[index-1]];
    deleteCount--;
    stateView.labelText=[NSString stringWithFormat:@"正在删除(%d/%d)",_deleteArr.count-deleteCount,_deleteArr.count];
    if (deleteCount==0) {
        stateView.labelText=@"删除成功";
        [_btnEdit alterNormalTitle:@"编辑"];
        [self toolBarWithAnimation:YES];
        isDelete=NO;
        [tableImg reloadData];
//        NSString *str=[self.title substringToIndex:[self.title rangeOfString:@" "].location];
//        self.title=[str stringByAppendingFormat:@" 共%d张",_morePhotoImg.count];
        self.title=[NSString stringWithFormat:@"%@年%@月 共%d张",self.detailTitle[@"year"],self.detailTitle[@"month"],_morePhotoImg.count];
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
        NSMutableArray *savaArr=[NSMutableArray array];
        for (REPhotoGroup *group in array) {
            if ([self isExitsWithYear:group.year month:group.month]) {
                PSLog(@"-------");
                group.itemAll=_morePhotoImg;
                group.items=_morePhotoImg;
                if (group.items.count>19) {
                    group.items=[NSMutableArray arrayWithArray:[group.items subarrayWithRange:NSMakeRange(0, 19)]];
                }
                group.count=group.itemAll.count;
            }
            [savaArr addObject:group];
        }
        [NSKeyedArchiver archiveRootObject:savaArr toFile:pathArchtive];
    }
}

-(BOOL)isExitsWithYear:(NSInteger)year month:(NSInteger) month{
    NSInteger y=[self.detailTitle[@"year"] integerValue];
    NSInteger m=[self.detailTitle[@"month"] integerValue];
    if (y==year&&m==month) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 网络请求
- (void)getRequest
{
    arrAddress=[NSMutableArray arrayWithArray:@[ROUTER_FOLDER_BASEURL(@"Photo")]];
    isAdd=YES;
    if(isRefresh){
        arrRefresh=[NSMutableArray array];
        [self initWithRequestAll];
    }else{
        if (!stateView) {
            stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        stateView.removeFromSuperViewOnHide=YES;
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.7];
    }
}

-(void)initWithRequestAll{
    if (arrAddress.count==0&&isAdd) {
        isAdd=NO;
        [arrAddress addObjectsFromArray:@[ROUTER_FOLDER_BASEURL(@"Data"),ROUTER_FOLDER_BASEURL(@"Data/download")]];
    }
    if (arrAddress.count>0) {
        NSString *path=arrAddress[0];
        [arrAddress removeObject:path];
        [self initGetWithURL:path
                        path:nil
                       paras:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"list", [GlobalShare getToken], @"token", nil]
                        mark:@"list"
                 autoRequest:YES];
    }else{
        if(isRefresh){
            [self updateWithArray:arrRefresh];
        }
    }
    
}



-(void)updateWithArray:(NSArray *)arr{
    //    arr=[arr subarrayWithRange:NSMakeRange(0, 20)];
    NSArray *sorted=[arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        REPhoto *item1=(REPhoto *)obj1;
        REPhoto *item2=(REPhoto *)obj2;
        return [item2.date compare:item1.date];
    }];
    [arrRefresh removeAllObjects];
    for (REPhoto *photo in sorted) {
        NSArray *arrDate=[photo.date componentsSeparatedByString:@"-"];
        NSUInteger year = [arrDate[0] integerValue];
        NSUInteger month = [arrDate[1] integerValue];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in arrRefresh) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month=month;
            group.year=year;
            [group.items addObject:photo];
            [arrRefresh addObject:group];
        }else {
            [group.items addObject:photo];
        }
    }
    for (REPhotoGroup *group in arrRefresh) {
        group.itemAll=group.items;
        group.count=group.items.count;
        if (group.items.count>19) {
            group.items=[NSMutableArray arrayWithArray:[group.items subarrayWithRange:NSMakeRange(0, 19)]];
        }
        if ([self isExitsWithYear:group.year month:group.month]) {
            _morePhotoImg=[NSMutableArray arrayWithArray:group.itemAll];
        }
    }
    [NSKeyedArchiver archiveRootObject:arrRefresh toFile:pathArchtive];
    if(isRefresh){
        isRefresh=NO;
        [_header endRefreshing];
    }
    self.title=[NSString stringWithFormat:@"%@年%@月 共%d张",self.detailTitle[@"year"],self.detailTitle[@"month"],_morePhotoImg.count];
    [tableImg reloadData];
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    PSLog(@"%@:%@",mark,error);
    if (isRefresh) {
        isRefresh=NO;
        [_header endRefreshing];
    }else{
        stateView.labelText=@"删除失败";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
}



#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = tableImg;
    header.delegate = self;
    self.header = header;
    isRefresh=NO;
}
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
    //        [self loadMoreData];
    //    } else { // 下拉刷新
    //        [self loadNewData];
    //    }
    //    [self initBase];
    isRefresh=YES;
    [self getRequest];
    
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




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(_morePhotoImg.count / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.superController=self;
    }
    
    
    if (_morePhotoImg) {
        int startIndex = indexPath.row * 4;
        int endIndex = startIndex + 4;
        if (endIndex > [_morePhotoImg count])
            endIndex = [_morePhotoImg count];
        [cell removeAllPhotos];
        for (int i = startIndex; i < endIndex; i++) {
            REPhoto *photo = [_morePhotoImg objectAtIndex:i];
            [cell addPhoto:photo];
        }
        cell.arryGroup=_morePhotoImg;
        if (isDelete) {
            cell.selectOrder=_deleteArr;
            cell.photoType=REPhotoMore;
        }else{
            cell.photoType=REPhotoOther;
        }
        [cell refresh];
    }

//    NSArray *arrPhoto=group.items;
//    [cell addPhotoWithArray:arrPhoto];
  
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PSLog(@"---tableview----");
}



#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//-(void)exitCurrentController{
//    [super exitCurrentController];
//    [self clearImageWithCookie];
//}

@end
