//
//  CCDownloadView.m
//  MyHome
//
//  Created by HXL on 14/11/14.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CCDownloadView.h"
#import "CCDownloadCell.h"
#import "DownLoadViewController.h"
#import "DocumentHtmlViewController.h"
#import "MusicPlayViewController.h"
#import "VideoPlayerViewController.h"
#import "FileInfo.h"
#import "MJPhotoBrowser.h"
#import "REPhoto.h"

@interface CCDownloadView () <UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *downArr;
    NSInteger insertRow;
    CCImageView *_floatLayout;
    CCImageView *_selectImage;
}

@end

@implementation CCDownloadView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        downArr=[NSMutableArray array];
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        _tableView.separatorColor=RGBCommon(189, 210, 214);
        [_tableView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_tableView];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        insertRow=-1;
        [self floatLayout];
    }
    return self;
}


// 布局
- (void)floatLayout
{
    _floatLayout = [[CCImageView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, 320, self.bounds.size.height)];
    _floatLayout.backgroundColor = RGBAlpha(0, 0, 0, 0.5);
    _floatLayout.userInteractionEnabled = YES;
    [self addSubview:_floatLayout];
    
    CCImageView *back = CCImageViewCreateWithNewValue(@"hm_tankuang", CGRectMake(20, (self.frame.size.height-149)/2-64, 280, 149));
    back.userInteractionEnabled = YES;
    [_floatLayout addSubview:back];
    
    CCLabel *lab = CCLabelCreateWithNewValue(@"你确定要删除些任务吗？", 15, CGRectMake(0, 15, 280, 25));
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = RGBCommon(27, 27, 27);
    [back addSubview:lab];//hm_weixuanzhong
    
    CCButton *select = CCButtonCreateWithValue(CGRectMake(5, 50, 25, 25), @selector(myAction:), self);
    select.tag = 0;
    [back addSubview:select];
    
    _selectImage = CCImageViewCreateWithNewValue(@"hm_weixuanzhong", CGRectMake(7, 7, 11, 11));
    [select addSubview:_selectImage];
    
    lab = CCLabelCreateWithNewValue(@"同时删除文件", 12, CGRectMake(30, 50, 280, 25));
    lab.textColor = RGBCommon(119, 147, 161);
    [back addSubview:lab];
    
    
    select = [CCButton createWithTitle:@"确定" backImage:nil frame:CGRectMake(13, 100, 125, 30)];
    select.tag = 1;
    [select alterNormalTitleColor:RGBCommon(27, 27, 27)];
    [select addAction:@selector(myAction:) runTarget:self];
    [back addSubview:select];
    
    select = [CCButton createWithTitle:@"取消" backImage:nil frame:CGRectMake(138, 100, 125, 30)];
    select.tag = 2;
    [select alterNormalTitleColor:RGBCommon(27, 27, 27)];
    [select addAction:@selector(myAction:) runTarget:self];
    [back addSubview:select];
    
}

#pragma mark 下标点击事件的处理
- (void)myAction:(CCButton *)but
{
    if (but.tag == 0) {
        NSString *orig = UIImagePNGRepresentation(_selectImage.image).base64Encoding;
        NSString *cur = UIImagePNGRepresentation(@"hm_xuanzhong".imageInstance).base64Encoding;
        _selectImage.image = ([orig isEqualToString:cur] ? @"hm_weixuanzhong":@"hm_xuanzhong").imageInstance;
        PSLog(@"选择");
    }else if (but.tag == 1) {
        FileInfo *file = [downArr objectAtIndex:(insertRow-1)];
        if (file) {
            [self HTTPRequestOfDeleteWithFile:file];
        }
        PSLog(@"确定");
    }else if (but.tag == 2) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.38];
        _floatLayout.frame = CGRectMake(0, -self.bounds.size.height, 320, self.bounds.size.height);
        _floatLayout.backgroundColor = RGBAlpha(0, 0, 0, 0);
        [UIView  commitAnimations];
        PSLog(@"取消");
        _selectImage.image = @"hm_weixuanzhong".imageInstance;
    }
}



