//
//  GDWXApiManager.m
//  LuoKeLock
//
//  Created by Apple on 2017/3/24.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "GDWXApiManager.h"

@interface GDWXApiManager ()
@property (copy, nonatomic)  void(^block)(int code);
@end

@implementation GDWXApiManager

+(instancetype)share{
    static GDWXApiManager * m = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[GDWXApiManager alloc] init];
    });
    
    
    return m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)WXPayBlock:(void(^)(int code))completeBlock{
    self.block = completeBlock;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        if (self.block) {
            self.block(resp.errCode);
        }
        
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
    }
    
}




@end
