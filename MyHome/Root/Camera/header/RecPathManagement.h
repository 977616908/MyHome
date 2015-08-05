//
//  PicPathManagement.h
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathSelectResultProtocol.h"
#import "RecPathDBUtils.h"

@interface RecPathManagement : NSObject<PathSelectResultProtocol>{
    NSMutableArray *IDArray;
    
    RecPathDBUtils *recPathDBUtil;

}

- (BOOL) InsertPath: (NSString*)did Date: (NSString*)strDate Path: (NSString*)strPath ;
- (BOOL) RemovePath: (NSString*)did Date: (NSString*)strDate Path: (NSString*)strPath ;
- (BOOL) RemovePathByID : (NSString*) did ;

- (NSMutableArray*) GetTotalDataArray: (NSString*) did;
- (NSMutableArray*) GetTotalPathArray: (NSString*)did date:(NSString*)date;

- (NSInteger) GetTotalNumByID: (NSString*) strDID;
- (NSInteger) GetTotalNumByIDAndDate: (NSString*) strDID Date: (NSString*)strDate;
- (NSString*) GetFirstPathByID: (NSString*) strDID;
- (NSString*) GetFirstPathByIDAndDate: (NSString*) strDID Date: (NSString*)strDate;

-(NSDictionary *) GetSumAndFirstPicByID:(NSString *)strDID;
-(void) UpdateImageByID:(NSString *)strDID Img:(UIImage *)img;

@end
