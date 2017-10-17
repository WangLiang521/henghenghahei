//
//  AppDelegate.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "AnswerTools.h"
#import "TimerTools.h"
#import "LoginVC.h"
#import "iflyMSC/IflyMSC.h"
//#import "EMSDK.h"
#import "EaseUI.h"
#import "YXDateGetter.h"

//讯飞语音 appId
//#define APPID_VALUE           @"57d25201"
                                
#define APPID_VALUE           @"597959f5"
//环信appkey
#define EMAPPKEY              @"jinyouwangluo#youxingjiaoyu"

#import "NetworkHelper.h"

//#import "BaiduMobStat.h"

#import <UMSocialCore/UMSocialCore.h>

#ifdef Define_BUGLY
#import <Bugly/Bugly.h>

#endif


#ifdef DefineAliPay
#import <AlipaySDK/AlipaySDK.h>
#endif

#ifdef DefineWeiXinPay
#import "WXApi.h"
#endif
#import "GDWXApiManager.h"



@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //修改电池颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#36b6e6"]];
    //UINavigationBar的文字颜色以及文字大小
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(38)]}];
    //UINavigationBar 返回的时候的文字颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self setUp3rd];
    
    [NetWorkingUtils requestNoteBookWith:BreakthroughTypeCourse];
    [NetWorkingUtils requestNoteBookWith:BreakthroughTypeWord];
    
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //start
#pragma mark gd_tips  时间-编号
    //    [NetWorkingUtils networkReachable:^{
    //        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLogin"]==NO) {
    //            LoginVC *login=[[LoginVC alloc]init];
    //            self.window.rootViewController=login;
    //        }else{
    //            BaseTabBarController *base=[[BaseTabBarController alloc]init];
    //            self.window.rootViewController=base;
    //        }
    //    } AndUnreachable:^{
    //        BaseTabBarController *base=[[BaseTabBarController alloc]init];
    //        self.window.rootViewController=base;
    //    }];
    
            if (![LGDUtils isValidStr:[Utils getCurrentToken]]) {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstLogin"];
                LoginVC *login=[[LoginVC alloc]init];
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
                nav.navigationBar.shadowImage = [UIImage new];
                self.window.rootViewController=nav;
            }else{
                BaseTabBarController *base=[[BaseTabBarController alloc]init];
                self.window.rootViewController=base;
            }

    //end
    
    [self.window makeKeyAndVisible];
    [self every5MinutesUpload];
    //讯飞sdk
    [self initIFly];
    //环信sdk
    [self initEMSDK];
    //初始化EaseUI
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EMAPPKEY
                                         apnsCertName:nil
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

#pragma mark gd_监听如果有网,上传关卡信息
    [self uploadPassInfoIfNetWorkReachable];

    

    return YES;
}



- (void)setUp3rd{
    
    [self setupBugly];
    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:KeyWeiXinPay];
    
    [self startBaiduMobileStat];
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//    
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:KeyYoumeng];
//    
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KeyShareWeiXinAppKey appSecret:KeyShareWeiXinAppSecret redirectURL:@"http://mobile.umeng.com/social"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KeyShareQQAppId/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:KeyShareSinaAppKey  appSecret:KeyShareSinaAppKey redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMSocial_UmSocial_Appkey];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UMSocial_Sina_appkey  appSecret:UMSocial_Sina_appSecret redirectURL:UMSocial_Sina_redirectURL];
    
//    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMSocial_Wx_appkey appSecret:UMSocial_Wx_appSecret redirectURL:UMSocial_Wx_redirectURL];
//
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UMSocial_QQ_appkey  appSecret:nil redirectURL:UMSocial_QQ_redirectURL];
    
    
    
    
    
    
    
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//    
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)setupBugly {
#ifdef Define_BUGLY
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = NO;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //[self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
    
#endif
    
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
#ifdef Define_BUGLY
    
    
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
    
#endif
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}

//// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = NO;
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    @try {
//        result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//        if (!result) {
//            // 其他如支付等SDK的回调
//        }
//    } @catch (NSException *exception) {
//        NSLog(@"openURL exception.name = %@,exception.name = %@",exception.reason,exception.reason);
//    } @finally {
//        
//    }
//    return result;
//}

// 启动百度移动统计
- (void)startBaiduMobileStat{
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
     */
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = NO;

    [statTracker startWithAppId:@"7932eca4a5"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

- (void)uploadPassInfoIfNetWorkReachable{

    DEFINE_WEAK(self);
    [[NetworkHelper share] networkStatusChangedBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSMutableArray * array = [FileManagerHelper getPassInfo];
            [wself uploadPassInfoWithArrayParameters:array index:0];
        }
        

    }];
}

- (void)uploadPassInfoWithArrayParameters:(NSMutableArray *)arrayParameters index:(NSInteger)index{


    if (arrayParameters.count==0 || arrayParameters.count <= index) {
        return;
    }
    NSDictionary * parameters = arrayParameters[index];
    DEFINE_WEAK(self);
    [NetWorkingUtils postWithUrl:SubmitInfo params:parameters successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSLog(@"%@",[response valueForKey:@"lastPassTime"]);
            [arrayParameters removeObject:[arrayParameters firstObject]];
            [FileManagerHelper updatePassInfoWithArray:arrayParameters];
            [wself uploadPassInfoWithArrayParameters:arrayParameters index:index + 1];
        }
        else{

            NSLog(@"%@",response);
            [wself uploadPassInfoWithArrayParameters:arrayParameters index:index];
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
        [wself uploadPassInfoWithArrayParameters:arrayParameters index:index];
    }];
}

