//
//  ChooseResModel.m
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseResModel.h"

@implementation ChooseResModel
+(instancetype)chooseResModelWithDic:(NSDictionary *)dic{
    ChooseResModel *model = [[ChooseResModel alloc]init];
    model.title = [dic valueForKey:@"name"];
    model.bookType = [dic valueForKey:@"bookType"];
    model.bookID = [dic valueForKey:@"bookId"];
    model.isLocked = [dic valueForKey:@"isLocked"];
    model.isUsed = [dic valueForKey:@"isUsed"];
    model.passesCount = [dic valueForKey:@"passesCount"];
    model.passedCount = [dic valueForKey:@"passedCount"];
    model.coins = [dic valueForKey:@"coins"];
    model.bookStyle = [dic valueForKey:@"bookStyle"];
    
    
    model.status = [dic valueForKey:@"status"];
    
    
    model.bookUrl = [dic valueForKey:@"bookUrl"];
    
    model.fileName = [dic valueForKey:@"fileName"];
    model.progress = @(0);
    return model;
}
@end
