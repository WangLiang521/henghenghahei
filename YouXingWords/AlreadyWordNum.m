//
//  AlreadyWordNum.m
//  YouXingWords
//
//  Created by tih on 16/11/1.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "AlreadyWordNum.h"

@implementation AlreadyWordNum
+(void)handleWithNumber:(NSNumber *)num{
    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]];
    //创建文件
    NSString *basePath =[NSHomeDirectory() stringByAppendingPathComponent:str];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:str isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *datePath = [NSString stringWithFormat:@"%@/%@",basePath,@"dateToday.plist"];
    NSString *path = [NSString stringWithFormat:@"%@/%@",basePath,@"alreadyWords.plist"];
//
//    if ([fm fileExistsAtPath:datePath]) {
//        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:datePath];
//        if (![[dic valueForKey:@"day"]isEqualToNumber:@([self getDayToday])]) {
//            @try {
//                [fm removeItemAtPath:path error:nil];
//
//            }
//            @catch (NSException *exception) {
//                
//            }
//            @finally {
//                NSDictionary *dic = @{@"day":@([self getDayToday])};
//                [dic writeToFile:datePath atomically:NO];
//            }
//        }
//    }else{
//        [fm removeItemAtPath:path error:nil];
//
//        NSDictionary *dic = @{@"day":@([self getDayToday])};
//        [dic writeToFile:datePath atomically:NO];
//    }
//    
    
    
    NSMutableArray *alreadyWords;
    if ([fm fileExistsAtPath:path]) {
        alreadyWords = [NSMutableArray arrayWithContentsOfFile:path];

    }else{
        alreadyWords = [NSMutableArray array];
    }
//    NSMutableArray *alreadyWords = [NSMutableArray arrayWithContentsOfFile:path];
    if (alreadyWords) {
        BOOL alreadyHave=NO;
        for (int i=0; i<alreadyWords.count; i++) {
            if ([num isEqualToNumber:alreadyWords[i]]) {
                alreadyHave =YES;
                break;
            }else{
                continue;
            }
        }
        if (!alreadyHave) {
            [alreadyWords addObject:num];
            [alreadyWords writeToFile:path atomically:NO];
        }

    }

}
+(NSInteger)getAlreadyNum{
    
    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]];
    //创建文件
    NSString *basePath =[NSHomeDirectory() stringByAppendingPathComponent:str];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:str isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *datePath = [NSString stringWithFormat:@"%@/%@",basePath,@"dateToday.plist"];
    NSString *path = [NSString stringWithFormat:@"%@/%@",basePath,@"alreadyWords.plist"];
    
    if ([fm fileExistsAtPath:datePath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:datePath];
        if (![[dic valueForKey:@"day"]isEqualToNumber:@([self getDayToday])]) {
            @try {
                [fm removeItemAtPath:path error:nil];
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                NSDictionary *dic = @{@"day":@([self getDayToday])};
                [dic writeToFile:datePath atomically:NO];
            }
        }
    }else{
        [fm removeItemAtPath:path error:nil];
        
        NSDictionary *dic = @{@"day":@([self getDayToday])};
        [dic writeToFile:datePath atomically:NO];
    }

    
    
    
    
    
    

    NSMutableArray *alreadyWords = [NSMutableArray arrayWithContentsOfFile:path];
    
    
    
    if (alreadyWords) {
        return alreadyWords.count;
    }
    return 0;
}

+(NSInteger )getDayToday{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    NSInteger unitFlags =NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    now= [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger dat =[ comps day];
    return dat;
    
}
@end
