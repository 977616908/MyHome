//
//  CameraList.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraListMgt.h"
#import "PPPPDefine.h"


@implementation CameraListMgt

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CameraArray = [[NSMutableArray alloc] init];
        cameraDB = [[CameraDBUtils alloc] init];
        
        cameraDB.selectDelegate = self;
        [cameraDB Open:@"OBJ_P2P_CAMERA_DB" TblName:@"OBJ_P2P_CAMERA_TBL" IPTblName:@"OBJ_ddns_CAMERA_TBL"];
        
        //[cameraDB SelectAll];
        
        m_Lock = [[NSCondition alloc] init];
    }
    
    return self;
}
-(void)selectP2PAll:(BOOL)isP2P{
    
    if (isP2P) {
        [cameraDB SelectAll];
    }else{
        [cameraDB SelectIpAll];
    }
}
-(BOOL)UpdateCameraAuthority:(NSString *)did User:(NSString *)user3 Pwd:(NSString *)pwd3{
    [m_Lock lock];
    //NSLog(@"UpdateCameraAuthority");
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        if ([_did caseInsensitiveCompare:did]==NSOrderedSame) {
            NSString *pwd=[cameraDic objectForKey:@STR_PWD];
            NSString *user=[cameraDic objectForKey:@STR_USER];
            // NSLog(@"UpdateCameraAuthority  user=%@ pwd=%@ user3=%@  pwd3=%@",user,pwd,user3,pwd3);
            
            NSNumber *authority=[NSNumber numberWithBool:NO];
            if (([user3 caseInsensitiveCompare:user]==NSOrderedSame)&&([pwd3 caseInsensitiveCompare:pwd]==NSOrderedSame)) {
                authority=[NSNumber numberWithBool:YES];
            }
            NSString *name=[cameraDic objectForKey:@STR_NAME];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            
            NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            
            
            
            NSDictionary *dic=[[NSDictionary alloc ]initWithObjectsAndKeys:name,@STR_NAME,user,@STR_USER,pwd,@STR_PWD,nPPPPStatus,@STR_PPPP_STATUS,nPPPPMode,@STR_PPPP_MODE,authority,@STR_AUTHORITY,_did,@STR_DID,img,@STR_IMG, nil] ;
            
            [CameraArray replaceObjectAtIndex:i withObject:dic];
//            [dic release];
            
            [m_Lock unlock];
            
            return YES;
        }
        
    }
    [m_Lock lock];
    return NO;
    
}
- (BOOL)AddIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd{
    
    [m_Lock lock];
    
    if ([self CheckCameraIp:ip]==NO) {
        [m_Lock unlock];
        
        return NO;
    }
    NSNumber *authority=[NSNumber numberWithBool:NO];
    NSMutableDictionary *ipCameraDic=[[NSMutableDictionary alloc]init];
    [ipCameraDic setObject:ip forKey:@STR_IPADDR];
    [ipCameraDic setObject:port forKey:@STR_PORT];
    [ipCameraDic setObject:name forKey:@STR_NAME];
    [ipCameraDic setObject:user forKey:@STR_USER];
    [ipCameraDic setObject:pwd forKey:@STR_PWD];
    [ipCameraDic setObject:authority forKey:@STR_AUTHORITY];
    if (NO == [cameraDB InsertIpCamera:name Ip:ip Port:port User:user Pwd:pwd])
    {
        
        // NSLog(@"cameraDB InsertCamera return NO");
        if (NO == [cameraDB InsertIpCamera:name Ip:ip Port:port User:user Pwd:pwd])
        {
//            [ ipCameraDic release];
            [m_Lock unlock];
            return NO;
        }
        
    }
    
    [CameraArray addObject:ipCameraDic];
//    [ipCameraDic release];
    [m_Lock unlock];
    return YES;
}
- (BOOL)AddCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Snapshot:(UIImage *)img
{
    [m_Lock lock];
    NSLog(@"CameraListMgt  Add Camera...name:%@, did: %@, user: %@, pwd: %@ ", name, did, user, pwd);
    if ([self CheckCamere:did] == NO) {
        [m_Lock unlock];
        NSLog(@"已经存在did=%@",did);
        return NO;
    }
    
    NSNumber *authority=[NSNumber numberWithBool:NO];
    NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
    NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
    NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                               did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD,// img,@STR_IMG,
                               nPPPPStatus, @STR_PPPP_STATUS,
                               nPPPPMode, @STR_PPPP_MODE,authority,@STR_AUTHORITY,nil];
    
    if (NO == [cameraDB InsertCamera:name DID:did User:user Pwd:pwd ])
    {
        NSLog(@"cameraDB InsertCamera return NO");
        if (NO == [cameraDB InsertCamera:name DID:did User:user Pwd:pwd ])
        {
            [m_Lock unlock];
            return NO;
        }
        
    }
    
    [CameraArray addObject:cameraDic];
    [m_Lock unlock];
    return YES;
}

