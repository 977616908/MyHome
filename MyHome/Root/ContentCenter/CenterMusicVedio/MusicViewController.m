//
//  ImageAndDocumentViewController.m
//  MyHome
//
//  Created by Harvey on 14-7-31.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicPlayViewController.h"
#import "ImageAndDocumentCell.h"
#import "MJPhotoBrowser.h"
#import "MJRefresh.h"
#import "FileInfo.h"


@interface MusicViewController () <MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    MBProgressHUD *stateView;
    NSMutableArray *files;
    NSMutableArray *refreshArr;
    NSMutableOrderedSet *arrAddress;
    BOOL          isAdd;
    NSString *pathArchive;
    BOOL          isRefresh;
}

@property(nonatomic,weak)MJRefreshHeaderView *header;
@property (nonatomic,weak)UITableView *rootTableView;
@end

@implementation MusicViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title =@"云音乐";
    CGFloat hg=[[UIScreen mainScreen]bounds].size.height-64;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), hg)];
    tableView.dataSource=self;
    tableView.delegate=self;
    _rootTableView=tableView;
    [self.view addSubview:tableView];
    [self setupRefreshView];
    files = [NSMutableArray array];
    [self  getRequest];
}

- (void)getRequest
{
    refreshArr=[NSMutableArray array];
    arrAddress=[NSMutableOrderedSet orderedSetWithArray:@[ROUTER_FOLDER_BASEURL(@"Music")]];
    isAdd=YES;
    if (isRefresh) {
        [self initWithRequestAll];
    }else{
        pathArchive=pathInCacheDirectory(@"AppCache/Music.archiver");
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchive];
        if (array&&array.count>0) {
            [files addObjectsFromArray:array];
            [_rootTableView reloadData];
        }else{
            if (!stateView) {
                stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            stateView.removeFromSuperViewOnHide=YES;
            [self initWithRequestAll];
        }
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
        [self updateWithData];
    }
    
}

- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    PSLog(@"%@",response);
    if ([mark isEqualToString:@"list"]) {
        NSArray *fileInfo = [response objectForKey:@"contents"];
        for (NSDictionary *info in fileInfo) {
            NSString *path = [info objectForKey:@"path"];
            NSString *name = [[path componentsSeparatedByString:@"/"] lastObject];
            if (![name hasPrefix:@"."]){
                NSNumber *isDir=[info objectForKey:@"is_dir"];
                NSRange range=[name rangeOfString:@"."];
                if (range.location!=NSNotFound&&![isDir boolValue]) {
                    NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
                    BOOL isMyNeed =[self isMusicWithFileSuffix:suffix];
                    //        PSLog(@"%@",ROUTER_FILE_WHOLEDOWNLOAD(path));
                    if (isMyNeed) {
                        FileInfo *item = [FileInfo new];
                        name=[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                        item.fileName = [[name componentsSeparatedByString:@"."] firstObject];
                        item.fileName=name;
                        item.fileSuffix = suffix;
                        item.filePath = path;
                        item.fileSize = [info objectForKey:@"size"];
                        //                item.fileUpDate = [info objectForKey:@"modified"];
                        item.fileUpDate = [CCDate timeIntervalConvertDate:[[info objectForKey:@"modified_lts"] longLongValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
                        item.isCanPlayOrOpen = [suffix.lowercaseString isEqualToString:@"mp3"];
                        if (isRefresh) {
                            [refreshArr addObject:item];
                        }else{
                            [files addObject:item];
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
        }
        [self initWithRequestAll];
    }else if([mark isEqualToString:@"delete"]){
        [NSKeyedArchiver archiveRootObject:files toFile:pathArchive];
    }

}

-(void)updateWithData{
    if (isRefresh) {
        isRefresh=NO;
        [self.header endRefreshing];
        [files removeAllObjects];
        files=refreshArr;
    }else{
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }
    [files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FileInfo *item1=(FileInfo *)obj1;
        FileInfo *item2=(FileInfo *)obj2;
        return [item2.fileUpDate compare:item1.fileUpDate];
    }];
    [NSKeyedArchiver archiveRootObject:files toFile:pathArchive];
    [self.rootTableView reloadData];
    PSLog(@"----%d----",self.header.isRefreshing);

   
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    if (isRefresh) {
        [self.header endRefreshing];
        isRefresh=NO;
    }else{
        stateView.labelText=@"访问失败!";
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
    PSLog(@"%@:%@",mark,error);
}

#pragma mark 上拉刷新

-(void)setupRefreshView{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.rootTableView;
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
    isRefresh=YES;
    [self getRequest];
    
}

-(void)dealloc{
    [self.header free];
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
//        if ([state isEqualToString:@"fail"]) {
//            [self exitCurrentController];
//        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Harvey";
    ImageAndDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (isNIL(cell)) {
        cell=[[ImageAndDocumentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    FileInfo *item = [files objectAtIndex:indexPath.row];
    cell.filePreview.image = (item.isCanPlayOrOpen?@"hm_spliebiao":@"hm_spliebiao02").imageInstance;
    cell.fileName.text = item.fileName;
    cell.fileSize.text = [NSString stringWithFormat:@"大小: %@",item.fileSize];
    cell.fileUpDate.text = [NSString stringWithFormat:@"更新时间:%@",item.fileUpDate];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return files.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayViewController *mpc = [[MusicPlayViewController alloc] init];
    mpc.musicInfo = [NSArray arrayWithArray:files];
    mpc.currentPlayIndex = indexPath.section*2 + indexPath.row;
    [self.navigationController pushViewController:mpc animated:YES];
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        PSLog(@"已删除...");
        FileInfo *info = [files objectAtIndex:indexPath.row];
        NSDictionary *param=@{@"path":info.filePath,@"root":@"syncbox"};
        [self initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:@"delete" autoRequest:YES];
        [files removeObject:info];
        [self.rootTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
