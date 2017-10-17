//
//  GDSessionHelp.m
//  断点续传
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 com.jinyouApp. All rights reserved.
//

#import "GDSessionManager.h"

#import "NSURLSession+CorrectedResumeData.h"

//#define targetpathMQLResumeManager @"doc"
//typedef void (^completionBlock)();
//typedef void (^progressBlock)();

#import "MD5.h"

// 下载文件的URL
//#define ChaosFileURL @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"

// 根据文件唯一的URL MD5值 作为文件名
#define ChaosFileNames [NSString stringWithFormat:@"%@%@",[MD5 md5:_ChaosFileURL],_ChaosFileType]

// 下载文件的全路径
#define ChaosFileFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:ChaosFileNames]

// 用来存储文件总长度的plist文件 key:文件名的MD5值 value:文件总长度
#define ChaosDownloadFilesPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadFiles.plist"]




// 已经下载的文件长度
#define ChaosDownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:ChaosFileFullPath error:nil][@"NSFileSize"] integerValue]


@interface GDSessionManager ()<NSURLSessionDataDelegate>

@property (nonatomic,copy) NSString * ChaosFileURL;

@property (nonatomic,copy) NSString * ChaosFileName;

@property (nonatomic,copy) NSString * ChaosFileType;

@property (nonatomic,copy) NSString * successPath;

/** stream */
@property(nonatomic,strong) NSOutputStream *stream;

/** session */
@property(nonatomic,strong) NSURLSession *session;

/** task */
@property(nonatomic,strong) NSURLSessionDataTask *task;

/** totalLength */
@property(nonatomic,assign) long long totalLength;

/** downloadLength */
@property(nonatomic,assign) long long downloadLength;

@property (strong, nonatomic) NSData *resumeData;

@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, copy) ErrorBlock failBlock;


@property (strong, nonatomic)  NSNumber *currentDownBookId;
@end

@implementation GDSessionManager

#define KeyArrDownloadQueue @"arrDownloadQueue"

//+(instancetype)shareWithUrl:(NSString *)url FileName:(NSString *)fileName{
//    static GDSessionManager * manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[GDSessionManager alloc] init];
//        manager.ChaosFileURL = url;
//        manager.ChaosFileName = fileName;
//    });
//    return manager;
//}

- (void)deleteFileWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType bookId:(NSNumber *)bookId{
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],bookId];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
    NSString *strZip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],bookId,ArchiveType];
    NSString *filePathZip = [NSHomeDirectory() stringByAppendingPathComponent:strZip];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathBase]) {
        [manager removeItemAtPath:filePathBase error:nil];
    }
    
    if ([manager fileExistsAtPath:filePathZip]) {
        [manager removeItemAtPath:filePathZip error:nil];
    }
    
    NSString * downPath = [self getDownloadPathWith:url fileType:chaosFileType];
    
    if ([manager fileExistsAtPath:downPath]) {
        [manager removeItemAtPath:downPath error:nil];
    }
    
}

- (NSInteger)getDownloadLengthWith:(NSString *)url fileType:(NSString *)fileType{
//    ChaosDownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:ChaosFileFullPath error:nil][@"NSFileSize"] integerValue]
    
    NSString * path = [self getDownloadPathWith:url fileType:fileType];
    NSInteger downloadLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil][@"NSFileSize"] integerValue];
    return downloadLength;
}

- (NSInteger)getTotalLengthWithfileName:(NSString *)fileName{

    NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist][fileName] integerValue];
    
    return totalLength;
}


- (NSString *)getDownloadPathWith:(NSString *)url fileType:(NSString *)fileType{
    NSString * fileName = [NSString stringWithFormat:@"%@%@",[MD5 md5:url],fileType];
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    return path;
}