-(void)setArrayList:(NSArray *)arrayList{
    [downArr removeAllObjects];
    if(arrayList)[downArr addObjectsFromArray:arrayList];
    PSLog(@"insertRow---[%d]---",insertRow);
    [_tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return downArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (insertRow!=-1&&insertRow==indexPath.row) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"CCDownloadCell" owner:nil options:nil];
        CCActionCell *aCell = cells[1];
        aCell.userClickAction=^(NSInteger index){
            [self userActionOnShow:index];
        };
        return aCell;
    }
    
    switch (self.downType) {
        case CCDownTypeAll:
            break;
        case CCDownTypeNotFinish:{//未下载
            static NSString *downCellId=@"downCellId";
            CCDownloadCell *downCell=[tableView dequeueReusableCellWithIdentifier:downCellId];
            if (!downCell) {
                downCell=[[CCDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downCellId];
            }
            downCell.actionView.hidden=NO;
            FileInfo *item=downArr[indexPath.row];
            if (item) {
                downCell.contentName.text = item.fileName;
                BOOL isActive = [item.fileStatus isEqualToString:@"active"];
                downCell.arrowImage.frame = CGRectMake(274, 15, 24, 24);
                downCell.arrowImage.image = (isActive ? @"hm_zanting":@"hm_xiazai").imageInstance;//hm_xiazai
                downCell.downPercent.text = isActive ? [NSString stringWithFormat:@"下载 %@%%",item.fileDownloadProgress]:
                [NSString stringWithFormat:@"暂停 %@%%",item.fileDownloadProgress];
                NSString *title=isActive ? @"暂停":@"下载";
                [downCell.actionBut setTitle:title forState:UIControlStateNormal];
//                downCell.actionBut.titleLabel.text = isActive ? @"暂停":@"下载";
                
                downCell.actionBut.tag = indexPath.row;
                downCell.delBut.tag=indexPath.row;
                [downCell.actionBut addTarget:self action:@selector(pauseAndGo:) forControlEvents:UIControlEventTouchUpInside];
                [downCell.delBut addTarget:self action:@selector(delTesk:) forControlEvents:UIControlEventTouchUpInside];
                downCell.contentSize.text = [NSString stringWithFormat:@"%0.2fMB/%.2fMB",item.fileFinishedSize/1024./1024.,item.fileLength/1024./1024.];
            }
            return downCell;
            
        }
            break;
        case CCDownTypeFinish:{ //已下载
            static NSString *finishCellId=@"finishCellId";
            insertRow=-1;
            CCDownloadCell *finishCell=[tableView dequeueReusableCellWithIdentifier:finishCellId];
            if (!finishCell) {
                finishCell=[[CCDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:finishCellId];
            }
            finishCell.actionView.hidden=YES;
            FileInfo *item=downArr[indexPath.row];
            if (item) {
                finishCell.contentName.text = item.fileName;
                finishCell.contentSize.text = [NSString stringWithFormat:@"大小:%.2fMB    更新时间:%@",item.fileLength/1024./1024.,item.fileAddTime];
                finishCell.arrowBackView.tag = indexPath.row;
                [finishCell.arrowBackView addTarget:self action:@selector(selectAnd:) forControlEvents:UIControlEventTouchUpInside];
            }
            return finishCell;
        }
            break;
        default:
            break;
        }
    return nil;
}

#pragma mark 下拉界面处理方式
- (void)userActionOnShow:(NSInteger )index
{
    switch (index) {
        case 0:{ //打开
            DownLoadViewController *controller=(DownLoadViewController*)self.superController;
            FileInfo *item = [downArr objectAtIndex:insertRow-1];
            if (!item) return;
            NSString *name=item.fileName;
            NSString *suffix = [[name componentsSeparatedByString:@"."] lastObject];
            NSString *path=[NSString stringWithFormat:@"/Data/download/%@",name];
            NSString *url = ROUTER_FILE_WHOLEDOWNLOAD(path);
            if ([controller isMusicWithFileSuffix:suffix]) {
                PSLog(@"正在播放音乐...");
                FileInfo *info=item;
                info.filePath=path;
                MusicPlayViewController *mpc = [[MusicPlayViewController alloc] init];
                mpc.musicInfo = [NSArray arrayWithObject:info];
                [controller.navigationController pushViewController:mpc animated:YES];
            }else if([controller isVideoWithFileSuffix:suffix]){
//                VideoPlayerViewController *_playerController = [[VideoPlayerViewController alloc] init];
//                _playerController.moviePlayer.contentURL = url.encodedString.urlInstance;
//                _playerController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
//                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
//                _playerController.view.transform = landscapeTransform;
//                _playerController.moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
//                [_playerController.moviePlayer prepareToPlay];
//                [controller presentMoviePlayerViewControllerAnimated:_playerController];
                
                MPMoviePlayerViewController *playerController=[[MPMoviePlayerViewController alloc]init];
                playerController.moviePlayer.contentURL = url.encodedString.urlInstance;
                playerController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
                //        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
                //        playerController.view.transform = landscapeTransform;
                //        _playerController.moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
                [playerController.moviePlayer prepareToPlay];
                [controller presentMoviePlayerViewControllerAnimated:playerController];
            }else if([controller isDocumentWithFileSuffix:suffix]){
                DocumentHtmlViewController *dpv = [DocumentHtmlViewController new];
                dpv.url = url;
                dpv.navigationItem.title = name;
                [controller.navigationController pushViewController:dpv animated:YES];
            }else if([controller isImageWithFileSuffix:suffix]){
//                REPhoto *rePhoto=_photos[imageTap.view.tag];
                MJPhotoBrowser *photoBrowser=[[MJPhotoBrowser alloc]init];
                REPhoto *photo=[[REPhoto alloc]init];
                photo.imageUrl=path;
                photo.imageName=name;
                photoBrowser.currentPhotoIndex=0;
                photoBrowser.photos=[NSMutableArray arrayWithObject:photo];
                photoBrowser.navigationItem.title=@"图片预览";
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5f ;
                animation.type = kCATransitionFade;//101
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                [controller.navigationController.view.layer addAnimation:animation forKey:@"animation"];
                [controller.navigationController pushViewController:photoBrowser animated:NO];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"很抱歉！暂不支持该文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            }
        }
            break;
        case 1:{ //下载到本地
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"正在开发中..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }
            break;
        case 2:{  // 删除
            [self delWithAnimation];
        }
            break;
    }
}

-(void)delWithAnimation{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    _floatLayout.frame = self.bounds;
    _floatLayout.backgroundColor = RGBAlpha(0, 0, 0, 0.5);
    [UIView  commitAnimations];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

#pragma mark 事件处理
-(void)pauseAndGo:(UIButton *)sendar{
    
//    [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(1)];
    FileInfo *item = [downArr objectAtIndex:sendar.tag];
    
    BOOL isActive = [item.fileStatus isEqualToString:@"active"];
    if (isActive) {
        [sendar setTitle:@"暂停" forState:UIControlStateNormal];
        [self HTTPRequestOfPauseWithTaskID:item.fileTaskID];
    }else {
        [sendar setTitle:@"下载" forState:UIControlStateNormal];
        [self HTTPRequestOfResumeWithTaskID:item.fileTaskID];
    }
    NSString *text = isActive ? @"正在暂停下载任务...":@"正在恢复下载任务...";
    [self.superController performSelector:@selector(showTipWithText:) withParameter:text];
}

-(void)delTesk:(UIButton *)sendar{
    insertRow=sendar.tag+1;
    [self delWithAnimation];
}

-(void)selectAnd:(UIButton *)sendar{
    CCDownloadCell *selectCell=(CCDownloadCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sendar.tag inSection:0]];
    if (insertRow==-1) { // 点击下拉
        [selectCell doAnimation];
        insertRow=sendar.tag+1;
        [downArr insertObject:@"" atIndex:insertRow];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{// 点击恢复
        if (insertRow==(sendar.tag+1)) {
            [selectCell resetAnimation];
            [self removeIndexFromInsert];
        }
    }
}


-(void)removeIndexFromInsert{
    PSLog(@"---removeObject--%d-",insertRow);
    if(insertRow!=-1){
        [downArr removeObjectAtIndex:insertRow-1];
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        insertRow=-1;
    }
}

- (void)hiddenFloatLayout
{
    NSInteger removeIndex=insertRow-1;
    if (self.downType==CCDownTypeFinish) {
        [self removeIndexFromInsert];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    
    _floatLayout.frame = CGRectMake(0, -self.bounds.size.height, 320, self.bounds.size.height);
    _floatLayout.backgroundColor = RGBAlpha(0, 0, 0, 0);
    [UIView  commitAnimations];
    PSLog(@"取消");
    _selectImage.image = @"hm_weixuanzhong".imageInstance;
    if (downArr.count>removeIndex) {
        [downArr removeObjectAtIndex:removeIndex];
        [_tableView reloadData];
    }

//    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:removeIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark -HTTP request for pause task
- (void)HTTPRequestOfDeleteWithFile:(FileInfo*)file
{
//    NSString *tID=file.fileTaskID;
//    NSString *orig = UIImagePNGRepresentation(_selectImage.image).base64Encoding;
//    NSString *cur = UIImagePNGRepresentation(@"hm_xuanzhong".imageInstance).base64Encoding;
    
//    BOOL delFile = [orig isEqualToString:cur];
//    NSString *param = delFile? [self convertJSONStringWithDel:@"delete" taskID:tID]:
//    [self convertJSONString:@"delete" taskID:tID];
//    __weak typeof(self) weakSelf=self;
//    [HttpRequest getWithBaseURL:ROUTINGBASEURL path:@"extension/ext_download" paras:[NSDictionary dictionaryWithObjectsAndKeys:[GlobalShare getToken],@"token",param,@"json", nil] OKBlock:^(NSDictionary *dict) {
//        
//        if(![[dict objectForKey:@"errcode"] boolValue]) {
//            if (delFile) {
//                NSDictionary *param=@{@"path":file.filePath,@"root":@"syncbox"};
//                [self.superController initPostWithURL:ROUTER_FILE_DELETE path:nil paras:param mark:@"delete" autoRequest:YES];
//            }
//            PSLog(@"删除任务成功");
//            [weakSelf hiddenFloatLayout];
//            [self.superController performSelector:@selector(showTipWithText:) withParameter:(id)@"删除成功"];
//            //[self.superControler performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//        }
//    } failBlock:^(NSError *error) {
//        
//        PSLog(@"删除任务失败");
//        [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//    }];
}

#pragma mark -HTTP request for pause task
- (void)HTTPRequestOfPauseWithTaskID:(NSString *)tID
{
//    [HttpRequest getWithBaseURL:ROUTINGBASEURL path:@"extension/ext_download" paras:[NSDictionary dictionaryWithObjectsAndKeys:[GlobalShare getToken],@"token",[self convertJSONString:@"pause" taskID:tID],@"json", nil] OKBlock:^(NSDictionary *dict) {
//        
//        if(![[dict objectForKey:@"errcode"] boolValue]) {
//            
//            PSLog(@"暂停任务成功");
//            [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//        }
//    } failBlock:^(NSError *error) {
//        
//        PSLog(@"暂停任务失败");
//        [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//    }];
}

#pragma mark -HTTP request for Resume task
- (void)HTTPRequestOfResumeWithTaskID:(NSString *)tID
{
//    [HttpRequest getWithBaseURL:ROUTINGBASEURL path:@"extension/ext_download" paras:[NSDictionary dictionaryWithObjectsAndKeys:[GlobalShare getToken],@"token",[self convertJSONString:@"resume" taskID:tID],@"json", nil] OKBlock:^(NSDictionary *dict) {
//        
//        if(![[dict objectForKey:@"errcode"] boolValue]) {
//            
//            [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//            PSLog(@"任务已恢复");
//        }
//    } failBlock:^(NSError *error) {
//        [self.superController performSelector:@selector(monitorDownloadInfoStop:) withParameter:@(0)];
//        PSLog(@"任务恢复失败");
//    }];
}


- (NSString *)convertJSONString:(NSString *)cmd taskID:(NSString *)tID
{
    NSString *jsons = [NSString stringWithFormat:@"{\"cmd\":\"%@\",\"param\":{\"taskid\":[\"l-%@\"],\"clear\":\"false\"}}",cmd,tID];
    return jsons;//clear
}

- (NSString *)convertJSONStringWithDel:(NSString *)cmd taskID:(NSString *)tID
{
    NSString *jsons = [NSString stringWithFormat:@"{\"cmd\":\"%@\",\"param\":{\"taskid\":[\"l-%@\"],\"clear\":\"true\"}}",cmd,tID];
    return jsons;
}

@end
