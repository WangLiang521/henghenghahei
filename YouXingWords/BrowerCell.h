//
//  BrowerCell.h
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowerModel.h"
#import "QsModel.h"
typedef void (^BrowerCellBlock)();

@interface BrowerCell : UITableViewCell
@property (nonatomic,copy)BrowerCellBlock block;
@property (nonatomic,retain)QsModel *item;
@end
