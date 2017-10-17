//
//  ChooseFriendsCell.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/27.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseFriendsCell : UITableViewCell

@property(nonatomic,assign)BOOL isChooseBool;
//是否选中的按钮
@property(nonatomic,retain)UIImageView *chooseImg;
//头像
@property(nonatomic,retain)UIImageView *iconImg;
//名称
@property(nonatomic,retain)UILabel *nameLb;
//内容
@property(nonatomic,retain)UILabel *contentLb;
//




@end