//#define ChaosFileNames [NSString stringWithFormat:@"%@%@",[MD5 md5:_ChaosFileURL],_ChaosFileType]
//
//// 下载文件的全路径
//#define ChaosFileFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:ChaosFileNames]
//
//// 用来存储文件总长度的plist文件 key:文件名的MD5值 value:文件总长度
//#define ChaosDownloadFilesPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadFiles.plist"]
//
//
//
//
//// 已经下载的文件长度
//#define ChaosDownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:ChaosFileFullPath error:nil][@"NSFileSize"] integerValue]

- (NSString *)getDownStatusWith:(NSNumber*)bookId url:(NSString *)url fileName:(NSString *)fileName fileType:(NSString *)fileType{
    
    //#define KeyBookDownInfo @"KeyBookDownInfo"

    ////    GDSessionManager * manager = [GDSessionManager ]
    //
    //    NSDictionary * bookDownInfo = [[NSUserDefaults standardUserDefaults] objectForKey:KeyBookDownInfo];
    //
        NSArray * arrDownloadQueue = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KeyArrDownloadQueue]];
    //
    //    if ([arrDownloadQueue containsObject:bookId]) {
    //
    //
    //        NSString * strProgress =  bookDownInfo[[NSString stringWithFormat:@"%@",bookId]];
    //        return [NSString stringWithFormat:@"等待下载:%@",strProgress];
    //
    //    }else{
    //
    //    }
    
    
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],bookId];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
    
    
    NSString *strZip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],bookId,ArchiveType];
    NSString *filePathBaseZip = [NSHomeDirectory() stringByAppendingPathComponent:strZip];
//    NSString *strZip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],@"1494986453508",ArchiveType];
//    NSString *filePathBaseZip = [NSHomeDirectory() stringByAppendingPathComponent:strZip];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ( [fm fileExistsAtPath:filePathBase]) {
//        1.当前教材已下载并成功解压
        return @"可用";
    }else if ( [fm fileExistsAtPath:filePathBaseZip]) {
//        2.当前教材已下载压缩包,但未解压
        

        NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
        NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
        
        
        
        
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
        [Utils unArchive:filePathBaseZip andPassword:nil destinationPath:filePathDest completionBlock:^{
            
        } failureBlock:^{
            
        }];
        
        if ( [fm fileExistsAtPath:filePathBase]) {
            return @"可用";
        }else{
            return @"解压失败";
        }
        
    }else{
        NSInteger downLength = [self getDownloadLengthWith:url fileType:fileType];
        NSInteger totalLength = [self getTotalLengthWithfileName:fileName];
        
        
        BOOL alreadyDownloadQueue = NO;

        for (NSDictionary * info in arrDownloadQueue) {
            if ([info[@"url"] isEqualToString:url]) {
                alreadyDownloadQueue = YES;;
            }
        }
        

        
        if (alreadyDownloadQueue) {
//        3.在下载队列中
            if (downLength > 0 && totalLength >0) {
                CGFloat progress = downLength * 100.0 / totalLength;
                //        4.1没有下载完
                return [NSString stringWithFormat:@"等待下载:%0.2f%%",progress];
            }else{
                //        4.1没有开始瞎子啊
                return @"等待下载";
            }
            
        }else{
//        4.没有下载或没有下载完
            if (downLength > 0 && totalLength > 0) {
                CGFloat progress = downLength * 100.0 / totalLength;
                //        4.1没有下载完
                return [NSString stringWithFormat:@"已暂停:%0.2f%%",progress];
            }else{
                //        4.1没有开始瞎子啊
                return @"下载";
            }
            
        }
        
    }
    return @"下载";
    
}

+(instancetype)share{
    static GDSessionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GDSessionManager alloc]init];
    });
    return manager ;
}

/**
 *  停止某个教材的下载
 */