- (BOOL)EditIpCamera:(NSString *)oldip Name:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd{
    [m_Lock lock];
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSMutableDictionary *ipCamDic=(NSMutableDictionary *)[CameraArray objectAtIndex:i];
        NSString *_ip=[ipCamDic objectForKey:@STR_IPADDR];
        NSNumber *authority=[NSNumber numberWithBool:NO];
        if ([_ip caseInsensitiveCompare:oldip]==NSOrderedSame) {
            [ipCamDic removeAllObjects];
            
            [ipCamDic setObject:ip forKey:@STR_IPADDR];
            [ipCamDic setObject:port forKey:@STR_PORT];
            [ipCamDic setObject:name forKey:@STR_NAME];
            [ipCamDic setObject:user forKey:@STR_USER];
            [ipCamDic setObject:pwd forKey:@STR_PWD];
            [ipCamDic setObject:authority forKey:@STR_AUTHORITY];
            [cameraDB UpdateIpCamera:name Ip:ip Port:port User:user Pwd:pwd OldIp:oldip];
            [m_Lock unlock];
            return YES;
        }
    }
    [m_Lock unlock];
    return NO;
}
- (BOOL) EditCamera:(NSString *)olddid Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd
{
    [m_Lock lock];
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:olddid] == NSOrderedSame)
        {
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
            NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
            NSNumber *authority=[NSNumber numberWithBool:NO];
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                                        did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD,
                                        nPPPPStatus, @STR_PPPP_STATUS,
                                        nPPPPMode, @STR_PPPP_MODE,
                                        authority,@STR_AUTHORITY,img, @STR_IMG, nil];
            
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [cameraDB UpdateCamera:name DID:did User:user Pwd:pwd OldDID:olddid];
            
            [m_Lock unlock];
            return YES;
        }
        
    }
    
    [m_Lock unlock];
    return NO;
}
-(NSInteger) UpdateIpCameraImage:(NSString *)ip Image:(UIImage *)img{
    [m_Lock lock];
    if (img == nil) {
        [m_Lock unlock];
        return NO;
    }
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSMutableDictionary *ipDic=(NSMutableDictionary *)[CameraArray objectAtIndex:i];
        NSString *_ip=[ipDic objectForKey:@STR_IPADDR];
        if ([_ip caseInsensitiveCompare:ip]==NSOrderedSame) {
            [ipDic removeObjectForKey:@STR_IMG];
            [ipDic setObject:img forKey:@STR_IMG];
            [m_Lock unlock];
            return i;
        }
    }
    [m_Lock unlock];
    return -1;
}
- (NSInteger) UpdateCamereaImage:(NSString *)did Image:(UIImage *)img
{
    //NSLog(@"UpdateCamereaImage====888888888888888");
    [m_Lock lock];
    if (img == nil) {
        [m_Lock unlock];
        return NO;
    }
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            NSNumber *PPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            NSNumber *PPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME,
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD,
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
            [m_Lock unlock];
            return i;
        }
    }
    
    [m_Lock unlock];
    
    return -1;
}
- (NSInteger) UpdatePPPPMode:(NSString *)did mode:(int)mode
{
    [m_Lock lock];
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *PPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
            NSNumber *PPPPMode = [[NSNumber alloc] initWithInt:mode];//[NSNumber numberWithInt:mode];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME,
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD,
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
//            [PPPPMode release];
            [m_Lock unlock];
            return i;
        }
        
    }
    
    [m_Lock unlock];
    return -1;
}

