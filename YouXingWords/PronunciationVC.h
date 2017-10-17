//
//  PronunciationVC.h
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <UIKit/UIKit.h>


#import "PassModel.h"
@class  ISEParams;
@interface PronunciationVC : UIViewController
@property (nonatomic, strong) ISEParams *iseParams;
@property (nonatomic,retain)PassModel *item;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)NSMutableArray *wordslist;//(all)


- (instancetype)initWith:(BreakthroughType)type;

@end