#pragma mark---初始化讯飞sdk
-(void)initIFly{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

-(void)every5MinutesUpload{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LoopTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //start
#pragma mark gd_使用新逻辑  2017-01-23 21:45:01
        //        NSString *str= [TimerTools getTime];
        NSString *str= [TimerTools getStudyTimeNew];
//        NSString *str= @"60";
        //end
        
        NSNumber *num = [NSNumber numberWithInteger:[str integerValue]];
        
        if (!num||[num integerValue]==0) {
            //还没看书过
        }else{
            [NetWorkingUtils networkReachable:^{
                //上传数据 不大于5分钟 上传后清零
//                if ([str integerValue]<=300) {
                
                    NSString * startStr = [Utils getStartTime];
                if (startStr) {
                    NSDictionary *paramsDic =@{@"token":[Utils getCurrentToken],@"studeTime":num,@"startTime":startStr};
                    
                    [NetWorkingUtils postWithUrlWithoutHUD:SubmitTime params:paramsDic successResult:^(id response) {
                        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
                            [self saveUploadHistory:paramsDic];
                            NSDictionary *dic = [response valueForKey:@"info"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"studyInfo" object:dic];
                        
                            //start
#pragma mark gd_使用新逻辑  2017-02-04
                            [TimerTools clear];
                            [TimerTools clearStudyTimeNew];
//                            [TimerTools clearStudyTimeNew];
                            //end
                        }else{
                            [self saveUploadFailHistory:paramsDic];
                        }
                    } errorResult:^(NSError *error) {
                        [self saveUploadFailHistory:paramsDic];
                    }];
                }
                    
//                }
//                //start
//#pragma mark gd_使用新逻辑  2017-01-23 21:45:01
//                [TimerTools clear];
//                [TimerTools clearStudyTimeNew];
//                [TimerTools clearStudyTimeNew];
//                //end
                
            } AndUnreachable:^{
                
            }];
            
            NSLog(@"*******************%@",str);
        }
        [self every5MinutesUpload];
    });
}

- (void)saveUploadHistory:(NSDictionary *)paramsDic{
    NSMutableArray * muArr = [FileManagerHelper readArrayInHomeDirectoryWithPath:@"/UploadHistory.txt"];
    if (!muArr) {
        muArr = [NSMutableArray array];
    }
    [muArr addObject:paramsDic];
    [FileManagerHelper writeArrayToFileInHomeDirectoryWithPath:@"/UploadHistory.txt" Array:muArr Atomically:YES];
}
- (void)saveUploadFailHistory:(NSDictionary *)paramsDic{
    NSMutableArray * muArr = [FileManagerHelper readArrayInHomeDirectoryWithPath:@"/UploadFailHistory.txt"];
    if (!muArr) {
        muArr = [NSMutableArray array];
    }
    [muArr addObject:paramsDic];
    [FileManagerHelper writeArrayToFileInHomeDirectoryWithPath:@"/UploadHistory.txt" Array:muArr Atomically:YES];
}

-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return  NO;
    }
    return YES;
}
#pragma mark---初始化环信sdk
-(void)initEMSDK
{
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:EMAPPKEY];
    //    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
}


//在应用处于后台，且后台任务下载完成时回调
- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler{
    
}





//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    BOOL open = [WXApi handleOpenURL:url delegate:[GDWXApiManager share]];
//    
//    if (!open) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//            }];
//        } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuchenggonghuidiao" object:resultDic];
//            }];
//        } else{
//            
//            //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//            @try {
//                open = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//                if (!open) {
//                    // 其他如支付等SDK的回调
//                }
//            } @catch (NSException *exception) {
//                NSLog(@"openURL exception.name = %@,exception.name = %@",exception.reason,exception.reason);
//            } @finally {
//                
//            }
//        }
//    }
//    
//    
//    return YES;
//}
//
//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    BOOL open = [WXApi handleOpenURL:url delegate:self];
//    
//    if (!open) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayComplete" object:resultDic];
//            }];
//        } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayComplete" object:resultDic];
//            }];
//        }
//    }
//    return YES;
//}
//
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    BOOL open = [WXApi handleOpenURL:url delegate:[GDWXApiManager share]];
//    
//    if (!open) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayComplete" object:resultDic];
//            }];
//        } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayComplete" object:resultDic];
//            }];
//        }
//    }
//    
//    
//    return  YES;
//}
//
//
//-(void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinPayComplete" object:resp];
//        switch (response.errCode) {
//            case WXSuccess:
//            {// 支付成功，向后台发送消息
//                NSLog(@"支付成功");
//                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
//            }
//                break;
//            case WXErrCodeCommon:
//            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
//                //                [MBProgressHUD showError:@"支付失败"];
//                NSLog(@"支付失败");
//            }
//                break;
//            case WXErrCodeUserCancel:
//            { //用户点击取消并返回
//                NSLog(@"取消支付");
//                //                [MBProgressHUD showError:@"取消支付"];
//            }
//                break;
//            case WXErrCodeSentFail:
//            { //发送失败
//                NSLog(@"发送失败");
//                //                [MBProgressHUD showError:@"发送失败"];
//            }
//                break;
//            case WXErrCodeUnsupport:
//            { //微信不支持
//                NSLog(@"微信不支持");
//                //                [MBProgressHUD showError:@"微信不支持"];
//            }
//                break;
//            case WXErrCodeAuthDeny:
//            { //授权失败
//                NSLog(@"授权失败");
//                //                [MBProgressHUD showError:@"授权失败"];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}
//



// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [AnswerTools recoverData];
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
