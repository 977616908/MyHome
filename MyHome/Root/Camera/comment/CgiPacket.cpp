

#include "stdio.h"
#include "string.h"
#include "CgiPacket.h"

CCgiPacket::CCgiPacket()
{

}

CCgiPacket::~CCgiPacket()
{
}


int CCgiPacket::SscanfString(const char *pszBuffer , const char *reg , char *szResult)
{
#if 0
	char * p = strstr((char *)pszBuffer,(char *)reg);
	if(p == NULL)
		return 0;

	char buf[512] = {0};
	sprintf(buf,"%s\"%s\";\r\n",reg,"%s");
	sscanf(p,buf, szResult);

    int nLen = strlen(szResult);
    if (nLen > 1)
    {
        szResult[nLen - 2] = 0;
    }
    
#endif
    
    //memset(szResult, 0, sizeof(szResult)) ;
    char buf[512] = {0};
    sprintf(buf, "%s\"", reg);
    char *p = strstr((char*)pszBuffer, buf);
    if(p == NULL)
        return 0;
    
    int len = strlen(buf);
    p += len;
    char *pEnd = strstr(p, "\"");
    if(pEnd == NULL)
        return 0;
    
    int offset = pEnd - p;
    if(offset > 128)
    {
        return 0;
    }
    
    int i;
    for(i = 0; i < offset; i++)
    {
        szResult[i] = p[i];
    }
    
    //NSLog(@"szResult: %s", szResult);
    
 	return 1;
}

int CCgiPacket::SscanfInt(const char *pszBuffer , const char *reg , int &nResult)
{
	char * p = strstr((char *)pszBuffer,(char *)reg);
	if(p == NULL)
		return 0;

	char buf[512] = {0};
	sprintf(buf,"%s%s", reg,"%d");
	sscanf(p, buf, &nResult);  

	return 1;
}

