//
//  NetworkHelper.h
//  YouXingWords
//
//  Created by wangliang on 2016/12/1.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^NetWorkChangedBlock)(AFNetworkReachabilityStatus status);


@interface NetworkHelper : NSObject

@property (assign, nonatomic)  AFNetworkReachabilityStatus currentNetWorkStatus;


+(instancetype)share;

-(void)networkStatusChangedBlock:(NetWorkChangedBlock)block;




@end
