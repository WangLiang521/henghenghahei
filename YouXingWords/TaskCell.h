//
//  TaskCell.h
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface TaskCell : UITableViewCell
@property (nonatomic,retain)TaskModel *item;

@property (copy, nonatomic)  TapBlock tapblock;

@end
