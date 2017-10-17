//
//  LGDUtils.m
//  EasyWedding
//
//  Created by wangliang on 16/9/6.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "LGDUtils.h"

/**
 *  时间转换是否使用 UTC
 */
#define NeedUTC 0

@interface LGDUtils ()

#pragma mark 定义一些各个项目不同的东西


@end

@implementation LGDUtils

+(NSString*)cleanChinaChar:(NSString*)orignal{
    NSArray * array = @[@".  ",@" ",@"，",@"。",@"！",@" ，",@" 。",@" ！",@"， ",@"。 ",@"！ ",@" ,",@" .",@" !",@", ",@". ",@"! ",@", ",@"  ",@"  ",@"  ",@"  ",@"\n",@"\t",@" ",@"ˈ",@"‘",@"’"];
    NSArray * replc = @[@".",@" ",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@" ",@" ",@" ",@" ",@"",@"",@" ",@"'",@"'",@"'"];
    
    for (int i = 0; i < array.count; i++) {
        orignal = [orignal stringByReplacingOccurrencesOfString:array[i] withString:replc[i]];
    }
    
    
    return orignal;
    
}


#pragma mark-正则表达式验证手机号
+ (BOOL)isValiadateMobile:(NSString *)mobile
{
    NSString * MOBILE = @"^1\\d{10}$";// 正则表达式
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res1 = [regextestmobile evaluateWithObject:mobile];
    if (res1 ) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSMutableAttributedString *)changeToCommonStringByHTMLString:(NSString *)htmlString{
    return [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
}


+(CGFloat)getHeightFromLabel:(UILabel *)label withWidth:(CGFloat)width{

    return [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

+(CGFloat)getWidthFromLabel:(UILabel *)label withHeight:(CGFloat)height{
    
    return [label sizeThatFits:CGSizeMake(height, MAXFLOAT)].width;
}

+(CGFloat)getWidthFromBtn:(UIButton *)btn withHeight:(CGFloat)height{
    
    return [btn sizeThatFits:CGSizeMake(height, MAXFLOAT)].width;
}

+(CGFloat)getHeightFromTextView:(UITextView *)textView withWidth:(CGFloat)width{
    return [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

+ (BOOL)quikTipsWhenTextFieldsNeroWith:(NSArray *)array{
    for (UITextField * textField in array) {
        if (textField.text.length == 0) {
            [MBProgressHUD showError:textField.placeholder];
            return NO;
        }
    }

    return YES;
}

+(NSDate*) convertDateFromString:(NSString*)dateString WithFormatterString:(NSString*)fromatterString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:fromatterString];
    if (NeedUTC) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}



+ (NSString *)stringFromDate:(NSDate *)date WithFormatterString:(NSString*)fromatterString{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (NeedUTC) {
         [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
   
    [dateFormatter setDateFormat:fromatterString];

    NSString *destDateString = [dateFormatter stringFromDate:date];


    return destDateString;
    
}

+(NSDateComponents *)jisuanjiangeWithFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate{
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *serverDate;
    NSDate *endDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&serverDate interval:NULL forDate:fromDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&endDate interval:NULL forDate:toDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:serverDate toDate:endDate options:0];
    return dayComponents;
}

+(NSDateComponents *)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents;
}

//+(NSDate*) convertDateFromString:(NSString*)dateString WithFormatterString:(NSString*)fromatterString
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:fromatterString];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSDate *date=[formatter dateFromString:dateString];
//    return date;
//}

+ (NSString *)getDateToDayFromTimeInt:(long long)timeInt{
    
//    NSString *tempStr = [dateStr substringToIndex:19];
    //    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateFormatter dateFromString:dateStr];
    
//    NSDate *date = [LGDUtils convertDateFromString:tempStr WithFormatterString:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date =[NSDate dateWithTimeIntervalSinceNow:timeInt / 1000.0];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInt / 1000.0];
    date = [LGDUtils getCorrectDate:date];
//    NSDate * dateNow = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger intervalzone = [zone secondsFromGMTForDate: dateNow];
//    NSDate *localeDate = [dateNow  dateByAddingTimeInterval: intervalzone];
    NSDate *localeDate = [LGDUtils getCorrectDate:[NSDate date]];
    NSString *tempStr  = [LGDUtils stringFromDate:date WithFormatterString:@"yyyy-MM-dd HH:mm"];
    NSLog(@"dead = %@",tempStr);
    NSTimeInterval interval = [date timeIntervalSinceDate:localeDate];
    if (interval < 0) {
        tempStr = @"已";
    }else if (interval < 3600) {
        tempStr = [NSString stringWithFormat:@" %lu分钟后",(long)interval/60];
    }else  {
        long hour = (long)interval / 3600;
        long minute = ((long)interval % 3600)/60;
        
        tempStr = [NSString stringWithFormat:@" %lu小时%lu分钟后",hour,minute];
        
        
        //        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)];
    }
//    else if (interval < 3600*24*2) {
//        tempStr = [NSString stringWithFormat:@" %@天后",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
//    }else if (interval < 3600*24*365){
//        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-14, 11)];
//        tempStr  = [tempStr stringByAppendingString:@" "];
//    }else {
//        tempStr = [tempStr substringToIndex:10];
//        tempStr  = [tempStr stringByAppendingString:@" "];
//    }
    tempStr  = [tempStr stringByAppendingString:@"结束"];
    
    return tempStr;
}

+ (NSString *)getDateToDayFromTimeStr:(NSString *)dateStr{
    
    //    NSString *tempStr = dateStr;
    NSString *tempStr = [dateStr substringToIndex:19];
    //    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSDate *date = [LGDUtils convertDateFromString:tempStr WithFormatterString:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * dateNow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervalzone = [zone secondsFromGMTForDate: dateNow];
    NSDate *localeDate = [dateNow  dateByAddingTimeInterval: intervalzone];
    
    
    NSTimeInterval interval = -[date timeIntervalSinceDate:localeDate];
    
    if (interval < 60) {
        tempStr = @"刚刚";
    }else if (interval < 3600) {
        tempStr = [NSString stringWithFormat:@"%lu分钟之前",(long)interval/60];
    }else if (interval < 3600*24) {
        tempStr = [NSString stringWithFormat:@"%lu小时之前",(long)interval / 3600];
        
        //        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)];
    }else if (interval < 3600*24*2) {
        tempStr = [NSString stringWithFormat:@"昨天%@",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
    }else if (interval < 3600*24*365){
        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-14, 11)];
    }else {
        tempStr = [tempStr substringToIndex:10];
    }
    
    return tempStr;
}

+(NSDate * )getCorrectDate:(NSDate *)date{
    if (NeedUTC) {
        NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        return localeDate;
    }else{
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        return localeDate;
    }
    
}


+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval WithFormatterString:(NSString*)fromatterString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
    return [self stringFromDate:confromTimesp WithFormatterString:fromatterString];
}