- (void)stopDownWithUrl:(NSString *)url{

    //    1.取出下载队列
    NSMutableArray * arrDownloadQueue = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KeyArrDownloadQueue]];
    //    2.判断当前下载的是否是此 url  如果正在下载,直接 停止并移除
    if ([url isEqualToString:self.ChaosFileURL]) {
        
        NSLog(@"正在下载,暂停");
        CGFloat pro =  self.totalLength == 0? 0 : self.downloadLength * 100.0 /self.totalLength;
        NSString * progress = pro > 0 ?[NSString stringWithFormat:@"已暂停:%0.2f%%",pro]:@"已暂停";
        [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"progress":@(pro),@"task":self.task,@"taskState":@(self.task.state)}];
        
        [self pauseClick];
        [self downloadStopOrSuccess];
        
        
        [self startNext];
    }else{
        //    3.查找下载队列中是否存在此 url  如果已经存在,移除
        for (int i = 0; i < arrDownloadQueue.count; i++) {
            NSDictionary * info = arrDownloadQueue[i];
            
            if ([info[@"url"] isEqualToString:url]) {
                [arrDownloadQueue removeObject:info];
                [[NSUserDefaults standardUserDefaults] setObject:arrDownloadQueue forKey:KeyArrDownloadQueue];
                
                CGFloat pro =  self.downloadLength * 100.0 /self.totalLength;
                NSString * progress = pro > 0 ? [NSString stringWithFormat:@"已暂停:%0.2f%%",pro] : @"已暂停";
                [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"progress":@(pro),@"task":self.task,@"taskState":@(self.task.state)}];
            }
        }
    }
    
    

}

/**
 *  开始下载下一个
 */
- (void)startNext{
//    1.取出下载队列
    NSMutableArray * arrDownloadQueue = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KeyArrDownloadQueue]];
    if (arrDownloadQueue.count > 0) {
        NSDictionary * info = arrDownloadQueue.firstObject;
        [arrDownloadQueue removeObject:info];
        [[NSUserDefaults standardUserDefaults] setObject:arrDownloadQueue forKey:KeyArrDownloadQueue];
        
        
        
        [self addToDownloadQueueWithUrl:info[@"url"] FileName:info[@"fileName"] ChaosFileType:info[@"chaosFileType"] successPath:info[@"successPath"]];
        
        
        
       
    }

}
/**
 *  当前下载启动失败,重新启动,
 *  目前已知启动失败的原因:
 *  1.启动时没有走 URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler  没有获取到 totalLength
 */
- (void)reStart{
    
//    self.ChaosFileURL = url;
//    self.ChaosFileName = fileName;
//    self.ChaosFileType = chaosFileType;
//    self.successPath = successPath;
//    self.downloadLength = 0;
//    self.totalLength = 0;
    //    4.2当前没有文件在下载,直接开始下载
    [self setUpWithUrl:self.ChaosFileURL FileName:self.ChaosFileName ChaosFileType:self.ChaosFileType successPath:self.successPath];
    [self downResWithBookUrl:self.ChaosFileURL fileName:self.ChaosFileName];
    
}

#pragma mark 添加到下载队列 - 不会重复添加
- (void)addToDownloadQueueWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType successPath:(NSString *)successPath{
    
//    1.取出下载队列
    NSMutableArray * arrDownloadQueue = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KeyArrDownloadQueue]];
    
    if (!arrDownloadQueue) {
        arrDownloadQueue = [NSMutableArray array];
    }
    
//    2.判断当前下载的是否是此 url  如果正在下载,直接 return
    if (_task && _task.state == NSURLSessionTaskStateRunning && [url isEqualToString:self.ChaosFileURL]) {
//        [self startClick];
//        [arrDownloadQueue removeObject:info];
//        [[NSUserDefaults standardUserDefaults] setObject:arrDownloadQueue forKey:KeyArrDownloadQueue];
//        
        CGFloat pro =  self.totalLength > 0 ? self.downloadLength * 100.0 /self.totalLength : 0;
        NSString * progress = [NSString stringWithFormat:@"已暂停:%0.2f%%",pro];
        [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"progress":@(pro),@"task":self.task,@"taskState":@(self.task.state)}];
        return;
    }
    
//    3.查找下载队列中是否已经存在此 url  如果已经存在,直接 return
    for (NSDictionary * dictInfo in arrDownloadQueue) {
        if ([dictInfo[@"url"] isEqualToString:url]) {
            NSLog(@"已经存在此 url -直接 return");
            return;
        }
    }
    
