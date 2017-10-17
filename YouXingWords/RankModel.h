//
//  RankModel.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject

@property(nonatomic,copy)NSString *address;//地址
@property(nonatomic,copy)NSString *coins;//钻石数
@property(nonatomic,copy)NSString *name;//名称
@property(nonatomic,copy)NSString *nickName;//昵称
@property(nonatomic,copy)NSString *schId;//学校ID
@property(nonatomic,copy)NSString *schName;//学校名称
@property(nonatomic,copy)NSString *sdutyTime;//学习时间
@property(nonatomic,copy)NSString *signPhoto;//头像图片地址
@property(nonatomic,copy)NSString *username;//用户账号

+(instancetype)rankModelWith:(NSDictionary *)dic;



@end
