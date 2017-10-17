//
//  NetworkHelper.m
//  YouXingWords
//
//  Created by wangliang on 2016/12/1.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NetworkHelper.h"

typedef void(^NetworkStatusBlock)(void);

@interface NetworkHelper ()

{
    AFNetworkReachabilityManager *manager;
}

@end

@implementation NetworkHelper

+(instancetype)share{
    static NetworkHelper * n = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        n = [[NetworkHelper alloc] init];
    });
    return n;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentNetWorkStatus = AFNetworkReachabilityStatusNotReachable;
    }
    return self;
}



-(void)networkStatusChangedBlock:(NetWorkChangedBlock)block{
    //创建网络监听管理者对象
    manager = [AFNetworkReachabilityManager sharedManager];
    
    //开始监听
    [manager startMonitoring];
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                _currentNetWorkStatus = AFNetworkReachabilityStatusUnknown;
                if (block) {
                    block(AFNetworkReachabilityStatusUnknown);
                }
                NSLog(@"gd_未识别的网络");
                break;

            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"gd_不可达的网络(未连接)");
                _currentNetWorkStatus = AFNetworkReachabilityStatusNotReachable;
                if (block) {
                    block(AFNetworkReachabilityStatusNotReachable);
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"gd_2G,3G,4G...的网络");
                _currentNetWorkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                if (block) {
                    block(AFNetworkReachabilityStatusReachableViaWWAN);
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"gd_wifi的网络");
                _currentNetWorkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                if (block) {
                    block(AFNetworkReachabilityStatusReachableViaWiFi);
                }
                break;
            default:
                break;
        }
    }];
    
}



@end
