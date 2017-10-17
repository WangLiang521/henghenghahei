//
//  BeforeLearnVC.h
//  YouXingWords
//
//  Created by tih on 16/11/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PassModel.h"
typedef void (^TestReadyBlock)();

@interface BeforeLearnVC : UIViewController
@property (nonatomic,retain) PassModel *item;
@property (nonatomic,retain) NSArray *wordList;
@property (nonatomic,copy)TestReadyBlock block;

- (instancetype)initWith:(BreakthroughType)type;
@end
