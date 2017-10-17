//
//  PassList.m
//  YouXingWords
//
//  Created by tih on 16/9/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PassList.h"
#import "QsModel.h"
#import "PassModel.h"
@interface PassList ()
/**
 *  不包含复习关的 当前 index，主要用于解锁下一关 ,用于操作本地 plist 因为里面不包含复习关
 */
@property (nonatomic,assign)NSInteger current;
/**
 *  包含复习关在内，当前 index ，主要用于下一题，用于操作各个关卡题目 listArray 因为里面包含了复习关
 */
@property (assign, nonatomic)  NSInteger currentIndexInAll;

@end
@implementation PassList

static PassList * _instance = nil;
+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+(void)setList:(NSMutableArray *)list{
#pragma mark gd_初始化全局数组,方法过关_tag
    [PassList defaultManager].list =list;
}



//start
#pragma mark gd_更改获取 currentIndex 的方式  <#时间#>-<#编号#>
+(void)setCurrent:(NSInteger)current{
//
    [PassList defaultManager].currentIndexInAll = current;
}

- (void)setCurrentModel:(PassModel *)currentModel{
    _currentModel = currentModel;
    if (![currentModel.passName isEqualToString:@"复习关"]) {
        NSString * passIndex  = [currentModel.passName substringWithRange:NSMakeRange(1, currentModel.passName.length - 2)];
        [PassList defaultManager].current = [passIndex integerValue] - 1;
    }else{
        [PassList defaultManager].current = self.indexFuxiguan;
    }
    
}



//end






+(PassModel *)getNext{

    //start
#pragma mark gd_修改下一题的获取方式  2017-03-31 10:51:22-<#编号#>
//    NSArray * list = [PassList defaultManager].list;
//    PassModel * model = [PassList defaultManager].list[ [PassList defaultManager].current ];
//    PassModel * nmodel = [PassList defaultManager].list[ [PassList defaultManager].current +1 ];
    
    NSInteger nextIndex = [PassList defaultManager].currentIndexInAll +1;
    if ([PassList defaultManager].list.count > nextIndex) {
        NSInteger index = [PassList defaultManager].currentIndexInAll +1;
        PassModel * model = [PassList defaultManager].currentModel;
        PassModel * nmodel = [PassList defaultManager].list[nextIndex];
        NSArray * array = [PassList defaultManager].list;
        [PassList defaultManager].currentModel = nmodel;
        [PassList defaultManager].currentIndexInAll = index;
    }
     return [PassList defaultManager].currentModel;
    //    [PassList defaultManager].current+=1;
    //    if ([PassList defaultManager].current<[PassList defaultManager].list.count) {
    //        return [PassList defaultManager].list[[PassList defaultManager].current];
    //
    //    }
    //    [PassList defaultManager].current-=1;
    //
    //    return [PassList defaultManager].list[ [PassList defaultManager].current ];
    //end
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(BOOL)canGetNext
+(BOOL)canGetNextWith:(BreakthroughType)type
//end
{
    
    BOOL flag = NO;

//    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *path = [PassList getIfLockArrayPath];
    NSString *path = [PassList getIfLockArrayPathWith:type];
    //end
    
    NSArray * _ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (!_ifLockArray) {
        return NO;
    }else{
        
        NSInteger nextIndex = [PassList defaultManager].currentIndexInAll +1;
//        这个判断保证数组不越界
        if ((nextIndex<[PassList defaultManager].list.count) && (_ifLockArray.count > [PassList defaultManager].current+1)) {
            
            
//            判断下一关是否是复习关

            NSArray * list = [PassList defaultManager].list;
            PassModel * model = [PassList defaultManager].list[nextIndex];
            if ([model.passName isEqualToString:@"复习关"]) {
                return YES;
            }
            
//            判断下一关是否已经解锁
            if (![[_ifLockArray[[PassList defaultManager].current+1] valueForKey:@"ifLock"]isEqualToNumber:@0]) {
                
                flag = YES;
            }
            
            
        }
    }
    
    
    

    return flag;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getIfLockArrayPath
+(NSString *)getIfLockArrayPathWith:(BreakthroughType)type
//end
{
//     NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
    
    NSString *path = [self getCurrentUserDirPath];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    path = [path stringByAppendingFormat:@"/%@",[AnswerTools getBookID]];
//    [FileManagerHelper creatDirectoryInHomeDirectoryWithPath:[NSString stringWithFormat:@"%@/%@",[Utils getCurrentUserName],[AnswerTools getBookID]]];
    path = [path stringByAppendingFormat:@"/%@",[AnswerTools getBookIDWith:type]];
    [FileManagerHelper creatDirectoryInHomeDirectoryWithPath:[NSString stringWithFormat:@"%@/%@",[Utils getCurrentUserName],[AnswerTools getBookIDWith:type]]];
    //end
   
    path = [path stringByAppendingString:@"/ifLockArray.plist"];
    
    return path;
}

+(NSString *)getCurrentUserDirPath
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],[Utils getCurrentUserName]];
    
    return path;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)refreshFuxitiWithResponse:(NSArray *)fuxitiArray
