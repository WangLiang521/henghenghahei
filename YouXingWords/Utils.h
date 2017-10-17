//
//  Utils.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SARUnArchiveANY.h"
#define ALTERTIME 1

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//#define KeyUserCuotiCount [NSString stringWithFormat:@"%@%@cuoti",[Utils getCurrentUserName],[AnswerTools getBookID]]
#define KeyUserCuotiCount(type) [NSString stringWithFormat:@"%@%@cuoti",[Utils getCurrentUserName],[AnswerTools getBookIDWith:(type)]]
//end

//#define KeyUserCuotiCount [NSString stringWithFormat:@"%@cuoti",[Utils getCurrentUserName]]


@interface Utils : NSObject

//自动消失的提示框
+(void)showAlter:(NSString *)message;
+(void)showAlter:(NSString *)message WithTime:(NSInteger)time;

//获取当前的token
+(NSString *)getCurrentToken;
//退出登录后清除 token
+(void)clearToken;
//获取所有资源包的文件夹名字
+(NSString *)getResFolder;
//获取图片路径
+(NSString *)getImageFolderWithQImage:(NSString *)qImage;
//获取当前的用户名
+(NSString *)getCurrentUserName;
//获取当前的用户信息
+(NSDictionary *)getCurrentUserInfo;
//获取当前用户优钻数量
+(NSNumber*)getCoinsCount;
/**
 *  根据路径获取题目 dic
 */
+(NSDictionary *)getDictWithPath:(NSString *)finalPath;

//根据时间戳转换成NSDate
+(NSString *)getDateStrByTimeStamp:(id)timeStamp;
//根据时间戳转换成 MM月dd日 hh:mm:ss
+(NSString *)changeByTimeStamp:(id)timeStamp;
//根据时间戳转换成 hh:mm
+(NSString *)timeByTimeStamp:(id)timeStamp;
//获取当前时间的时间戳
+(NSTimeInterval)getCurrentTimeStamp;

+(NSString *)wltimeByTimeStamp:(id)timeStamp;



//根据内容获得相应高度
+(CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width;

/**
 *  获取当前教材的qs.txt中的信息dict
 */
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSDictionary *)getCurrentQsTxtDict
+(NSDictionary *)getCurrentQsTxtDictWith:(BreakthroughType)type;
//end

/**
 *  获取当前教材的qs.txt中的信息 array
 */
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSArray *)getCurrentQsTxtQsArray
+(NSArray *)getCurrentQsTxtQsArrayWith:(BreakthroughType)type;
//end

/**
 *  获取当前教材的 wordInfos.json 中的信息dict
 */
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSDictionary *)getCurrentQsJsonDict;
+(NSDictionary *)getCurrentQsJsonDictWith:(BreakthroughType)type;
//end

/*
 {
 @"关卡id":{
 @"题目id":@"题目",
 @"题目id":@"题目",....},
 @"关卡id":{@"题目id":@"题目",@"题目id":@"题目"},.....
 }
 */
//将当前教材按照这种格式存取
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+ (void)creatTxtTimuDictWith:(NSDictionary *)dict;
+ (void)creatTxtTimuDictWith:(NSDictionary *)dict With:(BreakthroughType)type;
//end

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+ (NSDictionary *)getTxtTimuDict;
+ (NSDictionary *)getTxtTimuDictWith:(BreakthroughType)type;
//end

+ (BOOL) isNilOrNSNull: (id)object;

+ (BOOL) isNonnull:(id)object;

+ (BOOL) isValidStr:(NSString *)str;

+ (BOOL) isValidData:(NSData *)data;

+ (BOOL) isValidArray:(NSArray *)array;

+ (BOOL) isValidDictionary:(NSDictionary *)dict;


+ (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath completionBlock:(void(^)())completionBlock failureBlock:(void(^)())failureBlock;

+ (void)saveStartTime;

+ (NSString *)getStartTime;


/**
 *  获取当前所选教材的 qs.txt 路径
 */
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getPathCurrentQsTxt;
+(NSString *)getPathCurrentQsTxtWith:(BreakthroughType)type;
//end


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getPathNoteBookQsArray;
+(NSString *)getPathNoteBookQsArrayWith:(BreakthroughType)type;
//end

@end
