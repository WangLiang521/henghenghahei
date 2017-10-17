//
//  TimerTools.m
//  YouXingWords
//
//  Created by tih on 16/8/31.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TimerTools.h"

@implementation TimerTools

static TimerTools * _instance = nil;

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

+(void)timerAdd{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/timer.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
        NSString *str=@"0";
        [str writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        @try {
            NSString *numStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSInteger numInt = [numStr integerValue];
            numInt++;
            numStr = [NSString stringWithFormat:@"%lu",numInt];
            [numStr writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
    
}
+(void)clear{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/timer.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSString *str=@"0";
        [str writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}


+(NSString *)getTime{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/timer.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSString *numStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return numStr;
    }
    return nil;

}


#define LGDStudyTime [NSString stringWithFormat:@"LGDStudyTime%@",[Utils getCurrentUserName]]

+(void)reSaveTimeNew{
    
    //start
#pragma mark gd_  2017-03-14 09:54:45
//    NSString * studyTime = [self getTime];
//    
//    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
//    [userD setObject:studyTime forKey:LGDStudyTime];
//    [userD synchronize];
    
    
    NSString * studyTime = [self getTime];
    [self clear];
    NSString * newStudyTime = [self getStudyTimeNew];
    NSString * totalStudyTime = [NSString stringWithFormat:@"%zd",[studyTime integerValue] + [newStudyTime integerValue]];
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:totalStudyTime forKey:LGDStudyTime];
    [userD synchronize];
    //end
    
    
}

+ (NSString *)getStudyTimeNew{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSString * studyTime = [userD objectForKey:LGDStudyTime];
//    [userD setObject:nil forKey:LGDStudyTime];
    return studyTime;
}

+(void)clearStudyTimeNew{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:@"0" forKey:LGDStudyTime];
    [self clear];
    [userD synchronize];
}


@end