int CCgiPacket::UnpacketCameraParam(const char *pszBuffer,STRU_CAMERA_PARAMS &t)
{
    /*
    resolution=0;
    vbright=0;
    vcontrast=128;
    vhue=0;
    vsaturation=0;
    OSDEnable=0;
    mode=0;
    flip=0;
    enc_framerate=30;
    sub_enc_framerate=15;*/

	if (SscanfInt(pszBuffer,"resolution=",t.resolution) &&
		SscanfInt(pszBuffer,"vbright=",t.brightness) &&
		SscanfInt(pszBuffer,"vcontrast=",t.contrast) &&
		SscanfInt(pszBuffer,"vhue=",t.hue) &&
        SscanfInt(pszBuffer, "vsaturation=", t.saturation) &&
        SscanfInt(pszBuffer, "enc_framerate=", t.enc_framerate)&&
		SscanfInt(pszBuffer,"flip=",t.flip)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketNetworkParam(const char *pszBuffer,STRU_NETWORK_PARAMS &t)
{
	//get_params.cgi
	//var dhcpen=0; var ip="192.168.1.234"; var mask="255.255.255.0"; var gateway="192.168.1.1"; var dns1="8.8.8.8"; var dns2="202.96.134.33"; var port=81;
	if (SscanfString(pszBuffer,"ip=",t.ipaddr) &&
		SscanfString(pszBuffer,"mask=",t.netmask) &&
		SscanfString(pszBuffer,"gateway=",t.gateway) &&
		SscanfString(pszBuffer,"dns1=",t.dns1) &&
		SscanfString(pszBuffer,"dns2=",t.dns2)&&
		SscanfInt(pszBuffer,"dhcpen=",t.dhcp) &&
		SscanfInt(pszBuffer,"port=",t.port)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UppacketAlarmParams(const char *pszBuffer, STRU_ALARM_PARAMS &t)
{    

    if (SscanfInt(pszBuffer,"alarm_motion_armed=",t.motion_armed) &&
        SscanfInt(pszBuffer,"alarm_motion_sensitivity=",t.motion_sensitivity) &&
        SscanfInt(pszBuffer,"alarm_input_armed=",t.input_armed) &&
        SscanfInt(pszBuffer,"alarm_ioin_level=",t.ioin_level) &&
        SscanfInt(pszBuffer,"alarm_mail=",t.mail) &&
        SscanfInt(pszBuffer,"alarm_iolinkage=",t.iolinkage) &&
        SscanfInt(pszBuffer,"alarm_ioout_level=",t.ioout_level) &&
        SscanfInt(pszBuffer,"alarm_upload_interval=",t.upload_interval) &&
        SscanfInt(pszBuffer,"alarm_presetsit=",t.alarmpresetsit) &&
        SscanfInt(pszBuffer,"alarm_snapshot=",t.snapshot) &&
        SscanfInt(pszBuffer,"alarm_record=",t.record) &&
        SscanfInt(pszBuffer,"alarm_schedule_enable=",t.schedule_enable) &&
        SscanfInt(pszBuffer,"alarm_schedule_sun_0=",t.schedule_sun_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_sun_1=",t.schedule_sun_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_sun_2=",t.schedule_sun_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_mon_0=",t.schedule_mon_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_mon_1=",t.schedule_mon_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_mon_2=",t.schedule_mon_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_tue_0=",t.schedule_tue_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_tue_1=",t.schedule_tue_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_tue_2=",t.schedule_tue_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_wed_0=",t.schedule_wed_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_wed_1=",t.schedule_wed_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_wed_2=",t.schedule_wed_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_thu_0=",t.schedule_thu_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_thu_1=",t.schedule_thu_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_thu_2=",t.schedule_thu_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_fri_0=",t.schedule_fri_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_fri_1=",t.schedule_fri_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_fri_2=",t.schedule_fri_2) &&
        SscanfInt(pszBuffer,"alarm_schedule_sat_0=",t.schedule_sat_0) &&
        SscanfInt(pszBuffer,"alarm_schedule_sat_1=",t.schedule_sat_1) &&
        SscanfInt(pszBuffer,"alarm_schedule_sat_2=",t.schedule_sat_2)
        )
    {
        return 1;
    }

    return 0;
}

int CCgiPacket::UnpacketUserinfo(const char *pszBuffer,STRU_USER_INFO &t)
{
	//get_params.cgi
	//var user1_name="1"; var user1_pwd=""; var user2_name="2"; var user2_pwd=""; var user3_name="admin"; var user3_pwd=""; 
	if (SscanfString(pszBuffer,"user1_name=",t.user1) &&
		SscanfString(pszBuffer,"user1_pwd=",t.pwd1) &&
		SscanfString(pszBuffer,"user2_name=",t.user2) &&
		SscanfString(pszBuffer,"user2_pwd=",t.pwd2) &&
		SscanfString(pszBuffer,"user3_name=",t.user3)&&
		SscanfString(pszBuffer,"user3_pwd=",t.pwd3)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketStatusParam(const char *pszBuffer, STRU_CAMERA_STATUS &t)
{
    /*
    alias="调试用的";
    deviceid="OBJ-000165-PBKMW";
    sys_ver="93.0.0.0";
    now=1348121285;
    alarm_status=0;
    upnp_status=1;
    dnsenable=0;
    osdenable=0;
    mac="00:b9:c0:00:a9:b3";
    wifimac="00:13:2b:13:00:61";
    dns_status=0;
    sdstatus=0;
    devicetype=0x00;
    sdstatus=0;
    sdtotal=0;
    sdlevel=0;
    */

    if (SscanfString(pszBuffer,"sys_ver=",t.sysver) &&
        SscanfString(pszBuffer,"alias=",t.devname) &&
        SscanfString(pszBuffer,"deviceid=",t.devid) &&
        SscanfString(pszBuffer,"mac=",t.mac) &&
        SscanfString(pszBuffer,"wifimac=",t.wifimac) &&
        SscanfInt(pszBuffer,"alarm_status=",t.alarmstatus) &&
        SscanfInt(pszBuffer,"sdstatus=",t.sdcardstatus) &&
        SscanfInt(pszBuffer,"sdtotal=",t.sdcardtotalsize) &&
        SscanfInt(pszBuffer,"sdlevel=",t.sdcardremainsize) &&
        SscanfInt(pszBuffer,"upnp_status=",t.upnp_status) &&
        SscanfInt(pszBuffer,"dns_status=",t.dns_status)
        )
    {
        return 1;
    }

    return 0;
}
int CCgiPacket::UnpacketDDNSDatetimeParam(const char *pszBuffer,STRU_DATETIME_PARAMS &t){
    SscanfInt(pszBuffer,"now1=",t.now);
    SscanfInt(pszBuffer,"tz=",t.tz);
    SscanfInt(pszBuffer,"ntp_enable=",t.ntp_enable);
    SscanfString(pszBuffer,"ntp_svr=",t.ntp_svr) ;
    
    return 1;
}
int CCgiPacket::UnpacketDatetimeParam(const char *pszBuffer,STRU_DATETIME_PARAMS &t)
{
	//get_params.cgi
	//var tz=-28800; var ntp_enable=1; var ntp_svr="time.nist.gov";
// 	if (SscanfInt(pszBuffer,"now=",t.now) &&
// 		SscanfInt(pszBuffer,"tz=",t.tz) &&
// 		SscanfInt(pszBuffer,"ntp_enable=",t.ntp_enable) &&
// 		SscanfString(pszBuffer,"ntp_svr=",t.ntp_svr) 
// 		)
// 	{
// 		return 1;
// 	}
// 
//  	return 0;

    SscanfInt(pszBuffer,"now=",t.now);
    SscanfInt(pszBuffer,"tz=",t.tz);
    SscanfInt(pszBuffer,"ntp_enable=",t.ntp_enable);
    SscanfString(pszBuffer,"ntp_svr=",t.ntp_svr) ;

    return 1;
}

int CCgiPacket::UnpacketDdnsParam(const char *pszBuffer,STRU_DDNS_PARAMS &t)
{
	//get_params.cgi
	//var ddns_service=0; var ddns_proxy_svr=""; var ddns_host=""; var ddns_user=""; var ddns_pwd=""; var ddns_proxy_port=0; var ddns_mode=0; var ddns_status=0;
	if (SscanfInt(pszBuffer,"ddns_service=",t.service) &&
		SscanfString(pszBuffer,"ddns_proxy_svr=",t.proxy_svr) &&
		SscanfString(pszBuffer,"ddns_host=",t.host) &&
		SscanfString(pszBuffer,"ddns_user=",t.user) &&
		SscanfString(pszBuffer,"ddns_pwd=",t.pwd)&&
		SscanfInt(pszBuffer,"ddns_proxy_port=",t.proxy_port) &&
		SscanfInt(pszBuffer,"ddns_mode=",t.ddns_mode) &&
        SscanfInt(pszBuffer,"ddns_status=",t.ddns_status)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketFtpParam(const char *pszBuffer,STRU_FTP_PARAMS &t)
{
	//get_params.cgi
	//var ftp_svr=""; var ftp_user=""; var ftp_pwd=""; var ftp_dir="/"; var ftp_port=21; var ftp_mode=0; var ftp_upload_interval=0; var ftp_filename=6243764;
	if (SscanfString(pszBuffer,"ftp_svr=",t.svr_ftp) &&
		SscanfString(pszBuffer,"ftp_user=",t.user) &&
		SscanfString(pszBuffer,"ftp_pwd=",t.pwd) &&
		SscanfString(pszBuffer,"ftp_dir=",t.dir) &&
		SscanfInt(pszBuffer,"ftp_port=",t.port)&&
		SscanfInt(pszBuffer,"ftp_mode=",t.mode) &&
		SscanfInt(pszBuffer,"ftp_upload_interval=",t.upload_interval)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketMailParam(const char *pszBuffer,STRU_MAIL_PARAMS &t)
{
	//get_params.cgi
	//var mail_sender=""; var mail_receiver1=""; var mail_receiver2=""; var mail_receiver3=""; var mail_receiver4=""; 
	//var mailssl=0; var mail_svr=""; var mail_user=""; var mail_pwd=""; var mail_port=0; var mail_inet_ip=0;
	if (SscanfString(pszBuffer,"mail_sender=",t.sender) &&
		SscanfString(pszBuffer,"mail_receiver1=",t.receiver1) &&
		SscanfString(pszBuffer,"mail_receiver2=",t.receiver2) &&
		SscanfString(pszBuffer,"mail_receiver3=",t.receiver3) &&
		SscanfString(pszBuffer,"mail_receiver4=",t.receiver4) &&
		SscanfString(pszBuffer,"mail_svr=",t.svr) &&
		SscanfString(pszBuffer,"mail_user=",t.user) &&
		SscanfString(pszBuffer,"mail_pwd=",t.pwd) &&
		SscanfInt(pszBuffer,"mail_port=",t.port)&&
		SscanfInt(pszBuffer,"mailssl=",t.ssl)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketSdCardRecordParam(const char * pszBuffer,STRU_SD_RECORD_PARAM & t)
{
    /*
     var record_cover_enable=0;
     var record_timer=0;
     var record_size=0;
     var record_time_enable=0;
     var record_schedule_sun_0=0;
     var record_schedule_sun_1=0;
     var record_schedule_sun_2=0;
     var record_schedule_mon_0=0;
     var record_schedule_mon_1=0;
     var record_schedule_mon_2=0;
     var record_schedule_tue_0=0;
     var record_schedule_tue_1=0;
     var record_schedule_tue_2=0;
     var record_schedule_wed_0=0;
     var record_schedule_wed_1=0;
     var record_schedule_wed_2=0;
     var record_schedule_thu_0=0;
     var record_schedule_thu_1=0;
     var record_schedule_thu_2=0;
     var record_schedule_fri_0=0;
     var record_schedule_fri_1=0;
     var record_schedule_fri_2=0;
     var record_schedule_sat_0=0;
     var record_schedule_sat_1=0;
     var record_schedule_sat_2=0;
     var record_sd_status=0;
     var sdtotal=0;
     var sdfree=0;
     
     */
    if (SscanfInt(pszBuffer,"record_cover_enable=",t.record_cover_enable) &&
        SscanfInt(pszBuffer,"record_timer=",t.record_timer) &&
        SscanfInt(pszBuffer,"record_size=",t.record_size) &&
        SscanfInt(pszBuffer,"record_time_enable=",t.record_time_enable) &&
        SscanfInt(pszBuffer,"record_schedule_sun_0=",t.record_schedule_sun_0) &&
        SscanfInt(pszBuffer,"record_schedule_sun_1=",t.record_schedule_sun_1) &&
        SscanfInt(pszBuffer,"record_schedule_sun_2=",t.record_schedule_sun_2) &&
        SscanfInt(pszBuffer,"record_schedule_mon_0=",t.record_schedule_mon_0) &&
        SscanfInt(pszBuffer,"record_schedule_mon_1=",t.record_schedule_mon_1) &&
        SscanfInt(pszBuffer,"record_schedule_mon_2=",t.record_schedule_mon_2) &&
        SscanfInt(pszBuffer,"record_schedule_tue_0=",t.record_schedule_tue_0) &&
        SscanfInt(pszBuffer,"record_schedule_tue_1=",t.record_schedule_tue_1) &&
        SscanfInt(pszBuffer,"record_schedule_tue_2=",t.record_schedule_tue_2) &&
        SscanfInt(pszBuffer,"record_schedule_wed_0=",t.record_schedule_wed_0) &&
        SscanfInt(pszBuffer,"record_schedule_wed_1=",t.record_schedule_wed_1) &&
        SscanfInt(pszBuffer,"record_schedule_wed_2=",t.record_schedule_wed_2) &&
        SscanfInt(pszBuffer,"record_schedule_thu_0=",t.record_schedule_thu_0) &&
        SscanfInt(pszBuffer,"record_schedule_thu_1=",t.record_schedule_thu_1) &&
        SscanfInt(pszBuffer,"record_schedule_thu_2=",t.record_schedule_thu_2) &&
        SscanfInt(pszBuffer,"record_schedule_fri_0=",t.record_schedule_fri_0) &&
        SscanfInt(pszBuffer,"record_schedule_fri_1=",t.record_schedule_fri_1) &&
        SscanfInt(pszBuffer,"record_schedule_fri_2=",t.record_schedule_fri_2) &&
        SscanfInt(pszBuffer,"record_schedule_sat_0=",t.record_schedule_sat_0) &&
        SscanfInt(pszBuffer,"record_schedule_sat_1=",t.record_schedule_sat_1) &&
        SscanfInt(pszBuffer,"record_schedule_sat_2=",t.record_schedule_sat_2) &&
        SscanfInt(pszBuffer,"record_sd_status=",t.record_sd_status) &&
        SscanfInt(pszBuffer,"sdtotal=",t.sdtotal) &&
        SscanfInt(pszBuffer,"sdfree=",t.sdfree) 
        )
    {
        return 1;
    }
    
    return 0;
}


int CCgiPacket::UnpacketSdCardRecordFileList(const char * pszBuffer,STRU_RECORD_FILE_LIST & t)
{
//    int n = 0;
//	SscanfInt(pszBuffer,"record_file_count=",n);
//	if (n == 0)
//	{
//		return 0;
//	}	
//    
//    n = (n > MAX_RECORD_FILE_COUNT) ? MAX_RECORD_FILE_COUNT : n ;
//    
//    t.nCount = n;
//    
//    NSLog(@"t.nCount: %d", t.nCount);
//	
//	char buf[128]={0};
//	for (int i = 0 ; i < n ; i++)
//	{
//		sprintf(buf,"record_name[%d]=",i);
//		SscanfString(pszBuffer,buf,t.recordFile[i].szFileName);
//        
//		sprintf(buf,"record_size[%d]=",i);
//		SscanfInt(pszBuffer,buf,t.recordFile[i].nFileSize);
//        
//        NSLog(@"t.recordFile[%d].szFileName: %s, size: %d", i, t.recordFile[i].szFileName, t.recordFile[i].nFileSize);
//        
//	}
////    
//	return 1;
    
    int n = 0;
	SscanfInt(pszBuffer,"record_num0=",n);
	if (n == 0)
	{
		return 0;
	}
    
   // n = (n > MAX_RECORD_FILE_COUNT) ? MAX_RECORD_FILE_COUNT : n ;
    
    t.nCount = n;
    
    int PageCount;
    SscanfInt(pszBuffer,"PageCount=",PageCount);
    //Log("t.nCount: %d", t.nCount);
	t.nPageCount=PageCount;
	char buf[128]={0};
	for (int i = 0 ; i < n ; i++)
	{
		sprintf(buf,"record_name0[%d]=",i);
		SscanfString(pszBuffer,buf,t.recordFile[i].szFileName);
        
		sprintf(buf,"record_size0[%d]=",i);
		SscanfInt(pszBuffer,buf,t.recordFile[i].nFileSize);
        
        //Log("t.recordFile[%d].szFileName: %s, size: %d", i, t.recordFile[i].szFileName, t.recordFile[i].nFileSize);
        
	}
    
	return 1;
}

int CCgiPacket::UnpacketPtzParam(const char *pszBuffer,STRU_PTZ_PARAMS &t)
{
    
	//get_misc.cgi
	//var ptz_patrol_rate=6; var ptz_patrol_up_rate=0; var ptz_patrol_down_rate=0; var ptz_patrol_left_rate=0; 
	//var ptz_patrol_right_rate=0; var ptz_center_onstart=0; var ptz_disppreset=0; var led_mode=0; var preset_onstart=0; var ptruntimes=0; 
	if (SscanfInt(pszBuffer,"ptz_patrol_rate=",t.ptz_patrol_rate) &&
		SscanfInt(pszBuffer,"ptz_patrol_up_rate=",t.ptz_patrol_up_rate) &&
		SscanfInt(pszBuffer,"ptz_patrol_down_rate=",t.ptz_patrol_down_rate) &&
		SscanfInt(pszBuffer,"ptz_patrol_left_rate=",t.ptz_patrol_left_rate) &&
		SscanfInt(pszBuffer,"ptz_patrol_right_rate=",t.ptz_patrol_right_rate) &&
		SscanfInt(pszBuffer,"ptz_center_onstart=",t.ptz_center_onstart) &&
		SscanfInt(pszBuffer,"ptz_disppreset=",t.disable_preset) &&
		SscanfInt(pszBuffer,"led_mode=",t.led_mode) &&
		SscanfInt(pszBuffer,"preset_onstart=",t.ptz_preset)&&
		SscanfInt(pszBuffer,"ptruntimes=",t.ptz_run_times)
		)
	{
		return 1;
	}

	return 0;
}

int CCgiPacket::UnpacketWifiSearchResult(const char *pszBuffer,STRU_WIFI_SEARCH_RESULT_LIST &t)
{
	//wifi_scan.cgi
    /*var ap_number=13;
    var ap_ssid=new Array();
    var ap_mode=new Array();
    var ap_security=new Array();
    var ap_dbm0=new Array();
    var ap_dbm1=new Array();
    var ap_mac=new Array();
    ap_ssid[0] ="TP-LINK_888";
    ap_mac[0]="EC:88:8F:73:44:44";
    ap_security[0]=4;
    ap_dbm0[0]='100';
    ap_dbm1[0]='100';
    ap_mode[0]=0;
    ap_ssid[1] ="666888";
    ap_mac[1]="38:83:45:5F:8D:7C";
    ap_security[1]=4;
    ap_dbm0[1]='5';
    ap_dbm1[1]='100';
    ap_mode[1]=0;
    ap_ssid[2] ="ChinaNet-cnXA";
    ap_mac[2]="84:74:2A:57:72:72";
    ap_security[2]=2;
    ap_dbm0[2]='29';
    ap_dbm1[2]='100';
    ap_mode[2]=0;
    ap_ssid[3] ="Tenda_259678";
    ap_mac[3]="C8:3A:35:25:96:78";
    ap_security[3]=4;
    ap_dbm0[3]='76';
    ap_dbm1[3]='100';
    ap_mode[3]=0;
    ap_ssid[4] ="TP-LINK_6170A0";
    ap_mac[4]="00:25:86:61:70:A0";
    ap_security[4]=5;
    ap_dbm0[4]='15';
    ap_dbm1[4]='100';
    ap_mode[4]=0;
    ap_ssid[5] ="LINNET GROUP";
    ap_mac[5]="00:23:CD:E1:22:58";
    ap_security[5]=1;
    ap_dbm0[5]='60';
    ap_dbm1[5]='100';
    ap_mode[5]=0;
    ap_ssid[6] ="TP-LINK_OJT";
    */

	int n = 0;
	SscanfInt(pszBuffer,"ap_number=",n);
	if (n == 0)
	{
		return 0;
	}	

    n = (n > 50) ? 50 : n ;

    t.nResultCount = n;
	
	char buf[100]={0};
	for (int i = 0 ; i < n ; i++)
	{
		sprintf(buf,"ap_ssid[%d] =",i);
		SscanfString(pszBuffer,buf,t.wifi[i].ssid);

		sprintf(buf,"ap_mac[%d]=",i);
		SscanfString(pszBuffer,buf,t.wifi[i].mac);

		sprintf(buf,"ap_security[%d]=",i);
		SscanfInt(pszBuffer,buf,t.wifi[i].security);

		sprintf(buf,"ap_dbm0[%d]=",i);  //ap_dbm0[0]='100'  -->>  ap_dbm0[0]="100"
		SscanfString(pszBuffer,buf,t.wifi[i].dbm0);

		sprintf(buf,"ap_dbm1[%d]=",i);
		SscanfString(pszBuffer,buf,t.wifi[i].dbm1);

		sprintf(buf,"ap_mode[%d]=",i);
		SscanfInt(pszBuffer,buf,t.wifi[i].mode);

        sprintf(buf, "ap_channel[%d]=",i);
        SscanfInt(pszBuffer,buf,t.wifi[i].channel);
	}

	return 1;
}

int CCgiPacket::UnpacketWifiParams(const char *pszBuffer, STRU_WIFI_PARAMS &t)
{
    //get_params.cgi
    /*
    var wifi_enable=0; 
    var wifi_ssid=""; 
    var wifi_mode=0; 
    var wifi_encrypt=0; 
    var wifi_authtype=0; 
    var wifi_defkey=0; 
    var wifi_keyformat=0;
    var wifi_key1=""; 
    var wifi_key2=""; 
    var wifi_key3=""; 
    var wifi_key4=""; 
    var wifi_key1_bits=0; 
    var wifi_key2_bits=0; 
    var wifi_key3_bits=0; 
    var wifi_key4_bits=0; 
    var wifi_wpa_psk="";*/

    if (SscanfInt(pszBuffer,"wifi_enable=",t.enable) &&
        SscanfString(pszBuffer,"wifi_ssid=",t.ssid) &&
        SscanfInt(pszBuffer,"wifi_mode=",t.mode) &&
        SscanfInt(pszBuffer,"wifi_encrypt=",t.encrypt) &&
        SscanfInt(pszBuffer,"wifi_authtype=",t.authtype) &&
        SscanfInt(pszBuffer,"wifi_defkey=",t.defkey) &&
        SscanfInt(pszBuffer,"wifi_keyformat=",t.keyformat) &&
        SscanfString(pszBuffer,"wifi_key1=",t.key1) &&
        SscanfString(pszBuffer,"wifi_key2=",t.key2)&&
        SscanfString(pszBuffer,"wifi_key3=",t.key3) &&
        SscanfString(pszBuffer,"wifi_key4=",t.key4) &&
        SscanfInt(pszBuffer,"wifi_key1_bits=",t.key1_bits) &&
        SscanfInt(pszBuffer,"wifi_key2_bits=",t.key2_bits) &&
        SscanfInt(pszBuffer,"wifi_key3_bits=",t.key3_bits) &&
        SscanfInt(pszBuffer,"wifi_key4_bits=",t.key4_bits) &&
        SscanfString(pszBuffer,"wifi_wpa_psk=",t.wpa_psk) 
        )
    {
        return 1;
    }

    return 0;
}

int  CCgiPacket::UnpacketSetResult(const char *pszBuffer)
{
	char buf[100]={0};
	if (!SscanfString(pszBuffer,"result=",buf))
	{
		return -1;
	}

	if (NULL == strstr(buf,"ok"))
	{
		return -1;
	}
	
	return 0;
}