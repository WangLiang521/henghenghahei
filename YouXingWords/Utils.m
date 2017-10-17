//
//  Utils.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "Utils.h"
#import "PassModel.h"
@implementation Utils

+(void)showAlter:(NSString *)message;
{
    UIAlertView *alter=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:ALTERTIME target:self selector:@selector(timerAction:) userInfo:alter repeats:NO];
    [alter show];
}
+(void)showAlter:(NSString *)message WithTime:(NSInteger)time;
{
    UIAlertView *alter=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAction:) userInfo:alter repeats:NO];
    [alter show];
}

+(void)timerAction:(NSTimer *)timer
{
    UIAlertView *alter=(UIAlertView *)[timer userInfo];
    [alter dismissWithClickedButtonIndex:0 animated:YES];
}

+(NSString *)getCurrentToken
{
    NSString *tokenStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    return [Utils isValidStr:tokenStr]?tokenStr:@"";
}

+(void)clearToken{
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"toekn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    BOOL saveSuccess = [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"clearToken = %d",saveSuccess);
}


+(NSString *)getResFolder{
    return @"res";
}




+(NSString *)getImageFolderWithQImage:(NSString *)qImage{

    NSString *str7z = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],qImage];

    return path;
}


+(NSDictionary *)getDictWithPath:(NSString *)finalPath{
    NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];

    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];

    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *firstDic = nil;
    NSError *error;
    if (data) {
        firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    
    return firstDic;
}


+(NSString *)getCurrentUserName
{
    NSString *tokenStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
    if (![Utils isValidStr:tokenStr]) {
        return @"weidenglu";
    }
    return tokenStr;
}

+(NSNumber*)getCoinsCount{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSNumber * coins = @([userInfo[@"coins"] integerValue]);
    return coins;
}

+(NSDictionary *)getCurrentUserInfo
{
    NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    return userInfo;

}

+(NSString *)getDateStrByTimeStamp:(id)timeStamp;
{
    NSString *returnStr;
    NSString*str= [NSString stringWithFormat:@"%@",timeStamp];//时间戳
    NSTimeInterval lateTimeInterval=[str doubleValue]/1000;
    //当前时间
    NSDate *nowDate=[NSDate date];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    //计算时间差
    NSTimeInterval resultTime = nowTimeInterval - lateTimeInterval;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:lateTimeInterval];
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //根据时间戳获取年份
    NSDate *lateYearDate=[NSDate dateWithTimeIntervalSince1970:lateTimeInterval];
    NSDateFormatter *lateYear = [[NSDateFormatter alloc]init];
    [lateYear setDateFormat:@"yyyy"];
    NSString *lateYearStr = [lateYear stringFromDate:lateYearDate];
    //获取今年的年份
    NSDate *curYearDate=[NSDate date];
    NSDateFormatter *curYear = [[NSDateFormatter alloc]init];
    [curYear setDateFormat:@"yyyy"];
    NSString *curYearStr = [lateYear stringFromDate:curYearDate];
    //获取今天的日期
    NSDate *curDayDate=[NSDate date];
    NSDateFormatter *curDay = [[NSDateFormatter alloc]init];
    [curDay setDateFormat:@"HH:mm:ss"];
    NSString *curDayStr = [curDay stringFromDate:curDayDate];
    //获取当天的小时，分钟，秒数
    NSTimeInterval hour=[[curDayStr substringWithRange:NSMakeRange(0, 2)] doubleValue];
    NSTimeInterval min=[[curDayStr substringWithRange:NSMakeRange(3, 2)] doubleValue];
    NSTimeInterval sec=[[curDayStr substringWithRange:NSMakeRange(6, 2)] doubleValue];
    //当天的时间戳
    NSTimeInterval todayTimeInterVal=hour*60*60+min*60+sec;
    
    //根据时间差判断
    if (resultTime<=60) {
        returnStr=@"刚刚";
    }else if(60<resultTime&&resultTime<=3600){
        double min = resultTime/60;
        returnStr=[NSString stringWithFormat:@"%.f分钟之前",min];
    }else if (3600<resultTime&&resultTime<=todayTimeInterVal){
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        returnStr=currentDateStr;
    }else if (todayTimeInterVal<resultTime&&resultTime<=(todayTimeInterVal+60*60*24)){
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        returnStr=[NSString stringWithFormat:@"昨天 %@",currentDateStr];
    }else if ((todayTimeInterVal+60*60*24)<resultTime&&resultTime<=(todayTimeInterVal+60*60*24*2)){
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        returnStr=[NSString stringWithFormat:@"前天 %@",currentDateStr];
    }else if((todayTimeInterVal+60*60*24*2)<resultTime&&[lateYearStr isEqualToString:curYearStr]){
        //        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        returnStr=[NSString stringWithFormat:@"%@",currentDateStr];
    }else{
        //        NSString *str=@"yyyy年MM月dd日 \n HH:mm:ss";
        NSString *str=@"yyyy年MM月dd日";
        [dateFormatter setDateFormat:str];
        NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
        returnStr=[NSString stringWithFormat:@"%@",currentDateStr];
    }
    return returnStr;
}
+(NSString *)changeByTimeStamp:(id)timeStamp
{
    NSString*str= [NSString stringWithFormat:@"%@",timeStamp];//时间戳
    NSTimeInterval lateTimeInterval=[str doubleValue]/1000;
    //根据时间戳获取年份
    NSDate *lateYearDate=[NSDate dateWithTimeIntervalSince1970:lateTimeInterval];
    NSDateFormatter *lateYear = [[NSDateFormatter alloc]init];
    [lateYear setDateFormat:@"MM月dd日 HH:mm:ss"];
    NSString *lateYearStr = [lateYear stringFromDate:lateYearDate];
    return lateYearStr;
}
+(NSString *)timeByTimeStamp:(id)timeStamp
{
    NSString*str= [NSString stringWithFormat:@"%@",timeStamp];//时间戳
    NSTimeInterval lateTimeInterval=[str doubleValue]/1000;
    //根据时间戳获取年份
    NSDate *lateYearDate=[NSDate dateWithTimeIntervalSince1970:lateTimeInterval];
    NSDateFormatter *lateYear = [[NSDateFormatter alloc]init];
    [lateYear setDateFormat:@"MM月dd日 HH:mm"];
    NSString *lateYearStr = [lateYear stringFromDate:lateYearDate];
    return lateYearStr;
}

