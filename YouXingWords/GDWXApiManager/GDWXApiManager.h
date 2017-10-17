//
//  GDWXApiManager.h
//  LuoKeLock
//
//  Created by Apple on 2017/3/24.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DefineWeiXinPay
#import "WXApi.h"
#endif

@interface GDWXApiManager : NSObject<WXApiDelegate>

-(void)WXPayBlock:(void(^)(int code))completeBlock;

+(instancetype)share;


@end
