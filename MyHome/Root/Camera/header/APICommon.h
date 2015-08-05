//
//  APICommon.h
//  P2PCamera
//
//  Created by Tsang on 12-12-11.
//
//

#import <Foundation/Foundation.h>
#import "H264Decoder.h"
#import <UIKit/UIKit.h>
@interface APICommon : NSObject



+ (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) GetImageByNameFromImage: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) YUV420ToImage: (Byte*)yuv width:(int)width height:(int)height;

@end
