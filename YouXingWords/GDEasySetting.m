//
//  GDEasySetting.m
//  YouXingWords
//
//  Created by Apple on 2017/3/23.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "GDEasySetting.h"

@implementation GDEasySetting
+(instancetype)share{
    static  GDEasySetting * g = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g= [[GDEasySetting alloc] init];
    });
    
    
    
    return g;
}

- (NSInteger)PassSuccessCount{
    NSNumber * count = [[NSUserDefaults standardUserDefaults] objectForKey:@"PassSuccessAfterQsIndex"];
    
    if ([count integerValue] != 1) {
        count = @(99999);
    }
    
    return [count integerValue];
}



@end
