//
//  NetWorkUtiles.m
//  P2PCamera
//
//  Created by Tsang on 13-3-1.
//
//

#import "NetWorkUtiles.h"
#define CheckUser 0
#define SnapshotType 1
#define WifiType 2
#define UserType 3
#define DateType 4
#define AlarmType 5
#define FTPType 6
#define MailType 7
#define WifiScanType 8
#define CameraDefaultParam 9
#define SDCardType 10
@implementation NetWorkUtiles
@synthesize strIP;
@synthesize strPort;
@synthesize str_Pwd;
@synthesize str_User;
@synthesize paramType;
@synthesize wifiscanType;
@synthesize networkProtocol;
@synthesize ftpProtocol;
@synthesize mailProtocol;
@synthesize dateProtocol;
@synthesize userProtocol;
@synthesize alarmProtocol;
@synthesize wifiProtocol;
@synthesize imageNotifyProtocol;
@synthesize sdcardProtocol;
@synthesize mLock;

#pragma mark- Get

-(void)downloadSnapshot:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    [mLock lock];
   
    self.str_User=user;
    self.str_Pwd=pwd;
    self.paramType=type;
    self.strIP=ip;
    self.strPort=port;
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/snapshot.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    
    [self sendCommonURL:urlString];
    [mLock unlock];
}
-(void)checkUserNameAndPwd:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    [mLock lock];
    self.str_User=user;
    self.str_Pwd=pwd;
    self.paramType=type;
    self.strIP=ip;
    self.strPort=port;
     NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/check_user.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    [self sendCommonURL:urlString];
    
    [mLock unlock];
}
-(void)getCameraParam:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    [mLock lock];
    // NSLog(@"NetWorkUtiles getWifiParam()   ip=%@ port=%@  user=%@ pwd=%@",ip,port,user,pwd);
    self.str_User=user;
    self.str_Pwd=pwd;
    self.paramType=type;
    self.strIP=ip;
    self.strPort=port;
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_params.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    
    [self sendCommonURL:urlString];
    [mLock unlock];

}

-(void)getWifiScanParam:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    [mLock lock];
    self.str_User=user;
    self.str_Pwd=pwd;
    self.wifiscanType=type;
    self.strIP=ip;
    self.strPort=port;
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_wifi_scan_result.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
}

