//
//  NetWorkingUtils.h
//  YouXingWords
//
//  Created by : on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

typedef void(^responseSuccess)(id response);
typedef void(^responseprogress)(id response);
typedef void(^responseError)(NSError *error);

typedef void(^reachable)();
typedef void(^unreachable)();

#import <UIKit/UIKit.h>
#import "AnswerTools.h"


@interface NetWorkingUtils : NSObject

@property (nonatomic,retain) AFHTTPSessionManager *mgr;
@property (strong)Reachability *netReach;

/**
 *  AFNget方法封装
 *
 *  @param url           接口地址
 *  @param params        请求参数
 *  @param successResult 成功结果
 *  @param errorResult   失败结果
 */
+(void)getWithUrl:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult;
/**
 *  AFNpost方法封装
 *
 *  @param url           接口地址
 *  @param params        请求参数
 *  @param successResult 成功结果
 *  @param errorResult   失败结果
 */
+(void)postWithUrl:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult;

+(NSURLSessionDataTask *)getRarWithUrl:(NSString *)url params:(NSDictionary *)params progressResult:(responseprogress)progress successResult:(responseSuccess)successResult errorResult:(responseError)errorResult;
/**
 *  无等待视图的AFNpost方法封装
 *
 *  @param url           接口地址
 *  @param params        请求参数
 *  @param successResult 成功结果
 *  @param errorResult   失败结果
 */
+(void)postWithUrlWithoutHUD:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult;
+(void)networkReachable:(reachable)reachable AndUnreachable:(unreachable)unreachable;


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)uploadBarrierInfoPassfail:(BOOL)notPass passId:(NSNumber *)passId passTime:(NSNumber *)passTime currentVC:(UIViewController *)currentVC ;
+(void)uploadBarrierInfoPassfail:(BOOL)notPass passId:(NSNumber *)passId passTime:(NSNumber *)passTime currentVC:(UIViewController *)currentVC With:(BreakthroughType)type;
//end

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)requestNoteBook;
+ (void)requestNoteBookWith:(BreakthroughType)type;
//end



@end
