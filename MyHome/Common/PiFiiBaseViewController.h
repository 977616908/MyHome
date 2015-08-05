//
//  PiFiiBaseViewController.h
//  FlowTT_Home
//
//  Created by Harvey on 14-4-21.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPCilent.h"

@protocol PiFiiBaseViewDelegate <NSObject>

@optional
-(void)pushViewDataSource:(id)dataSource;

-(void)removeViewDataSources:(id)dataSource;

@end


@interface PiFiiBaseViewController : CCViewController<AFHTTPCilentDelegate>
/**
 *  设置navigationBar底部分割线的颜色
 */
@property (nonatomic,strong) UIColor *navigationBarButtomLineColor;
@property (nonatomic,assign,getter=isCustomAnimation) BOOL customAnimation;
@property (nonatomic,assign,getter=isCustomSet)BOOL customSet;
@property (nonatomic,weak)id<PiFiiBaseViewDelegate> pifiiDelegate;
/**
 *  设置自定义对话框
 */
-(void)coustomNav;

#pragma mark -new method for request
/**
 *  初始化post请求
 *
 *  @param path        method
 *  @param paras       参数列表
 *  @param mark        请求标志, mark用于区别返回的数据, 在同一控制器不允许存在相同的mark,否则在同时发出多个请求的情况下可能获得不正确数据
 *  @param autoRequest 该值如果为YES,初始化完就自动发出请求; 为NO则不自动发请求, 需要手动触发请求
 */
- (void)initPostWithPath:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark autoRequest:(BOOL)autoRequest;
- (void)initPostWithURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark  autoRequest:(BOOL)autoRequest;

/**
 *  初始化get请求
 *
 *  @param path        method
 *  @param paras       参数列表
 *  @param mark        请求标志, mark用于区别返回的数据, 在同一控制器不允许存在相同的mark,否则在同时发出多个请求的情况下可能获得不正确数据
 *  @param autoRequest 该值如果为YES,初始化完就自动发出请求; 为NO则不自动发请求, 需要手动触发请求
 */
- (void)initGetWithPath:(NSString *)path paras:(NSDictionary *)paras  mark:(NSString *)mark  autoRequest:(BOOL)autoRequest;
- (void)initGetWithURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras mark:(NSString *)mark  autoRequest:(BOOL)autoRequest;

///// 开始异步某个请求
- (void)startAsynRequestWihtMark:(NSString *)mark;

// 中断某个请求
- (void)cancelRequestWihtMark:(NSString *)mark;

///// 请求数据成功后, 在此函数处理返回数据
//- (void)handleRequestOK:(id)response mark:(NSString *)mark;

///// 请求数据失败后, 在此函数处理失败数据
//- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark;

/**
 *  设置请求参数
 *
 *  @param param 可选类型为(NSString *)或(NSDictionary *), 当为(NSDictionary *)时, value无效
 *  @param value 当param为(NSString *)时, 注意设置value
 *  @param mark  请求标志
 */
- (void)setRequestParam:(id)param value:(id)value mark:(NSString *)mark;

/**
 *  移除请求参数(没有开始的请求起作用)
 *
 *  @param key  参数名
 *  @param mark 请求标志
 */
- (void)removeRequestParamWithKey:(NSString *)key mark:(NSString *)mark;

- (void)removeNavigationBarButtomLine;
//- (void)loadCoustomSetting;
- (void)exitCurrentController;

/**
 * 判断是否绑定与连接PIFii路由
 */
-(BOOL)setMacBounds;

/* 显示信息 */
-(void)showToast:(NSString *)msg Long:(NSInteger)duration;

/**
 * 清理缓存
 */
-(void) clearWebViewWithCookie;

/**
 * 清理图片缓存
 */
-(void)clearImageWithCookie;

/**
 * 自定义动画
 */
-(CATransition *)customAnimation:(UIView *)viewNum upDown:(BOOL )boolUpDown;

#pragma mark -后续判断
- (BOOL)isDocumentWithFileSuffix:(NSString *)suffix;
- (BOOL)isMusicWithFileSuffix:(NSString *)suffix;
- (BOOL)isVideoWithFileSuffix:(NSString *)suffix;
- (BOOL)isImageWithFileSuffix:(NSString *)suffix;

@end


