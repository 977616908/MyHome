//
//  PlayViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"
//#include "IpCameraClientAppDelegate.h"

#import "obj_common.h"
#import "PPPPDefine.h"
#import "mytoast.h"
#import "cmdhead.h"
#import "moto.h"
#import "CustomToast.h"
#import <sys/time.h>
#import "APICommon.h"
#include "time.h"
#import <QuartzCore/QuartzCore.h>


@implementation PlayViewController


@synthesize m_pPPPPChannelMgt;
@synthesize imgView;
@synthesize cameraName;
@synthesize strDID;
@synthesize progressView;
@synthesize LblProgress;
@synthesize playToolBar;
//@synthesize btnItemResolution;
//@synthesize btnTitle;
@synthesize timeoutLabel;
@synthesize m_nP2PMode;
@synthesize toolBarTop;
//@synthesize btnUpDown;
//@synthesize btnLeftDown;
//@synthesize btnUpDownMirror;
//@synthesize btnLeftRightMirror;
//@synthesize btnTalkControl;
//@synthesize btnAudioControl;
//@synthesize btnSetContrast;
///@synthesize btnSetBrightness;
@synthesize imgVGA;
@synthesize img720P;
@synthesize imgQVGA;
//@synthesize btnSwitchDisplayMode;
@synthesize imgNormal;
@synthesize imgEnlarge;
@synthesize imgFullScreen;
@synthesize imageSnapshot;
@synthesize m_pPicPathMgt;
//@synthesize btnRecord;
@synthesize imageUp;
@synthesize imageDown;
@synthesize imageLeft;
@synthesize imageRight;
@synthesize m_pRecPathMgt;
@synthesize PicNotifyDelegate;
@synthesize RecNotifyDelegate;
//@synthesize btnSnapshot;
@synthesize isRecording;
@synthesize recordFileName;
@synthesize recordFilePath;
@synthesize recordFileDate;
@synthesize recordNum;

@synthesize preDialog;
@synthesize setDialog;
@synthesize isP2P;

@synthesize m_strIp;
@synthesize m_strPort;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize netUtiles;

@synthesize seeMoreDialog;
@synthesize frameDialog;

//@synthesize btnMicrophone;

@synthesize isMoreView;

@synthesize labelRecord;
@synthesize labelNetworkSpeed;

@synthesize strOSD;
#pragma mark -
#pragma mark others

- (void) StartAudio
{
    m_pPPPPChannelMgt->StartPPPPAudio([strDID UTF8String]);
}

- (void) StopAudio
{
    m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
}

- (void) StartTalk
{
    m_pPPPPChannelMgt->StartPPPPTalk([strDID UTF8String]);
}

- (void) StopTalk
{
    m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
}

- (IBAction)btnStop:(id)sender
{
    if (isRecording) {
        
        [CustomToast showWithText:@"请先停止录像"
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    bManualStop = YES;
    
    [self StopPlay: 0];
}

- (IBAction)btnAudioControl:(id)sender
{
    
    
    //
    //    if (isMicrophoneShow) {
    //       // btnAudioControl.style = UIBarButtonItemStyleBordered;
    //        [btnAudio setImage:[UIImage imageNamed:@"audio.png"] forState:UIControlStateNormal] ;
    //      //  [self StopTalk];
    //        [self StopAudio];
    //    }else{
    //      //  [self StopTalk];
    //        [self StartAudio];
    //       // btnAudioControl.style = UIBarButtonItemStyleDone;
    //        [btnAudio setImage:[UIImage imageNamed:@"audiosel.png"] forState:UIControlStateNormal];
    //
    //    }
    //    [self showBtnMicrophone:isMicrophoneShow];
    //    isMicrophoneShow=!isMicrophoneShow;
    //
    
    //   return;
    
    
    if (m_bAudioStarted) {
        [self StopAudio];
        [btnAudio setImage:[UIImage imageNamed:@"audio.png"] forState:UIControlStateNormal] ;
    }else {
        [self StartAudio];
        [btnAudio setImage:[UIImage imageNamed:@"audiosel.png"] forState:UIControlStateNormal] ;
    }
    
    m_bAudioStarted = !m_bAudioStarted;
    
    //    if (m_bAudioStarted) {
    //        btnTalkControl.enabled = NO;
    //    }else {
    //        btnTalkControl.enabled = YES;
    //    }
}

- (IBAction)btnTalkControl:(id)sender
{
    if (m_bTalkStarted) {
        [self StopTalk];
        //btnTalkControl.style = UIBarButtonItemStyleBordered;
        [btnTalk setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal] ;
        
    }else {
        [self StartTalk];
        [btnTalk setImage:[UIImage imageNamed:@"talksel.png"] forState:UIControlStateNormal] ;
        //btnTalkControl.style = UIBarButtonItemStyleDone;
    }
    m_bTalkStarted = !m_bTalkStarted;
    
    //    if (m_bTalkStarted) {
    //        btnAudioControl.enabled = NO;
    //    }else {
    //        btnAudioControl.enabled = YES;
    //    }
}
//-(void)btnOpenListenCloseTalk{
//    NSLog(@"btnOpenListenCloseTalk");
//    [self StopTalk];
//    [self StartAudio];
//    [self.btnAudioControl setImage:[UIImage imageNamed:@"audio.png"]];
//}
//-(void)btnOpenTalkCloseListen{
//    NSLog(@"btnOpenTalkCloseListen");
//    [self StopAudio];
//    [self StartTalk];
//    [self.btnAudioControl setImage:[UIImage imageNamed:@"micro_on.png"]];
//
//}
- (IBAction) btnItemDefaultVideoParamsPressed:(id)sender
{
    sliderBrightness.value = 1;
    sliderContrast.value = 128;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 1, 1);
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 2, 128);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:1 Value:1];
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:2 Value:128];
    }
    [CustomToast showWithText:@"视频参数恢复默认"
                    superView:self.view
                    bLandScap:YES];
}

- (IBAction) btnUpDown:(id)sender
{
    if (m_bPtzIsUpDown) {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN_STOP);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_UP_DOWN_STOP Step:0];
            
        }
        //btnUpDown.style = UIBarButtonItemStyleBordered;
        [btnUpDown setImage:[UIImage imageNamed:@"updown.png"] forState:UIControlStateNormal];
        
    }else {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_UP_DOWN);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_UP_DOWN Step:0];
            
        }
        // btnUpDown.style = UIBarButtonItemStyleDone;
        
        [btnUpDown setImage:[UIImage imageNamed:@"updownsel.png"] forState:UIControlStateNormal];
    }
    m_bPtzIsUpDown = !m_bPtzIsUpDown;
    
}

- (NSString*) GetRecordFileName
{
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    NSString *strFileName =nil;
    if (isP2P) {
        strFileName = [NSString stringWithFormat:@"%@_%@.rec", strDID, strDateTime];
    }else{
        strFileName = [NSString stringWithFormat:@"%@_%@.rec", m_strIp, strDateTime];
    }
//    [formatter release];
    
    return strFileName;
    
}

- (NSString*) GetRecordPath: (NSString*)strFileName
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath =nil;
    if (isP2P) {
        strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    }else{
        strPath = [documentsDirectory stringByAppendingPathComponent:m_strIp];
    }
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    
    return strPath;
    
    
}

- (void) stopRecord
{
    [m_RecordLock lock];
    //SAFE_DELETE(m_pCustomRecorder);
    [RecNotifyDelegate NotifyReloadData];
    [m_RecordLock  unlock];
}

- (IBAction) btnRecord:(id)sender
{
    if (m_videoFormat == -1) {
        return ;
    }
    
    [m_RecordLock lock];
    
    if (m_pCustomRecorder == NULL) {
        BOOL flag=[self isOutOfMemory];
        if (flag) {
            [CustomToast showWithText:NSLocalizedStringFromTable(@"deviceMemoryOver", @STR_LOCALIZED_FILE_NAME, nil)
                            superView:self.view
                            bLandScap:YES];
            return;
        }
        labelRecord.hidden=NO;
        m_pCustomRecorder = new CCustomAVRecorder();
        recordFileName = [self GetRecordFileName];
        recordFilePath = [self GetRecordPath: recordFileName];
        NSLog(@"录像。。。recordFilePath=%@  cameraName=%@",recordFilePath,cameraName);
        if(m_pCustomRecorder->StartRecord((char*)[recordFilePath UTF8String], m_videoFormat, (char*)[strDID UTF8String]))
        {
            NSDate* date = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            recordFileDate = [formatter stringFromDate:date];
            if (isP2P) {
                if (m_pRecPathMgt!=nil) {
                    [m_pRecPathMgt InsertPath:strDID Date:recordFileDate Path:recordFileName];
                }
                
                
            }else{
                if (m_pRecPathMgt!=nil) {
                    [m_pRecPathMgt InsertPath:m_strIp Date:recordFileDate Path:recordFileName];
                }
                
                
            }
//            [formatter release];
        }
        
        [btnRecord setImage:[UIImage imageNamed:@"recordsel.png"] forState:UIControlStateNormal];
        //   btnRecord.style = UIBarButtonItemStyleDone;
        //  [self.btnItemResolution setEnabled:NO];
        isRecording=YES;
    }else {
        labelRecord.hidden=YES;
        //  [self.btnItemResolution setEnabled:YES];
        isRecording=NO;
        SAFE_DELETE(m_pCustomRecorder);
        [RecNotifyDelegate NotifyReloadData];
        //  btnRecord.style = UIBarButtonItemStyleBordered;
        [btnRecord setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        recordNum=0;
    }
    
    [m_RecordLock unlock];
    
}

- (IBAction) btnLeftRight:(id)sender
{
    if (m_bPtzIsLeftRight) {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_LEFT_RIGHT_STOP Step:0];
            
        }
        
        //  btnLeftRight.style = UIBarButtonItemStyleBordered;
        [btnLeftRight setImage:[UIImage imageNamed:@"leftright.png"] forState:UIControlStateNormal];
        
    }else {
        if (isP2P) {
            m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], CMD_PTZ_LEFT_RIGHT);
        }else{
            [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:CMD_PTZ_LEFT_RIGHT Step:0];
            
        }
        
        // btnLeftRight.style = UIBarButtonItemStyleDone;
        [btnLeftRight setImage:[UIImage imageNamed:@"leftrightsel.png"] forState:UIControlStateNormal];
    }
    m_bPtzIsLeftRight = !m_bPtzIsLeftRight;
}

- (IBAction) btnUpDownMirror:(id)sender
{
    int value;
    
    if (m_bUpDownMirror) {
        //btnUpDownMirror.style = UIBarButtonItemStyleBordered;
        [btnRotate setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
        
        if (m_bLeftRightMirror) {
            value = 2;
        }else {
            value = 0;
        }
    }else {
        //btnUpDownMirror.style = UIBarButtonItemStyleDone;
        [btnRotate setImage:[UIImage imageNamed:@"rotatesel.png"] forState:UIControlStateNormal];
        if (m_bLeftRightMirror) {
            value = 3;
        }else {
            value = 1;
        }
    }
    
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:5 Value:value];
    }
    m_bUpDownMirror = !m_bUpDownMirror;
}

