//
//  CommonShare.m
//  YouXingWords
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "CommonShare.h"

@implementation CommonShare

+(instancetype)share{
    static CommonShare * c = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        c = [[CommonShare alloc] init];
    });
    return c;
}


- (void)setCurrentBookName:(NSString *)currentBookName{
    _currentBookName = currentBookName;
    NSString * key = [NSString stringWithFormat:@"YXCurrentName%@",[Utils getCurrentUserName]];
    [[NSUserDefaults standardUserDefaults] setObject:currentBookName forKey:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * key = [NSString stringWithFormat:@"YXCurrentName%@",[Utils getCurrentUserName]];
        NSString * currentBookName = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if ([LGDUtils isValidStr:currentBookName]) {
            self.currentBookName = currentBookName;
        }
    }
    return self;
}

@end
