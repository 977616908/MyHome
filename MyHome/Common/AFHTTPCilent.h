//
//  AFHTTPCilent.h
//  FlowTT_Home
//
//  Created by Harvey on 14-4-29.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol AFHTTPCilentDelegate <NSObject>

/// 请求数据成功后, 在此函数处理返回数据
- (void)handleRequestOK:(id)response mark:(NSString *)mark;

/// 请求数据失败后, 在此函数处理失败数据
- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark;

/**
 *  移除完成的请求(失败||成功)在请求组里
 *
 *  @param mark 请求标志
 */
- (void)removeRequestFromSetWithMark:(NSString *)mark;

@end

@interface AFHTTPCilent : NSObject

@property (nonatomic,assign) id<AFHTTPCilentDelegate>     delegate;
@property (nonatomic,strong) NSString                    *mark;// 线程标志
@property (nonatomic,strong) NSMutableDictionary         *paras;
@property (nonatomic,strong) NSString                    *method;
@property (nonatomic,strong) NSString                    *path;
@property (nonatomic,strong) NSString                    *url;

- (id)initWithURL:(NSString *)url path:(NSString *)path mark:(NSString *)mark;

/// 开始异步请求
- (void)startAsynRequest;

/// 中断请求
- (void)cancelRequest;

/**
 *  是否可更改请求参数, 已经完成(或正在执行)的请求不允许更改
 */
- (BOOL)canChangeParam;

- (BOOL)isExecuting;

- (BOOL)isFinished;

@end
