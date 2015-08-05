//
//  MyHomeHeader.h
//  MyHome
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#ifndef MyHome_MyHomeHeader_h
#define MyHome_MyHomeHeader_h

#define PFIP [GlobalShare routerIP]
#define ROUTINGIP [NSString stringWithFormat:@"http://%@/cgi-bin/luci",PFIP]
//#define ROUTINGIP @"https://witfii.com/api/0" //中转服务器
#define ROUTINGBASEURL [NSString stringWithFormat:@"%@/api/0",ROUTINGIP]/** 路由器请求地址 */
#define ROUTER_FOLDER_BASEURL(path) [NSString stringWithFormat:@"%@/syncboxlite/0/metadata/syncbox/%@",ROUTINGIP,path]
#define ROUTER_FILE_DOWNLOAD(path) [NSString stringWithFormat:@"%@/syncboxlite/0/files/syncbox/%@",ROUTINGIP,path]

#define ROUTER_FILE_WHOLEDOWNLOAD(path) [NSString stringWithFormat:@"%@/syncboxlite/0/files/syncbox%@?dl=1&token=%@",ROUTINGIP,path,[GlobalShare getToken]]
//删除图片地址
#define ROUTER_FILE_DELETE [NSString stringWithFormat:@"%@/syncboxlite/0/fileops/delete?token=%@",ROUTINGIP,[GlobalShare getToken]]
//备份图片地址
#define ROUTER_FILE_UPDOWN [NSString stringWithFormat:@"%@/syncboxlite/0/files/syncbox/Photo?overwrite=false&token=%@",ROUTINGIP,[GlobalShare getToken]]
//备份视频地址
#define ROUTER_FILE_UPVEDIO [NSString stringWithFormat:@"%@/syncboxlite/0/files/syncbox/Video?overwrite=false&token=%@",ROUTINGIP,[GlobalShare getToken]]
//#define ROUTINGPASSWORD @"12345678"
#define REQUESTTIMEOUT 10
#define FLOWTTBASEURL @"http://58.67.196.187:8080/platports/pifii/plat/system" //外网
//#define FLOWTTBASEURL @"http://192.168.1.213:8022/platports/pifii/plat/system"  //内网
#define CLOUNDURL @"http://58.67.196.187:8080/platports/pifii/plat/cloud" //云下载

#define MyHomeURL @"http://58.67.196.187:8080/platports/pifii/plat/timeRouter" //云下载getCamera
//#define MyHomeURL @"http://192.168.1.6:8080/platports/pifii/plat/timeRouter" //云下载 内网
#define ROUTINGCAMERA @"http://58.67.196.187:8080/platports/pifii/plat/plug" //摄像头
#define JUHEIURL @"http://op.juhe.cn/onebox/movie/video"  //聚合影视

#define TOKEN @"token" //路由访问的token
#define ROUTERIP @"routerIP" //路由访问的IP
#define ROUTERMAC @"routerMAC" //路由访问的MAC
#define BOUNDMAC @"boundMAC"  //是否绑定路由
#define ROUTERNAME @"routerName" //路由的名字
#define ISLOGIN @"isLogin" //是否登录业务
#define NETPASSWORD @"netPassword" //网络密码
#define ISNET @"isNet" //是否安全上网
#define USERDATA @"userData" //保存用户日记
#define ISCONNECT @"isConnect" //是否连接当前路由
#define ISHDPICTURE @"isHDPicture" //是否为高清图片
#define ISLOADING @"isLoading" //是否有引导


//自定义Log
#ifdef DEBUG
#define PSLog(...) NSLog(__VA_ARGS__)
#else
#define PSLog(...)
#endif

#define PSNotificationCenter [NSNotificationCenter defaultCenter]

#endif