- (NSInteger) UpdatePPPPStatus:(NSString *)did status:(int)status
{
    [m_Lock lock];
    
    //NSLog(@"UpdatePPPPStatus ... did: %@, status: %d", did, status);
    
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            NSString *_name = [cameraDic objectForKey:@STR_NAME];
            NSString *_user = [cameraDic objectForKey:@STR_USER];
            NSString *_pwd = [cameraDic objectForKey:@STR_PWD];
            UIImage *img = [cameraDic objectForKey:@STR_IMG];
            NSNumber *PPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
            NSNumber *PPPPStatus = [[NSNumber alloc] initWithInt:status];//[NSNumber numberWithInt:status];
            
            NSDictionary *_cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:_name, @STR_NAME,
                                        _did, @STR_DID, _user ,@STR_USER, _pwd,@STR_PWD,
                                        PPPPStatus, @STR_PPPP_STATUS,
                                        PPPPMode, @STR_PPPP_MODE,
                                        img, @STR_IMG, nil];
            [CameraArray replaceObjectAtIndex:i withObject:_cameraDic];
//            [PPPPStatus release];
            [m_Lock unlock];
            return i;
        }
        
    }
    [m_Lock unlock];
    return -1;
}
- (BOOL) RemoveIpCamera:(NSString *)ip{
    [m_Lock lock];
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_ip = [cameraDic objectForKey:@STR_IPADDR];
        
        if ([_ip caseInsensitiveCompare:ip] == NSOrderedSame)
        {
            [CameraArray removeObjectAtIndex:i];
            
            [cameraDB RemoveCameraByIp:_ip];
            [m_Lock unlock];
            return YES;
        }
        
    }
    [m_Lock unlock];
    return NO;
}
- (BOOL) RemoveCamerea:(NSString *)did
{
    [m_Lock lock];
    int count = [self GetCount];
    int i;
    for ( i=0; i < count ; i++)
    {
        NSDictionary *cameraDic = [CameraArray objectAtIndex:i];
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame)
        {
            [CameraArray removeObjectAtIndex:i];
            [cameraDB RemoveCamera:_did];
            [m_Lock unlock];
            return YES;
        }
        
    }
    [m_Lock unlock];
    return NO;
}

- (NSDictionary*) GetCameraAtIndex:(NSInteger)index
{
    [m_Lock lock];
    if (index >= CameraArray.count)
    {
        [m_Lock unlock];
        return nil;
    }
    
    NSDictionary *cameraDic = [CameraArray objectAtIndex:index];
    
    
//    [cameraDic retain];
//    [cameraDic autorelease];
    [m_Lock unlock];
    return cameraDic;
}

-(int)GetCameraIndex:(NSString *)did{
    [m_Lock lock];
    for (int i = 0; i < CameraArray.count; i++) {
        if ([[[CameraArray objectAtIndex:i] objectForKey:@STR_DID] isEqualToString:did]) {
            [m_Lock unlock];
            return i;
        }
    }
    [m_Lock unlock];
    return 0;
}

- (NSMutableDictionary *)GetIpCameraAtIndex:(NSInteger)index{
    [m_Lock lock];
    if (index >= CameraArray.count)
    {
        [m_Lock unlock];
        return nil;
    }
    
    NSMutableDictionary *cameraDic = (NSMutableDictionary *)[CameraArray objectAtIndex:index];
    
    
//    [cameraDic retain];
//    [cameraDic autorelease];
    [m_Lock unlock];
    return cameraDic;
}

