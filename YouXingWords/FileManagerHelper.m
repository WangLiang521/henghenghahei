//
//  FileManagerHelper.m
//  FileManager-Demo
//
//  Created by wangliang on 2016/11/30.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "FileManagerHelper.h"




@implementation FileManagerHelper

+(instancetype)share{
    static FileManagerHelper * f = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        f = [[FileManagerHelper alloc] init];
    });
    return f;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

+(BOOL)creatDirectoryInHomeDirectoryWithPath:(NSString *)path{
    path = [FileManagerHelper getHomeDirectoryPathWithLastPath:path];

//    if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
//        return YES;
//    }
    
    BOOL isDir = YES;

    BOOL existed = [[FileManagerHelper share].fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir == YES && existed == YES)
    {
        return YES;
//        [[FileManagerHelper share].fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    return [[FileManagerHelper share].fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+(BOOL)creatFileInHomeDirectoryWithPath:(NSString *)path{
    path = [FileManagerHelper getHomeDirectoryPathWithLastPath:path];
    if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return [[FileManagerHelper share].fileManager createFileAtPath:path contents:nil attributes:nil];
}


+(BOOL)writeArrayToFileInHomeDirectoryWithPath:(NSString *)path Array:(NSArray *)array Atomically:(BOOL)useAuxiliaryFile{

    if ([self creatFileInHomeDirectoryWithPath:path]) {
        return [array writeToFile:[FileManagerHelper getHomeDirectoryPathWithLastPath:path] atomically:useAuxiliaryFile];
    }

    return NO;
}

+(BOOL)writeDictionaryToFileInHomeDirectoryWithPath:(NSString *)path Dictionary:(NSDictionary *)dictionary Atomically:(BOOL)useAuxiliaryFile{

    if ([self creatFileInHomeDirectoryWithPath:path]) {
//        NSString * strData = [dictionary]
//        [path writeToFile:path atomically:<#(BOOL)#> encoding:<#(NSStringEncoding)#> error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
        return [dictionary writeToFile:[FileManagerHelper getHomeDirectoryPathWithLastPath:path] atomically:useAuxiliaryFile];
    }

    return NO;
}

+(NSString *)readStringInHomeDirectoryWithPath:(NSString *)path
{

    path = [FileManagerHelper getHomeDirectoryPathWithLastPath:path];

    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];  ;
}

+(NSMutableDictionary *)readDictionaryInHomeDirectoryWithPath:(NSString *)path
{

    path = [FileManagerHelper getHomeDirectoryPathWithLastPath:path];

//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSError *error;
//    if (data) {
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        return dict;
//    }

    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

+(NSMutableArray *)readArrayInHomeDirectoryWithPath:(NSString *)path
{
    path = [FileManagerHelper getHomeDirectoryPathWithLastPath:path];

    return [NSMutableArray arrayWithContentsOfFile:path];
}




+ (NSString *)getHomeDirectoryPathWithLastPath:(NSString*)path{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",path]];
}


#pragma mark gd_youxing
+ (void)savePassInfoWithDic:(NSDictionary *)dic{
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
//    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[[NSUserDefaults standardUserDefaults] objectForKey:@""]];
    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[Utils getCurrentUserName]];
    //end
    NSMutableArray * array = [FileManagerHelper readArrayInHomeDirectoryWithPath:path];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:dic];
    [FileManagerHelper writeArrayToFileInHomeDirectoryWithPath:path Array:array Atomically:NO];
}

+(void)updatePassInfoWithArray:(NSArray *)array{
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
    //    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[[NSUserDefaults standardUserDefaults] objectForKey:@""]];
    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[Utils getCurrentUserName]];
    //end
    [FileManagerHelper writeArrayToFileInHomeDirectoryWithPath:path Array:array Atomically:NO];
}

+ (NSMutableArray *)getPassInfo{
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
    //    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[[NSUserDefaults standardUserDefaults] objectForKey:@""]];
    NSString * path = [NSString stringWithFormat:@"%@/unUploadAnswers.txt",[Utils getCurrentUserName]];
    //end
    NSMutableArray * array = [self readArrayInHomeDirectoryWithPath:path];
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
}




@end