-(void)getCameraDefaultParams:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    [mLock lock];
    self.str_User=user;
    self.str_Pwd=pwd;
    self.paramType=type;
    self.strIP=ip;
    self.strPort=port;
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_camera_params.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
}
-(void)getSdcardParam:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ParamType:(int)type{
    
    [mLock lock];
    self.str_User=user;
    self.str_Pwd=pwd;
    self.paramType=type;
    self.strIP=ip;
    self.strPort=port;
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_record.cgi?user=%@&pwd=%@&",ip,port,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
}
#pragma mark set
-(void)setDateTime:(NSString *)ip Port:(NSString *)port Zone:(int)tz NtpEnable:(int)enable NtpServer:(NSString *)svr Now:(int)now User:(NSString *)user Pwd:(NSString *)pwd{
    [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_datetime.cgi?tz=%d&ntp_enable=%d&ntp_svr=%@&loginuse=%@&loginpas=%@&",ip,port,tz,enable,svr,user,pwd];
//  &now=%d
    [self sendCommonURL:urlString];
    [mLock unlock];
}
-(void)setUserpwd:(NSString *)ip Port:(NSString *)port User1:(NSString *)user1 Pwd1:(NSString *)pwd1 User2:(NSString *)user2 Pwd2:(NSString *)pwd2 User3:(NSString *)user3 Pwd3:(NSString *)pwd3 User:(NSString *)user Pwd:(NSString *)pwd{
    [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_users.cgi?user1=%@&pwd1=%@&user2=%@&pwd2=%@&user3=%@&pwd3=%@&loginuse=%@&loginpas=%@&",ip,port,user1,pwd1,user2,pwd2,user3,pwd3,user,pwd];
    [self sendCommonURL:urlString];
    
    [mLock unlock];
}
-(void)setAlarm:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd MotionArm:(int)motion_armed MotionSensitivity:(int)motion_sensitivity InputArmed:(int)input_armed IoinLevel:(int)ioin_level Preset:(int)alarmpresetsit Iolinkage:(int)iolinkage IooutLevel:(int)ioout_level Mail:(int)mail UploadInterval:(int)upload_interval Record:(int)record{
    [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_alarm.cgi?motion_armed=%d&motion_sensitivity=%d&input_armed=%d&ioin_level=%d&preset=%d&iolinkage=%d&ioout_level=%d&mail=%d&record=%d&upload_interval=%d&schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&loginuse=%@&loginpas=%@&",
                         ip,
                         port,
                         motion_armed,
                         motion_sensitivity,
                         input_armed,
                         ioin_level,
                         alarmpresetsit,
                         iolinkage,ioout_level,
                         mail,
                         record,
                         upload_interval,
                         ((motion_armed>0)||(input_armed>0))?1:0
                         ,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         0xffffffff,0xffffffff,0xffffffff,
                         user,
                         pwd
                         ];
    [self sendCommonURL:urlString];
    [mLock unlock];
}



-(void)setWifi:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd Enable:(int)enable SSID:(NSString *)ssid Channel:(int)channel Mode:(int)mode Authtype:(int)authtype Encrypt:(int)encrypt Keyformat:(int)keyformat Defkey:(int)defkey Key1:(NSString *)key1 Key2:(NSString *)key2 Key3:(NSString *)key3 Key4:(NSString *)key4 Key1_bits:(int)key1_bits Key2_bits:(int)key2_bits Key3_bits:(int)key3_bits Key4_bits:(int)key4_bits Wpa_psk:(NSString *)wpa_psk{
   [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_wifi.cgi?enable=%d&ssid=%@&encrypt=%d&defkey=%d&key1=%@&key2=%@&key3=%@&key4=%@&authtype=%d&keyformat=%d&key1_bits=%d&key2_bits=%d&key3_bits=%d&key4_bits=%d&channel=%d&mode=%d&wpa_psk=%@&loginuse=%@&loginpas=%@&",ip
                         ,port,enable,ssid,encrypt,defkey,key1,key2,key3,key4,authtype,keyformat,key1_bits,key2_bits,key3_bits,key4_bits,channel,mode,wpa_psk,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
    
}
-(void)setFtp:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd FTPSvr:(NSString *)svr StrUser:(NSString *)strUser StrPwd:(NSString *)strPwd SPort:(int)sport UploadInterval:(int)uploadinterval{
   [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_ftp.cgi?svr=%@&port=%d&user=%@&pwd=%@&mode=0&dir=/&interval=%d&loginuse=%@&loginpas=%@&",ip,port,svr,sport,strUser,strPwd,uploadinterval,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
     
}

-(void)setMail:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd Sender:(NSString *)sender Smtp_svr:(NSString *)smtp_svr Smtp_port:(int)smtp_port SSL:(int)ssl Auth:(int)auth StrUser:(NSString *)strUser StrPwd:(NSString *)strPwd Recv1:(NSString *)recv1 Recv2:(NSString *)recv2 Recv3:(NSString *)recv3 Recv4:(NSString *)recv4{

    [mLock lock];
    
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_mail.cgi?svr=%@&user=%@&pwd=%@&sender=%@&receiver1=%@&receiver2=%@&receiver3=%@&receiver4=%@&port=%d&ssl=%d&loginuse=%@&loginpas=%@&",ip,port,smtp_svr,strUser,strPwd,sender,recv1,recv2,recv3,recv4,smtp_port,ssl,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];

}
-(void)setRoot:(NSString *)ip Port:(NSString *)port CGI:(NSString *)cgi User:(NSString *)user Pwd:(NSString *)pwd{
    [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/reboot.cgi?loginuse=%@&loginpas=%@&",ip,port,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
}
-(void)setSdcard:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd CoverEnable:(int)cover_enable TimeLength:(int)timeLength RecordEnable:(int)recordenable{
    [mLock lock];
    
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/set_recordsch.cgi?record_cover=%d&record_timer=%d&time_schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%dloginuse=%@&loginpas=%@&",
                         ip,
                         port,
                         cover_enable,
                         timeLength,
                         recordenable,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         0xffffffff,
                         user,
                         pwd
                         ];
    [self sendCommonURL:urlString];
    [mLock unlock];
    
   
}
#pragma mark- CameraControl
-(void)PTZControl:(NSString *)ip
                Port:(NSString *)port
                User:(NSString *)user
                 Pwd:(NSString *)pwd
             Command:(int)command
             Step:(int)step{
    [mLock lock];
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/decoder_control.cgi?command=%d&onestep=%d&user=%@&pwd=%@&loginuse=%@&loginpas=%@&",ip,port,command,step,user,pwd,user,pwd];
    [self sendCommonURL:urlString];
    [mLock unlock];
}
-(void)CameraControl:(NSString *)ip
                Port:(NSString *)port
                User:(NSString *)user
                 Pwd:(NSString *)pwd
             Command:(int)cmd
               Value:(int)value{
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/camera_control.cgi?param=%d&value=%d&&user=%@&pwd=%@&loginuse=%@&loginpas=%@&",ip,port,cmd,value,user,pwd,user,pwd];
    [self sendCommonURL:urlString];
}
#pragma mark  NSURLConnection
-(void)sendCommonURL:(NSString *)strUrl{
    NSLog(@"NetWorkUtiles  urlString=%@",strUrl);
    NSURL *url=[NSURL URLWithString:strUrl];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];

    mConn=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:true];
    [mConn start];
//    [request release];
    
    
}

#pragma mark-NSURLConnectionDelegate/NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
     NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"NetWorkUtiles   didReceiveData()....paramType=%d str=%@",paramType,str);
    switch (paramType) {
            
        case CheckUser:{
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"CheckUser...str=%@",[str description]);
            if (networkProtocol!=nil) {
                if ([networkProtocol respondsToSelector:@selector(checkUserResult:Port:User:Pwd:Result:Type:)]) {
                    
                    [networkProtocol checkUserResult:strIP Port:strPort User:str_User Pwd:str_Pwd Result:1 Type:CheckUser];
                    paramType=-1;
                }
            }else{
               NSLog(@"CheckUser...str networkProtocol==nil");
            }
//            [str release];
            return;
        }
            break;
        case SnapshotType:{
            UIImage *image=[[UIImage alloc]initWithData:data];
            if (networkProtocol!=nil) {
                if ([networkProtocol respondsToSelector:@selector(snapShotResult:Img:)]) {
                    [networkProtocol snapShotResult:strIP Img:image];
                    paramType=-1;
                }
                
            }
            return;
            }
            break;
        case WifiType:
        {
            
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding]; 
            NSLog(@"str=%@",[str description]);
            STRU_WIFI_PARAMS wifiParams;
            memset(&wifiParams, 0, sizeof(wifiParams));
            if (m_CgiPacket.UnpacketWifiParams((char *)[str UTF8String], wifiParams))
            {
                if(wifiProtocol!=nil){
                    if ([wifiProtocol respondsToSelector:@selector(WifiParams:enable:ssid:channel:mode:authtype:encryp:keyformat:defkey:strKey1:strKey2:strKey3:strKey4:key1_bits:key2_bits:key3_bits:key4_bits:wpa_psk:)]) {
                        [wifiProtocol WifiParams:@"" enable:wifiParams.enable ssid:[NSString stringWithUTF8String:wifiParams.ssid] channel:wifiParams.channel mode:wifiParams.mode authtype:wifiParams.authtype encryp:wifiParams.encrypt keyformat:wifiParams.keyformat defkey:wifiParams.defkey strKey1:[NSString stringWithUTF8String:wifiParams.key1] strKey2:[NSString stringWithUTF8String:wifiParams.key2] strKey3:[NSString stringWithUTF8String:wifiParams.key3] strKey4:[NSString stringWithUTF8String:wifiParams.key4] key1_bits:wifiParams.key1_bits key2_bits:wifiParams.key2_bits key3_bits:wifiParams.key3_bits key4_bits:wifiParams.key4_bits wpa_psk:[NSString stringWithUTF8String:wifiParams.wpa_psk]];
                    }
                    
                }
            }
            
//            [str release];
            
            
            paramType=-1;
            
            NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_wifi_scan_result.cgi?user=%@&pwd=%@&",strIP,strPort,str_User,str_Pwd];
            wifiscanType=8;
            [self sendCommonURL:urlString];
            return;
        }
            
        case UserType:
        {
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str=%@  length=%d",str,str.length);
            NSArray *arr=[str componentsSeparatedByString:@"="];
            NSString *s=[arr objectAtIndex:1];
            NSLog(@"s=%@",s);
            NSString *result=[s substringWithRange:NSMakeRange(1,11)];
            NSLog(@"result=%@",result);
            if ([@"Auth Failed" caseInsensitiveCompare:result]==NSOrderedSame) {
                [networkProtocol checkUserResult:strIP Port:strPort User:str_User Pwd:str_Pwd Result:0 Type:CheckUser];
                
                paramType=-1;
                return;
            }
            STRU_USER_INFO userInfo;
            memset(&userInfo, 0, sizeof(userInfo));
            if (m_CgiPacket.UnpacketUserinfo((char *)[str UTF8String], userInfo))
            {
                if (userProtocol !=nil) {
                    if ([userProtocol respondsToSelector:@selector(UserPwdResult:user1:pwd1:user2:pwd2:user3:pwd3:)]) {
                         [userProtocol UserPwdResult:strIP user1:[NSString stringWithUTF8String:userInfo.user1]  pwd1:[NSString stringWithUTF8String:userInfo.pwd1] user2:[NSString stringWithUTF8String:userInfo.user2] pwd2:[NSString stringWithUTF8String:userInfo.pwd2] user3:[NSString stringWithUTF8String:userInfo.user3] pwd3:[NSString stringWithUTF8String:userInfo.pwd3]];
                    }
                   
                }
            
                
            }else{
              [userProtocol UserPwdResult:strIP user1:@""  pwd1:@"" user2:@"" pwd2:@"" user3:@"" pwd3:@""   ];
            
            }
            paramType=-1;
//            [str release];
            return;
        }
            
        case DateType:
        {
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str=%@",str);
            STRU_DATETIME_PARAMS datetimeParams;
            memset(&datetimeParams, 0, sizeof(datetimeParams));
            if (m_CgiPacket.UnpacketDDNSDatetimeParam((char *)[str UTF8String], datetimeParams))
            {
                if (dateProtocol != nil) {
                    if ([dateProtocol respondsToSelector:@selector(DateTimeProtocolResult:tz:ntp_enable:net_svr:)]) {
                        [dateProtocol DateTimeProtocolResult:datetimeParams.now  tz:(int)datetimeParams.tz ntp_enable:(int)datetimeParams.ntp_enable net_svr:[NSString stringWithUTF8String:datetimeParams.ntp_svr]];
                    }
                    
                    
                }
            }
//            [str release];
            paramType=-1;
            return;  
        }
            
        case AlarmType:
        {
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str=%@",str);
            STRU_ALARM_PARAMS alarm;
            memset(&alarm, 0, sizeof(alarm));
            if (m_CgiPacket.UppacketAlarmParams((char *)[str UTF8String], alarm))
            {
                if (alarmProtocol != nil) {
                    if ([alarmProtocol respondsToSelector:@selector(AlarmProtocolResult:motion_sensitivity:input_armed:ioin_level:alarmpresetsit:iolinkage:ioout_level:mail:snapshot:upload_interval:record:)]) {
                        [alarmProtocol AlarmProtocolResult:alarm.motion_armed motion_sensitivity:(int)alarm.motion_sensitivity input_armed:(int)alarm.input_armed ioin_level:(int)alarm.ioin_level alarmpresetsit:(int)alarm.alarmpresetsit iolinkage:(int)alarm.iolinkage ioout_level:(int)alarm.ioout_level mail:(int)alarm.mail snapshot:(int)alarm.snapshot upload_interval:(int)alarm.upload_interval record:alarm.record];
                    }
                    
                }
            
            }
//            [str release];
            paramType=-1;
            return;  
        }
           
        case FTPType:
        {
           
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str =%@",[str description]);
            STRU_FTP_PARAMS ftpParam;
            memset(&ftpParam, 0, sizeof(ftpParam));
            if (m_CgiPacket.UnpacketFtpParam((char *)[str UTF8String], ftpParam))
            {
                
                if (ftpProtocol != nil) {
                    if ([ftpProtocol respondsToSelector:@selector(FtpParam:user:pwd:dir:port:uploadinterval:mode:)]) {
                        [ftpProtocol
                         FtpParam:ftpParam.svr_ftp
                         user:ftpParam.user
                         pwd:ftpParam.pwd
                         dir:ftpParam.dir
                         port:ftpParam.port
                         uploadinterval:ftpParam.upload_interval
                         mode:ftpParam.mode];
                    }
                    
                    
                     
                }
                
            }
//            [str release];
            paramType=-1;
            return;  
        }
          
        case MailType:
        {
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        
            
            STRU_MAIL_PARAMS mailParam;
            memset(&mailParam, 0, sizeof(mailParam));
            if (m_CgiPacket.UnpacketMailParam((char *)[str UTF8String], mailParam))
            {
                if (mailProtocol!=nil) {
                    if ([mailProtocol respondsToSelector:@selector(MailParam:smtpsvr:smtpport:ssl:auth:user:pwd:recv1:recv2:recv3:recv4:)]) {
                        [mailProtocol MailParam:[NSString stringWithUTF8String:mailParam.sender]
                                        smtpsvr:[NSString stringWithUTF8String:mailParam.svr]
                                       smtpport:mailParam.port
                                            ssl:mailParam.ssl
                                           auth:(strlen(mailParam.user) > 0 ? 1 : 0)
                                           user:[NSString stringWithUTF8String:mailParam.user]
                                            pwd:[NSString stringWithUTF8String:mailParam.pwd]
                                          recv1:[NSString stringWithUTF8String:mailParam.receiver1]
                                          recv2:[NSString stringWithUTF8String:mailParam.receiver2]
                                          recv3:[NSString stringWithUTF8String:mailParam.receiver3]
                                          recv4:[NSString stringWithUTF8String:mailParam.receiver4]];
                    }
                   
                }
               
            }
//            [str release];
            paramType=-1;
            return;
                          
            
        }
        case SDCardType:
        {
        NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str=%@",str);
            STRU_SD_RECORD_PARAM recordParam;
            memset(&recordParam, 0, sizeof(recordParam));
            if (m_CgiPacket.UnpacketSdCardRecordParam((char *)[str UTF8String], recordParam))
            {
                if (sdcardProtocol) {
                    if ([sdcardProtocol respondsToSelector:@selector(sdcardScheduleParams:Tota:RemainCap:SD_status:Cover:TimeLength:FixedTimeRecord:RecordSize:)]) {
                        [sdcardProtocol  sdcardScheduleParams:@"" Tota:recordParam.sdtotal RemainCap:recordParam.sdfree SD_status:recordParam.record_sd_status Cover:recordParam.record_cover_enable TimeLength:recordParam.record_timer FixedTimeRecord:recordParam.record_time_enable RecordSize:recordParam.record_size];
                    }
                    
                }
              
            }
//            [str release];
            paramType=-1;
             return;
        }
            break;
        case CameraDefaultParam:{
            NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"str=%@",str);
            STRU_CAMERA_PARAMS CameraParam;
            memset(&CameraParam, 0, sizeof(CameraParam));
            if(m_CgiPacket.UnpacketCameraParam((char *)[str UTF8String], CameraParam)){
                //NSLog(@"CameraDefaultParam....1");
                if (imageNotifyProtocol!=nil) {
                    if ([imageNotifyProtocol respondsToSelector:@selector(CameraDefaultParams:Bright:Resolution:Flip:Frame:)]) {
                        [imageNotifyProtocol CameraDefaultParams:CameraParam.contrast Bright:CameraParam.brightness Resolution:CameraParam.resolution Flip:CameraParam.flip Frame:CameraParam.enc_framerate];
                    }
                    
                }
                
                // NSLog(@"CameraDefaultParam....2");
            }
