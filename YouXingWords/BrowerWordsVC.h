//
//  BrowerWordsVC.h
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassModel.h"

@interface BrowerWordsVC : UIViewController
@property (nonatomic,retain) PassModel *item;
@property (nonatomic,retain)NSMutableArray *removeList; //移除的qsmodel
@property (nonatomic,retain)NSMutableArray *list;//9个qsmodel
@property (nonatomic,retain)NSMutableArray *selectList; //剩下的qsmodel
//@property (nonatomic,retain) NSArray *itemList;
//@property (nonatomic,assign) NSInteger currentItemNum;


- (instancetype)initWith:(BreakthroughType)type;

@end
