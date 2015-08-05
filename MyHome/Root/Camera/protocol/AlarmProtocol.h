//
//  AlarmProtocol.h
//  P2PCamera
//
//  Created by mac on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlarmProtocol <NSObject>

- (void) AlarmProtocolResult:(int)motion_armed 
          motion_sensitivity:(int)motion_sensitivity 
                 input_armed:(int)input_armed 
                  ioin_level:(int)ioin_level 
              alarmpresetsit:(int)alarmpresetsit 
                   iolinkage:(int)iolinkage 
                 ioout_level:(int)ioout_level 
                        mail:(int)mail 
                    snapshot:(int)snapshot 
             upload_interval:(int)upload_interval
                      record:(int)record;


@end