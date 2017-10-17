//
//  PKDetailVC.h
//  YouXingWords
//
//  Created by LDJ on 16/11/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassModel.h"
@interface PKDetailVC : UIViewController
@property (nonatomic,retain) PassModel *item;
@property (nonatomic,retain) NSArray *wordList;
@property (nonatomic,copy)NSString *timeStr;
@property (nonatomic,copy)NSString *contestId;

- (instancetype)initWith:(BreakthroughType)type;

@end
