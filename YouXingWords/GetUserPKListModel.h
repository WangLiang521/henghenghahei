//
//  GetUserPKListModel.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/27.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserPKListModel : NSObject

@property(nonatomic,copy)NSString *id;//帐号
@property(nonatomic,copy)NSString *chanType;//挑战类型:1.学习时常，2财富
@property(nonatomic,copy)NSString *challenger;//发起挑战者帐号
@property(nonatomic,copy)NSString *challengerName;//发起挑战者姓名
@property(nonatomic,copy)NSString *challengerImageUrl;//发起挑战者头像
@property(nonatomic,copy)NSString *beChallenger;//被挑战帐号
@property(nonatomic,copy)NSString *beChallengerName;//被挑战者姓名
@property(nonatomic,copy)NSString *beChallengerImageUrl;//被挑战者头像
@property(nonatomic,copy)NSString *chanName;//挑战名称
@property(nonatomic,copy)NSString *coins;//押注优钻数量
@property(nonatomic,copy)NSString *status;//状态:1创建; 3同意; 9完成; -1被拒绝, 0被取消
@property(nonatomic,copy)NSString *deadline;//截至时间
@property(nonatomic,copy)NSString *winner;//胜利者(状态是9的可以显示胜利者)
@property(nonatomic,copy)NSString *createTim;//创建时间
@property(nonatomic,copy)NSString *challengerValue;//挑战者的数值
@property(nonatomic,copy)NSString *beChallengerValue;//被挑战者的数值

//+(instancetype)getUserListModelWith:(NSDictionary *)dic;




@end
