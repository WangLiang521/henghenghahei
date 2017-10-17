//
//  GDSessionHelp.h
//  断点续传
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 com.jinyouApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>






typedef void (^CompletionBlock)(void);
typedef void (^ProgressBlock)(long long totalLength,long long downloadLength);
typedef void (^ErrorBlock)(NSError *error);
@interface GDSessionManager : NSObject

//- (instancetype)initWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType successPath:(NSString *)successPath;

- (void)addToDownloadQueueWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType successPath:(NSString *)successPath;


-(void)startWithProgressblock:(ProgressBlock)progressBlock CompletionBlock:(CompletionBlock)completionBlock failBlock:(ErrorBlock)failBlock;

- (void)stop;

- (NSString *)getDownStatusWith:(NSNumber*)bookId url:(NSString *)url fileName:(NSString *)fileName fileType:(NSString *)fileType;


- (void)downResWithBookUrl:(NSString *)bookUrl fileName:(NSString *)fileName;

+(instancetype)share;

/**
 *   url 为当前 url 停止当前,并开始下一个
 *   url在队列中,从队列中移除
 */
- (void)stopDownWithUrl:(NSString *)url;


/**
 *  删除文件
 */
- (void)deleteFileWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType bookId:(NSNumber *)bookId;


@end
