//
//  NetWorkingUtils.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NetWorkingUtils.h"
#import <SVProgressHUD.h>
#import "PassModel.h"
#import "PassList.h"
#import "LexiconViewController.h"

#define TIMEOUTINTERVAL 10 //请求超时

@implementation NetWorkingUtils

static NetWorkingUtils * _instance = nil;

+(id)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        manager.requestSerializer.timeoutInterval =TIMEOUTINTERVAL;
        _instance.mgr = manager;
        _instance.netReach = [Reachability reachabilityWithHostname:@"www.google.com"];

        
    });
    return _instance;
}
//请求数据包时不能解析json
+(NSURLSessionDataTask *)getRarWithUrl:(NSString *)url params:(NSDictionary *)params progressResult:(responseprogress)progress successResult:(responseSuccess)successResult errorResult:(responseError)errorResult{
//    [SVProgressHUD showWithStatus:@"下载课程中..."];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
//    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
//    HUD.label.text = [NSString stringWithFormat:@"下载中"];

    NSURLSessionDataTask * task = [[[self defaultManager] mgr] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //网络请求进度
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showProgress:downloadProgress.fractionCompleted status:@"下载中..."];

//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            HUD.progress = downloadProgress.fractionCompleted;
//            NSLog(@"%f",downloadProgress.fractionCompleted);
//        });
        
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除等待视图
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showSuccessWithStatus:@"切换教材成功！"];
        //json解析数据
//        NSDictionary *dicc=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successResult(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除等待视图
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        errorResult(error);
    }];
    return task;

}
+(void)getWithUrl:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult
{

    //设置背景颜色可自定义
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    //设置加载的text
    [SVProgressHUD showWithStatus:@"加载中"];
    //设置背景颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.875 alpha:1.000]];
    
    [[[self defaultManager] mgr] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //网络请求进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除等待视图
        [SVProgressHUD dismiss];
        //json解析数据
        NSDictionary *dicc=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successResult(dicc);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除等待视图
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        errorResult(error);
    }];
}
+(void)postWithUrl:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult
{
    //设置背景颜色可自定义
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    //设置加载的text
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[[self defaultManager] mgr] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //网络请求进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除等待视图
        [SVProgressHUD dismiss];
        //json解析数据
        NSDictionary *dicc=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successResult(dicc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除等待视图
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        errorResult(error);
    }];
}
+(void)postWithUrlWithoutHUD:(NSString *)url params:(NSDictionary *)params successResult:(responseSuccess)successResult errorResult:(responseError)errorResult
{
    [[[self defaultManager] mgr] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //网络请求进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //json解析数据
        NSDictionary *dicc=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        successResult(dicc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
+(void)networkReachable:(reachable)reachable AndUnreachable:(unreachable)unreachable{
    if ([[[self defaultManager] netReach] isReachable]) {
        reachable(reachable);
    
    }else{
        unreachable(unreachable);
    }
 
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//+(void)uploadBarrierInfoPassfail:(BOOL)notPass passId:(NSNumber *)passId passTime:(NSNumber *)passTime currentVC:(UIViewController *)currentVC
+(void)uploadBarrierInfoPassfail:(BOOL)notPass passId:(NSNumber *)passId passTime:(NSNumber *)passTime currentVC:(UIViewController *)currentVC With:(BreakthroughType)type
//end

{
    
    //start
#pragma mark gd_分用户储存  0115
    //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
    //end
    
    NSArray *jsonArr =[NSArray arrayWithContentsOfFile:path];
    NSString *jsonStr = [jsonArr mj_JSONString];
    //    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookID],@"passId":passId,@"passTime":passTime,@"wordsInfo":jsonStr,@"isExit":@(notPass)};
    NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookIDWith:type],@"passId":passId,@"passTime":passTime,@"wordsInfo":jsonStr,@"isExit":@(notPass?1:0)};
    //end
    
    
    
    
#pragma mark gd_提交用户闯关信息
    [NetWorkingUtils postWithUrl:SubmitInfo params:paramsDic successResult:^(id response) {
        
        //        提交闯关信息成功,检测是否需要出复习关
        //        提交闯关信息失败,保存闯关信息,有网络时提交
        
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSLog(@"%@",[response valueForKey:@"lastPassTime"]);
            //        提交闯关信息成功
            if (!notPass) {
                NSArray * array = response[@"data"];
                
                //start
#pragma mark gd_修改复习关方式  2017-03-30 20:59:19
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                [PassList refreshFuxitiWithResponse:array];
                [PassList refreshFuxitiWithResponse:array With:type];
                //end
                
                
                //                //start
                //#pragma mark gd_不论之前做的是不是复习关,都需要清除之前的复习关因为如果错题数达到5个,是会在后面重新出复习关的  2017-03-22 10:33:10-2
                //
                //                NSString *pathIfLockArray = [PassList getIfLockArrayPath];
                //                NSMutableArray * ifLockArray = [NSMutableArray arrayWithContentsOfFile:pathIfLockArray];
                //                for (NSInteger i = ifLockArray.count - 1; i >= 0; i --) {
                //                    NSDictionary * dict = ifLockArray[i];
                //                    if (dict[@"isFuxiguan"] && [dict[@"isFuxiguan"] integerValue] == 1) {
                //                        [ifLockArray removeObject:dict];
                //                        [[PassList defaultManager].list removeObjectAtIndex:i];
                //
                //                    }
                //                }
                //                [ifLockArray writeToFile:pathIfLockArray atomically:NO];
                //
                //                //end
                //                
                // 
                //
                //                if (array.count > CountWrongWordsCallFuxi) { // 0115 多于5个才出复习关
                //                    [PassList insertFuxiGuanWithDicFuxiti:response];
                //
                //                }
                //end
                
//                {
//#pragma mark   *************gd 添加复习关*********
//                    //*************gd 添加复习关*********\\
//                    //        本来存在的lockArray
//                    NSString *path = [PassList getIfLockArrayPath];
//                    NSArray *lockArrayExisted = nil;
//                    if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
//                        lockArrayExisted = [NSArray arrayWithContentsOfFile:path];
//                        
//                        for (int i = 0; i < lockArrayExisted.count; i++) {
//                            NSDictionary * dict = lockArrayExisted[i];
//                            if ([dict[@"isFuxiguan"] integerValue] ==1) {
//                                
//                                //                    PassModel *model = [PassModel modelWithDic:listArr[i]];
//                                //                    [self.listArray addObject:model];
//                                PassModel *model = [PassList getFuxiti];
////                                [self.listArray insertObject:model atIndex:i];
//                                [PassList defaultManager].list;
//                            }
//                        }
//                    }
//                }
            }
        }
        else{
            //        提交闯关信息失败
            [FileManagerHelper savePassInfoWithDic:paramsDic];
            NSLog(@"%@",response);
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
        [FileManagerHelper savePassInfoWithDic:paramsDic];
    }];
    [self requestQiandao];
}


+ (void)requestQiandao{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:GDURL_Qiandao parameters:parameters success:^(id dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:dictJSON[@"seriesSignDays"] forKey:KeySeriesSignDays];
        }
    } failure:^(NSError *error) {
        
    }];
}

