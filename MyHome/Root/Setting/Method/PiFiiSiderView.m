//
//  PiFiiSiderView.m
//  MyHome
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiSiderView.h"

#define HEIGHT 48

@implementation PiFiiSiderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self viewLoad];
    }
    return self;
}

- (void)initBase
{
    _data = [NSMutableArray new];
    NSArray *left = @[@"hm_shezhi",@"hm_icon",@"hm_jcbd",@"hm_zhuxiao",@"hm_icon02",@""];
    NSArray *texts = @[@"设置",@"快速上网",@"解除绑定",@"注销",@"意见反馈",@"点击升级"];
    for (int i=0; i<left.count; i++) {
        PiFiiSiderViewItem *item = [PiFiiSiderViewItem new];
        item.leftImage = [left objectAtIndex:i];
        item.text = [texts objectAtIndex:i];
        [_data addObject:item];
    }
}

- (void)initStyle
{
     self.backgroundColor = @"hm_bg01".colorInstance;
}


-(void)setBindMac:(BOOL)bindMac{
    PiFiiSiderViewItem *item=_data[2];
    if (bindMac) {
        item.leftImage=@"hm_jcbd";
        item.text=@"解除绑定";
    }else{
        item.leftImage=@"hm_bangdi";
        item.text=@"绑定";
    }
    [_mainTableView reloadData];
}
- (void)addControl
{
    CGFloat hg=HEIGHT*_data.count;
    _mainTableView = CCTableViewCreateStylePlain(CGRectMake(30, (CGRectGetHeight(self.frame)-hg)/2, 205, hg), self,YES);
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = RGBClearColor();
    _mainTableView.scrollEnabled = NO;
    [self addSubview:_mainTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Harvey";
    PiFiiSiderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (isNIL(cell)) {
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PiFiiSiderViewCell" owner:self options:nil] lastObject];
    }
    PiFiiSiderViewItem *item = [_data objectAtIndex:indexPath.row];
    cell.leftImage.image = item.leftImage.imageInstance;
    cell.bgLine.hidden=YES;
    cell.tipText.text = item.text;
    if (indexPath.row == _data.count-1) {
        cell.rightImage.hidden = YES;
        cell.bgLine.hidden=NO;
        [cell.contentView addSubview:[CCView createWithFrame:CGRectMake(0, 64, 226, 1) backgroundColor:RGBCommon(40, 76, 70)]];
        CCLabel *lab = CCLabelCreateWithNewValue(@"当前版本:1.0 获取最新版本", 12, CGRectMake(0, 26, 226, 15));
        [lab alterFontColor:RGBCommon(143, 211, 244)];
        [cell.contentView addSubview:lab];
        cell.tipText.frame = CGRectMake(0, 6, 185, 20);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==_data.count-1) {
        [self onCheckVersion];
    }else{
        self.pushStepViewController(indexPath.row);
    }
    PSLog(@"%d",(int)indexPath.row);
}


#pragma mark 检测版本升级
-(void)onCheckVersion{
    NSDictionary *info=[[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion=[info objectForKey:@"CFBundleVersion"];
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=682185259"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];;
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:REQUESTTIMEOUT];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (recervedData||[urlResponse statusCode]==200) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:kNilOptions error:nil];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if (![lastVersion isEqualToString:currentVersion]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10001;
                [alert show];
            }
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常，暂时无法更新!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
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
