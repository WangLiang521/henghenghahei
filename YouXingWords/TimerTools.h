
//
//  TimerTools.h
//  YouXingWords
//
//  Created by tih on 16/8/31.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXTimerDelegate <NSObject>


@end
@interface TimerTools : NSObject
@property (nonatomic,assign)id<YXTimerDelegate> delegate;
+(void)clear;
+(void)timerAdd;
+(NSString *)getTime;
+(instancetype)defaultManager;

/**
 *  答题完毕后转存,方便之后上传,之前的逻辑有问题
 */
+(void)reSaveTimeNew;
+ (NSString *)getStudyTimeNew;
+(void)clearStudyTimeNew;


@end
