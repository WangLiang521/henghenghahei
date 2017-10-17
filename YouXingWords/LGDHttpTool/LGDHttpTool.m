//
//  LGDHttpTool.m
//  EasyWedding
//
//  Created by wangliang on 16/8/23.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "LGDHttpTool.h"
#import "AFNetworking.h"



@interface LGDHttpTool ()
@property (strong, nonatomic)  AFHTTPSessionManager *manager;
@end

@implementation LGDHttpTool

//+(void)POST:(NSString *)URLString parameters:(id)parameters  success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure{
//
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//       manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//
//
//    //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    //    NSDictionary * parameters = @{@"type":@"1",@"phone":@"18500737265",@"pswd":[[MD5 md5:@"123456"] lowercaseString]};
//    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, NSData * responseObject) {
//
//        NSDictionary * responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//        dictSuccessJSON(responseJSON);
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        failure(error);
//        
//    }];
//}

+(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters  success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   manager.responseSerializer = [AFHTTPResponseSerializer serializer];


    //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSDictionary * parameters = @{@"type":@"1",@"phone":@"18500737265",@"pswd":[[MD5 md5:@"123456"] lowercaseString]};
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, NSData * responseObject) {

        NSDictionary * responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        dictSuccessJSON(responseJSON);

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);


    }];
}



+ (void) POSTImagesWithUrl:(NSString *)url parameters:(NSDictionary *)parameters ImageArray:(NSArray *)ImageArray fileName:(NSString*)fileName success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"yzHbRQTi13WsqbMr58oolN4L1BKUB3BGG9AnP62_Hc8" forHTTPHeaderField:@"X-CSRF-Token"];
    
    manager.requestSerializer = requestSerializer;

    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i = 0 ; i<ImageArray.count ; i ++) {
            UIImage * image = ImageArray[i];
            NSData * data = nil;
            NSString * strFileType = nil;
            if (UIImagePNGRepresentation(image)) {
                data = UIImagePNGRepresentation(image);
                strFileType = @".png";
            }else{
                data = UIImageJPEGRepresentation(image, 1.0f);
                strFileType = @".jpg";
            }

            if (data) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString * filesFileName = [NSString stringWithFormat:@"%d%@%@",i,str,strFileType];
                [formData appendPartWithFileData:data name:fileName fileName:filesFileName mimeType:@"image/png"];
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        DLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary * responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        dictSuccessJSON(responseJSON);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"error = %@",error.localizedDescription);
        failure(error);
    }];
    
}


+(void)uploadSuccess:(Block_JSON_Dictionary)dictSuccessJSON{
    
}

+(void)onCheckVersionWithAppId:(NSString *)appid With:(UIViewController *)vc
{
    NSString * keyCheckVersion = @"keyCheckVersion";
    
    NSString * checkBlueDateString = [[NSUserDefaults standardUserDefaults] objectForKey:keyCheckVersion];
    if (!checkBlueDateString || checkBlueDateString.length > 1 ) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate * date =[dateFormatter dateFromString:checkBlueDateString];
        NSDate * dateNow = [NSDate date];
        NSString * dateNowStr = [dateFormatter stringFromDate:dateNow];
        
        if (date && [self getDaysFrom:date To:dateNow].day <= 0 ) {
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:keyCheckVersion];
            return;
        }
        
        
        NSDateComponents * comp = [self getDaysFrom:date To:dateNow];
        if (comp.day >= 1) {
        
            
            NSString * url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
            
            [LGDHttpTool POST:url parameters:nil success:^(NSDictionary *resultDic) {
                
                
                float version =[[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"version"] floatValue];
                NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                float currentVersion = [[infoDic valueForKey:@"CFBundleShortVersionString"] floatValue];
                
                
                if (version > currentVersion) {
                    NSString *alertTitle=[@"发现新版本v" stringByAppendingString:[NSString stringWithFormat:@"%0.1f",version]];
                    NSString *alertMsg=@"是否立即更新？";
                    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:alertTitle message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * actionConfirm = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString * urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/wang-yi-yun-yin-le-pao-bufm/id%@?mt=8",appid];
                        NSURL *urlAppstore = [NSURL URLWithString:urlStr];
                        [[UIApplication sharedApplication] openURL:urlAppstore];
                    }];
                    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dateNowStr forKey:keyCheckVersion];
                    }];
                    [alertVC addAction:actionConfirm];
                    [alertVC addAction:actionCancel];
                    
                    [vc presentViewController:alertVC animated:YES completion:nil];
                }
                
                //        if(version>0.9){
                //            NSString *alertTitle=[@"发现新版本v" stringByAppendingString:[NSString stringWithFormat:@"%0.1f",version]];
                //            NSString *alertMsg=@"是否立即更新？";
                //            //NSString *alertMsg  = [[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"releaseNotes"]
                //            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"立即更新", nil];
                //            [alertView show];
                //        }
                
                
                
            } failure:^(NSError *error) {
                
            }];

        
        
        
        
        }
    }
    
    
}


+(NSDateComponents *)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents;
}


@end