//    4.下载队列不存在此 url, 并且当前下载的不是此 url

    if (_task && _task.state == 0) {
        NSLog(@"当前有文件正在下载,加入下载队列");
        //    4.1当前有文件正在下载,加入下载队列
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        info[@"url"] = url;
        info[@"fileName"] = fileName;
        info[@"chaosFileType"] = chaosFileType;
        info[@"successPath"] = successPath;
        [arrDownloadQueue addObject:info];
        
        [[NSUserDefaults standardUserDefaults] setObject:arrDownloadQueue forKey:KeyArrDownloadQueue];
        
        NSString * progress = @"等待下载";
        [[NSNotificationCenter  defaultCenter] postNotificationName:fileName object:nil userInfo:@{@"text":progress,@"task":self.task,@"taskState":@(self.task.state)}];
        
    }else{
        NSLog(@"当前没有文件在下载,直接开始下载");
        //    4.2当前没有文件在下载,直接开始下载
        [self setUpWithUrl:url FileName:fileName ChaosFileType:chaosFileType successPath:successPath];
        [self downResWithBookUrl:url fileName:fileName];
        CGFloat pro =  self.totalLength > 0 ? self.downloadLength * 100.0 /self.totalLength : 0;
        NSString * progress = pro > 0 ? [NSString stringWithFormat:@"正在下载:%0.2f%%",pro] : @"正在下载";
        [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"progress":@(pro),@"task":self.task,@"taskState":@(self.task.state)}];
    }
  
}

- (void)setUpWithUrl:(NSString *)url FileName:(NSString *)fileName ChaosFileType:(NSString *)chaosFileType successPath:(NSString *)successPath
{
//    if (self.ChaosFileURL) {
//        [self downloadStopOrSuccess];
//    }
    
    self.ChaosFileURL = url;
    self.ChaosFileName = fileName;
    self.ChaosFileType = chaosFileType;
    self.successPath = successPath;
    self.downloadLength = 0;
    self.totalLength = 0;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist];
    // 字典可能为空
    if (dict == nil){
        dict = [NSMutableDictionary dictionary];
        // 写入文件
        dict[_ChaosFileName] = @(0);
        [dict writeToFile:ChaosDownloadFilesPlist atomically:YES];
        
    }
    
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:ChaosFileFullPath]) {
        self.stream = [NSOutputStream outputStreamToFileAtPath:ChaosFileFullPath append:YES];
        NSData * data = [NSData new];
        [self.stream write:[data bytes] maxLength:data.length];
        [self.stream open];
        
    }
    
}


-(void)startWithProgressblock:(ProgressBlock)progressBlock CompletionBlock:(CompletionBlock)completionBlock failBlock:(ErrorBlock)failBlock{
    
    //     progressBlock = self.progressBlock;
    //     completionBlock = self.completionBlock ;
    self.progressBlock = progressBlock;
    self.completionBlock = completionBlock;
    self.failBlock = failBlock;
    
//    [self task];
    
    NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist][_ChaosFileName] integerValue];
    // 请求同一个文件，判断下载文件长度；如果没下载过此文件，totalLength = 0
    if (totalLength && ChaosDownloadLength == totalLength) {
        NSLog(@"文件已经下载过.");
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_ChaosFileURL]];
    
    // 设置请求头 -- range 这次从哪里开始请求数据 格式：bytes=***-***（从指定开始到指定结束）  或者：bytes=***-（从指定位置到结束）
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",ChaosDownloadLength];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    _task = [self.session dataTaskWithRequest:request];
    
    [self startClick];
}

- (void)stop{
    
    NSError * error= [NSError errorWithDomain:@"ss" code:-1000 userInfo:@{@"info":@"取消"}];
    if (self.failBlock) {
        self.failBlock(error);
    }
    [self pauseClick];
    
    
}