+(void)refreshFuxitiWithResponse:(NSArray *)fuxitiArray With:(BreakthroughType)type
//end
{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString * currentUserDirPath = [self getFuxitiPath];
    NSString * currentUserDirPath = [self getFuxitiPathWith:type];
    //end
    
    //    [FileManagerHelper writeDictionaryToFileInHomeDirectoryWithPath:currentUserDirPath Dictionary:response Atomically:NO];
    [FileManagerHelper writeArrayToFileInHomeDirectoryWithPath:currentUserDirPath Array:fuxitiArray Atomically:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(fuxitiArray.count) forKey:KeyUserCuotiCount(type)];
    
    
    if ([PassList defaultManager].list.count > 0) {
        
        
        NSInteger insertIndex = 0;
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *path = [self getIfLockArrayPath];
        NSString *path = [self getIfLockArrayPathWith:type];
        //end

        
        NSMutableArray * ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
//        for (NSInteger i = ifLockArray.count - 1; i >= 0; i --) {
//            NSDictionary * dict = ifLockArray[i];
//            if (dict[@"isFuxiguan"] && [dict[@"isFuxiguan"] integerValue] == 1) {
//                [ifLockArray removeObject:dict];
//                
////                删除 PassList 中的 复习关
//                if ([PassList defaultManager].list.count > i) {
//                    PassModel * model = [PassList defaultManager].list[i];
//                    if ([model.passName isEqualToString:@"复习关"]) {
//                        [[PassList defaultManager].list removeObject:model];
//                    }
//                }
//            }
//        }
        
//        重置复习关之前,复习关所在 index
        NSInteger beforeFuxiguanIndex = [PassList defaultManager].indexFuxiguan;
        
        if ( [PassList defaultManager].indexFuxiguan != -1) {
            NSInteger indexFuxi = [PassList defaultManager].indexFuxiguan;
            PassModel * model = [PassList defaultManager].list[indexFuxi];
            if ([model.passName isEqualToString:@"复习关"]) {
                [[PassList defaultManager].list removeObject:model];
            }else{
                for (PassModel * qmodel in [PassList defaultManager].list) {
                    if ([qmodel.passName isEqualToString:@"复习关"]) {
                        [[PassList defaultManager].list removeObject:qmodel];
                    }
                }
            }
        }
        
        
        
        if (fuxitiArray.count > CountWrongWordsCallFuxi) {
            for (NSInteger i = 0; i < ifLockArray.count; i ++) {
                NSDictionary * dict = ifLockArray[i];
                if ([dict[@"ifLock"] integerValue] == 0){
                    insertIndex = i ;
                    break;
                }
            }
            if (insertIndex > 0) {
                insertIndex --;
            }
            
            
            if ([PassList defaultManager].list.count > insertIndex) {
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                PassModel * fuxiModel = [PassList getFuxiti];
                PassModel * fuxiModel = [PassList getFuxitiWith:type];
                //end
                
                [[PassList defaultManager].list insertObject:fuxiModel atIndex:insertIndex];
                [PassList defaultManager].indexFuxiguan = insertIndex;
                
                
                
                if ([PassList defaultManager].currentIndexInAll > beforeFuxiguanIndex && [PassList defaultManager].currentIndexInAll < insertIndex) {
                     [PassList defaultManager].currentIndexInAll -= 1;
                }
                
                if ([PassList defaultManager].current > beforeFuxiguanIndex && [PassList defaultManager].current < insertIndex) {
                    [PassList defaultManager].current -= 1;
                }
            }
        }else if(beforeFuxiguanIndex != -1){ //不等于-1 说明之前有复习关 ,但是进入到这个 if 里说明现在没有复习关了
            
//            之前存在复习关,但是,新做题之后,没有复习关了,这样,需要把 index 改掉,这些 index 包括三个:[PassList defaultManager].indexFuxiguan, [PassList defaultManager].current,[PassList defaultManager].currentIndexInAll
            [PassList defaultManager].indexFuxiguan = -1;  //没有复习关 indexFuxiguan 填-1
            
            if ([PassList defaultManager].current > beforeFuxiguanIndex) {
                [PassList defaultManager].current -= 1;
            }
            
            if ([PassList defaultManager].currentIndexInAll > beforeFuxiguanIndex) {
                [PassList defaultManager].currentIndexInAll -= 1;
            }
            
            
        }

    }
    
    
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)insertFuxiGuanWithDicFuxiti:(NSDictionary *)dicFuxiti
+(void)insertFuxiGuanWithDicFuxiti:(NSDictionary *)dicFuxiti With:(BreakthroughType)type
//end
{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *path = [self getIfLockArrayPath];
    NSString *path = [self getIfLockArrayPathWith:type];
    //end
    
    NSMutableArray * ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (!ifLockArray) {
        return;
    }else{
 
        //start
#pragma mark gd_复习关出现的位置改为最后一个解锁关卡之后  2017-03-22 10:08:38-1
//        NSInteger insertIndex = [PassList defaultManager].current + 1;
        NSInteger insertIndex = 0;
        for (NSInteger i = ifLockArray.count - 1; i >= 0; i --) {
            NSDictionary * dict = ifLockArray[i];
            if (dict[@"isFuxiguan"] && [dict[@"isFuxiguan"] integerValue] == 1) {
                [ifLockArray removeObject:dict];
            }
        }
        
        for (NSInteger i = 0; i <= ifLockArray.count; i ++) {
            NSDictionary * dict = ifLockArray[i];
           if ([dict[@"ifLock"] integerValue] == 0){
                insertIndex = i ;
                break;
            }
        }
        if (insertIndex > 0) {
            insertIndex --;
        }
        //end
        
       
        
        
        NSUInteger creatTime = [Utils getCurrentTimeStamp];
        
        
        
        if (ifLockArray.count >= insertIndex) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@1 forKey:@"ifLock"];
            [dic setValue:@0 forKey:@"Udiamond"];
            [dic setValue:@1 forKey:@"isFuxiguan"];
            [dic setValue:@(creatTime) forKey:@"creatTime"];
            [ifLockArray insertObject:dic atIndex:insertIndex];
            
            
            [ifLockArray writeToFile:path atomically:NO];
            
            
//            NSMutableArray * arraySave = [NSMutableArray array];
//            //        只保留刚添加的复习关,其余删除
//            for (int i = 0  ; i < ifLockArray.count ; i++) {
//                NSDictionary * dict = ifLockArray[i];
//                NSNumber * ctime = dict[@"creatTime"];
//                if (!ctime || [ctime integerValue] == 0 || ([ctime integerValue] - creatTime == 0)) {
//                    [arraySave addObject:dict];
//                }
//
//            }
//            
//            
//            
//            
//            [arraySave writeToFile:path atomically:NO];
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            NSString * currentUserDirPath = [self getFuxitiPath];
            NSString * currentUserDirPath = [self getFuxitiPathWith:type];
            //end
            
            [FileManagerHelper writeDictionaryToFileInHomeDirectoryWithPath:currentUserDirPath Dictionary:dicFuxiti Atomically:NO];
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            PassModel * fuxiModel = [PassList getFuxiti];
            PassModel * fuxiModel = [PassList getFuxitiWith:type];
            //end
            
            [[PassList defaultManager].list insertObject:fuxiModel atIndex:insertIndex];
        }
 
    }
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(NSString *)getFuxitiPath
+(NSString *)getFuxitiPathWith:(BreakthroughType)type
//end
{
    NSString * currentUserDirPath = [Utils getCurrentUserName];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    currentUserDirPath = [currentUserDirPath stringByAppendingFormat:@"/fuxiti%@.txt",[AnswerTools getBookID]];
    currentUserDirPath = [currentUserDirPath stringByAppendingFormat:@"/fuxiti%@.txt",[AnswerTools getBookIDWith:type]];
    //end
    
    return currentUserDirPath;
}

