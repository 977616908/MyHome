//
//  AFHTTPCilent.m
//  FlowTT_Home
//
//  Created by Harvey on 14-4-29.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "AFHTTPCilent.h"

@interface AFHTTPCilent ()
{
    AFHTTPRequestOperation      *_requestOperation;
    NSMutableURLRequest         *_mRequest;
    AFNetworkReachabilityStatus _status;
}

@end

@implementation AFHTTPCilent

- (id)initWithURL:(NSString *)url path:(NSString *)path mark:(NSString *)mark
{
    self = [super init];
    if (self) {
//        [self netWorkState];
        self.url = url;
        self.mark = mark;
        self.path = path;
    }
    return self;
}

#pragma mark 判断网络
-(void)netWorkState{
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        _status=status;
    //    }];
    NSURL *baseURL = [NSURL URLWithString:@"http://example.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _status=status;
    }];
    //开始监控
    [manager.reachabilityManager startMonitoring];
}

- (void)startAsynRequest
{
    __weak typeof(self) weakSelf = self;
    NSString *wholeURL = _url;
    if (_path.length) {
        wholeURL = [NSString stringWithFormat:@"%@/%@",wholeURL,_path];
    }
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */

//    if (_status==AFNetworkReachabilityStatusNotReachable) {
//        NSDictionary *error=@{@"statue":@(AFNetworkReachabilityStatusNotReachable),@"error":@"网络未连接"};
//        [weakSelf.delegate handleRequestFail:[NSError errorWithDomain:@"error" code:AFNetworkReachabilityStatusNotReachable userInfo:error] mark:[weakSelf.mark copy]];
//        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
//    }else if(_status==AFNetworkReachabilityStatusReachableViaWWAN&&[wholeURL hasPrefix:ROUTINGIP]){
//        NSDictionary *error=@{@"statue":@(AFNetworkReachabilityStatusNotReachable),@"error":@"网络访问出错"};
//        [weakSelf.delegate handleRequestFail:[NSError errorWithDomain:@"error" code:AFNetworkReachabilityStatusReachableViaWWAN userInfo:error] mark:[weakSelf.mark copy]];
//        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
//    }else{
        AFHTTPRequestSerializer *_requestSerializer = [AFHTTPRequestSerializer serializer];
        NSError *myError=nil;
        _mRequest=[_requestSerializer requestWithMethod:_method URLString:wholeURL parameters:_paras error:&myError];
        [_mRequest setTimeoutInterval:5];
        _requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:_mRequest];
        _requestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
        //_requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        
        [_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf.delegate handleRequestOK:[responseObject objectFromJSONData] mark:[weakSelf.mark copy]];
            [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary *errorParam=@{@"statue":@(AFNetworkReachabilityStatusUnknown),@"error":@"网络异常"};
            [weakSelf.delegate handleRequestFail:[NSError errorWithDomain:@"error" code:error.code userInfo:errorParam] mark:[weakSelf.mark copy]];
            [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
        }];
        [_requestOperation start];
//    }
}


-(void)sendRequestMethod:(id)obj{
    [self.delegate handleRequestFail:obj mark:[self.mark copy]];
    [self.delegate removeRequestFromSetWithMark:[self.mark copy]];
}

-(void)startAsynRequests{
    __weak typeof(self) weakSelf=self;
    AFHTTPRequestSerializer *requestSerializer=[AFHTTPRequestSerializer serializer];
    NSString *wholeURL = _url;
    if (_path.length) {
        
        wholeURL = [NSString stringWithFormat:@"%@/%@",wholeURL,_path];
    }
//    _mRequest=[requestSerializer requestWithMethod:_method URLString:wholeURL parameters:_paras];
    NSError *error=nil;
    _mRequest=[requestSerializer requestWithMethod:_method URLString:wholeURL parameters:_paras error:&error];
    [_mRequest setTimeoutInterval:REQUESTTIMEOUT];
    PSLog(@"失败：%@",error);
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _requestOperation=[manager HTTPRequestOperationWithRequest:_mRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.delegate handleRequestOK:[responseObject objectFromJSONData] mark:[weakSelf.mark copy]];
        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.delegate handleRequestFail:[error copy] mark:[weakSelf.mark copy]];
        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
    }];
    [_requestOperation start];
//    [manager GET:wholeURL parameters:_paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [weakSelf.delegate handleRequestOK:[responseObject objectFromJSONData] mark:[weakSelf.mark copy]];
//        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf.delegate handleRequestFail:[error copy] mark:[weakSelf.mark copy]];
//        [weakSelf.delegate removeRequestFromSetWithMark:[weakSelf.mark copy]];
//    }];
}


- (void)cancelRequest
{
    if (_requestOperation.isFinished^1) {
    
        [_requestOperation cancel];
    }
}

- (BOOL)canChangeParam
{
    if ([_requestOperation isExecuting] || [_requestOperation isFinished]) {
        
        return NO;
    }
    return YES;
}

- (BOOL)isExecuting
{
    return _requestOperation.isExecuting;
}

- (BOOL)isFinished
{

    return _requestOperation.isFinished;
}

@end