- (IBAction) btnLeftRightMirror:(id)sender
{
    int value;
    
    if (m_bLeftRightMirror) {
        //btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
        [btnMirror setImage:[UIImage imageNamed:@"mirror.png"] forState:UIControlStateNormal];
        
        if (m_bUpDownMirror) {
            value = 1;
        }else {
            value = 0;
        }
    }else {
        
        //btnLeftRightMirror.style = UIBarButtonItemStyleDone;
        [btnMirror setImage:[UIImage imageNamed:@"mirrorsel.png"] forState:UIControlStateNormal];
        
        if (m_bUpDownMirror) {
            value = 3;
        }else {
            value = 2;
        }
    }
    
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 5, value);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:5 Value:value];
    }
    m_bLeftRightMirror = !m_bLeftRightMirror;
}

- (void) showContrastSlider: (BOOL) bShow
{
    [labelContrast setHidden:!bShow];
    [sliderContrast setHidden:!bShow];
    
    if (bShow) {
        //btnSetContrast.style = UIBarButtonItemStyleDone;
        [btnContrast setImage:[UIImage imageNamed:@"contrastsel.png"] forState:UIControlStateNormal];
    }else {
        // btnSetContrast.style = UIBarButtonItemStyleBordered;
        [btnContrast setImage:[UIImage imageNamed:@"contrast.png"] forState:UIControlStateNormal];
    }
}

- (void) showBrightnessSlider: (BOOL) bShow
{
    [labelBrightness setHidden:!bShow];
    [sliderBrightness setHidden:!bShow];
    
    if (bShow) {
        // btnSetBrightness.style = UIBarButtonItemStyleDone;
        [btnBrightness setImage:[UIImage imageNamed:@"brightnesssel.png"] forState:UIControlStateNormal];
    }else {
        // btnSetBrightness.style = UIBarButtonItemStyleBordered;
        [btnBrightness setImage:[UIImage imageNamed:@"brightness.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) btnSetContrast:(id)sender
{
    if (m_bContrastShow) {
        [self showContrastSlider:NO];
    }else {
        [self showContrastSlider:YES];
    }
    m_bContrastShow = !m_bContrastShow;
}

- (IBAction) btnSetBrightness:(id)sender
{
    if (m_bBrightnessShow) {
        [self showBrightnessSlider:NO];
    }else {
        [self showBrightnessSlider:YES];
    }
    m_bBrightnessShow = !m_bBrightnessShow;
}

- (void) setResolutionSize:(NSInteger) resolution
{
    switch (resolution) {
        case 0:
            m_nVideoWidth = 640;
            m_nVideoHeight = 480;
            break;
        case 1:
            m_nVideoWidth = 320;
            m_nVideoHeight = 240;
            break;
        case 3:
            m_nVideoWidth = 1280;
            m_nVideoHeight = 720;
            break;
            
        default:
            break;
    }
    
    [self setDisplayMode];
}

- (IBAction) btnItemResolutionPressed:(id)sender
{
    NSLog(@"btnItemResolutionPressed 999999");
    if (isP2P) {
        if (bGetVideoParams == NO || m_bGetStreamCodecType == NO) {
            return ;
        }
    }
    
    
    int resolution = 0;
    
    if (m_StreamCodecType == STREAM_CODEC_TYPE_JPEG) {
        if (nResolution == 0) {
            resolution = 1;
            
        }else {
            resolution = 0;
        }
    }else {
        switch (nResolution) {
            case 0:
                resolution = 1;
                break;
            case 1:
                resolution = 3;
                break;
            case 3:
                resolution = 0;
                break;
            default:
                return;
        }
    }
    
    progressView.hidden=NO;
    [progressView startAnimating];
    //[self setResolutionSize:resolution];
    nResolution = resolution;
    //[self updateVideoResolution];
    NSLog(@"btnItemResolutionPressed resolution=%d",resolution);
    if (isP2P) {
        
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, resolution);
    }else{
        
        
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:0 Value:resolution];
        
    }
    nUpdataImageCount = 0;
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:3.0];
}

- (IBAction) btnSwitchDisplayMode:(id)sender
{
    switch (m_nDisplayMode) {
        case 0:
            m_nDisplayMode = 1;
            break;
        case 1:
            m_nDisplayMode = 2;
            break;
        case 2:
            m_nDisplayMode = 0;
            break;
        default:
            m_nDisplayMode = 0;
            break;
    }
    
    [self setDisplayMode];
}
-(void) setResolution{
    NSLog(@"setResolution...nResolution=%d",nResolution);
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, nResolution);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:0 Value:nResolution];
        
    }
    
    [self performSelector:@selector(getCameraParams) withObject:nil afterDelay:3.0];
    self.progressView.hidden=YES;
}
- (void) image: (UIImage*)image didFinishSavingWithError: (NSError*) error contextInfo: (void*)contextInfo
{
    //NSLog(@"save result");
    
    if (error != nil) {
        //show error message
        NSLog(@"take picture failed");
    }else {
        //show message image successfully saved
        //NSLog(@"save success");
        [CustomToast showWithText:@"抓图成功"
                        superView:self.view
                        bLandScap:YES];
    }
    
}

- (IBAction) btnSnapshot:(id)sender
{
    NSLog(@"btnSnapshot.....");
    if (isTakepicturing) {
        
        return ;
    }
    
    isTakepicturing=YES;
    UIImage *image = nil;
    if(m_videoFormat!= 0 && m_videoFormat != 2) //MJPEG && H264
    {
        return ;
    }
    
    if (m_videoFormat == 0) {//MJPEG
        
        if (imageSnapshot == nil || m_pPicPathMgt == nil) {
            return;
        }
        image = imageSnapshot;
    }else{//H264
        
        [m_YUVDataLock lock];
        if (m_YUVDataLock == NULL) {
            [m_YUVDataLock unlock];
            return;
        }
        
        //yuv->image
        image = [APICommon YUV420ToImage:m_pYUVData width:m_nWidth height:m_nHeight];
        
        [m_YUVDataLock unlock];
    }
    
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //------save image--------
    
//    [self saveFileManager:image];
    
    // NSLog(@"拍照完成....");
    isTakepicturing=NO;
    if (PicNotifyDelegate!=nil) {
        [PicNotifyDelegate NotifyReloadData];
    }
    
    
}

-(void)saveFileManager:(UIImage *)image{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath=nil;
    if (isP2P) {
        strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    }else{
        strPath = [documentsDirectory stringByAppendingPathComponent:m_strIp];
    }
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [formatter stringFromDate:date];
    
    NSString *strFileName =nil;
    if (isP2P) {
        strFileName = [NSString stringWithFormat:@"%@_%@.jpg", strDID, strDateTime];
    }else{
        strFileName = [NSString stringWithFormat:@"%@_%@.jpg", m_strIp, strDateTime];
        
    }
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    //NSLog(@"strPath: %@", strPath);
    
    //NSData *dataImage = UIImageJPEGRepresentation(imageSnapshot, 1.0);
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    if([dataImage writeToFile:strPath atomically:YES ])
    {
        if (isP2P) {
            if (m_pPicPathMgt!=nil) {
                [m_pPicPathMgt InsertPicPath:strDID PicDate:strDate PicPath:strFileName];
            }
            
        }else{
            if (m_pPicPathMgt!=nil) {
                [m_pPicPathMgt InsertPicPath:m_strIp PicDate:strDate PicPath:strFileName];
            }
            
        }
    }
    
    [CustomToast showWithText:@"抓图成功"
                    superView:self.view
                    bLandScap:YES];
}

- (void) showOSD
{
    if (m_bH264) {
        return ;
    }
    
    [OSDLabel setHidden:NO];
    if (bPlaying == YES) {
        [TimeStampLabel setHidden:NO];
    }
}

- (void) showPtzImage: (BOOL) bShow
{
    [imageUp setHidden:!bShow];
    [imageDown setHidden:!bShow];
    [imageLeft setHidden:!bShow];
    [imageRight setHidden:!bShow];
}

- (void) animationStop
{
    //NSLog(@"animation stop");
    if (!m_bToolBarShow) {
        [self showOSD];
        
        //[self showPtzImage:m_bToolBarShow];
    }
}

- (void) ShowToolBar: (BOOL) bShow
{
    //开始动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    
    //动画的内容
    CGRect frame = toolBarTop.frame;
    if (bShow == YES) {
        frame.origin.y += frame.size.height;
    }else {
        frame.origin.y -= frame.size.height;
    }
    [toolBarTop setFrame:frame];
    
    CGRect frame2 = playToolBar.frame;
    CGRect frame3 = timeoutLabel.frame;
    
    if (bShow == YES) {
        frame3.origin.y -= frame2.size.height;
    }else {
        frame3.origin.y += frame2.size.height;
    }
    [timeoutLabel setFrame:frame3];
    
    if (bShow == YES) {
        frame2.origin.y -= frame2.size.height;
    }else {
        frame2.origin.y += frame2.size.height;
    }
    [playToolBar setFrame:frame2];
    
    
    //动画结束
    [UIView commitAnimations];
}

