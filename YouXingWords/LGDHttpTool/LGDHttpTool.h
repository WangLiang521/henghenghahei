//
//  LGDHttpTool.h
//  EasyWedding
//
//  Created by wangliang on 16/8/23.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block_JSON_Dictionary)(id dictJSON);

typedef void(^TapBlock)(void);

typedef void(^TapIdBlock)(id obj);

#import <UIKit/UIKit.h>

@interface LGDHttpTool : NSObject

//[self.manager POST:EW_Login_POST_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//
//} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    NSDictionary * dict = (NSDictionary * )responseObject;
//    NSDictionary * dictJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//    DLog(@"dict = %@  /n dictJSON = %@",dict,dictJSON);
//} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    DLog(@"error = %@",error.localizedDescription);
//}];


//+(void)POST:(NSString *)URLString parameters:(id)parameters  success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure;


+(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters  success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure;


+ (void) POSTImagesWithUrl:(NSString *)url parameters:(NSDictionary *)parameters ImageArray:(NSArray *)ImageArray fileName:(NSString*)fileName success:(Block_JSON_Dictionary)dictSuccessJSON failure:(void (^)(NSError *error))failure;


+(void)uploadSuccess:(Block_JSON_Dictionary)dictSuccessJSON;


//检测版本更新
+(void)onCheckVersionWithAppId:(NSString *)appid With:(UIViewController *)vc;


//+ (void)requestXianquWithCity:(NSString *)city;

@end
