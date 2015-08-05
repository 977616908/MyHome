//
//  CameraSearchViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CameraSearchViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "SearchDVS.h"
#import "SearchListMgt.h"
#import "SearchCameraResultProtocol.h"
#import "SearchListCell.h"
//#import "IpCameraClientAppDelegate.h"

extern int BTN_NORMAL_RED ;
extern int BTN_NORMAL_GREEN ;
extern int BTN_NORMAL_BLUE ;
//


@interface CameraSearchViewController ()<SearchCameraResultProtocol,
UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>{
    IBOutlet UITableView *SearchListView;
    IBOutlet UINavigationBar *navigationBar;
    
    SearchListMgt *searchListMgt;
    CSearchDVS *m_pSearchDVS;
    NSTimer *searchTimer;
    
    BOOL bSearchFinished;
}

@property (nonatomic, retain) IBOutlet UITableView *SearchListView;


@end

@implementation CameraSearchViewController

@synthesize SearchListView;
@synthesize SearchAddCameraDelegate;

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
    
    bSearchFinished = NO;    
    
    [self showLoadingIndicator];    
    searchListMgt = [[SearchListMgt alloc] init];    
    m_pSearchDVS = NULL;
    [self startSearch];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=SearchListView.frame;
    imgView.center=SearchListView.center;
    SearchListView.backgroundView=imgView;
//    [imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self stopSearch];
//    [searchListMgt release];
    searchListMgt = nil;
}

- (void) dealloc
{
    [self stopSearch];
    self.SearchListView = nil;
    self.SearchAddCameraDelegate = nil;
//    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleTimer:(NSTimer *)timer
{
    //time is up, invalidate the timer
    [searchTimer invalidate];  
    
    [self stopSearch];    
    
    bSearchFinished = YES;
    [self hideLoadingIndicator];
    
    [SearchListView reloadData];    
    
}

- (void) startSearch
{
    [self stopSearch];
    
    m_pSearchDVS = new CSearchDVS();
    m_pSearchDVS->searchResultDelegate = self;
    m_pSearchDVS->Open();
    
    //create the start timer
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];    
}

- (void) stopSearch
{
    
    if (m_pSearchDVS != NULL) {
        m_pSearchDVS->searchResultDelegate = nil;
        SAFE_DELETE(m_pSearchDVS);
    }
}


- (void) btnRefresh: (id) sender
{
    //PSLog(@"btnRefresh");
    [self showLoadingIndicator];
    [searchListMgt ClearList];
    [SearchListView reloadData];
    [self startSearch];
}

- (void)showLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = progress;
    
}

- (void)hideLoadingIndicator
{
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(10, 0, 30,25), @selector(btnRefresh:), self);
    sendBut.tag=1;
    [sendBut setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
//    [sendBut setImage:[UIImage imageNamed:@"hm_shangchuan_select"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    
}

#pragma mark -
#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // PSLog(@"numberOfSectionsInTableView");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // PSLog(@"numberOfRowsInSection");
    if (bSearchFinished == NO) {
        return 0;
    }
    
    return [searchListMgt GetCount];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //PSLog(@"cellForRowAtIndexPath");             
    
    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    
    NSString *cellIdentifier = @"SearchListCell";
    SearchListCell *cell=(SearchListCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        UINib *nib=[UINib nibWithNibName:@"SearchListCell" bundle:nil];
//        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchListCell" owner:self options:nil];
//        cell=[nib objectAtIndex:0];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell=(SearchListCell *)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *ip=[cameraDic objectForKey:@STR_IPADDR];
    
    
//    cell.textLabel.text = name;
//    cell.detailTextLabel.text = did;
	cell.nameLabel.text=name;
    cell.addrLabel.text=ip;
    cell.didLabel.text=did;
	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 65.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *ip=[cameraDic objectForKey:@STR_IPADDR];
    NSString *port=[cameraDic objectForKey:@STR_PORT];
    PSLog(@"[%@]:[%@]:[%@]",[cameraDic objectForKey:@STR_USER],[cameraDic objectForKey:@STR_PWD],[cameraDic objectForKey:@STR_SSID]);
    [SearchAddCameraDelegate AddCameraInfo:name DID:did IP:ip Port:port];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return NSLocalizedStringFromTable(@"Network", @STR_LOCALIZED_FILE_NAME, nil);
//}

#pragma mark -
#pragma mark SearchCamereResultDelegate
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString *)did
{
    if ([did length] == 0) {
        return;
    }
    
    PSLog(@"SearchCameraResult。。。mac:%@ name=%@ addr=%@ port=%@ did=%@",mac,name,addr,port,did);
    if ([name length]==0) {
        name=@"P2PCam";
    }
    BOOL b=[searchListMgt AddCamera:mac Name:name Addr:addr Port:port DID:did];
    if (b) {
        PSLog(@"SearchCameraResult..添加成功");
    }else{
        PSLog(@"SearchCameraResult..添加失败");
    }
}

#pragma mark -
#pragma mark navigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
