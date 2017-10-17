//
//  ChooseResCell.h
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseResModel.h"



@interface ChooseResCell : UITableViewCell
@property (nonatomic,retain)ChooseResModel *item;

@property (copy, nonatomic)  void(^tapFileBlock)(NSString * statusName) ;

@end
