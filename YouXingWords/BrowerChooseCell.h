//
//  BrowerChooseCell.h
//  YouXingWords
//
//  Created by tih on 16/9/7.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowerModel.h"
#import "QsModel.h"
typedef void (^BrowerCellBlock)();
@interface BrowerChooseCell : UITableViewCell
@property (nonatomic,copy)BrowerCellBlock block;
@property (nonatomic,retain)QsModel *item;
@end