+(NSString *)wltimeByTimeStamp:(id)timeStamp
{
    NSString*str= [NSString stringWithFormat:@"%@",timeStamp];//时间戳
    NSTimeInterval lateTimeInterval=[str doubleValue]/1000;
    //根据时间戳获取年份
    NSDate *lateYearDate=[NSDate dateWithTimeIntervalSince1970:lateTimeInterval];
    NSDateFormatter *lateYear = [[NSDateFormatter alloc]init];
    [lateYear setDateFormat:@"MM月dd日"];
    NSString *lateYearStr = [lateYear stringFromDate:lateYearDate];
    return lateYearStr;
}

+(NSTimeInterval)getCurrentTimeStamp
{
    //当前时间
    NSDate *nowDate=[NSDate date];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    return nowTimeInterval*1000;
}




+(CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width  {
    if ( text == nil || font == nil || width <= 0) {
        return 0 ;
    }
    CGSize size;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil ].size ;
    return size.height ;
    
}



//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSDictionary *)getCurrentQsTxtDict
+(NSDictionary *)getCurrentQsTxtDictWith:(BreakthroughType)type
//end
{
    
    
    //解析qs.txt
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:type],@"txt/qs.txt"];
    //end
    

    

    NSError * error1 = nil;
    NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:&error1];
    
    