//停止播放，并返回到设备列表界面
- (void) StopPlay:(int)bForce
{
    NSLog(@"StopPlay....");
    isStop=YES;
    if (m_pCustomRecorder != nil) {
        isRecording=NO;
        SAFE_DELETE(m_pCustomRecorder);
    }
    if (isP2P) {
        
        if (m_pPPPPChannelMgt != NULL) {
            //   m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
            //    m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, nil);
            m_pPPPPChannelMgt->StopPPPPLivestream([strDID UTF8String]);
            m_pPPPPChannelMgt->StopPPPPAudio([strDID UTF8String]);
            m_pPPPPChannelMgt->StopPPPPTalk([strDID UTF8String]);
            m_pPPPPChannelMgt->SetDateTimeDelegate((char*)[strDID UTF8String], nil);
            NSLog(@"delegate===nil.....");
        }
        
        if (timeoutTimer != nil) {
            [timeoutTimer invalidate];
            timeoutTimer = nil;
        }
        
        
        [self stopRecord];
        
    }else{
        NSLog(@"stop...ddns");
        netUtiles.imageNotifyProtocol=nil;
        netUtiles.dateProtocol=nil;
        m_pCameraMediaSource->msgDelegate = nil;
        m_pCameraMediaSource->m_PlayViewImageNotifyDelegate=nil;
        SAFE_DELETE(m_pCameraMediaSource);
        SAFE_DELETE(m_pVideoBuf);
    }
    
    
   [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if (bForce != 1 && bManualStop == NO) {
        [CustomToast showWithText:@"连接断开"
                        superView:self.view
                        bLandScap:YES];
    }
    
}

- (void) hideProgress:(id)param
{
    //  NSLog(@"hideProgress...");
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
    
    if (NO == [OSDLabel isHidden]) {
        [TimeStampLabel setHidden:NO];
    }
    
    //    if (m_nP2PMode == PPPP_MODE_RELAY) {
    //        [timeoutLabel  setHidden:NO];
    //        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    //    }
    
    // [self getCameraParams];
    
    if (m_bH264 == 1) {
        [OSDLabel setHidden:YES];
        [TimeStampLabel setHidden:YES];
    }
}

- (void)enableButton
{
    if (btnRecord!=nil) {
        [btnRecord setEnabled:YES];
    }
    if (btnSnapshot!=nil) {
        [btnSnapshot setEnabled:YES];
    }
    
}


//handler the start timer
- (void)handleTimer:(NSTimer *)timer
{
    //NSLog(@"handleTimer");
    if(m_nTimeoutSec <= 0){
        //[timeoutTimer invalidate];
        //[self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
        [self StopPlay:1];
        return;
    }
    
    //[self performSelectorOnMainThread:@selector(updateTimeout:) withObject:nil waitUntilDone:NO];
    NSString *strTimeout = [NSString stringWithFormat:@"%@ %d %@", @"转发模式观看,剩余时间:",m_nTimeoutSec,@"秒"];
    timeoutLabel.text = strTimeout;
    m_nTimeoutSec = m_nTimeoutSec - 1;
    
    //timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) //userInfo:nil repeats:NO];
    
}

- (void) updateTimeout:(id)data{
    NSString *strTimeout = [NSString stringWithFormat:@"%@ %d %@", @"转发模式观看,剩余时间:",m_nTimeoutSec,@"秒"];
    timeoutLabel.text = strTimeout;
    m_nTimeoutSec = m_nTimeoutSec - 1;
    //NSLog(@"m_nTimeoutSec: %d", m_nTimeoutSec);
}

- (void) updateImage:(id)data
{
    
    UIImage *img = (UIImage*)data;
    
    self.imageSnapshot = img;
    if (imgView!=nil) {
        imgView.image = img;
    }
    
//    [img release];
    
    //show timestamp
    // [self updateTimestamp];
    
}

- (void) updateTimestamp:(NSString *)osd
{
    if (isP2P) {
        if (TimeStampLabel!=nil) {
            TimeStampLabel.text = osd;
        }
        
    }else{
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* str = [formatter stringFromDate:date];
        
        TimeStampLabel.text = str;
//        [formatter release];
        
    }
    
}

- (void) getCameraParams
{
    if (isP2P) {
        m_pPPPPChannelMgt->GetCGI([strDID UTF8String], CGI_IEGET_CAM_PARAMS);
    }else{
        //get_camera_params.cgi
        [netUtiles getCameraDefaultParams:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:9];
    }
}

- (void) updateVideoResolution
{
    NSLog(@"updateVideoResolution  0 VGA  1 QVGA  3 720P nResolution: %d", nResolution);
    
    [self setResolutionSize:nResolution];
    //
    //    switch (nResolution) {
    //        case 0:
    //            //btnItemResolution.title = @"640*480";
    //            btnItemResolution.image = imgVGA;
    //            break;
    //        case 1:
    //            //btnItemResolution.title = @"320*240";
    //            btnItemResolution.image = imgQVGA;
    //            break;
    //        case 2:
    //            //btnItemResolution.title = @"160*120";
    //            break;
    //        case 3:
    //            //btnItemResolution.title = @"1280*720";
    //            btnItemResolution.image = img720P;
    //            break;
    //        case 4:
    //            //btnItemResolution.title = @"640*360";
    //            break;
    //        case 5:
    //            //btnItemResolution.title = @"1280*960";
    //            break;
    //        default:
    //            break;
    //    }
}

- (void) UpdateVieoDisplay
{
    [self updateVideoResolution];
    //[setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",mFrame] Index:4];
    //NSLog(@"m_nFlip: %d", m_nFlip);
    if (bPlaying) {
        progressView.hidden=YES;
    }
    
    switch (m_nFlip) {
        case 0: // normal
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = NO;
            //btnUpDownMirror.style = UIBarButtonItemStyleBordered;
            //btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
            [btnRotate setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
            [btnMirror setImage:[UIImage imageNamed:@"mirror.png"] forState:UIControlStateNormal];
            break;
        case 1: //up down mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = NO;
            // btnUpDownMirror.style = UIBarButtonItemStyleDone;
            // btnLeftRightMirror.style = UIBarButtonItemStyleBordered;
            [btnRotate setImage:[UIImage imageNamed:@"rotatesel.png"] forState:UIControlStateNormal];
            [btnMirror setImage:[UIImage imageNamed:@"mirror.png"] forState:UIControlStateNormal];
            break;
        case 2: // left right mirror
            m_bUpDownMirror = NO;
            m_bLeftRightMirror = YES;
            //btnUpDownMirror.style = UIBarButtonItemStyleBordered;
            //btnLeftRightMirror.style = UIBarButtonItemStyleDone;
            [btnRotate setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
            [btnMirror setImage:[UIImage imageNamed:@"mirrorsel.png"] forState:UIControlStateNormal];
            break;
        case 3: //all mirror
            m_bUpDownMirror = YES;
            m_bLeftRightMirror = YES;
            //btnUpDownMirror.style = UIBarButtonItemStyleDone;
            //btnLeftRightMirror.style = UIBarButtonItemStyleDone;
            [btnRotate setImage:[UIImage imageNamed:@"rotatesel.png"] forState:UIControlStateNormal];
            [btnMirror setImage:[UIImage imageNamed:@"mirrorsel.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    sliderContrast.value = m_Contrast;
    sliderBrightness.value = m_Brightness;
}


- (void) ptzImageTouched: (UITapGestureRecognizer*)sender
{
    UIImageView *imageView = (UIImageView*)[sender view];
    
    // NSLog(@"ptzImageTouched... tag: %d", imageView.tag);
    int command = 0;
    switch (imageView.tag) {
        case 0: //up
            command = CMD_PTZ_UP;
            break;
        case 1: //down
            command = CMD_PTZ_DOWN;
            break;
        case 2: //left
            command = CMD_PTZ_LEFT;
            break;
        case 3: //right
            command = CMD_PTZ_RIGHT;
            break;
            
        default:
            return;
    }
    
    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
}

- (void) playViewTouch: (id) param
{
    //NSLog(@"touch....");
    m_bToolBarShow = !m_bToolBarShow;
    [self ShowToolBar:m_bToolBarShow];
    
    
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
    if (isFrameDialogShow) {
        [self showFrameDialog:isFrameDialogShow];
        isFrameDialogShow=!isFrameDialogShow;
    }
    if (isSeeMoreDialogShow) {
        [self showSeeMoreDialog:isSeeMoreDialogShow];
        isSeeMoreDialogShow=!isSeeMoreDialogShow;
    }
    if (isSetDialogShow) {
        [self showSetDialog:isSetDialogShow];
        isSetDialogShow=!isSetDialogShow;
    }
    
    //    if (isMicrophoneShow) {
    //        [self showBtnMicrophone:isMicrophoneShow];
    //        isMicrophoneShow=!isMicrophoneShow;
    //    }
    
    if (m_bToolBarShow) {
        [OSDLabel setHidden:YES];
        [TimeStampLabel setHidden:YES];
        //[self showPtzImage:YES];
    }else {
        m_bContrastShow = NO;
        m_bBrightnessShow = NO;
        [self showBrightnessSlider:NO];
        [self showContrastSlider:NO];
        
    }
}

#pragma mark -
#pragma mark TouchEvent
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    beginPoint = [[touches anyObject] locationInView:imgView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    
    CGPoint p1;
    CGPoint p2;
    CGFloat sub_x;
    CGFloat sub_y;
    CGFloat currentDistance;
    CGRect imgFrame;
    
    NSArray * touchesArr=[[event allTouches] allObjects];
    
    //NSLog(@"手指个数%d",[touchesArr count]);
    //    NSLog(@"%@",touchesArr);
    
    if ([touchesArr count]>=2) {
        isScale=YES;
        p1=[[touchesArr objectAtIndex:0] locationInView:self.view];
        p2=[[touchesArr objectAtIndex:1] locationInView:self.view];
        
        sub_x=p1.x-p2.x;
        sub_y=p1.y-p2.y;
        
        currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
        
        if (lastDistance>0) {
            if (myGLViewController==nil) {
                imgFrame=imgView.frame;
            }else{
                imgFrame=myGLViewController.view.frame;
            }
            
            
            if (currentDistance>lastDistance+2) {
                NSLog(@"放大");
                
                imgFrame.size.width+=10;
                if (imgFrame.size.width>1000) {
                    imgFrame.size.width=1000;
                }
                
                lastDistance=currentDistance;
            }
            if (currentDistance<lastDistance-2) {
                NSLog(@"缩小");
                
                imgFrame.size.width-=10;
                
                if (imgFrame.size.width<50) {
                    imgFrame.size.width=50;
                }
                
                lastDistance=currentDistance;
            }
            
            if (lastDistance==currentDistance) {
                
                if (myGLViewController==nil) {
                    imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                    
                    float addwidth=imgFrame.size.width-imgView.frame.size.width;
                    float addheight=imgFrame.size.height-imgView.frame.size.height;
                    
                    imgView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
                }else{
                    imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                    
                    float addwidth=imgFrame.size.width-myGLViewController.view.frame.size.width;
                    float addheight=imgFrame.size.height-myGLViewController.view.frame.size.height;
                    
                    myGLViewController.view.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
                }
                
            }
            
        }else {
            lastDistance=currentDistance;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastDistance=0;
    
    
    
    if (isScale) {
        isScale=NO;
        return;
    }
    
    if (bPlaying == NO)
    {
        return;
    }
    
    
    
    CGPoint currPoint = [[touches anyObject] locationInView:imgView];
    const int EVENT_PTZ = 1;
    int curr_event = EVENT_PTZ;
    
    int x1 = beginPoint.x;
    int y1 = beginPoint.y;
    int x2 = currPoint.x;
    int y2 = currPoint.y;
    //NSLog(@"x1=%d y1=%d x2=%d y2=%d",x1,y1,x2,y2);
    int view_width = imgView.frame.size.width;
    int _width1 = 0;
    int _width2 = view_width  ;
    
    if(x1 >= _width1 && x1 <= _width2)
    {
        curr_event = EVENT_PTZ;
    }
    else
    {
        return;
    }
    
    const int MIN_X_LEN = 60;
    const int MIN_Y_LEN = 60;
    
    int len = (x1 > x2) ? (x1 - x2) : (x2 - x1) ;
    BOOL b_x_ok = (len >= MIN_X_LEN ) ? YES : NO ;
    len = (y1 > y2) ? (y1 - y2) : (y2 - y1) ;
    BOOL b_y_ok = (len > MIN_Y_LEN) ? YES : NO;
    
    BOOL bUp = NO;
    BOOL bDown = NO;
    BOOL bLeft = NO;
    BOOL bRight = NO;
    
    bDown = (y1 > y2) ? NO : YES;
    bUp = !bDown;
    bRight = (x1 > x2) ? NO : YES;
    bLeft = !bRight;
    
    int command = 0;
    
    switch (curr_event)
    {
        case EVENT_PTZ:
        {
            
            if (b_x_ok == YES)
            {
                if (bLeft == YES)
                {
                    NSLog(@"left");
                    //command = CMD_PTZ_LEFT;
                    command = CMD_PTZ_RIGHT;
                }
                else
                {
                    NSLog(@"right");
                    //command = CMD_PTZ_RIGHT;
                    command = CMD_PTZ_LEFT;
                }
                
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:command Step:1];
                    
                }
                if (isMove) {
                    return;
                }
                isMove=YES;
                progressView.hidden=NO;
                [progressView startAnimating];
                [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:2];
                
            }
            
            if (b_y_ok == YES)
            {
                
                if (bUp == YES)
                {
                    NSLog(@"up");
                    //command = CMD_PTZ_UP;
                    command = CMD_PTZ_DOWN;
                }
                else
                {
                    NSLog(@"down");
                    //command = CMD_PTZ_DOWN;
                    command = CMD_PTZ_UP;
                }
                
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control([strDID UTF8String], command);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:command Step:1];
                }
                if (isMove) {
                    return;
                }
                isMove=YES;
                progressView.hidden=NO;
                [progressView startAnimating];
                [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:2];
                
            }
        }
            break;
            
        default:
            return ;
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesCancelled");
}

#pragma mark -

#pragma mark system

-(BOOL)shouldAutorotate{
    return NO;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    
    // NSLog(@"playviewcontroller shouldAutorotateToInterfaceOrientation");
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 6.0) {
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
        CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
        
        self.view.frame = rectScreen;//CGRectMake(0,0,480,320);
    }
    
    if (isMoreView) {
        NSLog(@"PlayView...more  viewWillAppear");
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(popToHome)
         name:@"enterbackground"
         object:nil];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(createPlay)
     name:@"becomeActive"
     object:nil];
}

-(void)popToHome{
    [self StopPlay:1];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if (isMoreView) {
        NSLog(@"PlayViewController....more..viewWillDisappear");
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"enterbackground" object:nil];
        
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"becomeActive" object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) updateContrast: (id) sender
{
    UISlider  *slider=(UISlider*)sender;
    float f = slider.value;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 2, f);
        NSLog(@"sliderContrast....f=%f",f);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:2 Value:f];
    }
}

