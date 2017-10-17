//
//  GetUserPKListModel.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/27.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "GetUserPKListModel.h"

@implementation GetUserPKListModel
+(instancetype)getUserListModelWith:(NSDictionary *)dic
{
    GetUserPKListModel *model=[[GetUserPKListModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