- (int) GetCount
{
    return CameraArray.count;
}

- (BOOL) CheckCamere:(NSString *)did
{
    for (NSDictionary *cameraDic in CameraArray)
    {
        NSString *_did = [cameraDic objectForKey:@STR_DID];
        
        if ([_did caseInsensitiveCompare:did] == NSOrderedSame )
        {
            return NO;
        }
    }
    return YES;
}
-(BOOL)CheckCameraIp:(NSString *)ip{
    
    for (NSMutableDictionary *cameraDic in CameraArray)
    {
        
        NSString *_ip = [cameraDic objectForKey:@STR_IPADDR];
        
        if ([_ip caseInsensitiveCompare:ip] == NSOrderedSame )
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) RemoveCameraAtIndex:(NSInteger) index
{
    if (index > [self GetCount])
    {
        return NO;
    }
    
    NSDictionary *cameraDic = [CameraArray objectAtIndex:index];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    
    //NSLog(@"RemoveCameraAtIndex.. addr: %@, port:%@", addr, port);
    [cameraDB RemoveCamera:did];
    [CameraArray removeObjectAtIndex:index];
    
    return YES;
}
-(BOOL) RemoveIpCameraAtIndex:(NSInteger)index{
    if (index > [self GetCount])
    {
        return NO;
    }
    
    NSMutableDictionary *cameraDic = (NSMutableDictionary *)[CameraArray objectAtIndex:index];
    NSString *ip = [cameraDic objectForKey:@STR_IPADDR];
    
    [cameraDB RemoveCameraByIp:ip];
    
    [CameraArray removeObjectAtIndex:index];
    
    return YES;
}
- (UIImage*) GetCameraSnapshotImage: (NSString*) strDID
{
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *imgRead = [UIImage imageWithContentsOfFile:strPath];
    
    return imgRead;
}

#pragma mark -
#pragma mark DBSelectResultDelegate

- (void)SelectP2PResult:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd
{
    NSLog(@"SelectP2PResult....name: %@, did: %@, user: %@, pwd: %@", name, did, user, pwd);
    
    NSNumber *nPPPPStatus = [NSNumber numberWithInt:PPPP_STATUS_UNKNOWN];
    NSNumber *nPPPPMode = [NSNumber numberWithInt:PPPP_MODE_UNKNOWN];
    
    //UIImage *img = nil;
    NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @STR_NAME,
                               did, @STR_DID, user ,@STR_USER, pwd,@STR_PWD, //img, @STR_IMG,
                               nPPPPStatus, @STR_PPPP_STATUS,
                               nPPPPMode, @STR_PPPP_MODE,nil];
    
    [CameraArray addObject:cameraDic];
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [self GetCameraSnapshotImage:did];
    if (image != nil) {
        [self UpdateCamereaImage:did Image:image];
    }
//    [pool release];
    
}
-(void)SelectDDNSResult:(NSString *)name IP:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd{
    NSLog(@"SelectDDNSResult....name: %@, ip: %@, port: %@  user: %@, pwd: %@", name, ip,port, user, pwd);
    
    NSMutableDictionary *ipDic=[[NSMutableDictionary alloc]init];
    [ipDic setObject:name forKey:@STR_NAME];
    [ipDic setObject:ip forKey:@STR_IPADDR];
    [ipDic setObject:port forKey:@STR_PORT];
    [ipDic setObject:user forKey:@STR_USER];
    [ipDic setObject:pwd forKey:@STR_PWD];
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [self GetCameraSnapshotImage:ip];
    if (image != nil) {
        [ipDic setObject:image forKey:@STR_IMG];
    }
//    [pool release];
    
    
    [CameraArray addObject:ipDic];
//    [ipDic release];
}
- (void)dealloc
{
//    [CameraArray release];
    CameraArray = nil;
    [cameraDB Close];
//    [cameraDB release];
    cameraDB = nil;
//    [super dealloc];
}

@end
