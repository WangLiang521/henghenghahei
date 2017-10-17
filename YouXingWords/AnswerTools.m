//
//  AnswerTools.m
//  YouXingWords
//
//  Created by tih on 16/8/31.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "AnswerTools.h"

@interface AnswerTools ()
@property (nonatomic,retain)NSMutableArray* results;
@property (nonatomic,assign)NSInteger  lives;
@property (nonatomic,assign)id<YXAnswerWrong>  delegate;

@property (nonatomic,retain)NSNumber *wordBookID;
@property (nonatomic,retain)NSNumber *courseBookID;
/**
 *  当前课程 bookId
 */
@property (nonatomic,retain)NSNumber *bookIDCourse;
@property (nonatomic,retain)NSNumber *PKID;

@end
@implementation AnswerTools
static AnswerTools * _instance = nil;

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+(void)setDelegate:(id)dele{
    [AnswerTools defaultManager].delegate = dele;
}
+(void)beginRecorder{
    if ([AnswerTools defaultManager].results) {
        [[AnswerTools defaultManager].results removeAllObjects];
    }
    else{
        [AnswerTools defaultManager].results = [NSMutableArray array];
    }
    [AnswerTools defaultManager].lives = 6;
    

    //start
#pragma mark gd_分用户储存  0115
    //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
    //end
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    [[AnswerTools defaultManager].results writeToFile:path atomically:NO];
}
+(void)answerRightWithQId:(NSNumber *)qID AndWordId:(NSNumber *)wordID AndWord:(NSString*)word{
    if (![AnswerTools defaultManager].results) {
        [AnswerTools beginRecorder];
    }
    NSDictionary *dic = @{@"qId":qID,@"wordId":wordID,@"word":word,@"isRight":@1};
    [[AnswerTools defaultManager].results addObject:dic];

    //start
#pragma mark gd_分用户储存  0115
    //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
    //end
    
    [[AnswerTools defaultManager].results writeToFile:path atomically:NO];

}
+(void)answerWrongWithQId:(NSNumber *)qID AndWordId:(NSNumber *)wordID AndWord:(NSString*)word{
    if (![AnswerTools defaultManager].results) {
        [AnswerTools beginRecorder];
    }
    NSDictionary *dic = @{@"qId":qID,@"wordId":wordID,@"word":word,@"isRight":@0};
    BOOL isHave = NO;
    for (int i=0; i<[AnswerTools defaultManager].results.count; i++) {
        if ([[[AnswerTools defaultManager].results[i] valueForKey:@"qId"]isEqualToNumber:qID]) {
            isHave = YES;
            break;
        }
    }
    if (!isHave) {
        [[AnswerTools defaultManager].results addObject:dic];
        
        //start
#pragma mark gd_分用户储存  0115
        //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
        NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
        //end
        
        [[AnswerTools defaultManager].results writeToFile:path atomically:NO];
        [AnswerTools defaultManager].lives --;
    }
//    [[AnswerTools defaultManager].results addObject:dic];

    if ([AnswerTools defaultManager].lives<=0) {
        NSLog(@"死没了！%@",[AnswerTools defaultManager].results);
        if ([[AnswerTools defaultManager].delegate respondsToSelector:@selector(showfailView)]) {
            [[AnswerTools defaultManager].delegate showfailView];
        }
    }else{
        if ([[AnswerTools defaultManager].delegate respondsToSelector:@selector(showWrongVC)]) {
            [[AnswerTools defaultManager].delegate showWrongVC];
        }
    }

}
+(float)getRate{
    int a = [AnswerTools defaultManager].results.count;
    int b=0;
    for (int i=0; i<a; i++) {
        if ([[[AnswerTools defaultManager].results[i] valueForKey:@"isRight"]isEqualToNumber:@1]) {
            b++;
        }
    }
    return b*1.00/a;
}
+(NSInteger)getLives{
    return [AnswerTools defaultManager].lives;
}

+(void)recoverData{
    //start
#pragma mark gd_分用户储存  0115
    //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
    //end
    
    [AnswerTools defaultManager].results = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];
    
}
+(void)cleatData{
    [AnswerTools defaultManager].lives=6;
}
+(void)setBookID:(NSNumber *)num With:(BreakthroughType)type{

    switch (type) {
        case BreakthroughTypeWord:
            [self setBookID:num];
            break;
            
        case BreakthroughTypeGrammer:
            
            break;
            
        case BreakthroughTypeCourse:
            [self setCourseBookID:num];
            break;
            
        default:
            break;
    }
    

}
+(NSNumber *)getBookIDWith:(BreakthroughType)type{
    NSNumber * bookId = @(0);
    switch (type) {
        case BreakthroughTypeWord:
            bookId = [self getBookID];
            break;
            
        case BreakthroughTypeGrammer:
            
            break;
            
        case BreakthroughTypeCourse:
            bookId = [self getCourseBookID];
            break;
            
        default:
            break;
    }
    return bookId;
}


+(void)setBookID:(NSNumber *)num {
    [AnswerTools defaultManager].wordBookID =  num;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setValue:num forKey:@"CurrentBookID"];
    
    

    
}
+(NSNumber *)getBookID {
    if ([AnswerTools defaultManager].wordBookID) {
        return [AnswerTools defaultManager].wordBookID;
        
    }else{
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"CurrentBookID"];
        return num;
    }
}


+(void)setCourseBookID:(NSNumber *)num{
    [AnswerTools defaultManager].courseBookID =  num;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setValue:num forKey:@"CurrentCourseBookID"];
    
    
    //start
#pragma mark gd_不再使用newBookId  2017-04-27 11:13:53
    //保存当前bookid
    //    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"newBookId"];
    //end
    
    
    
}
+(NSNumber *)getCourseBookID{
    if ([AnswerTools defaultManager].courseBookID) {
        return [AnswerTools defaultManager].courseBookID;
        
    }else{
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"CurrentCourseBookID"];
        return num;
    }
}

+(void)setBookName:(NSString *)bookName With:(BreakthroughType)type{
    [[NSUserDefaults standardUserDefaults] setObject:bookName forKey:[NSString stringWithFormat:@"bookName%zd",type]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getBookNameWith:(BreakthroughType)type{
    NSString * bookName = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"bookName%zd",type]];
    
    
    
    return bookName;
}


+(void)setPKID:(NSNumber *)num{
    [AnswerTools defaultManager].PKID =  num;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setValue:num forKey:@"CurrentPKID"];
}
+(NSNumber *)getPKID{
    if ([AnswerTools defaultManager].PKID) {
        return [AnswerTools defaultManager].PKID;
        
    }else{
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"CurrentPKID"];
        return num;
    }
}
@end
