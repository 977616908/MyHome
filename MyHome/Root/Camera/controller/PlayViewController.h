//
//  PlayViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPStatusProtocol.h"
#import "PPPPChannelManagement.h"
#import "ParamNotifyProtocol.h"
#import "ImageNotifyProtocol.h"
#import "PicPathManagement.h"
#import "CustomAVRecorder.h"
#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"
#import "MyGLViewController.h"
#import "MySetDialog.h"
#import "PresetDialog.h"


#import "CameraMediaSource.h"
#import "NetWorkUtiles.h"
#import "CircleBuf.h"
#import "CgiResultProtocol.h"
#import "NotifyMessageProtocol.h"

#import "DateTimeProtocol.h"
@interface PlayViewController : PiFiiBaseViewController <UINavigationBarDelegate, PPPPStatusProtocol, ParamNotifyProtocol,ImageNotifyProtocol,PresetDialogDelegate,MySetDialogDelegate,NotifyMessageProtocol,CgiResultProtocol,DateTimeProtocol>
{
    IBOutlet UIImageView *imgView;
    IBOutlet UIActivityIndicatorView *progressView;
    IBOutlet UILabel *LblProgress;
    IBOutlet UIToolbar *playToolBar;
    //  IBOutlet UIBarButtonItem *btnItemResolution;
    //  IBOutlet UIBarButtonItem *btnTitle;
    IBOutlet UILabel *timeoutLabel;
    IBOutlet UIToolbar *toolBarTop;
    //  IBOutlet UIBarButtonItem *btnUpDown;
    //  IBOutlet UIBarButtonItem *btnLeftRight;
    //  IBOutlet UIBarButtonItem *btnUpDownMirror;
    //  IBOutlet UIBarButtonItem *btnLeftRightMirror;
    //  IBOutlet UIBarButtonItem *btnAudioControl;
    //  IBOutlet UIBarButtonItem *btnTalkControl;
    //   IBOutlet UIBarButtonItem *btnSetContrast;
    //   IBOutlet UIBarButtonItem *btnSetBrightness;
    //  IBOutlet UIBarButtonItem *btnSwitchDisplayMode;
    //  IBOutlet UIBarButtonItem *btnRecord;
    IBOutlet UIImageView *imageUp;
    IBOutlet UIImageView *imageDown;
    IBOutlet UIImageView *imageLeft;
    IBOutlet UIImageView *imageRight;
    //  IBOutlet UIBarButtonItem *btnSnapshot;
    
    // IBOutlet UIButton *btnMicrophone;
    
    UILabel *labelContrast;
    UISlider *sliderContrast;
    UILabel *labelBrightness;
    UISlider *sliderBrightness;
    UIImage *imgVGA;
    UIImage *imgQVGA;
    UIImage *img720P;
    UIImage *imgNormal;
    UIImage *imgEnlarge;
    UIImage *imgFullScreen;
    UIImage *ImageBrightness;
    UIImage *ImageContrast;
    NSString *cameraName;
    NSString *strDID;
    UIImage *imageSnapshot;
    
    
    CGPoint beginPoint;
    int m_Contrast;
    int m_Brightness;
    BOOL bGetVideoParams;
    BOOL bPlaying;
    BOOL bManualStop;
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    int nResolution;
    UILabel *OSDLabel;
    UILabel *TimeStampLabel;
    NSInteger nUpdataImageCount;
    NSTimer *timeoutTimer;
    BOOL m_bAudioStarted;
    BOOL m_bTalkStarted;
    BOOL m_bGetStreamCodecType;
    int m_StreamCodecType;
    int m_nP2PMode;
    int m_nTimeoutSec;
    BOOL m_bToolBarShow;
    BOOL m_bPtzIsUpDown;
    BOOL m_bPtzIsLeftRight;
    BOOL m_bUpDownMirror;
    BOOL m_bLeftRightMirror;
    int m_nFlip;
    BOOL m_bBrightnessShow;
    BOOL m_bContrastShow;
    
    int m_nDisplayMode;
    int m_nVideoWidth;
    int m_nVideoHeight;
    
    int m_nScreenWidth;
    int m_nScreenHeight;
    
//    PicPathManagement *m_pPicPathMgt;
//    RecPathManagement *m_pRecPathMgt;
    
    CCustomAVRecorder *m_pCustomRecorder;
    NSCondition *m_RecordLock;
    
//    id<NotifyEventProtocol> PicNotifyDelegate;
//    id<NotifyEventProtocol> RecNotifyDelegate;
//    
    MyGLViewController *myGLViewController;
    
    int m_videoFormat;
    
    Byte *m_pYUVData;
    NSCondition *m_YUVDataLock;
    int m_nWidth;
    int m_nHeight;
    int m_nLength;
    BOOL isRecording;
    BOOL isTakepicturing;
    NSString *recordFileName;
    NSString *recordFilePath;
    NSString *recordFileDate;
    
    
    int recordNum;
    
    CGFloat lastDistance;
    
    CGFloat imgStartWidth;
    CGFloat imgStartHeight;
    
    
    PresetDialog *preDialog;
    MySetDialog *setDialog;
    BOOL isPresetDialogShow;
    BOOL isCallPreset;
    BOOL isSetDialogShow;
    MySetDialog *seeMoreDialog;
    MySetDialog *frameDialog;
    BOOL isSeeMoreDialogShow;
    BOOL isFrameDialogShow;
    
    BOOL isP2P;
    
    //ddns
    
