//
//  CountBytes.m
//  YouXingWords
//
//  Created by tih on 16/11/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "CountBytes.h"

@implementation CountBytes
+(NSString *)countBytesBy:(NSInteger)bytes{
    NSString *bytesStr = nil;
    if (!(bytes/1024)) {
        bytesStr = [NSString stringWithFormat:@"%dB",bytes];
    }else if(!bytes/1024/1024){
        bytesStr = [NSString stringWithFormat:@"%.2fkb",(float)bytes/1024];
    }else{
        bytesStr = [NSString stringWithFormat:@"%.2fM",(float)bytes/1024/1024];
    }
    return bytesStr;
}
@end