- (void) updateBrightness: (id) sender
{
    UISlider  *slider=(UISlider*)sender;
    
    float f = slider.value;
    if (isP2P) {
        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 1, f);
        NSLog(@"updateBrightness....f=%f",f);
    }else{
        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:1 Value:f];
    }
}

- (void) setDisplayModeImage
{
    switch (m_nDisplayMode) {
        case 0: //normal
            // btnSwitchDisplayMode.image = imgEnlarge;
            [btnSize setImage:imgEnlarge forState:UIControlStateNormal];
            break;
        case 1: //enlarge
            // btnSwitchDisplayMode.image = imgFullScreen;
            [btnSize setImage:imgFullScreen forState:UIControlStateNormal];
            break;
        case 2: //full screen
            // btnSwitchDisplayMode.image = imgNormal;
            [btnSize setImage:imgNormal forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void) setDisplayMode
{
    //NSLog(@"setDisplayMode...m_nVideoWidth: %d, m_nVideoHeight: %d, m_nDisplayMode: %d", m_nVideoWidth, m_nVideoHeight, m_nDisplayMode);
    
    if (m_nVideoWidth == 0 || m_nVideoHeight == 0)
    {
        return;
    }
    
    int nDisplayWidth = 0;
    int nDisplayHeight = 0;
    
    
    switch (m_nDisplayMode)
    {
        case 0:
        {
            if (m_nVideoWidth > m_nScreenWidth || m_nVideoHeight > m_nScreenHeight) {
                nDisplayHeight = m_nScreenHeight;
                nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
                if (nDisplayWidth > m_nScreenWidth) {
                    nDisplayWidth = m_nScreenWidth;
                    nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
                }
            }else {
                nDisplayWidth = m_nVideoWidth;
                nDisplayHeight = m_nVideoHeight;
            }
        }
            break;
        case 1:
        {
            nDisplayHeight = m_nScreenHeight;
            nDisplayWidth = m_nVideoWidth * m_nScreenHeight / m_nVideoHeight ;
            if (nDisplayWidth > m_nScreenWidth) {
                nDisplayWidth = m_nScreenWidth;
                nDisplayHeight = m_nVideoHeight * m_nScreenWidth / m_nVideoWidth;
            }
        }
            break;
        case 2:
        {
            nDisplayWidth = m_nScreenWidth;
            nDisplayHeight = m_nScreenHeight;
        }
            break;
        default:
            break;
    }
    
    //NSLog(@"nDisplayWidth: %d, nDisplayHeight: %d", nDisplayWidth, nDisplayHeight);
    
    int nCenterX = m_nScreenWidth / 2;
    int nCenterY = m_nScreenHeight / 2;
    
    //NSLog(@"nCenterX:%d, nCenterY: %d", nCenterX, nCenterY);
    
    int halfWidth = nDisplayWidth / 2;
    int halfHeight = nDisplayHeight / 2;
    
    int nDisplayX = nCenterX - halfWidth;
    int nDisplayY = nCenterY - halfHeight;
    
    //NSLog(@"halfWdith: %d, halfHeight: %d, nDisplayX: %d, nDisplayY: %d",
    //      halfWidth, halfHeight, nDisplayX, nDisplayY);
    
    CGRect imgViewFrame ;
    imgViewFrame.origin.x = nDisplayX;
    imgViewFrame.origin.y = nDisplayY;
    imgViewFrame.size.width = nDisplayWidth;
    imgViewFrame.size.height = nDisplayHeight;
    imgView.frame = imgViewFrame;
    
    //----for yuv------
    //CGRect GLViewRect ;
    //GLViewRect.origin.x = nDisplayX;
    //GLViewRect.origin.y = nDisplayY;
    ////GLViewRect.size.width = nDisplayWidth;
    //GLViewRect.size.height = nDisplayHeight;
    myGLViewController.view.frame = imgViewFrame;
    
    // NSLog(@"nDisplayWidth: %d, nDisplayHeight: %d", nDisplayWidth, nDisplayHeight);
    
    
    [self setDisplayModeImage];
    
}

- (IBAction) btnMore:(id)sender{
    [self showSetDialog:isSetDialogShow];
    isSetDialogShow=!isSetDialogShow;
    if (isPresetDialogShow) {
        [self showPresetDialog:isPresetDialogShow];
        isPresetDialogShow=!isPresetDialogShow;
    }
}
#pragma mark -
#pragma mark DialogDelegate
-(void)presetDialogOnClick:(int)tag{
    NSLog(@"presetDialogOnClick  tag=%d",tag);
    switch (tag) {
        case 101:
            isCallPreset=YES;
            break;
        case 102:
            isCallPreset=NO;
            break;
        case 1:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 30);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:30 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 31);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:31 Step:0];
                }
                
            }
            break;
        case 2:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 32);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:32 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 33);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:33 Step:0];
                }
                
            }
            break;
        case 3:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 34);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:34 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 35);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:35 Step:0];
                }
                
            }
            break;
        case 4:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 36);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:36 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 37);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:37 Step:0];
                }
                
            }
            break;
        case 5:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 38);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:38 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 39);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:39 Step:0];
                }
                
            }
            break;
        case 6:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 40);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:40 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 41);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:41 Step:0];
                }
                
            }
            break;
        case 7:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 42);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:42 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 43);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:43 Step:0];
                }
                
            }
            break;
            
        case 8:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 44);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:44 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 45);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:45 Step:0];
                }
                
            }
            break;
        case 9:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 46);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:46 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 47);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:47 Step:0];
                }
                
            }
            break;
        case 10:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 48);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:48 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 49);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:49 Step:0];
                }
                
            }
            break;
        case 11:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 50);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:50 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 51);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:51 Step:0];
                }
                
            }
            break;
        case 12:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 52);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:52 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 53);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:53 Step:0];
                }
                
            }
            break;
        case 13:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 54);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:54 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 55);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:55 Step:0];
                }
                
            }
            break;
        case 14:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 56);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:56 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 57);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:57 Step:0];
                }
                
            }
            break;
        case 15:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 58);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:58 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 59);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:59 Step:0];
                }
                
            }
            break;
        case 16:
            if (!isCallPreset) {
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 60);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:60 Step:0];
                }
                
            }else{
                if (isP2P) {
                    m_pPPPPChannelMgt->PTZ_Control((char *)[strDID UTF8String], 61);
                }else{
                    [netUtiles PTZControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:61 Step:0];
                }
                
            }
            break;
            
        default:
            break;
    }
    if (tag!=101&&tag!=102) {
        [self showPresetDialog:YES];
        isPresetDialogShow=NO;
    }
    
}
-(void)mySetDialogOnClick:(int)tag Type:(int)type{//预置位和红外灯
    NSLog(@"mySetDialogOnClick type=%d tag=%d",type,tag);
    switch (type) {
        case 1:
            switch (tag) {
                case 0:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 0);
                        [setDialog setBtnSelected:YES Index:0];
                        [setDialog setBtnSelected:NO Index:1];
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:14 Value:0];
                        [setDialog setBtnSelected:YES Index:0];
                        [setDialog setBtnSelected:NO Index:1];
                    }
                    
                    break;
                case 1:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 14, 1);
                        [setDialog setBtnSelected:NO Index:0];
                        [setDialog setBtnSelected:YES Index:1];
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:14 Value:1];
                        [setDialog setBtnSelected:NO Index:0];
                        [setDialog setBtnSelected:YES Index:1];
                    }
                    
                    
                    break;
                case 2:
                    NSLog(@"预置位。。。");
                    if (isFrameDialogShow) {
                        [self showFrameDialog:isFrameDialogShow];
                        isFrameDialogShow=!isFrameDialogShow;
                    }
                    if (isSeeMoreDialogShow) {
                        [self showSeeMoreDialog:isSeeMoreDialogShow];
                        isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    }
                    
                    [self showPresetDialog:isPresetDialogShow];
                    isPresetDialogShow=!isPresetDialogShow;
                    break;
                case 3:
                    if (isFrameDialogShow) {
                        [self showFrameDialog:isFrameDialogShow];
                        isFrameDialogShow=!isFrameDialogShow;
                    }
                    if (isPresetDialogShow) {
                        [self showPresetDialog:isPresetDialogShow];
                        isPresetDialogShow=!isPresetDialogShow;
                    }
                    [self showSeeMoreDialog:isSeeMoreDialogShow];
                    isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    break;
                case 4:
                    if (isSeeMoreDialogShow) {
                        [self showSeeMoreDialog:isSeeMoreDialogShow];
                        isSeeMoreDialogShow=!isSeeMoreDialogShow;
                    }
                    if (isPresetDialogShow) {
                        [self showPresetDialog:isPresetDialogShow];
                        isPresetDialogShow=!isPresetDialogShow;
                    }
                    [self showFrameDialog:isFrameDialogShow];
                    isFrameDialogShow=!isFrameDialogShow;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            [self showSeeMoreDialog:isSeeMoreDialogShow];
            isSeeMoreDialogShow=!isSeeMoreDialogShow;
            
            //  [self.progressView setHidden:NO];
            //  [self.progressView startAnimating];
            
            switch (tag) {
                case 0://质量优先
                    NSLog(@"质量优先");
                    [seeMoreDialog setBtnSelected:YES Index:0];
                    [seeMoreDialog setBtnSelected:NO Index:1];
                    [seeMoreDialog setBtnSelected:NO Index:2];
                    
                    if (isP2P) {
                        
                        //5350
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 1500);//码率
                        // usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 5);//帧率
                        
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 0);//分辨率
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 3);//分辨率
                        
                        
                        //3518E
                        //请求主码流
                        m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 3, self);
                        
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:2500];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:10];
                    }
                    nResolution=0;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                case 1://速度优先
                    [seeMoreDialog setBtnSelected:NO Index:0];
                    [seeMoreDialog setBtnSelected:YES Index:1];
                    [seeMoreDialog setBtnSelected:NO Index:2];
                    NSLog(@"速度优先");
                    if (isP2P) {
                        //5350
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 128);//码率
                        //usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 20);//帧率
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);//分辨率
                        
                        //3518E
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 20, 128);//码率
                        //usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 17, 20);//帧率
                        m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 1, self);
                        
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:800];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:20];
                    }
                    nResolution=1;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                case 2://画质中等
                    NSLog(@"画质中等");
                    [seeMoreDialog setBtnSelected:NO Index:0];
                    [seeMoreDialog setBtnSelected:NO Index:1];
                    [seeMoreDialog setBtnSelected:YES Index:2];
                    
                    if (isP2P) {
                        //5350
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 13, 512);//码率
                        // usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 10);//帧率
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 0);//分辨率
                        
                        //3518E
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 19, 512);//码率
                        // usleep(100);
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 12, 10);//帧率
                        m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 0, self);
                        
                    }else{
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:13 Value:1300];
                        usleep(100);
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:15];
                    }
                    nResolution=0;
                    [self performSelector:@selector(setResolution) withObject:nil afterDelay:10];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            [self showFrameDialog:isFrameDialogShow];
            isFrameDialogShow=!isFrameDialogShow;
            
            [self.progressView setHidden:NO];
            [self.progressView startAnimating];
            switch (tag) {
                case 0:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 5);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:5];
                    }
                    
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",5] Index:4];
                    break;
                case 1:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 10);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:10];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",10] Index:4];
                    break;
                case 2:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 15);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:15];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",15] Index:4];
                    break;
                case 3:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 20);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:20];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",20] Index:4];
                    break;
                case 4:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 25);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:25];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",25] Index:4];
                    break;
                case 5:
                    if (isP2P) {
                        m_pPPPPChannelMgt->CameraControl([strDID UTF8String], 6, 30);
                    }else{
                        
                        [netUtiles CameraControl:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd Command:6 Value:30];
                    }
                    [setDialog setBtnTitle:[NSString stringWithFormat:@"%dfps",30] Index:4];
                    break;
                default:
                    break;
            }
            [self performSelector:@selector(hindeProgressView) withObject:nil afterDelay:5];
            break;
            
        default:
            break;
    }
    
}
-(void)hindeProgressView{
    isMove=NO;
    [self.progressView setHidden:YES];
}
-(void)showPresetDialog:(BOOL)bShow{
    NSLog(@"showPresetDialog...");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=preDialog.frame;
    if (bShow) {
        frame.origin.y-=240;
    }else{
        frame.origin.y+=240;
    }
    preDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}

