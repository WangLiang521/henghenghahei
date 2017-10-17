//
//  BarrierDetailVC.h
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassModel.h"
@interface BarrierDetailVC : UIViewController
@property (nonatomic,retain) PassModel *item;
@property (nonatomic,retain) NSArray *wordList;
- (instancetype)initWith:(BreakthroughType)type;
@end