//    for (int i = 1; i <= 15; i ++) {
//        NSError * error1 = nil;
//        NSString *dataStrw = [[NSString alloc]initWithContentsOfFile:finalPath encoding:i error:&error1];
//        NSLog(@"i = %d,dataStr = %@",i,dataStrw);
//    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        NSLog(@"fileExistsAtPath");
        if (dataStr) {
            NSLog(@"有了");
        }
    } else{
        NSLog(@"not   fileExistsAtPath");
        if (dataStr) {
            NSLog(@"有了");
        }
    }
    
    
    
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    //start
#pragma mark xl_加了个单引号  7.30-15：18
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
//    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //end
    
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return firstDic;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSArray *)getCurrentQsTxtQsArray
+(NSArray *)getCurrentQsTxtQsArrayWith:(BreakthroughType)type
//end
{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSArray *listArr = [[self getCurrentQsTxtDict] valueForKey:@"datas"];
    NSArray *listArr = [[self getCurrentQsTxtDictWith:type] valueForKey:@"datas"];
    //end
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i=1; i<listArr.count; i++) {
        PassModel *model = [PassModel modelWithDic:listArr[i]];
        [array addObject:model];
    }
    return [NSArray arrayWithArray:array];
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSDictionary *)getCurrentQsJsonDict
+(NSDictionary *)getCurrentQsJsonDictWith:(BreakthroughType)type
//end
{


    //解析wordInfos.json
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:type],@"txt/wordInfos.json"];
    //end

    


    //    NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
    //    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:finalPath];
//    NSError *error;
//    NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

#pragma mark gd_修改获取资源包方式
    NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
    NSError *error;

    return firstDic;
}



//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+ (void)creatTxtTimuDictWith:(NSDictionary *)dict
+ (void)creatTxtTimuDictWith:(NSDictionary *)dict With:(BreakthroughType)type
//end
{

    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/timuDict.txt"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:type],@"txt/timuDict.txt"];
    //end
    

    NSFileManager *fileManager = [NSFileManager defaultManager];


    if ([fileManager fileExistsAtPath:finalPath]) {
        [fileManager removeItemAtPath:finalPath error:nil];
    }

    BOOL res=[fileManager createFileAtPath:finalPath contents:nil attributes:nil];

    if (res) {
//        NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//        if (data) {
//            NSString * strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [strData writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        }
        NSString * str = [Utils convertToJSONData:dict];
        [str writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+ (NSDictionary *)getTxtTimuDict
+ (NSDictionary *)getTxtTimuDictWith:(BreakthroughType)type
//end
{
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/timuDict.txt"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:type],@"txt/timuDict.txt"];
    //end
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:finalPath];
        NSError *error;
        if (data) {
            NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            return firstDic;
        }
    }

    return nil;
}

+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    NSString *jsonString = @"";

    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符

    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    return jsonString;
}

+ (BOOL) isNilOrNSNull:(id)object {
    return object == nil || [object isKindOfClass:[NSNull class]];
}

+ (BOOL) isNonnull:(id)object{
    return !(object == nil || object == NULL || object == [NSNull null] || [[NSString stringWithFormat:@"%@",object] isEqualToString:@"null"]);
}

+ (BOOL) isValidStr:(NSString *)str{
    return (([self isNonnull:str] && ([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]) && str.length > 0) && ([str rangeOfString:@"null"].location == NSNotFound));
}

//+ (BOOL) isValidStr:(NSString *)str{
//    return [self isNonnull:str] && ([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]) && str.length > 0;
//}

+ (BOOL) isValidData:(NSData *)data{
    return [self isNonnull:data] && ([data isKindOfClass:[NSData class]] || [data isKindOfClass:[NSMutableData class]]) && data.length > 0;
}

+ (BOOL) isValidArray:(NSArray *)array{
    return [self isNonnull:array] && ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) && array.count > 0;
}

+ (BOOL) isValidDictionary:(NSDictionary *)dict{
    return [self isNonnull:dict] && ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]]) && dict.count > 0;
}