-(void)showSetDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=setDialog.frame;
    if (bShow) {
        frame.origin.x-=90;
    }else{
        frame.origin.x+=90;
    }
    setDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showSeeMoreDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=seeMoreDialog.frame;
    if (bShow) {
        frame.origin.y-=175;
    }else{
        frame.origin.y+=175;
    }
    seeMoreDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)showFrameDialog:(BOOL)bShow{
    NSLog(@"showFrameDialog...start");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=frameDialog.frame;
    if (bShow) {
        frame.origin.y-=225;
    }else{
        frame.origin.y+=225;
    }
    frameDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
    // NSLog(@"showFrameDialog...end");
}

-(void)showBtnMicrophone:(BOOL)bShow{
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDelegate:self];
    //    //设定动画持续时间
    //    [UIView setAnimationDuration:0.4];
    //    CGRect frame=btnMicrophone.frame;
    //    if (bShow) {
    //        frame.origin.x+=150;
    //    }else{
    //        frame.origin.x-=150;
    //    }
    //    btnMicrophone.frame=frame;
    //
    //    //动画结束
    //    [UIView commitAnimations];
}
-(void)onNSTimerRun{
//    return;
//    [self performSelectorOnMainThread:@selector(showNetWorkSpeed) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(showNetWorkSpeed) withObject:nil waitUntilDone:NO];
    //NSLog(@"onNSTimerRun");
}
-(void)showNetWorkSpeed{
    NSString *speed=[NSString stringWithFormat:@"%dKbps",((int)(networkspeed/8000))];
    labelNetworkSpeed.text=speed;
    labelNetworkSpeed.hidden=NO;
    networkspeed=0;
}

-(void)initFrameDialog:(NSNumber *)num{
    BOOL flag=[num boolValue];
    if (flag) {//高清
        frameDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -180, 120, 180) Btn:5];
        
        // [frameDialog setBtnTitle:@"30fps" Index:0];
        [frameDialog setBtnTitle:@"25fps" Index:4];
        [frameDialog setBtnTitle:@"20fps" Index:3];
        [frameDialog setBtnTitle:@"15fps" Index:2];
        [frameDialog setBtnTitle:@"10fps" Index:1];
        [frameDialog setBtnTitle:@"5fps" Index:0];
    }else{//标清
        frameDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -180, 120, 180) Btn:6];
        
        [frameDialog setBtnTitle:@"30fps" Index:5];
        [frameDialog setBtnTitle:@"25fps" Index:4];
        [frameDialog setBtnTitle:@"20fps" Index:3];
        [frameDialog setBtnTitle:@"15fps" Index:2];
        [frameDialog setBtnTitle:@"10fps" Index:1];
        [frameDialog setBtnTitle:@"5fps" Index:0];
    }
    frameDialog.mType=3;
    frameDialog.diaDelegate=self;
    [self.view addSubview:frameDialog];
}
- (void) CreateGLView
{
    imgView.hidden=YES;
    myGLViewController = [[MyGLViewController alloc] init];
    myGLViewController.view.frame = CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    [self.view addSubview:myGLViewController.view];
    [self.view bringSubviewToFront:OSDLabel];
    [self.view bringSubviewToFront:TimeStampLabel];
    [self.view bringSubviewToFront:toolBarTop];
    [self.view bringSubviewToFront:playToolBar];
    [self.view bringSubviewToFront:labelBrightness];
    [self.view bringSubviewToFront:labelContrast];
    [self.view bringSubviewToFront:sliderBrightness];
    [self.view bringSubviewToFront:sliderContrast];
    [self.view bringSubviewToFront:timeoutLabel];
    [self.view bringSubviewToFront:setDialog];
    [self.view bringSubviewToFront:preDialog];
    [self.view bringSubviewToFront:seeMoreDialog];
    [self.view bringSubviewToFront:frameDialog];
    [self.view bringSubviewToFront:progressView];
    //   [self.view bringSubviewToFront:btnMicrophone];
    [self.view bringSubviewToFront:labelNetworkSpeed];
    [self.view bringSubviewToFront:labelRecord];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    CGRect mainScreen=[[UIScreen mainScreen]bounds];
    [self.view setBackgroundColor:[UIColor blackColor]];
    strOSD=@"";
    
    labelRecord.adjustsFontSizeToFitWidth=YES;
    
    
    imgView.backgroundColor=[UIColor blackColor];
    isStop=NO;
    networkspeed=0;
    
    m_bH264 = 0;
    
    
    //    [btnMicrophone setBackgroundImage:[UIImage imageNamed:@"microphoneselected.png"] forState:UIControlStateHighlighted];
    //    [btnMicrophone setBackgroundImage:[UIImage imageNamed:@"microphone.png"] forState:UIControlStateNormal];
    //    CGRect btnMPFrame=btnMicrophone.frame;
    //    btnMPFrame.origin.x+=150;
    //    btnMicrophone.frame=btnMPFrame;
    //    [btnMicrophone addTarget:self action:@selector(btnOpenTalkCloseListen) forControlEvents:UIControlEventTouchDown];
    //    [btnMicrophone addTarget:self action:@selector(btnOpenListenCloseTalk) forControlEvents:UIControlEventTouchUpInside];
    //    btnMicrophone.backgroundColor=[UIColor clearColor];
    
    //CGRect mainScreen=[[UIScreen mainScreen] bounds];
    isSetDialogShow=NO;
    isPresetDialogShow=NO;
    isCallPreset=YES;
    setDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(-80, 50, 80, 180) Btn:4];
    setDialog.mType=1;
    [self.view addSubview:setDialog];
    setDialog.diaDelegate=self;
    setDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    [setDialog setBtnImag:[UIImage imageNamed:@"Led.png"] Index:0];
    [setDialog setBtnImag:[UIImage imageNamed:@"led_open.png"] Index:1];
    [setDialog setBtnTitle:@"預置位" Index:2];
    [setDialog setBtnTitle:@"观看模式" Index:3];
    //    [setDialog setBtnTitle:@"15p/s" Index:4];
    preDialog=[[PresetDialog alloc]initWithFrame:CGRectMake(100,-190, 200, 190) Num:4];
    [self.view addSubview:preDialog];
    
    preDialog.diaDelegate=self;
    preDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    
    
    isSeeMoreDialogShow=NO;
    isFrameDialogShow=NO;
    
    
    seeMoreDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(100, -130, 120, 130) Btn:3];
    seeMoreDialog.mType=2;
    [self.view addSubview:seeMoreDialog];
    [seeMoreDialog setBtnTitle:@"画质优先" Index:0];
    [seeMoreDialog setBtnTitle:@"速度优先" Index:1];
    [seeMoreDialog setBtnTitle:@"画质中等" Index:2];
    //[seeMoreDialog setBtnSelected:YES Index:0];
    seeMoreDialog.diaDelegate=self;
    
    
    //NSLog(@"PlayViewController viewDidLoad=======================================");
    recordNum=0;
    isRecording=NO;
    isTakepicturing=NO;
    m_videoFormat = -1;
    nUpdataImageCount = 0;
    m_bTalkStarted = NO;
    m_bAudioStarted = NO;
    m_bPtzIsUpDown = NO;
    m_bPtzIsLeftRight = NO;
    m_nDisplayMode = 0;
    m_nVideoWidth = 0;
    m_nVideoHeight = 0;
    m_pCustomRecorder = NULL;
    m_pYUVData = NULL;
    m_nWidth = 0;
    m_nHeight = 0;
    m_YUVDataLock = [[NSCondition alloc] init];
    m_RecordLock = [[NSCondition alloc] init];
    
    [self showPtzImage:NO];
    
    
    
    CGRect getFrame = [[UIScreen mainScreen]applicationFrame];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    //m_nScreenHeight = getFrame.size.height;
    //m_nScreenWidth = getFrame.size.width;
    //NSLog(@"screen width: %d height: %d", m_nScreenWidth, m_nScreenHeight);
    
    //create yuv displayController
    myGLViewController = nil;
    
    imageUp.tag = 0;
    imageDown.tag = 1;
    imageLeft.tag = 2;
    imageRight.tag = 3;
    imageUp.userInteractionEnabled = YES;
    UITapGestureRecognizer *ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageUp addGestureRecognizer:ptzImageGR];
