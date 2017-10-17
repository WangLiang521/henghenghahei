//
//  FileManagerHelper.h
//  FileManager-Demo
//
//  Created by wangliang on 2016/11/30.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerHelper : NSObject


@property (strong, nonatomic)  NSFileManager *fileManager;


+(instancetype)share;
//创建文件夹
+ (BOOL)creatDirectoryInHomeDirectoryWithPath:(NSString *)path;
//创建文件
+(BOOL)creatFileInHomeDirectoryWithPath:(NSString *)path;

+(BOOL)writeArrayToFileInHomeDirectoryWithPath:(NSString *)path Array:(NSArray *)array Atomically:(BOOL)useAuxiliaryFile;

+(BOOL)writeDictionaryToFileInHomeDirectoryWithPath:(NSString *)path Dictionary:(NSDictionary *)dictionary Atomically:(BOOL)useAuxiliaryFile;

+(NSString *)readStringInHomeDirectoryWithPath:(NSString *)path;

+(NSMutableDictionary *)readDictionaryInHomeDirectoryWithPath:(NSString *)path;

+(NSMutableArray *)readArrayInHomeDirectoryWithPath:(NSString *)path;

+ (NSString *)getHomeDirectoryPathWithLastPath:(NSString*)path;


#pragma mark gd_youxing 
//断网时,用这个方法保存用户闯关信息,这个字典可以直接作为params使用,但是需要替换token. 
+ (void)savePassInfoWithDic:(NSDictionary *)dic;
+(void)updatePassInfoWithArray:(NSArray *)array;
+ (NSMutableArray *)getPassInfo;


@end