+(NSString *)getCurrentTimeString13{
    double current = [[NSDate date] timeIntervalSince1970];
    NSString * currentStr = [NSString stringWithFormat:@"%lf",current * 1000];
    if (currentStr && currentStr.length >=13) {
        currentStr = [currentStr substringToIndex:13];
    }
    return currentStr;
}

+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month
{


    NSDateComponents *comps = [[NSDateComponents alloc] init];


    [comps setMonth:month];


    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];


    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];


    
    return mDate;
    
    
}

+ (BOOL) isNilOrNSNull:(id)object {
    return object == nil || [object isKindOfClass:[NSNull class]];
}

+ (BOOL) isNonnull:(id)object{
    return !(object == nil || object == NULL || object == [NSNull null] || [[NSString stringWithFormat:@"%@",object] isEqualToString:@"null"]);
}

+ (BOOL) isValidStr:(NSString *)str{
    BOOL b1 = [self isNonnull:str];
    BOOL b2 =([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]);
    BOOL b3 = str.length > 0;
    BOOL b4 = ([str rangeOfString:@"null"].location == NSNotFound);
    BOOL b5 = ([str rangeOfString:@"nil"].location == NSNotFound);
    return b1 && b2 && b3 && b4 && b5;
}

//+ (BOOL) isValidStr:(NSString *)str{
//    return [self isNonnull:str] && ([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]) && str.length > 0;
//}

