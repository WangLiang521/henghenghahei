//
//  TaskModel.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel
+(instancetype)taskModelWithTitle:(NSString *)title AndNum:(NSString *)num AndIsDiam:(BOOL)isDiam AndIsComp:(BOOL)isComp{
    TaskModel *model = [[TaskModel alloc]init];
    model.title = title;
    model.num = num;
    model.isDiamond = isDiam;
    model.isComplete = isComp;
    return model;
}
@end