//    [ptzImageGR release];
    
    imageDown.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageDown addGestureRecognizer:ptzImageGR];
//    [ptzImageGR release];
    
    imageLeft.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageLeft addGestureRecognizer:ptzImageGR];
//    [ptzImageGR release];
    
    imageRight.userInteractionEnabled = YES;
    ptzImageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptzImageTouched:)];
    [ptzImageGR setNumberOfTapsRequired:1];
    [imageRight addGestureRecognizer:ptzImageGR];
//    [ptzImageGR release];
    
    
    
    UIImageView *imageBg;
    imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight)];
    imageBg.backgroundColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:0.5];
//    imageBg.backgroundColor=[UIColor redColor];
    imageBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    [tapGes1 setNumberOfTapsRequired:1];
    [imageBg addGestureRecognizer:tapGes1];
//    [tapGes1 release];
    [self.view addSubview:imageBg];
    [self.view sendSubviewToBack:imageBg];
//    [imageBg release];
    
    self.imgVGA = [UIImage imageNamed:@"resolution_vga_pressed"];
    self.imgQVGA = [UIImage imageNamed:@"resolution_qvga"];
    self.img720P = [UIImage imageNamed:@"resolution_720p_pressed"];
    
    
    self.imgNormal = [UIImage imageNamed:@"ptz_playmode_standard"];
    self.imgEnlarge = [UIImage imageNamed:@"ptz_playmode_enlarge"];
    self.imgFullScreen = [UIImage imageNamed:@"ptz_playmode_fullscreen"];
    
    //==========================================================
    labelContrast  = [[UILabel alloc] initWithFrame:CGRectMake(20, (mainScreen.size.width-170)/2, 30, 170)];
    UIColor *labelColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    labelContrast.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelContrast.layer.cornerRadius = 5.0;
    labelContrast.userInteractionEnabled=YES;
    [self.view addSubview:labelContrast];
    [labelContrast setHidden:YES];
    
    sliderContrast = [[UISlider alloc] init];
    [sliderContrast setMaximumValue:255.0];
    [sliderContrast setMinimumValue:1.0];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-1.57079633);
    sliderContrast.transform = rotation;
    [sliderContrast setFrame:CGRectMake(20,  (mainScreen.size.width-160)/2, 30, 160)];
    [self.view addSubview:sliderContrast];
    [sliderContrast setHidden:YES];
    [sliderContrast addTarget:self action:@selector(updateContrast:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bContrastShow = NO;
    //==========================================================
    
    //==========================================================
    labelBrightness  = [[UILabel alloc] initWithFrame:CGRectMake(mainScreen.size.height - 50, (mainScreen.size.width-170)/2, 30, 170)];
    labelBrightness.backgroundColor = labelColor;
    labelContrast.layer.masksToBounds = YES;
    labelBrightness.layer.cornerRadius = 5.0;
    labelBrightness.userInteractionEnabled=YES;
    [self.view addSubview:labelBrightness];
    [labelBrightness setHidden:YES];
    
    sliderBrightness = [[UISlider alloc] init];
    [sliderBrightness setMaximumValue:255.0];
    [sliderBrightness setMinimumValue:1.0];
    sliderBrightness.transform = rotation;
    [sliderBrightness setFrame:CGRectMake(mainScreen.size.height - 50, (mainScreen.size.width-160)/2, 30, 160)];
    [self.view addSubview:sliderBrightness];
    [sliderBrightness setHidden:YES];
    [sliderBrightness addTarget:self action:@selector(updateBrightness:) forControlEvents:UIControlEventTouchUpInside];
    
    m_bBrightnessShow = NO;
    //==========================================================
    
    m_bToolBarShow = YES;
    if ([[UIDevice currentDevice] userInterfaceIdiom]!=UIUserInterfaceIdiomPhone) {
        CGRect frame=toolBarTop.frame;
        frame.origin.y-=20;
        toolBarTop.frame=frame;
    }
    //self.btnTitle.title = cameraName;
    
    
    toolBarTop.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255.0f green:COLOR_BASE_GREEN/255.0f blue:COLOR_BASE_BLUE/255.0f alpha:1.0f];
    playToolBar.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255.0f green:COLOR_BASE_GREEN/255.0f blue:COLOR_BASE_BLUE/255.0f alpha:1.0f];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        
        //iOS 5
        UIImage *toolBarIMG = [UIImage imageNamed: @"barbk.png"];
        if ([toolBarTop respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [toolBarTop setBackgroundImage:toolBarIMG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        }
        if ([playToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [playToolBar setBackgroundImage:toolBarIMG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        }
        
    } else {
        
        //iOS 4
        [toolBarTop insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barbk.png"]] atIndex:0];
        [playToolBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barbk.png"]] atIndex:0];
    }
    
    //    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTouch:)];
    //    [tapGes setNumberOfTapsRequired:1];
    //    [self.imgView addGestureRecognizer:tapGes];
    //    [tapGes release];
    
    UIColor *osdColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3f];
    
    ///////////////////////////////////////////////////////////////////
    OSDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [OSDLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    CGSize size = CGSizeMake(170,100);
    OSDLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *s = cameraName;
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [OSDLabel setFrame: CGRectMake(10, 10, labelsize.width, labelsize.height)];
    OSDLabel.text = cameraName;
    OSDLabel.font = font;
    OSDLabel.layer.masksToBounds = YES;
    OSDLabel.layer.cornerRadius = 2.0;
    OSDLabel.backgroundColor = osdColor;
    [self.view addSubview:OSDLabel];
    [OSDLabel setHidden:YES];
    ///////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////////////
    TimeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [TimeStampLabel setNumberOfLines:0];
    //font = [UIFont fontWithName:@"Arial" size:18];
    //size = CGSizeMake(170,100);
    TimeStampLabel.lineBreakMode = NSLineBreakByWordWrapping;
    s = @"2012-07-04 08:05:30";
    labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [TimeStampLabel setFrame: CGRectMake(mainScreen.size.height - 10 - labelsize.width, 10, labelsize.width, labelsize.height)];
    TimeStampLabel.font = font;
    TimeStampLabel.layer.masksToBounds = YES;
    TimeStampLabel.layer.cornerRadius = 2.0;
    TimeStampLabel.backgroundColor = osdColor;
    [self.view addSubview:TimeStampLabel];
    [TimeStampLabel setHidden:YES];
    ///////////////////////////////////////////////////////////////////
    
    [timeoutLabel setHidden:YES];
    //timeoutLabel.backgroundColor = osdColor;
    m_nTimeoutSec = 180;
    timeoutTimer = nil;
    
    //imgView.userInteractionEnabled = YES;
    bGetVideoParams = NO;
    bManualStop = NO;
    m_bGetStreamCodecType = NO;
    
    self.LblProgress.text = @"正在连接...";
    
    [self.progressView setHidden:NO];
    [self.progressView startAnimating];
    
   
    [self performSelector:@selector(playViewTouch:) withObject:nil afterDelay:1];
    
    imgStartWidth=imgView.frame.size.width;
    imgStartHeight=imgView.frame.size.height;
    
    //return ;
    
    [self createPlay];
    //////
    
    myToolBarItems = [NSMutableArray array];
    
    //updown
    btnUpDown = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,35)];
    [btnUpDown setImage:[UIImage imageNamed:@"updown.png"] forState:UIControlStateNormal];
    [btnUpDown setImage:[UIImage imageNamed:@"updownsel.png"] forState:UIControlStateHighlighted];
    [btnUpDown addTarget:self action:@selector(btnUpDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnUpDown];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    //return ;
    
    //left right
    btnLeftRight = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnLeftRight setImage:[UIImage imageNamed:@"leftright.png"] forState:UIControlStateNormal];
    [btnLeftRight setImage:[UIImage imageNamed:@"leftrightsel.png"] forState:UIControlStateHighlighted];
    [btnLeftRight addTarget:self action:@selector(btnLeftRight:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnLeftRight];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    //more
    btnMoreControl = [[UIButton alloc] initWithFrame:CGRectMake(5,5,45,45)];
    [btnMoreControl setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    //   [btnMoreControl setImage:[UIImage imageNamed:@"leftrightsel.png"] forState:UIControlStateHighlighted];
    [btnMoreControl addTarget:self action:@selector(btnMore:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnMoreControl];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    //////////
    [myToolBarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///titleLabel
    LabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5,5,100,50)];
    //LabelTitle.text = @"Test";
    LabelTitle.textColor = [UIColor whiteColor];
    
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:LabelTitle];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    
    //////////
    [myToolBarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    //rotate
    btnRotate = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnRotate setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
    [btnRotate setImage:[UIImage imageNamed:@"rotatesel.png"] forState:UIControlStateHighlighted];
    [btnRotate addTarget:self action:@selector(btnUpDownMirror:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnRotate];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    //mirror
    btnMirror = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnMirror setImage:[UIImage imageNamed:@"mirror.png"] forState:UIControlStateNormal];
    [btnMirror setImage:[UIImage imageNamed:@"mirrorsel.png"] forState:UIControlStateHighlighted];
    [btnMirror addTarget:self action:@selector(btnLeftRightMirror:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnMirror];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    //close
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(5,5,30,30)];
    [btnClose setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnStop:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnClose];
    
    [myToolBarItems addObject:barItem];
//    [barItem release];
    
    
    
    
    ///////
    [toolBarTop setItems:myToolBarItems];
    //  [myToolBarItems release];
    
    // return ;
    
    ///////
    
    myToolBarItems2 = [NSMutableArray array];
    
    ///snapshot
    btnSnapshot = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnSnapshot setImage:[UIImage imageNamed:@"snapshot.png"] forState:UIControlStateNormal];
    [btnSnapshot setImage:[UIImage imageNamed:@"snapshotsel.png"] forState:UIControlStateHighlighted];
    [btnSnapshot addTarget:self action:@selector(btnSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnSnapshot];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///record
    btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnRecord setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [btnRecord setImage:[UIImage imageNamed:@"recordsel.png"] forState:UIControlStateHighlighted];
    [btnRecord addTarget:self action:@selector(btnRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnRecord];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    
    ///audio
    btnAudio = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnAudio setImage:[UIImage imageNamed:@"audio.png"] forState:UIControlStateNormal];
    [btnAudio setImage:[UIImage imageNamed:@"audiosel.png"] forState:UIControlStateHighlighted];
    [btnAudio addTarget:self action:@selector(btnAudioControl:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnAudio];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///talk
    btnTalk = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnTalk setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
    [btnTalk setImage:[UIImage imageNamed:@"talksel.png"] forState:UIControlStateHighlighted];
    [btnTalk addTarget:self action:@selector(btnTalkControl:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnTalk];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///contrast
    btnContrast = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnContrast setImage:[UIImage imageNamed:@"contrast.png"] forState:UIControlStateNormal];
    [btnContrast setImage:[UIImage imageNamed:@"contrastsel.png"] forState:UIControlStateHighlighted];
    [btnContrast addTarget:self action:@selector(btnSetContrast:) forControlEvents:UIControlEventTouchUpInside];
    
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnContrast];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///brightness
    btnBrightness = [[UIButton alloc] initWithFrame:CGRectMake(5,5,40,40)];
    [btnBrightness setImage:[UIImage imageNamed:@"brightness.png"] forState:UIControlStateNormal];
    [btnBrightness setImage:[UIImage imageNamed:@"brightnesssel.png"] forState:UIControlStateHighlighted];
    [btnBrightness addTarget:self action:@selector(btnSetBrightness:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnBrightness];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    //////
    [myToolBarItems2 addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    
    ///size
    btnSize = [[UIButton alloc] initWithFrame:CGRectMake(5,5,45,45)];
    [btnSize setImage:[UIImage imageNamed:@"ptz_playmode_enlarge.png"] forState:UIControlStateNormal];
    [btnSize addTarget:self action:@selector(btnSwitchDisplayMode:) forControlEvents:UIControlEventTouchUpInside];
    
    barItem = [[UIBarButtonItem alloc]initWithCustomView:btnSize];
    
    [myToolBarItems2 addObject:barItem];
//    [barItem release];
    
    ///////
    
    
    [playToolBar setItems:myToolBarItems2];
    // [myToolBarItems2 release];
    
    
    [btnRecord setEnabled:NO];
    [btnSnapshot setEnabled:NO];
    
    LabelTitle.text = self.cameraName;
    
    
    
}


-(void)createPlay{
    if (isP2P) {
        m_pPPPPChannelMgt->SetDateTimeDelegate((char*)[strDID UTF8String], self);
        m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }else{
        netUtiles.dateProtocol=self;
        //[netUtiles getCameraParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:4];
        
    }
    
    if(isP2P){
        if (m_pPPPPChannelMgt != NULL) {
            //如果请求视频失败，则退出播放
            // NSLog(@"kkkkkkkk===startPPPPLivestream 111111==============================");
            //            if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 0, self) == 0 ){
            //                [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
            //                // NSLog(@"kkkkkkkk===startPPPPLivestream 2222222==============================");
            //                return;
            //            }
            dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                while (true) {
                    if( m_pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 0, self) == 0 ){
                        sleep(1);
                        continue;
                    }else{
                        break;
                    }
                }
            });
            //NSLog(@"kkkkkkkk===startPPPPLivestream 33333=====================================");
            //[self getCameraParams];
        }
        
    }else{//ddns
        
        
        
        //
        //        [btnAudioControl setEnabled:NO];
        //        [btnTalkControl setEnabled:NO];
        
        netUtiles.imageNotifyProtocol=self;
        [self StartPlay];
    }
    [self getCameraParams];
}

- (void) StartPlay
{
    m_pVideoBuf = new CCircleBuf();
    m_pVideoBuf->Create(VBUF_SIZE);
    m_pCameraMediaSource = new CCameraMediaSource((char*)[m_strIp UTF8String], atoi([m_strPort UTF8String]), ENUM_VIDEO_MODE_H264, (char*)[m_strUser UTF8String], (char*)[m_strPwd UTF8String], m_pVideoBuf);
    
    m_pCameraMediaSource->msgDelegate = self;
    
    m_pCameraMediaSource->m_PlayViewImageNotifyDelegate=self;
    m_pCameraMediaSource->Start();
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //NSLog(@"PlayViewController ViewDidUnload");
    
}


- (void)dealloc {
    NSLog(@"PlayViewController dealloc");
    
    if (OSDLabel != nil) {
//        [OSDLabel release];
        OSDLabel = nil;
    }
    if (TimeStampLabel != nil) {
//        [TimeStampLabel release];
        TimeStampLabel = nil;
    }
    self.imgView = nil;
    self.cameraName = nil;
    self.strDID = nil;
    self.playToolBar = nil;
    // self.btnItemResolution = nil;
    // self.btnTitle = nil;
    self.toolBarTop = nil;
    // self.btnUpDown = nil;
    // self.btnLeftDown = nil;
    // self.btnUpDownMirror = nil;
    // self.btnLeftRightMirror = nil;
    // self.btnTalkControl = nil;
    // self.btnAudioControl = nil;
//    [sliderContrast release];
//    [labelContrast release];
    // self.btnSetContrast = nil;
    // self.btnSetBrightness = nil;
//    [sliderBrightness release];
//    [labelBrightness release];
    self.imgVGA = nil;
    self.imgQVGA = nil;
    self.img720P = nil;
    // self.btnSwitchDisplayMode = nil;
    self.imgEnlarge = nil;
    self.imgFullScreen = nil;
    self.imgNormal = nil;
    self.imageSnapshot = nil;
    
    // self.btnRecord = nil;
    if (m_RecordLock != nil) {
//        [m_RecordLock release];
        m_RecordLock = nil;
        
    }
    self.imageLeft = nil;
    self.imageUp = nil;
    self.imageDown = nil;
    self.imageRight = nil;
    self.m_pPicPathMgt = nil;
    self.m_pRecPathMgt = nil;
    self.PicNotifyDelegate = nil;
    if (myGLViewController != nil) {
//        [myGLViewController release];
        myGLViewController = nil;
    }
    if (m_YUVDataLock != nil) {
//        [m_YUVDataLock release];
        m_YUVDataLock = nil;
    }
    SAFE_DELETE(m_pYUVData);
    
    ////
    //
    //    [btnUpDown release];
    //    [btnLeftRight release];
    //    [btnMoreControl release];
    //    [LabelTitle release];
    //    [btnRotate release];
    //    [btnMirror release];
    //    [btnClose release];
    //    [btnSnapshot release];
    //    [btnRecord release];
    //    [btnAudio  release];
    //    [btnTalk release];
    //    [btnContrast release];
    //    [btnBrightness release];
    //    [btnSize release];
    //    [myToolBarItems release];
    //    [myToolBarItems2 release];
    
//    [super dealloc];
    NSLog(@"PlayViewController dealloc。。。end");
}

#pragma mark -
#pragma mark PPPPStatusDelegate
- (void) PPPPStatus:(NSString *)astrDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    //NSLog(@"PlayViewController strDID: %@, statusType: %d, status: %d", astrDID, statusType, status);
    //处理PPP的事件通知
    
    if (bManualStop == YES) {
        return;
    }
    
    if(isStop){
        return;
    }
    //这个一般情况下是不会发生的
    if ([astrDID isEqualToString:strDID] == NO) {
        return;
    }
    
    //如果是PPP断开，则停止播放
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS && (status == PPPP_STATUS_DISCONNECT || status == PPPP_STATUS_DEVICE_NOT_ON_LINE)) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
    }
    
}

