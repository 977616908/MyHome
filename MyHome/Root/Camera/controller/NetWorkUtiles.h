//
//  NetWorkUtiles.h
//  P2PCamera
//
//  Created by Tsang on 13-3-1.
//
//

#import <Foundation/Foundation.h>
#import "NetworkUtilesProtocol.h"
#import "UserPwdProtocol.h"
#import "WifiParamsProtocol.h"
#import "AlarmProtocol.h"
#import "DateTimeProtocol.h"
#import "FtpParamProtocol.h"
#import "MailParamProtocol.h"
#import "CgiPacket.h"
#import "P2P_API_Define.h"
#import "cmdhead.h"
#import "ImageNotifyProtocol.h"
#import "SdcardScheduleProtocol.h"
@interface NetWorkUtiles : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSURLConnection *mConn;
    NSString *strIP;
    NSString *strPort;
    NSString *str_User;
    NSString *str_Pwd;
//    id<NetworkUtilesProtocol> networkProtocol;
//    id<UserPwdProtocol> userProtocol;
//    id<WifiParamsProtocol> wifiProtocol;
//    id<AlarmProtocol> alarmProtocol;
//    id<DateTimeProtocol> dateProtocol;
//    id<FtpParamProtocol> ftpProtocol;
//    id<MailParamProtocol> mailProtocol;
//    id<ImageNotifyProtocol> imageNotifyProtocol;
//    id<SdcardScheduleProtocol> sdcardProtocol;
    int paramType;
    int wifiscanType;
    NSCondition *mLock;
    
    CCgiPacket m_CgiPacket;
    
    int wifiscanCount;
}

@property (nonatomic ,retain)NSCondition *mLock;
@property (nonatomic,copy)NSString *strIP;
@property (nonatomic,copy)NSString *strPort;
@property (nonatomic,copy)NSString *str_User;
@property (nonatomic,copy)NSString *str_Pwd;
@property int paramType;
@property int wifiscanType;
@property (nonatomic, weak)id<NetworkUtilesProtocol> networkProtocol;
@property (nonatomic, weak)id<UserPwdProtocol> userProtocol;
@property (nonatomic, weak)id<WifiParamsProtocol> wifiProtocol;
@property (nonatomic, weak)id<AlarmProtocol> alarmProtocol;
@property (nonatomic, weak)id<DateTimeProtocol> dateProtocol;
@property (nonatomic, weak)id<FtpParamProtocol> ftpProtocol;
@property (nonatomic, weak)id<MailParamProtocol> mailProtocol;
@property (nonatomic, weak)id<ImageNotifyProtocol> imageNotifyProtocol;
@property (nonatomic, weak)id<SdcardScheduleProtocol> sdcardProtocol;
//get
-(void)downloadSnapshot:(NSString *) ip
                   Port:(NSString *)port
                   User:(NSString *)admin
                    Pwd:(NSString *)pwd
              ParamType:(int)type;
-(void)checkUserNameAndPwd:(NSString *)ip
                      Port:(NSString *)port
                      User:(NSString *)user
                       Pwd:(NSString *)pwd
                 ParamType:(int)type;

-(void)getCameraParam:(NSString *) ip
                 Port:(NSString *)port
                 User:(NSString *)user
                  Pwd:(NSString *)pwd
            ParamType:(int)type;

-(void)getWifiScanParam:(NSString *)ip
                   Port:(NSString *)port
                   User:(NSString *)user
                    Pwd:(NSString *)pwd
              ParamType:(int)type;

-(void)getSdcardParam:(NSString *)ip
                 Port:(NSString *)port
                 User:(NSString *)user
                  Pwd:(NSString *)pwd
            ParamType:(int)type;

-(void)getCameraDefaultParams:(NSString *) ip
                         Port:(NSString *)port
                         User:(NSString *)user
                          Pwd:(NSString *)pwd
                    ParamType:(int)type;
//set
-(void)setDateTime:(NSString *)ip//ok
              Port:(NSString *)port
              Zone:(int)tz
         NtpEnable:(int)enable
         NtpServer:(NSString *)svr
               Now:(int)now
              User:(NSString *)user
               Pwd:(NSString *)pwd;

-(void)setUserpwd:(NSString *)ip//ok
             Port:(NSString *)port
            User1:(NSString *)user1
             Pwd1:(NSString *)pwd1
            User2:(NSString *)user2
             Pwd2:(NSString *)pwd2
            User3:(NSString *)user3
             Pwd3:(NSString *)pwd3
             User:(NSString *)user
              Pwd:(NSString *)pwd;


-(void)setRoot:(NSString *)ip
          Port:(NSString *)port
           CGI:(NSString *)cgi
          User:(NSString *)user
           Pwd:(NSString *)pwd;

-(void)setAlarm:(NSString *)ip//
           Port:(NSString *)port
           User:(NSString *)user
            Pwd:(NSString *)pwd

      MotionArm:(int)motion_armed
MotionSensitivity:(int)motion_sensitivity
     InputArmed:(int)input_armed
      IoinLevel:(int)ioin_level
         Preset:(int)alarmpresetsit
      Iolinkage:(int)iolinkage
     IooutLevel:(int)ioout_level
           Mail:(int)mail
 UploadInterval:(int)upload_interval
         Record:(int)record
;


-(void)setWifi:(NSString *)ip//
          Port:(NSString *)port
          User:(NSString *)user
           Pwd:(NSString *)pwd
        Enable:(int)enable
          SSID:(NSString *)ssid
       Channel:(int)channel
          Mode:(int)mode
      Authtype:(int)authtype
       Encrypt:(int)encrypt
     Keyformat:(int)keyformat
        Defkey:(int)defkey
          Key1:(NSString *)key1
          Key2:(NSString *)key2
          Key3:(NSString *)key3
          Key4:(NSString *)key4
     Key1_bits:(int )key1_bits
     Key2_bits:(int)key2_bits
     Key3_bits:(int)key3_bits
     Key4_bits:(int)key4_bits
       Wpa_psk:(NSString *)wpa_psk;


-(void)setFtp:(NSString *)ip//ok
         Port:(NSString *)port
         User:(NSString *)user
          Pwd:(NSString *)pwd
       FTPSvr:(NSString *)svr
      StrUser:(NSString *)strUser
       StrPwd:(NSString *)strPwd
        SPort:(int)sport
UploadInterval:(int)uploadinterval;

-(void)setMail:(NSString *)ip
          Port:(NSString *)port
          User:(NSString *)user
           Pwd:(NSString *)pwd

        Sender:(NSString *)sender
      Smtp_svr:(NSString *)smtp_svr
     Smtp_port:(int)smtp_port
           SSL:(int)ssl
          Auth:(int)auth
       StrUser:(NSString *)strUser
        StrPwd:(NSString *)strPwd
         Recv1:(NSString *)recv1
         Recv2:(NSString *)recv2
         Recv3:(NSString *)recv3
         Recv4:(NSString *)recv4;
-(void)setSdcard:(NSString *)ip
            Port:(NSString *)port
            User:(NSString *)user
             Pwd:(NSString *)pwd
     CoverEnable:(int)cover_enable
      TimeLength:(int)timeLength
    RecordEnable:(int)recordenable;
//camera control
-(void)PTZControl:(NSString *)ip
             Port:(NSString *)port
             User:(NSString *)user
              Pwd:(NSString *)pwd
          Command:(int)command
             Step:(int)step;
-(void)CameraControl:(NSString *)ip
                Port:(NSString *)port
                User:(NSString *)user
                 Pwd:(NSString *)pwd
             Command:(int)cmd
               Value:(int)value;
@end