- (NSURLSession *)session
{
    if (_session == nil) {
        
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    
    return _session;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.session= [self backgroundURLSession];
//    }
//    return self;
//}
//
//#pragma mark - backgroundURLSession
//- (NSURLSession *)backgroundURLSession {
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *identifier = @"com.yourcompany.appId.BackgroundSession";
//        NSURLSessionConfiguration* sessionConfig = nil;
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
//        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
//#else
//        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
//#endif
//        session = [NSURLSession sessionWithConfiguration:sessionConfig
//                                                delegate:self
//                                           delegateQueue:[NSOperationQueue mainQueue]];
//    });
//    
//    return session;
//}

//- (NSURLSessionDataTask *)task
//{
//    if (_task == nil) {
//        NSLog(@"新建 task");
//        // 获得文件总长度
//        NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist][_ChaosFileName] integerValue];
//        // 请求同一个文件，判断下载文件长度；如果没下载过此文件，totalLength = 0
//        if (totalLength && ChaosDownloadLength == totalLength) {
//            NSLog(@"文件已经下载过.");
//            return nil;
//        }
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_ChaosFileURL]];
//        
//        // 设置请求头 -- range 这次从哪里开始请求数据 格式：bytes=***-***（从指定开始到指定结束）  或者：bytes=***-（从指定位置到结束）
//        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",ChaosDownloadLength];
//        
//        [request setValue:range forHTTPHeaderField:@"Range"];
//        
//        _task = [self.session dataTaskWithRequest:request];
//        
//    }
//    return _task;
//}



// 开始
- (void)startClick{
    
    
    
    [self.task resume];
}
// 暂停
- (void)pauseClick{
    NSLog(@"暂停 - pauseClick");
    [self.task suspend];
    [self downloadStopOrSuccess];
}