+(NSString *)getBookQstxtPathWithBookId:(NSNumber *)bookId{
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];

    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,bookId,@"txt/qs.txt"];
    return finalPath;
}

/**
 *  获取 book 文件夹 路径
 */
+(NSString *)getBookDirePathWithBookId:(NSNumber *)bookId{
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,bookId,@"txt/qs.txt"];
    return finalPath;
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(PassModel *)getFuxiti
+(PassModel *)getFuxitiWith:(BreakthroughType)type
//end
{
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString * fuxitiPath = [self getFuxitiPath];
    NSString * fuxitiPath = [self getFuxitiPathWith:type];
    //end
    

    //start
#pragma mark gd_更改复习题方式  2017-03-30 21:49:42
    //    后台传的错题本信息
    //    NSDictionary * dictFuxiti = [FileManagerHelper readDictionaryInHomeDirectoryWithPath:fuxitiPath];
    //    后台传的错题本中的错题
    //    NSArray * cuotiArray = dictFuxiti[@"data"];
    NSArray * cuotiArray = [FileManagerHelper readArrayInHomeDirectoryWithPath:fuxitiPath];
    //end
    
//    出出来的复习题
    NSMutableArray * fuxitiArray = [NSMutableArray array];
    
    
//    错题包含哪些教材
    NSMutableDictionary * jiaocaiDict = [NSMutableDictionary dictionary];

    
//    应该出题的单词 1.取9个 2.要判断bookId ,看是不是有这个单词
    NSMutableArray * yingchuArray = [NSMutableArray array];
    
    
    
    
//    1.检出应该出的题目,以及出题教材
    for (int i = 0; i < cuotiArray.count; i++) {
//        错题
        NSDictionary * dictCuoti = cuotiArray[i];
        
        NSString * finalPath = [self getBookQstxtPathWithBookId:dictCuoti[@"bookId"]];
//        如果当前教材没下载那就不出这道题了
        if (![[NSFileManager defaultManager]fileExistsAtPath:finalPath]) {
            continue;
        }
        
        [yingchuArray addObject:dictCuoti];
        NSString * bookId = [NSString stringWithFormat:@"%@",dictCuoti[@"bookId"]];
        
//        [yingchuDict setObject:bookId forKey:dictCuoti];
        
        if (!jiaocaiDict[bookId]) {
            [jiaocaiDict setObject:[self getDictWId_QsArrWithBookId:dictCuoti[@"bookId"]] forKey:bookId];
        }
        
        
        if (yingchuArray.count >= 9) {
//            最多出9道题
            break;
        }
    }
    
    
    
    //    2.出题
    for (int i = 0; i < jiaocaiDict.allKeys.count; i++) {
        //        2.1 将本地教材中的所有关卡取出,做成字典,关卡id对应关卡
        NSString * bookId = [jiaocaiDict allKeys][i];
        //        对应教材中所有单词,题目   单词 id 对应题目数组
        NSDictionary * dictWId_Qs = jiaocaiDict[bookId];


        ////        将题目数组转为题目dic 单词id对应题目数组(数组中存储的是同一单词的不同题型) --- 目的是防止同一关卡的错题重复遍历关卡
        
        int i = 0;
        for (NSDictionary * cuoti in yingchuArray) {
            
            i++;
            //            当前教材的错题 cuoti
            if ([cuoti[@"bookId"] integerValue] - [bookId integerValue] == 0) {

                
                NSString * wordId = [NSString stringWithFormat:@"%@",cuoti[@"wordId"]];
                NSArray * qss = dictWId_Qs[wordId];
                NSMutableArray * arrCurrentCuoti = [NSMutableArray array]; //当前错题 出出来的复习题数组
                if ([cuoti[@"wrongCounts"] integerValue] > 1) {
                    
                    for (int i = 0; i < MIN(4, qss.count); i ++) {
                        [arrCurrentCuoti addObject:qss[i]];
                        
                    }
                }else{
                    
                    for (int i = 0; i < MIN(6, qss.count); i ++) {
                        
                        NSDictionary * qsDic = qss[i];
                        //                            错一次   只添加题型 1 2
                        if (([qsDic[@"type"] integerValue] == 1)||([qsDic[@"type"] integerValue] == 2)) {
                            [arrCurrentCuoti addObject:qsDic];
                            
                        }
                        
                        
                        if (arrCurrentCuoti.count >= 2) {
                            break;
                        }
                    }
                }
                
                [fuxitiArray addObjectsFromArray:arrCurrentCuoti];
            }
        }
        
        
        
    }

    
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
    if (SuijiFuxiguanQS) {
        fuxitiArray = [NSMutableArray arrayWithArray:[LGDUtils randamArry:fuxitiArray]];
    }
    //end

    NSMutableDictionary * passDic = [NSMutableDictionary dictionary];
    passDic[@"passId"] = @(FuxiPassId);
//    passDic[@"passId"] = @(2);
    passDic[@"passName"] = @"复习关";
    passDic[@"passDescs"] = @"复习关";
    passDic[@"course"] = @"   ";
    passDic[@"data"] = fuxitiArray;
    
    PassModel * model = [PassModel modelWithDic:passDic];
    
    
    return model;
}



