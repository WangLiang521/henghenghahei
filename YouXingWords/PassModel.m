//
//  PassModel.m
//  YouXingWords
//
//  Created by LDJ on 16/8/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PassModel.h"

@implementation PassModel
+(instancetype)modelWithDic:(NSDictionary *)dic{
    PassModel *model = [[PassModel alloc]init];
    
    model.dic  =dic;
    model.passID = [dic valueForKey:@"passId"];
    model.passDescs = [dic valueForKey:@"passDescs"];
    model.passName = [dic valueForKey:@"passName"];
    model.course = [dic valueForKey:@"course"];
    NSArray *arr =[dic valueForKey:@"data"];
    NSMutableArray *list = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        QsModel *item = [QsModel modelWithDic:arr[i]];
        [list addObject:item];
    }
    model.list =list;
    return model;
}
@end
