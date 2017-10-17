//
//  NotebookModel.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NotebookModel.h"

@implementation NotebookModel
+(instancetype)notebookModelWithDic:(NSDictionary *)dic{
    NotebookModel *model = [[NotebookModel alloc]init];
    model.word = [dic valueForKey:@"name"];
    model.wordId = [dic valueForKey:@"wordId"];
    model.bookId = [dic valueForKey:@"bookId"];
    model.wightCounts = [dic valueForKey:@"wightCounts"];
    model.rightCounts = [dic valueForKey:@"rightCounts"];
    return model;
}
@end