    NSString *m_strIp;
    NSString *m_strPort;
    NSString *m_strUser;
    NSString *m_strPwd;
    CCameraMediaSource *m_pCameraMediaSource;
    CCircleBuf *m_pVideoBuf;
//    NetWorkUtiles *netUtiles;
    
    BOOL isScale;// 缩放
    int mFrame;
    BOOL isMove;
    BOOL isMicrophoneShow;
    BOOL isMoreView;
    
    IBOutlet UILabel *labelRecord;
    int networkspeed;
    IBOutlet UILabel *labelNetworkSpeed;
    
    
    BOOL isH264;
    BOOL isStop;
    
    int timezone;
    NSString *strOSD;
    
    int ddnsDisconnectNumber;
    
    /////////////
    //add by iven
    UIButton *btnSnapshot;
    UIButton *btnRecord;
    UIButton *btnAudio;
    UIButton *btnTalk;
    UIButton *btnContrast;
    UIButton *btnBrightness;
    UIButton *btnSize;
    
    UIButton *btnUpDown;
    UIButton *btnLeftRight;
    UIButton *btnMoreControl;
    UILabel *LabelTitle;
    UIButton *btnRotate;
    UIButton *btnMirror;
    UIButton *btnClose;
    
    NSMutableArray *myToolBarItems;
    NSMutableArray *myToolBarItems2;
    
    int m_bH264;
}
@property (nonatomic,copy)NSString *strOSD;
@property (nonatomic,retain) IBOutlet UILabel *labelRecord;
@property (nonatomic,retain) IBOutlet UILabel *labelNetworkSpeed;
@property BOOL isMoreView;
@property (nonatomic,copy) NSString *m_strIp;
@property (nonatomic,copy) NSString *m_strPort;
@property (nonatomic,copy) NSString *m_strUser;
@property (nonatomic,copy) NSString *m_strPwd;
@property (nonatomic, assign) NetWorkUtiles *netUtiles;

@property BOOL isP2P;
@property (nonatomic,retain)MySetDialog *setDialog;
@property (nonatomic,retain) PresetDialog *preDialog;
@property (nonatomic,retain)MySetDialog *seeMoreDialog;
@property (nonatomic,retain)MySetDialog *frameDialog;

@property int recordNum;

@property BOOL isRecording;
@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, copy) NSString *cameraName;
@property (nonatomic, copy) NSString *recordFileName;
@property (nonatomic, copy) NSString *recordFilePath;
@property (nonatomic, copy) NSString *recordFileDate;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, retain) UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UILabel *LblProgress;
@property (nonatomic, retain) UIToolbar *playToolBar;
//@property (nonatomic, retain) UIBarButtonItem *btnItemResolution;
//@property (nonatomic, retain) UIBarButtonItem *btnTitle;
@property (nonatomic, retain) UILabel *timeoutLabel;
@property int m_nP2PMode;
@property (nonatomic, retain) UIToolbar *toolBarTop;
//@property (nonatomic, retain) UIBarButtonItem *btnUpDown;
//@property (nonatomic, retain) UIBarButtonItem *btnLeftDown;
//@property (nonatomic, retain) UIBarButtonItem *btnUpDownMirror;
//@property (nonatomic, retain) UIBarButtonItem *btnLeftRightMirror;
//@property (nonatomic, retain) UIBarButtonItem *btnAudioControl;
//@property (nonatomic, retain) UIBarButtonItem *btnTalkControl;
//@property (nonatomic, retain) UIBarButtonItem *btnSetContrast;
//@property (nonatomic, retain) UIBarButtonItem *btnSetBrightness;
@property (nonatomic, retain) UIImage *imgVGA;
@property (nonatomic, retain) UIImage *imgQVGA;
@property (nonatomic, retain) UIImage *img720P;
//@property (nonatomic, retain) UIBarButtonItem *btnSwitchDisplayMode;
@property (nonatomic, retain) UIImage *imgNormal;
@property (nonatomic, retain) UIImage *imgEnlarge;
@property (nonatomic, retain) UIImage *imgFullScreen;
@property (nonatomic, retain) UIImage *imageSnapshot;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
//@property (nonatomic, retain) UIBarButtonItem *btnRecord;
@property (nonatomic, retain) UIImageView *imageUp;
@property (nonatomic, retain) UIImageView *imageDown;
@property (nonatomic, retain) UIImageView *imageLeft;
@property (nonatomic, retain) UIImageView *imageRight;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecNotifyDelegate;
//@property (nonatomic, retain) UIBarButtonItem *btnSnapshot;
//@property (nonatomic, retain) IBOutlet UIButton *btnMicrophone;

//- (IBAction) btnItemResolutionPressed:(id)sender;
//- (IBAction) btnItemDefaultVideoParamsPressed:(id)sender;
//- (void)StopPlay: (int) bForce;
//- (IBAction) btnAudioControl: (id) sender;
//- (IBAction) btnTalkControl:(id)sender;
//- (IBAction) btnStop:(id)sender;
//- (IBAction) btnUpDown:(id)sender;
//- (IBAction) btnLeftRight:(id)sender;
//- (IBAction) btnUpDownMirror:(id)sender;
//- (IBAction) btnLeftRightMirror:(id)sender;
//- (IBAction) btnSetContrast:(id)sender;
//- (IBAction) btnSetBrightness:(id)sender;
//- (IBAction) btnSwitchDisplayMode:(id)sender;
//- (IBAction) btnSnapshot:(id)sender;
//- (IBAction) btnRecord:(id)sender;
//- (IBAction) btnMore:(id)sender;
@end
