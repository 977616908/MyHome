//
//  APICacheManagement.h
//  FlowTT_Home
//
//  Created by Harvey on 14-4-17.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KAdvantageousCacheKey @"Advantageous" /**<占便宜缓存KEY*/
#define KEarnFlowtCacheKey @"EarnFlow" /**<赚流量缓存KEY*/
#define KEarnFlowtRecoCacheKey @"EarnFlow"


@interface APICacheManagement : NSObject

/// 将接口数据写入缓存, data: 数据, 类型可以是(NSDictionary *),(NSString *),(NSData *), cName: 缓存的名字
+ (void)writeToCacheWithData:(id)data CacheName:(NSString *)cName;

/// 从缓存中读取接口数据, cName: 缓存的名字
+ (NSData *)readCacheWithCacheName:(NSString *)cName;

@end

