//
//  LGDUtils.h
//  EasyWedding
//
//  Created by wangliang on 16/9/6.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <UIKit/UIKit.h>



static NSString * const FormatterStringyyyy_MM_dd = @"yyyy-MM-dd";
static NSString * const FormatterStringyyyyYearMMMonthddDay = @"yyyy年MM月dd日";








@interface LGDUtils : NSObject

/**
 *  清除字符串中的中文字符和/t /n
 */
+(NSString*)cleanChinaChar:(NSString*)orignal;


/**
 *  正则表达式验证手机号 - 以 1 开头的11位数字
 */
+ (BOOL)isValiadateMobile:(NSString *)mobile;


/**
 *  将包含HTML格式的字符串转换成普通字符串
 *
 *  @param htmlString Html字符串
 *
 *  @return 普通字符串
 */
+(NSMutableAttributedString *)changeToCommonStringByHTMLString:(NSString *)htmlString;

/**
 *  获取一个label的高度
 */
+(CGFloat)getHeightFromLabel:(UILabel *)label withWidth:(CGFloat)width;
/**
 *  获取一个label的宽度
 */
+(CGFloat)getWidthFromLabel:(UILabel *)label withHeight:(CGFloat)height;
/**
 *  获取一个btn的宽度
 */
+(CGFloat)getWidthFromBtn:(UIButton *)btn withHeight:(CGFloat)height;

/**
 *  获取一个TextView的高度
 */
+(CGFloat)getHeightFromTextView:(UITextView *)textView withWidth:(CGFloat)width;

/**
 *  判断数组中的 TextField.text 是否为空，若为空则提示 TextField 的 placeholder ，全部有值返回yes，否则在数组中的第一个 TextField.text 为空时返回NO
 *
 *  @param array textField 组成的数组
 *
 *  @return ，全部有值返回yes，否则在数组中的第一个 TextField.text 为空时返回NO
 */
+ (BOOL)quikTipsWhenTextFieldsNeroWith:(NSArray *)array ;



// NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
/**
 *  将一个 string 转换为 NSDate ，需要输入 fromatterString   FormatterStringyyyy_MM_dd  FormatterStringyyyyYearMMMonthddDay ;
 */
+(NSDate*) convertDateFromString:(NSString*)dateString WithFormatterString:(NSString*)fromatterString;


/**
 *  将 NSdate 转换为 string 需要输入 fromatterString  FormatterStringyyyy_MM_dd  FormatterStringyyyyYearMMMonthddDay
 */
+ (NSString *)stringFromDate:(NSDate *)date WithFormatterString:(NSString*)fromatterString;



/**
 *  传入毫秒
 *  将 timeInterval 转换为 string 需要输入 fromatterString  FormatterStringyyyy_MM_dd  FormatterStringyyyyYearMMMonthddDay
 */
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval WithFormatterString:(NSString*)fromatterString;

/**
 *  获取当前时间戳
 */
+(NSString *)getCurrentTimeString13;

/**
 *  当前日期加减月份之后的时间
 *
 *  @param date  当前月份
 *  @param month 加减月份
 */
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

/**
 *  输入起止时间，计算间隔
 */
+(NSDateComponents *)jisuanjiangeWithFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate;
+(NSDateComponents *)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;


+ (NSString *)getDateToDayFromTimeStr:(NSString *)dateStr;
+ (NSString *)getDateToDayFromTimeInt:(long long)timeInt;



/**
 *  压缩图片到 size 的大小之下，size单位 kb
 *
 *  @param image <#image description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)compressedImage:(UIImage *)image belowSize:(CGFloat)size;



// return YES if object is nil or[NSNull null]
+ (BOOL) isNilOrNSNull: (id)object;

+ (BOOL) isNonnull:(id)object;

+ (BOOL) isValidStr:(NSString *)str;

+ (BOOL) isValidData:(NSData *)data;

+ (BOOL) isValidArray:(NSArray *)array;

+ (BOOL) isValidDictionary:(NSDictionary *)dict;

/**
 *  乱序的数组，即每次显示的顺序不同
 */
+ (NSArray *)randamArry:(NSArray *)array;

+ (NSString*)getCorrectStringWithString:(NSString*)string;



+(long long)changeSecondsToMinute:(NSString *)seconds;
+(NSString *)changeSecondsToHour:(NSString *)seconds;




@end
