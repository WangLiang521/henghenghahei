
//
//  PassList.h
//  YouXingWords
//
//  Created by tih on 16/9/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PassModel;
@interface PassList : NSObject

@property (nonatomic,retain)NSMutableArray *list;

@property (strong, nonatomic)  PassModel *currentModel;
/**
 *  复习关 index, 如果没有复习关,那么这个 index 是-1
 */
@property (assign, nonatomic)  NSInteger indexFuxiguan;

+(instancetype)defaultManager;
+(void)setList:(NSArray *)list;
+(void)setCurrent:(NSInteger)current;

+(PassModel *)getNext;

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(BOOL)canGetNext;
+(BOOL)canGetNextWith:(BreakthroughType)type;
//end
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)unlockNext;
+(void)unlockNextWith:(BreakthroughType)type;
//end
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)gotUdiamondNum:(NSNumber *)num;
+(void)gotUdiamondNum:(NSNumber *)num With:(BreakthroughType)type;
//end


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(BOOL)shouldSetUpFuxiguan;
+(BOOL)shouldSetUpFuxiguanWith:(BreakthroughType)type;
//end



#pragma mark gd_获取当前用户目录路径
+(NSString *)getCurrentUserDirPath;


#pragma mark gd_获取关卡是否通过的存储路径
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getIfLockArrayPath
+(NSString *)getIfLockArrayPathWith:(BreakthroughType)type;
//end
#pragma mark gd_添加复习关  加在了 ifLockArray.plist 里

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)insertFuxiGuanWithDicFuxiti:(NSDictionary *)dicFuxiti;
+(void)insertFuxiGuanWithDicFuxiti:(NSDictionary *)dicFuxiti With:(BreakthroughType)type;
//end



//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getFuxitiPath;
+(NSString *)getFuxitiPathWith:(BreakthroughType)type;
//end

/*
 * 获取复习关卡题目
*/
//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(PassModel *)getFuxiti;
+(PassModel *)getFuxitiWith:(BreakthroughType)type;
//end


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)refreshFuxitiWithResponse:(NSArray *)fuxitiArray;
+(void)refreshFuxitiWithResponse:(NSArray *)fuxitiArray With:(BreakthroughType)type;
//end

//保存已经通过的关卡的 id, 已区分 userName 和 BookId
+(void)savePassedPassIdsWith:(NSNumber*)passId BookId:(NSNumber *)bookId;
//获取某本教材的已通关的passId 已区分 userName 和 BookId
+ (NSMutableDictionary *)getBookAllPassedPassIdsWithBookId:(NSNumber *)bookId;

+(void)saveSysInfo:(NSDictionary *)sysInfo;
+(NSInteger)getSysInfo:(NSInteger)getCoins;

@end