#pragma mark - <NSURLSessionDataDelegate>
/**
 * 接收到响应的时候调用
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 调用blcok，才能接受到数据
    completionHandler(NSURLSessionResponseAllow);
    // 获取文件总长度
    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + ChaosDownloadLength;
    // 初始化stream
    self.stream = [NSOutputStream outputStreamToFileAtPath:ChaosFileFullPath append:YES];
    [self.stream open];
    NSString * path =ChaosFileFullPath;
    
    
    // 接收到服务器响应的时候存储文件的总长度到plist,实现多文件下载，先取出字典，给字典赋值最后写入。
    // 错误做法：直接写入文件，会用这次写入的信息覆盖原来所有的信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist];
    // 字典可能为空
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    // 写入文件
    dict[_ChaosFileName] = @(self.totalLength);
    [dict writeToFile:ChaosDownloadFilesPlist atomically:YES];
    
    
    if (self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(self.totalLength,self.downloadLength);
        });
        
    }
}

/**
 * 接收到服务器发来的数据的时候调用 -- 有可能调用多次
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (![_task isEqual:dataTask]) {
        _task = dataTask;
    }
    if (self.stream == nil) {
        self.stream = [NSOutputStream outputStreamToFileAtPath:ChaosFileFullPath append:YES];
        [self.stream open];
    }
    
    NSString * path =ChaosFileFullPath;
    NSInteger actually = -1;
    // 写入数据
    do {
        actually = [self.stream write:[data bytes] maxLength:data.length];
//        NSLog(@"actually = %zd",actually);
    } while (actually != data.length);    // 获取已经下载的长度
    self.downloadLength = ChaosDownloadLength;
    if (!self.totalLength) {
        self.totalLength = [self getTotalLengthWithfileName:self.ChaosFileName];
    }
    // 计算进度
//    NSLog(@"%f",1.0 * self.downloadLength / self.totalLength);
    
    if (self.totalLength == 0 ) {
        self.totalLength = [[NSDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist][_ChaosFileName] integerValue];
    }
    
    if (self.totalLength > 0 && dataTask.state == 0) {
        CGFloat pro = self.downloadLength * 100.0 /self.totalLength;
        
        NSString * progress = @"正在下载";
        if (dataTask.state == 0 ) {
            progress = [NSString stringWithFormat:@"正在下载:%0.2f%%",pro];
        }else{
            progress = [NSString stringWithFormat:@"已暂停:%0.2f%%",pro];
        }
        
        [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"progress":@(pro),@"task":self.task,@"taskState":@(self.task.state)}];
    }else{
        
    }
//    else{
//        [self reStart];
//    }
    
    
    if (self.progressBlock) {
        self.progressBlock(self.totalLength,self.downloadLength);
    }
}

/**
 * 任务完成的时候调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
//    [self.stream close];
//    self.stream = nil;
//    
//    // 一个任务对应一个文件，用完清空
//    self.task = nil;
    
    
    

    
    
    
    
   
    
    if (error) {
        if (self.failBlock) {
            self.failBlock(error);
        }
    }else{
        NSFileManager * manager = [NSFileManager defaultManager];
        
        [manager moveItemAtPath:ChaosFileFullPath toPath:self.successPath error:nil];
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
    
    
    [self downloadStopOrSuccess];
    [self startNext];
    
}

- (void)downloadStopOrSuccess{
    _stream = nil;
    
    // 一个任务对应一个文件，用完清空
    _task = nil;
    self.downloadLength = 0;
    self.totalLength = 0;
    NSLog(@"用完清空 - downloadStopOrSuccess");
    NSLog(@"----------");
//    
//    self.ChaosFileURL = nil;
//    self.ChaosFileName = nil;
//    self.ChaosFileType = nil;
}

- (void)downResWithBookUrl:(NSString *)bookUrl fileName:(NSString *)fileName{
    
    
    
    
    NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]]];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
#pragma mark 下载进度
    
    

    
    
    

 
    
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],fileName];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
    NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
    
//    GDSessionManager*_manager  = [[GDSessionManager alloc] initWithUrl:bookUrl FileName:[NSString stringWithFormat:@"%@.zip",bookId] ChaosFileType:@"" successPath:filePathBase];
    
    [self startWithProgressblock:^(long long totalLength, long long downloadLength) {

    } CompletionBlock:^{
        NSLog(@"CompletionBlock");
        //        return ;
        NSLog(@"filePathBase = %@",filePathBase);
  
        
//        1.解压
        
        
        
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
        [Utils unArchive:filePathBase andPassword:nil destinationPath:filePathDest completionBlock:^{
            
        } failureBlock:^{
            
        }];
        
        NSString *strFile = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],fileName];
        if ([strFile containsString:ArchiveType]) {
            strFile = [strFile stringByReplacingOccurrencesOfString:ArchiveType withString:@""];
            strFile = [strFile substringToIndex:strFile.length - 1];
        }
        NSString *filePathBaseFile = [NSHomeDirectory() stringByAppendingPathComponent:strFile];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filePathBaseFile]) {
            NSString * progress = @"可用";
            [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"task":self.task,@"taskState":@(self.task.state)}];
            
        }else{
            NSString * progress = @"解压失败";
            [[NSNotificationCenter  defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:@{@"text":progress,@"task":self.task,@"taskState":@(self.task.state)}];
            
        }
        

        
////        2.判断队列中是否还有未下载教材,如果有,则下载
//        NSMutableArray * arrDownloadQueue = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KeyArrDownloadQueue]];
//        if (arrDownloadQueue.count>0) {
//            NSDictionary * info = arrDownloadQueue.firstObject;
//            [arrDownloadQueue removeObject:info];
//            [[NSUserDefaults standardUserDefaults] setObject:arrDownloadQueue forKey:KeyArrDownloadQueue];
//            [self addToDownloadQueueWithUrl:info[@"url"] FileName:info[@"fileName"] ChaosFileType:info[@"chaosFileType"] successPath:info[@"successPath"]];
//            
//            
//        }
        
    } failBlock:^(NSError *error) {
        NSLog(@"failBlock");
        
        
    }];
    
    
    
    
}


@end
