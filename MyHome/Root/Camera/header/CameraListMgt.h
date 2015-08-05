//
//  CameraList.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSelectResultProtocol.h"
#import "CameraDBUtils.h"

#import "obj_common.h"


@interface CameraListMgt : NSObject <DBSelectResultProtocol> {
    
    
@private
    NSMutableArray *CameraArray;
    CameraDBUtils *cameraDB;
    
    NSCondition *m_Lock;
    
}

- (void) selectP2PAll:(BOOL)isP2P ;

- (BOOL) AddCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Snapshot:(UIImage *)img ;
- (BOOL)AddIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd;


- (BOOL) EditCamera:(NSString *)olddid Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
- (BOOL) EditIpCamera:(NSString *)oldip Name:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd;

- (NSInteger) UpdateCamereaImage:(NSString *)did Image:(UIImage *)img;
- (NSInteger) UpdateIpCameraImage:(NSString *)ip Image:(UIImage *)img;

- (BOOL) RemoveCamerea:(NSString *)did ;
- (BOOL) RemoveIpCamera:(NSString *)ip;
- (int) GetCount;

-(NSMutableDictionary *)GetIpCameraAtIndex:(NSInteger)index;
- (NSDictionary*) GetCameraAtIndex:(NSInteger) index;
-(int) GetCameraIndex:(NSString *)did;

- (BOOL) RemoveCameraAtIndex:(NSInteger) index;
- (BOOL) RemoveIpCameraAtIndex:(NSInteger) index;

- (BOOL) CheckCamere:(NSString *)did;
-(BOOL)CheckCameraIp:(NSString *)ip;

- (NSInteger) UpdatePPPPStatus: (NSString*) did status:(int)status;
- (NSInteger) UpdatePPPPMode: (NSString*) did mode: (int) mode;
-(BOOL) UpdateCameraAuthority:(NSString *)did User:(NSString *)user3 Pwd:(NSString *)pwd3;

@end
