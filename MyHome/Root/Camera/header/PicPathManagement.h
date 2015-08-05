//
//  PicPathManagement.h
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathSelectResultProtocol.h"
#import "PicPathDBUtils.h"

@interface PicPathManagement : NSObject<PathSelectResultProtocol>{
    NSMutableArray *IDArray;
    
    PicPathDBUtils *picPathDBUtil;

}

- (BOOL) InsertPicPath: (NSString*)did PicDate: (NSString*)strDate PicPath: (NSString*)strPath ;
- (BOOL) RemovePicPath: (NSString*)did PicDate: (NSString*)strDate PicPath: (NSString*)strPath ;
- (BOOL) RemovePicPathByID : (NSString*) did ;

- (NSMutableArray*) GetTotalPicDataArray: (NSString*) did;
- (NSMutableArray*) GetTotalPathArray: (NSString*)did date:(NSString*)date;

- (NSInteger) GetTotalNumByID: (NSString*) strDID;
- (NSInteger) GetTotalNumByIDAndDate: (NSString*) strDID Date: (NSString*)strDate;
- (NSString*) GetFirstPathByID: (NSString*) strDID;
- (NSString*) GetFirstPathByIDAndDate: (NSString*) strDID Date: (NSString*)strDate;
-(NSDictionary *) GetPicCountAndFirstPicByID:(NSString *)strDID;
-(void)updateImgByDID:(UIImage *)myImg DID:(NSString *)did;

-(void)reSelectAll;
@end