#pragma mark -
#pragma mark ParamNotify

- (void) ParamNotify:(int)paramType params:(void *)params
{
    //NSLog(@"PlayViewController ParamNotify");
    if(isStop){
        return;
    }
    
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM pCameraParam = (PSTRU_CAMERA_PARAM)params;
        m_Contrast = pCameraParam->contrast;
        m_Brightness = pCameraParam->bright;
        nResolution = pCameraParam->resolution;
        m_nFlip = pCameraParam->flip;
        mFrame=pCameraParam->enc_framerate;
        bGetVideoParams = YES;
        NSLog(@"PlayViewController ParamNotify...nResolution=%d",nResolution);
        [self performSelectorOnMainThread:@selector(UpdateVieoDisplay) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (paramType == STREAM_CODEC_TYPE) {
        //NSLog(@"STREAM_CODEC_TYPE notify");
        m_StreamCodecType = *((int*)params);
        m_bGetStreamCodecType = YES;
        //[self performSelectorOnMainThread:@selector(DisplayVideoCodec) withObject:nil waitUntilDone:NO];
    }
    
}

#pragma mark -
#pragma mark ImageNotify


-(void)stopRecordForMemoryOver{
    //  [self.btnItemResolution setEnabled:YES];
    isRecording=NO;
    SAFE_DELETE(m_pCustomRecorder);
    [RecNotifyDelegate NotifyReloadData];
    //  btnRecord.style = UIBarButtonItemStyleBordered;
    [btnRecord setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    
    [CustomToast showWithText:NSLocalizedStringFromTable(@"deviceMemoryOver", @STR_LOCALIZED_FILE_NAME, nil)
                    superView:self.view
                    bLandScap:YES];
    recordNum=0;
}
- (void) H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger) timestamp DID:(NSString *)did
{
    if(isStop){
        return;
    }
    //networkspeed+=sizeof(h264Frame);
    //NSLog(@"H264Data....networkspeed=%d",(int)networkspeed);
    if (m_videoFormat == -1) {
        m_videoFormat = 2;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    //NSLog(@"H264Data... length: %d, type: %d", length, type);
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        recordNum++;
        if (recordNum==100) {
            recordNum=0;
            BOOL flag=[self isOutOfMemory];
            if (flag) {
                [self performSelectorOnMainThread:@selector(stopRecordForMemoryOver) withObject:self waitUntilDone:NO];
            }
        }
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        NSLog(@"H264Data... 录像一帧  unTimestamp: %d", unTimestamp);
        
        
        m_pCustomRecorder->SendOneFrame((char*)h264Frame, length, unTimestamp, type,timezone,timestamp);
        
//        [pool release];
    }
    [m_RecordLock unlock];
}

- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    //NSLog(@"YUVNotify.... length: %d, timestamp: %d, width: %d, height: %d DID:%@", length, timestamp, width, height,did);
    
    m_bH264 = 1;
    
    if(isStop){
        return;
    }
    networkspeed+=length;
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    //NSLog(@"dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString  *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    
//    if ([IpCameraClientAppDelegate is43Version]) {//4.3.3版本
//        
//        UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
//        if (bPlaying==NO) {
//            bPlaying = YES;
//            [self updateResolution:image];
//            m_StreamCodecType=1;
//            [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
//            // [self performSelectorOnMainThread:@selector(initFrameDialog:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
//        }
//        
//        
//        [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:sOSD waitUntilDone:NO];
//        if (image != nil) {
//            [image retain];
//            [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
//        }
//        
//        [m_YUVDataLock lock];
//        SAFE_DELETE(m_pYUVData);
//        int yuvlength = width * height * 3 / 2;
//        m_pYUVData = new Byte[yuvlength];
//        memcpy(m_pYUVData, yuv, yuvlength);
//        m_nWidth = width;
//        m_nHeight = height;
//        [m_YUVDataLock unlock];
//        
//        return;
//    }
    
    if (bPlaying == NO)
    {
        
        m_StreamCodecType=1;
        bPlaying = YES;
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
        [self updataResolution:width height:height];
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(initFrameDialog:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
    }
    
    
    [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:sOSD waitUntilDone:NO];
    
    
    
    [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
    
    
    //NSDate *date=[NSDate date];
    //NSLog(@"高清   时间  date=%@",[date description]);
    [m_YUVDataLock lock];
    SAFE_DELETE(m_pYUVData);
    int yuvlength = width * height * 3 / 2;
    m_pYUVData = new Byte[yuvlength];
    m_nLength=yuvlength;
    memcpy(m_pYUVData, yuv, yuvlength);
    m_nWidth = width;
    m_nHeight = height;
    [m_YUVDataLock unlock];
    
    
}

- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    // NSLog(@"ImageNotify...DID:%@...timestamp:%d", did,timestamp);
    if(isStop){
        return;
    }
    
    NSTimeInterval se=(long)timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-timezone];
    // NSLog(@"img  dd=%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]);
    NSString *sOSD=[NSString stringWithFormat:@"%@",[[dd  description] substringWithRange:NSMakeRange(0, 19)]];
    
    //    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    //     networkspeed+=data.length;
    
    if (m_videoFormat == -1) {
        m_videoFormat = 0;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    
    if (bPlaying == NO)
    {
        bPlaying = YES;
        [self updateResolution:image];
        
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        //[self performSelectorOnMainThread:@selector(initFrameDialog:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
        
    }
    
    [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:sOSD waitUntilDone:NO];
    
    if (image != nil) {
//        [image retain];
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
    
    [m_RecordLock lock];
    if (m_pCustomRecorder != nil) {
        recordNum++;
        if (recordNum==100) {
            recordNum=0;
            BOOL flag=[self isOutOfMemory];
            if (flag) {
                [self performSelectorOnMainThread:@selector(stopRecordForMemoryOver) withObject:self waitUntilDone:NO];
            }
        }
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        unsigned int unTimestamp = 0;
        struct timeval tv;
        struct timezone tz;
        gettimeofday(&tv, &tz);
        unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
        //NSLog(@"unTimestamp: %d", unTimestamp);
        m_pCustomRecorder->SendOneFrame((char*)[data bytes], [data length], unTimestamp, 0,timezone,timestamp);
//        [pool release];
    }
    [m_RecordLock unlock];
    
}

#pragma mark-DDNS
- (void) CameraDefaultParams:(int)contrast Bright:(int)brightness Resolution:(int)resolution Flip:(int)flip Frame:(int)frame{
    if (isStop) {
        return;
    }
    NSLog(@"PlayViewController CameraDefaultParams:  contrast=%d m_Brightness＝%d",contrast,brightness);
    m_Contrast = contrast;
    m_Brightness = brightness;
    nResolution =resolution;
    m_nFlip =flip;
    bGetVideoParams = YES;
    m_bGetStreamCodecType=YES;
    mFrame=frame;
    [self performSelectorOnMainThread:@selector(UpdateVieoDisplay) withObject:nil waitUntilDone:NO];
    
}
- (void) AVData:(char *)data length:(int)length Timestamp:(int)timestamp

{
    if(isStop){
        return;
    }
    networkspeed+=length;
    m_StreamCodecType=0;
    // NSLog(@"PlayviewController  AVData... length: %d", length);
    if (m_videoFormat == -1) {
        m_videoFormat = 0;
        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
    if (bPlaying == NO)
    {
        bPlaying = YES;
        
        [self performSelectorOnMainThread:@selector(hideProgress:) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(initFrameDialog:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
    }
    
    [self performSelectorOnMainThread:@selector(updateTimestamp:) withObject:@"" waitUntilDone:NO];
    //显示图片
    NSData *image = [[NSData alloc] initWithBytes:data length:length];
    UIImage *img = [[UIImage alloc] initWithData:image];
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:img waitUntilDone:NO];
    //[self performSelectorInBackground:@selector(updateImage:) withObject:img];
    //[img release];
    if (isRecording) {
        
        
        [m_RecordLock lock];
        
        if (m_pCustomRecorder != nil) {
            recordNum++;
            if (recordNum==100) {
                recordNum=0;
                BOOL flag=[self isOutOfMemory];
                if (flag) {
                    [self performSelectorOnMainThread:@selector(stopRecordForMemoryOver) withObject:self waitUntilDone:NO];
                }
            }
//            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            unsigned int unTimestamp = 0;
            struct timeval tv;
            struct timezone tz;
            gettimeofday(&tv, &tz);
            unTimestamp = tv.tv_usec / 1000 + tv.tv_sec * 1000 ;
            //NSLog(@"unTimestamp: %d", unTimestamp);
            //            NSDate *d=[NSDate date];
            //            NSTimeInterval interval =[d timeIntervalSince1970];
            m_pCustomRecorder->SendOneFrame((char*)[data bytes], [data length], unTimestamp, 0,timezone,timestamp);
//            [pool release];
        }
        [m_RecordLock unlock];
    }
//    [image release];
    
}


#pragma mark -
#pragma mark NotifyMessageProtocol
- (void) NotifyMessage:(NSInteger)msgType
{
    NSLog(@"NotifyMessage... msgType: %d", msgType);
    if(isStop){
        return;
    }
    if (PPPP_STATUS_DISCONNECT==msgType) {
        
        if (ddnsDisconnectNumber<5) {
            SAFE_DELETE(m_pCameraMediaSource);
            SAFE_DELETE(m_pVideoBuf);
            sleep(1);
            [self StartPlay];
            ddnsDisconnectNumber++;
        }else{
            
            NSNumber *num=[NSNumber numberWithInt:msgType];
            [self performSelectorOnMainThread:@selector(DDNSStop:) withObject:num waitUntilDone:NO];
        }
    }
    
    return;
    
}
//停止播放，并返回到设备列表界面
- (void) DDNSStop:(NSNumber *)num
{
    [self StopPlay:0];
}
#pragma mark -
#pragma mark CgiResultProtocol

- (void) CgiResultNotify:(NSInteger)cgiID CgiResult:(NSString *)strResult
{
    if(isStop){
        return;
    }
    //NSLog(@"CgiResultNotify.... cgiID: %d strResult: %@", cgiID, strResult);
    if (cgiID == CGI_IEGET_CAM_PARAMS) {
        /*
         var resolution=0;
         var vbright=0;
         var vcontrast=128;
         var vhue=0;
         var vsaturation=0;
         var OSDEnable=0;
         var mode=0;
         var flip=0;
         var enc_framerate=30;
         var sub_enc_framerate=15;
         */
        
        int resolution;
        int bright;
        int contrast;
        int hue;
        int saturation;
        int osdenable;
        int mode;
        int flip;
        
        
        sscanf((char*)[strResult UTF8String],
               "var resolution=%d;\r\nvar vbright=%d;\r\nvar vcontrast=%d;\r\nvar vhue=%d;\r\nvar vsaturation=%d;\r\nvar OSDEnable=%d;\r\nvar mode=%d;\r\nvar flip=%d;\r\n",
               &resolution, &bright, &contrast, &hue, &saturation,
               &osdenable, &mode, &flip);
        
        //        NSLog(@"resolution: %d\
        //              bright: %d\
        //              contrast: %d\
        //              hue: %d\
        //              saturation: %d\
        //              osdenable: %d\
        //              mode: %d\
        //              flip: %d",
        //              resolution,
        //              bright,
        //              contrast,
        //              hue,
        //              saturation,
        //              osdenable,
        //              mode,
        //              flip);
        
        m_Brightness = bright;
        m_Contrast = contrast;
        nResolution = resolution;
        
        bGetVideoParams = YES;
        
//        [self performSelectorOnMainThread:@selector(UpdateVieoRosolution) withObject:nil waitUntilDone:NO];
        
    }
}
#pragma mark-----

- (void) updataResolution: (int) width height:(int)height
{
    m_nVideoWidth = width;
    m_nVideoHeight = height;
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else {
        
    }
    
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
    
}

- (void) updateResolution:(UIImage*)image
{
    //NSLog(@"updateResolution");
    m_nVideoWidth = image.size.width;
    m_nVideoHeight = image.size.height;
    
    //NSLog(@"m_nVideoWidth: %d, m_nVideoHeight: %d", m_nVideoWidth, m_nVideoHeight);
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else {
        
    }
    
    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
}

-(BOOL)isOutOfMemory {
    
    //    return NO;
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
//    [fileManager release];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    float free=([freeSpace longLongValue])/1024.0/1024.0/1024.0;
    float total=([totalSpace longLongValue])/1024.0/1024.0/1024.0;
    NSString *memory=@"";
    if (free>1.0) {
        memory=[NSString stringWithFormat:@"%0.1fG/%0.1fG",free,total];
        //strMemory=[[NSString alloc]initWithFormat:@"%0.1fG/%0.1fG",free,total];
    }else{
        free=([freeSpace longLongValue])/1024.0/1024.0;
        memory=[NSString stringWithFormat:@"%0.1fM/%0.1fG",free,total];
        if (free<100.0) {
            [self performSelectorOnMainThread:@selector(showMemory:) withObject:memory waitUntilDone:NO];
            return YES;
        }
    }
    NSLog(@"memory=%@",memory);
    
    [self performSelectorOnMainThread:@selector(showMemory:) withObject:memory waitUntilDone:NO];
    
    return NO;
}

-(void)showMemory:(NSString *)memory{
    labelRecord.text=[NSString stringWithFormat:@"%@ %@",memory,@"正在录像..."];
}

#pragma  mark--DateTimeProtocol
- (void) DateTimeProtocolResult:(int)now tz:(int)tz ntp_enable:(int)ntp_enable net_svr:(NSString*)ntp_svr
{
    if(isStop){
        return;
    }
    NSLog(@"m_timeZone=%d  now=%d  ntp_enable=%d  net_svr=%@",tz,now,ntp_enable,ntp_svr);
    timezone=tz;
}
@end
