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

#import "PhotoSelectController.h"
#import "REPhotoThumbnailsCell.h"
#import "MLKMenuPopover.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define BARHEIGHT 44

typedef enum {
    SelectNone,
    SelectPhoto,
    SelectVedio
}SelectReType;

@interface PhotoSelectController ()<UITableViewDataSource,UITableViewDelegate,MLKMenuPopoverDelegate>{
    UITableView     *tableImg;
    NSMutableArray *_photoArr;
    NSMutableArray *_datasource;
    NSMutableOrderedSet  *_upArray;
    BOOL isUpdate;
    NSString *pathArchtive;
    NSMutableOrderedSet *_saveSet;
}

@property(nonatomic,weak)CCButton *btnSelect;
@property(nonatomic,weak)MLKMenuPopover *menuPopover;
@property (nonatomic,assign)SelectReType type;
@end

@implementation PhotoSelectController


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat gh=44;
    if (is_iOS7()) {
        gh+=20;
    }
    tableImg=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    tableImg.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableImg.showsVerticalScrollIndicator=NO;
    tableImg.delegate=self;
    tableImg.dataSource=self;
    [self.view addSubview:tableImg];
    

}

#pragma -mark 加载数据
-(void)initBase{
    _datasource = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
//                    photo.image = [UIImage imageWithCGImage:result.aspectRatioThumbnail];//高清
                    NSString *fileName=[[result defaultRepresentation]filename];
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    [_datasource addObject:photo];
                }else if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
//                    photo.image = [UIImage imageWithCGImage:result.aspectRatioThumbnail];//高清
                    NSString *fileName=[[result defaultRepresentation]filename];
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    photo.isVedio=YES;
                    NSTimeInterval duration=[[result valueForProperty:ALAssetPropertyDuration] doubleValue];
                    int hours=((int)duration)%(3600*24)/3600;
                    int minus=((int)duration)%(3600*24)/60;
                    int mt=((int)duration)%(3600*24)%60;
                    if (hours==0) {
                        photo.duration=[NSString stringWithFormat:@"%d:%02d",minus,mt];
                    }else{
                        photo.duration=[NSString stringWithFormat:@"%d%d:%02d",hours,minus,mt];
                    }
                    PSLog(@"--[%@]--",fileName);
                    [_datasource addObject:photo];
                }
            }];
        } else {
            [_datasource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                REPhoto *item1=(REPhoto *)obj1;
                REPhoto *item2=(REPhoto *)obj2;
                return [item2.photoDate compare:item1.photoDate];
            }];
            [self reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

#pragma -mark 导航栏设置
-(void)coustomNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(selectOK)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIView *bgPow=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 125, 44)];
    CCButton *btnPow=CCButtonCreateWithValue(CGRectMake(0, 0, CGRectGetWidth(bgPow.frame), 44), @selector(upDownListener:), self);
    btnPow.titleLabel.textAlignment=NSTextAlignmentRight;
    btnPow.tag=2;
    [btnPow setImage:[UIImage imageNamed:@"hm_xiala02"] forState:UIControlStateNormal];
    btnPow.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
    btnPow.imageEdgeInsets=UIEdgeInsetsMake(12,102,12,0);
    MLKMenuPopover *menuPopover=[[MLKMenuPopover alloc]initWithFrame:CGRectMake(70, 0, 180, 200) menuItems:@[@"手机全部",@"手机相册",@"手机视频"]];
    self.menuPopover=menuPopover;
    menuPopover.menuPopoverDelegate=self;
    [btnPow alterFontUseBoldWithSize:20.0f];
    [btnPow alterNormalTitle:@"手机全部"];
    self.btnPopover=btnPow;
    [bgPow addSubview:btnPow];
    bgPow.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView=bgPow;
   
}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

/**
 *  确定选中
 */
- (void)selectOK
{
    [self.pifiiDelegate pushViewDataSource:_upArray.array];
    // 关闭控制器
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)setTitleButton{
    if (self.type==SelectPhoto) {
        [self.btnPopover alterNormalTitle:@"手机相册"];
    }else if(self.type==SelectVedio){
        [self.btnPopover alterNormalTitle:@"手机视频"];
    }else{
        [self.btnPopover alterNormalTitle:@"手机全部"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)upDownListener:(CCButton *)sendar{
    [self.menuPopover showInView:self.navigationController.view];
    [sendar setImage:[UIImage imageNamed:@"hm_xiala"] forState:UIControlStateNormal];
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    PSLog(@"---[%d]--",selectedIndex);
    [_btnPopover setImage:[UIImage imageNamed:@"hm_xiala02"] forState:UIControlStateNormal];
    [self.menuPopover dismissMenuPopover];
    if(selectedIndex==-1)return;
    switch (selectedIndex) {
        case 0:
            self.type=SelectNone;
            break;
        case 1:
            self.type=SelectPhoto;
            break;
        case 2:
            self.type=SelectVedio;
            break;

    }
    [_upArray removeAllObjects];
    [self setTitleButton];
    [self reloadData];
}


- (void)reloadData
{
    _photoArr=[NSMutableArray array];
    _upArray=[NSMutableOrderedSet orderedSet];
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    NSMutableArray *arrType=[NSMutableArray array];
    for (REPhoto *photo in _datasource) {
        if (self.type==SelectVedio) {
            if(photo.isVedio)[arrType addObject:photo];
        }else if (self.type==SelectPhoto){
            if(!photo.isVedio)[arrType addObject:photo];
        }else{
            [arrType addObject:photo];
        }
    }
    for (REPhoto *photo in arrType) {
        if ([_saveSet containsObject:photo.imageName]) {
            photo.isBackup=YES;
        }
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.photoDate];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in _photoArr) {
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
            [_photoArr addObject:group];
        }else {
            [group.items addObject:photo];
        }
    }
    //    REPhotoGroup *group=_photoArr[0];
    //    [_upArray addObject:group.items[0]];
    [tableImg reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_photoArr count] == 0) return 0;
    if ([self tableView:tableImg numberOfRowsInSection:[_photoArr count] - 1] == 0) {
        return [_photoArr count] - 1;
    }
    return [_photoArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.superController=self;
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:indexPath.section];
    if (group) {
        NSArray *array=group.items;
        int startIndex = indexPath.row * 4;
        int endIndex = startIndex + 4;
        if (endIndex > [array count])
            endIndex = [array count];
        [cell removeAllPhotos];
        for (int i = startIndex; i < endIndex; i++) {
            REPhoto *photo = [group.items objectAtIndex:i];
            [cell addPhoto:photo];
        }
        cell.arryGroup=array;
        cell.photoType=REPhotoSelect;
        cell.selectOrder=_upArray;
        
        [cell refresh];
        //        [cell addPhotoWithArray:group.itemAll];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    NSString *content=[NSString stringWithFormat:@"%d年%d月 共%d张",group.year,group.month,[group.items count]];
    return content;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
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

@end