+ (BOOL) isValidData:(NSData *)data{
    return ([self isNonnull:data]) && ([data isKindOfClass:[NSData class]] || [data isKindOfClass:[NSMutableData class]]) && data.length > 0;
}

+ (BOOL) isValidArray:(NSArray *)array{
    return ([self isNonnull:array]) && ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) && array.count > 0;
}

+ (BOOL) isValidDictionary:(NSDictionary *)dict{
    return ([self isNonnull:dict]) && ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]]) && dict.count > 0;
}

+ (NSString*)getCorrectStringWithString:(NSString*)string{
    
    return [LGDUtils isValidStr:string]?string:@"";
    
}



+ (NSArray *)randamArry:(NSArray *)array
{
    
    NSMutableArray * muarrNum = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        [muarrNum addObject:@(i)];
    }
    
    // 对数组乱序
     NSArray * sortArray = [muarrNum sortedArrayUsingComparator:^NSComparisonResult(id str1, id str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    NSMutableArray * muResultArr = [NSMutableArray array];
    for (NSNumber * number in sortArray) {
        [muResultArr addObject:array[[number integerValue]]];
    }
    
    return [NSArray arrayWithArray:muResultArr];
    
}

+(long long)changeSecondsToMinute:(NSString *)seconds{
    if (!seconds || [LGDUtils isNilOrNSNull:seconds]) {
        return 0;
    }
    NSInteger studyTime = [seconds integerValue] / 60.0;
    NSInteger yushu = [seconds integerValue] % 60;
    if (yushu > 0 && MinuteJia1IfMoreThan(yushu)) {
        studyTime += 1;
    }
    
    return studyTime;
}

+(NSString *)changeSecondsToHour:(NSString *)seconds{
    NSInteger minute = [self changeSecondsToMinute:seconds];
    //    分钟转小时
    NSInteger hour = minute / 60;
    NSInteger minuteYushu = minute % 60;
    
    
    NSString * outPutTimeStr = nil;
    if (hour > 0) {
        outPutTimeStr = [NSString stringWithFormat:@"%zd小时%zd分钟",hour,minuteYushu];
    }else{
        outPutTimeStr = [NSString stringWithFormat:@"%zd分钟",minute];
    }
    
    return outPutTimeStr;
}



+(UIImage *)compressedImage:(UIImage *)image belowSize:(CGFloat)size{

    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    if (data.length < size * 1024 ) {
        return image;
    }
    UIImage * imageComplete = image;

    int i = 0;

    while (data.length > size * 1024 && i < 3) {

        CGSize size = CGSizeMake(imageComplete.size.width * 0.5, imageComplete.size.height * 0.5);
        imageComplete = [UIView reSizeImage:imageComplete toSize:size];
        data = UIImageJPEGRepresentation(imageComplete, 1.0);


    }

    return imageComplete;
}



-(void)judgeAPPVersionWithAppId:(NSString *)appid
{
    //    https://itunes.apple.com/lookup?id=604685049

    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",appid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data Delegate:(id)delegate
{

    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];

    NSLog(@"商店的版本是 %@",version);

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前的版本是 %@",currentVersion);


    if (![version isEqualToString:currentVersion]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"商店有最新版本了" delegate:delegate cancelButtonTitle:@"YES" otherButtonTitles:nil,nil];
        [alert show];

    }
    
}






@end



