+(NSDictionary *)getwordInfosWithBookId:(NSNumber *)bookId{
    //解析wordInfos.txt
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,bookId,@"txt/wordInfos.json"];
    
    NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
    
    return firstDic;
}


/**
 *  根据bookId 获取 教材内所有的单词_题目
 */
+(NSDictionary *)getDictWId_QsArrWithBookId:(NSNumber *)bookId{
//    NSLog(@"------ getDictWId_QsArrWithBookId ------");
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    
    NSString *bookPath=[NSString stringWithFormat:@"%@/%@",filePathBase,bookId ];
    
//    NSString * bookPath = [self getBookDirePathWithBookId:bookId];
    NSString * dictWIdQsArrPath = [NSString stringWithFormat:@"%@/dictWIdQsArr.txt",bookPath];
    
    //        将关卡数组转为关卡dic  关卡id对应关卡
    NSMutableDictionary * dictWIdQsArr = [NSMutableDictionary dictionaryWithContentsOfFile:dictWIdQsArrPath];
    
    if (!dictWIdQsArr || dictWIdQsArr.allKeys.count == 0) {
        dictWIdQsArr = [NSMutableDictionary dictionary];
        NSString * path = [self getBookQstxtPathWithBookId:bookId];
#pragma mark gd_修改获取资源包方式
        NSDictionary *firstDic = [Utils getDictWithPath:path];
        
        //        对应教材中的qs.txt 中的所有关卡
        NSArray * guanqiaArray = firstDic[@"datas"];
        for (NSDictionary * dict in guanqiaArray) {
            NSArray * array = dict[@"data"];
            for (NSDictionary * qsDict in array) {
                NSString * wordId = [NSString stringWithFormat:@"%@",qsDict[@"wordId"]];
                NSMutableArray * arrayQs = dictWIdQsArr[wordId];
                if (!arrayQs) {
                    arrayQs = [NSMutableArray array];
                }
                [arrayQs addObject:qsDict];
                dictWIdQsArr[wordId] = arrayQs;
            }
        }
        
//        [dictWIdQsArr writeToFile:dictWIdQsArrPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        [dictWIdQsArr writeToFile:dictWIdQsArrPath atomically:YES];
    }
    
    
//    [FileManagerHelper writeDiction3aryToFileInHomeDirectoryWithPath:dictWIdQsArrPath Dictionary:dictWIdQsArrPath Atomically:YES];
    
    return dictWIdQsArr;
}

