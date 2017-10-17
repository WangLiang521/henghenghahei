//
//  RankModel.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "RankModel.h"

@implementation RankModel

+(instancetype)rankModelWith:(NSDictionary *)dic
{
    RankModel *model=[[RankModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}



@end
