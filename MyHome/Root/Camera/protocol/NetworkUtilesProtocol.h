//
//  NetworkUtilesProtocol.h
//  P2PCamera
//
//  Created by Tsang on 13-3-1.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol NetworkUtilesProtocol <NSObject>
-(void)snapShotResult:(NSString *)ip  Img:(UIImage *)img;
@optional
-(void)connectFailed:(NSString *)ip;
-(void)checkUserResult:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd Result:(int)result Type:(int)type;
@end