+(NSDictionary *)getQstxtWithBookId:(NSNumber *)bookId{
    NSString * path = [self getBookQstxtPathWithBookId:bookId];
#pragma mark gd_修改获取资源包方式
    NSDictionary *firstDic = [Utils getDictWithPath:path];
    return firstDic;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)unlockNext
+(void)unlockNextWith:(BreakthroughType)type
//end
{
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *path = [self getIfLockArrayPath];
    NSString *path = [self getIfLockArrayPathWith:type];
    //end
    
    NSMutableArray * _ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (!_ifLockArray) {
        return;
    }else{
        if ([PassList defaultManager].currentIndexInAll+1<[PassList defaultManager].list.count) {
            
            
            //start
#pragma mark gd_更改解锁条件,如果存在复习关,不解锁下一关  2017-04-05 10:21:49-7
            if ([PassList shouldSetUpFuxiguanWith:type] && !ShouleUnLockNextIfHasFuxiguan) {
                return;
            }
            
            //end
            
            
            //start
#pragma mark gd_更改解锁方式，因为 plist 中不在体现复习关  2017-03-30 21:52:21
//            //start
//#pragma mark gd_如果刚做完的是复习关,不需要解锁下一关  2017-03-22 17:18:03
//            NSDictionary * dicCurrent = [_ifLockArray objectAtIndex:[PassList defaultManager].current];
//            if ([dicCurrent[@"isFuxiguan"] integerValue] ==1) {
//                return;
//            }
//            //end
//            
//            NSDictionary *dic = [_ifLockArray objectAtIndex:[PassList defaultManager].current+1];
//            // 判断下一关是不是复习关,如果不是,接下下一关,如果是复习关,解锁下下关
//            [dic setValue:@1 forKey:@"ifLock"];
//            
//            if ([dic[@"isFuxiguan"] integerValue] ==1) {
//                
//                dic = [_ifLockArray objectAtIndex:[PassList defaultManager].current+2];
//                [dic setValue:@1 forKey:@"ifLock"];
//                //start
//#pragma mark gd_解锁下下一关  2017-01-20-1
//                _ifLockArray[[PassList defaultManager].current+2] = dic;
//                
//                //end
//            }else{
//                //start
//#pragma mark gd_解锁下一关  2017-01-20-1
//                _ifLockArray[[PassList defaultManager].current+1] = dic;
//                
//                //end
//            }
            
            
            
            PassModel * model = [PassList defaultManager].list[[PassList defaultManager].currentIndexInAll];
            if (![model.passName isEqualToString:@"复习关"]) {
                NSString * passIndex  = [model.passName substringWithRange:NSMakeRange(1, model.passName.length - 2)];
//                如果刚做完的不是复习关
                if ([passIndex integerValue]<_ifLockArray.count) {
                    NSMutableDictionary *dic = [_ifLockArray objectAtIndex:[passIndex integerValue]];
                    [dic setValue:@1 forKey:@"ifLock"];
                    _ifLockArray[[passIndex integerValue]] = dic;
                }else{
                    
                    NSString * title =@"恭喜您完成本课程学习！\n接下来您可以把本课程每一关做到3颗钻，也可以进入下一课程学习.";
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message: title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];

                }
            }
            //end

            
            [_ifLockArray writeToFile:path atomically:NO];
            
        }
    }
    
}

