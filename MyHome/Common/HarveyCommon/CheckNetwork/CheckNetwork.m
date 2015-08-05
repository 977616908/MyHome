//
//  CheckNetwork.m
//  iphone.network1
//
//  Created by wangjun on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

#define TEST_HOMEHOST @"www.apple.com"

@implementation CheckNetwork:NSObject

+(BOOL)isExistenceNetwork
{
    return [CheckNetwork checkExistenceNetworkWithAlert:YES];
}

+(BOOL)isExistenceNetworkNoAlert
{
	return [CheckNetwork checkExistenceNetworkWithAlert:NO];
}

+ (BOOL)checkExistenceNetworkWithAlert:(BOOL)alert
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:TEST_HOMEHOST];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
			   PSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
			   PSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
			 PSLog(@"正在使用wifi网络");
            break;
    }
	if (!isExistenceNetwork && alert) {
		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未连接到网络,当前使用的是数据库中的数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
		[myalert show];
	}
	return isExistenceNetwork;
}
@end