//            [str release];
            paramType=-1;
             return;
        }

            break;
       
    }
    NSLog(@"wifiscanType=%d  WifiScanType=%d",wifiscanType,WifiScanType);
    if ((wifiscanType==WifiScanType)&&(paramType=-1)) {
        NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"wifiscanResult=%@",str);
        int apNmber=0;
        
        if (m_CgiPacket.SscanfInt((char*)[str UTF8String],"ap_number=", apNmber)) {
            if (apNmber<=0&&wifiscanCount<3) {
                NSString *urlString=[NSString stringWithFormat:@"http://%@:%@/get_wifi_scan_result.cgi?user=%@&pwd=%@&",strIP,strPort,str_User,str_Pwd];
                wifiscanType=8;
                [self sendCommonURL:urlString];
                wifiscanCount++;
                NSLog(@"wifiscanCount=%d",wifiscanCount);
                return;
            }
        }
   
        wifiscanCount=0;
        STRU_WIFI_SEARCH_RESULT_LIST wifiSearchResultList;
        memset(&wifiSearchResultList, 0 ,sizeof(wifiSearchResultList));
        if (m_CgiPacket.UnpacketWifiSearchResult((char *)[str UTF8String], wifiSearchResultList))
        {
            int nCount = wifiSearchResultList.nResultCount;
            int i;
            for (i = 0; i < nCount; i++)
            {
                int bEnd = 0;
                if (i == nCount - 1)
                {
                    bEnd = 1;
                }
                
                if (wifiProtocol!=nil) {
                    if ([wifiProtocol respondsToSelector:@selector(WifiScanResult:ssid:mac:security:db0:db1:mode:channel:bEnd:)]) {
                        [wifiProtocol WifiScanResult:@"" ssid:[NSString stringWithUTF8String:wifiSearchResultList.wifi[i].ssid] mac:[NSString stringWithUTF8String:wifiSearchResultList.wifi[i].mac] security:wifiSearchResultList.wifi[i].security db0:atoi(wifiSearchResultList.wifi[i].dbm0) db1:100 mode:wifiSearchResultList.wifi[i].mode channel:wifiSearchResultList.wifi[i].channel bEnd:bEnd];
                    }
                    
                }
               
                
            }
           
        }
         //wifiscanType=-1;
//        [str release]; 
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"NetWorkUtils  didFailWithError");
    if (networkProtocol!=nil) {
        if ([networkProtocol respondsToSelector:@selector(connectFailed:)]) {
            [networkProtocol connectFailed:strIP];
        }
    }
}

@end