#define PathPassInfo @"passInfo"
+(void)savePassedPassIdsWith:(NSNumber*)passId BookId:(NSNumber *)bookId{
    NSMutableDictionary * allUserPassInfo = [FileManagerHelper readDictionaryInHomeDirectoryWithPath:PathPassInfo];
    if (!allUserPassInfo) {
        allUserPassInfo = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary * currentUserAllBookPassInfo = [allUserPassInfo objectForKey:[Utils getCurrentUserName]];
    if (!currentUserAllBookPassInfo) {
        currentUserAllBookPassInfo = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary * currentUserPassedPassIds = [currentUserAllBookPassInfo objectForKey:bookId];
    if (!currentUserPassedPassIds) {
        currentUserPassedPassIds = [NSMutableDictionary dictionary];
    }
    
    [currentUserPassedPassIds setObject:@"YES" forKey:passId];
    
    [FileManagerHelper writeDictionaryToFileInHomeDirectoryWithPath:PathPassInfo Dictionary:allUserPassInfo Atomically:YES];
    
}

+ (NSMutableDictionary *)getBookAllPassedPassIdsWithBookId:(NSNumber *)bookId{
    NSMutableDictionary * allUserPassInfo = [FileManagerHelper readDictionaryInHomeDirectoryWithPath:PathPassInfo];
    if (!allUserPassInfo) {
        allUserPassInfo = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary * currentUserAllBookPassInfo = [allUserPassInfo objectForKey:[Utils getCurrentUserName]];
    if (!currentUserAllBookPassInfo) {
        currentUserAllBookPassInfo = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary * currentUserPassedPassIds = [currentUserAllBookPassInfo objectForKey:bookId];
    if (!currentUserPassedPassIds) {
        currentUserPassedPassIds = [NSMutableDictionary dictionary];
    }
    return currentUserPassedPassIds;
}


//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(BOOL)shouldSetUpFuxiguan
+(BOOL)shouldSetUpFuxiguanWith:(BreakthroughType)type
//end
{
    
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString * userCuotiCount = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserCuotiCount];
    NSString * userCuotiCount = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserCuotiCount(type)];
    //end
    
    
    if ([userCuotiCount integerValue] > CountWrongWordsCallFuxi) {
        return YES;
    }
    
    return NO;
}



//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)gotUdiamondNum:(NSNumber *)num
+(void)gotUdiamondNum:(NSNumber *)num With:(BreakthroughType)type
//end
{
//    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
    NSString *path = [PassList getIfLockArrayPathWith:type];
    NSMutableArray * _ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (!_ifLockArray) {
        return;
    }else{
        if ([PassList defaultManager].current<[PassList defaultManager].list.count) {
            NSDictionary *dic = [_ifLockArray objectAtIndex:[PassList defaultManager].current];
            [dic setValue:num forKey:@"Udiamond"];
            [_ifLockArray writeToFile:path atomically:NO];
            
        }
    }
    
}

+(void)saveSysInfo:(NSDictionary *)sysInfo{
    if (sysInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:sysInfo forKey:@"sysInfo"];
    }
}

+(NSInteger)getSysInfo:(NSInteger)getCoins{
    NSDictionary * sysInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"sysInfo"];
    if (sysInfo) {
        NSInteger getCoinsn = 0;
        switch (getCoins) {
            case 1:
                getCoinsn = [[sysInfo objectForKey:@"get1Coins"] integerValue];
                break;
                
            case 2:
                getCoinsn = [[sysInfo objectForKey:@"get2Coins"] integerValue];
                break;
                
            case 3:
                getCoinsn = [[sysInfo objectForKey:@"get3Coins"] integerValue];
                break;
                
            default:
                break;
        }
        return getCoinsn;
    }else{
        return getCoins * 2;
    }
}





@end