+ (NSString *)contentTypeForImageData:(NSData *)data {

    uint8_t c;

    [data getBytes:&c length:1];

    switch (c) {

        case 0xFF:

            return @"jpeg";

        case 0x89:

            return @"png";

        case 0x47:

            return @"gif";

        case 0x49:

        case 0x4D:

            return @"tiff";

        case 0x52:

            if ([data length] < 12) {

                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            
            return nil;
            
    }
    
    return nil;
    
}


#pragma mark - 解压缩
+ (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath completionBlock:(void(^)())completionBlock failureBlock:(void(^)())failureBlock{
    
    @try {
        NSAssert(filePath, @"can't find filePath");
        
        SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc] initWithPath:filePath];
        
        if (password != nil && password.length > 0) {
            unarchive.password = password;
        }
        
        if (destPath != nil) {
            
            // (Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
            unarchive.destinationPath = destPath;
        }
        
        unarchive.completionBlock = ^(NSArray *filePaths) {
            
            NSLog(@"For Archive : %@", filePath);
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
                
                NSLog(@"US Presidents app is installed.");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
            }
            
            for (NSString *filename in filePaths) {
                //            NSLog(@"File: %@", filename);
            }
        };
        
        unarchive.failureBlock = ^(){
            NSLog(@"Cannot be unarchived");
        };
        
        [unarchive decompress];
        
        if ([ArchiveType isEqualToString:@"7z"]) {
            
            if (!destPath) {
                NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                destPath = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
            }
            
            NSString * str7zPath = [destPath stringByAppendingString:@"/7z"];
            NSFileManager * fManager = [NSFileManager defaultManager];
            if ([fManager fileExistsAtPath:str7zPath]) {
                NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:str7zPath error:nil];
                
                for (NSString * realPath in contents) {
                    NSString * fullPath = [str7zPath stringByAppendingFormat:@"/%@",realPath];
                    NSError * error = nil;
                    destPath = [destPath stringByAppendingFormat:@"/%@",realPath];
                    [fManager moveItemAtPath:fullPath toPath:destPath error:&error];
                    NSLog(@"error = %@",error.localizedDescription);
                }
                
                [fManager removeItemAtPath:str7zPath error:nil];
                
            }
        }

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
//    NSAssert(filePath, @"can't find filePath");
//    
//    NSLog(@"unArchive  --  解压缩");
//    NSLog(@"filePath = %@",filePath);
//    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
//    if (password != nil && password.length > 0) {
//        unarchive.password = password;
//    }
//    
//    if (destPath != nil){
//        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
//    }
//    
//    unarchive.completionBlock = ^(NSArray *filePaths){
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
//            NSLog(@"US Presidents app is installed.");
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
//        }
//        
//        for (NSString *filename in filePaths) {
//            //            NSLog(@"File: %@", filename);
//        }
//        
//        if (completionBlock) {
//            completionBlock();
//        }
//    };
//    unarchive.failureBlock = ^(){
//        //        NSLog(@"Cannot be unarchived");
//        if (failureBlock) {
//            failureBlock();
//        }
//    };
//    [unarchive decompress];

//    NSAssert(filePath, @"can't find filePath");
//    
//    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc] initWithPath:filePath];
//    
//    if (password != nil && password.length > 0) {
//        unarchive.password = password;
//    }
//    
//    if (destPath != nil) {
//        
//        // (Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
//        unarchive.destinationPath = destPath;
//    }
//    
//    unarchive.completionBlock = ^(NSArray *filePaths) {
//        
//        NSLog(@"For Archive : %@", filePath);
//        
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
//            
//            NSLog(@"US Presidents app is installed.");
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
//        }
//        
//        for (NSString *filename in filePaths) {
//            NSLog(@"File: %@", filename);
//        }
//
//        if (completionBlock) {
//            completionBlock();
//        }
//    };
//    
//    unarchive.failureBlock = ^(){
//        NSLog(@"Cannot be unarchived");
//        if (failureBlock) {
//            failureBlock();
//        }
//    };
//    
//    [unarchive decompress];


}

#define TimeString13 [NSString stringWithFormat:@"getCurrentTimeString13%@",[Utils getCurrentUserName]]

+ (void)saveStartTime{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    
    [userD setObject:[LGDUtils getCurrentTimeString13] forKey:TimeString13];
    [userD synchronize];

}

+(NSString *)getStartTime{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSString * current = [userD objectForKey:TimeString13];

    return current;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getPathCurrentQsTxt
+(NSString *)getPathCurrentQsTxtWith:(BreakthroughType)type
//end
{
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:type],@"txt/qs.txt"];
    //end
    
    return finalPath;
}




//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getPathNoteBookQsArray
+(NSString *)getPathNoteBookQsArrayWith:(BreakthroughType)type
//end
{
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/txt/%@NoteBookQsArray.txt",filePathBase,[AnswerTools getBookID],[self getCurrentUserName]];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/txt/%@NoteBookQsArray.txt",filePathBase,[AnswerTools getBookIDWith:type],[self getCurrentUserName]];
    //end
    
    return finalPath;
}





@end
