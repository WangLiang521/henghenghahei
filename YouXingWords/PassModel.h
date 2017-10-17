//
//  PassModel.h
//  YouXingWords
//
//  Created by LDJ on 16/8/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QsModel.h"
//一个关卡的全部信息
@interface PassModel : NSObject

@property (nonatomic,assign)BOOL isNULL;
@property (nonatomic,retain)NSNumber *passID;
@property (nonatomic,copy)NSString *passName;
@property (nonatomic,copy)NSString *passDescs;
@property (nonatomic,copy)NSString *course;
@property (nonatomic,retain)NSDictionary *dic;
@property (nonatomic,retain) NSMutableArray<QsModel *> *list;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
