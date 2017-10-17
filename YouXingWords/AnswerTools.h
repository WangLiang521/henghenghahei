
//
//  AnswerTools.h
//  YouXingWords
//
//  Created by tih on 16/8/31.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BreakthroughTypeWord = 1,
    BreakthroughTypeGrammer = 2,
    BreakthroughTypeCourse = 3} BreakthroughType;

@protocol YXAnswerWrong <NSObject>

-(void)showWrongVC;

-(void)showfailView;

@end
@interface AnswerTools : NSObject
+(instancetype)defaultManager;
+(void)beginRecorder;
+(void)answerRightWithQId:(NSNumber *)qID AndWordId:(NSNumber *)wordID AndWord:(NSString*)word;
+(void)answerWrongWithQId:(NSNumber *)qID AndWordId:(NSNumber *)wordID AndWord:(NSString*)word;

+(float)getRate;
+(void)setDelegate:(id)dele;

+(NSInteger)getLives;
+(void)recoverData;
+(void)cleatData;

+(void)setBookID:(NSNumber *)num With:(BreakthroughType)type;
+(NSNumber *)getBookIDWith:(BreakthroughType)type;
+(void)setCourseBookID:(NSNumber *)num;
+(NSNumber *)getCourseBookID;

+(void)setBookName:(NSString *)bookName With:(BreakthroughType)type;
+(NSString*)getBookNameWith:(BreakthroughType)type;


+(void)setPKID:(NSNumber *)num;
+(NSNumber *)getPKID;
@end
