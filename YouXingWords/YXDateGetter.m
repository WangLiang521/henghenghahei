//
//  YXDateGetter.m
//  YouXingWords
//
//  Created by tih on 16/10/31.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "YXDateGetter.h"

@implementation YXDateGetter
+(NSInteger *)getDayToday{
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:now];
    NSInteger day = [dateComponent day];
    return day;
}
+(NSString *)getTimestamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]];
    return timeSp;
}
@end
