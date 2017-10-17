//
//  NotebookModel.h
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotebookModel : NSObject

@property (nonatomic,copy)NSString *word;
@property (nonatomic,retain)NSNumber *wordId;
@property (nonatomic,retain)NSNumber *bookId;
@property (nonatomic,retain)NSNumber *wightCounts;
@property (nonatomic,retain)NSNumber *rightCounts;



+(instancetype)notebookModelWithDic:(NSDictionary *)dic;
@end