//start
#pragma mark gd_修改 type  2017-05-02 21:58:41
+ (void)requestNoteBookWith:(BreakthroughType)type
//end
{
    
    NSString * token = [Utils getCurrentToken];
    
    if (![LGDUtils isValidStr:token]) {
        return;
    }
    
//    NSDictionary * response = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString * bookId = [NSString stringWithFormat:@"%@",[AnswerTools getBookID]];
    NSString * bookId = [NSString stringWithFormat:@"%@",[AnswerTools getBookIDWith:type]];
    //end
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = token;
    parameters[@"bookId"] = bookId;
    parameters[@"page"] = @"0";
    parameters[@"size"] = @"20";
    
    
    
    [NetWorkingUtils postWithUrl:WrongList params:parameters successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSLog(@"+++%@",response);
            
            NSArray * array = response[@"data"];
            
//            NSDictionary * dicFuxiti = response[@"data"];
            
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            [PassList refreshFuxitiWithResponse:array];
            [PassList refreshFuxitiWithResponse:array With:type];
            //end
            
            
//            NSString * path = [Utils getPathNoteBookQsArray];
//            
//            
//            [array writeToFile:path atomically:NO];
//            if (array.count > CountWrongWordsCallFuxi) { // 0115 多于5个才出复习关
//                [PassList insertFuxiGuanWithDicFuxiti:response];
//                
//            }

        }
    } errorResult:^(NSError *error) {
        //结束刷新
        
        
    }];
}



@end













