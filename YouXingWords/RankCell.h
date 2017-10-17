//
//  RankCell.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell

@property(nonatomic,retain)UIImageView *rankImg;//前三名排行图片
@property(nonatomic,retain)UILabel *rankLb;//第三名之后的排行

@property(nonatomic,retain)UIImageView *iconImg;//人物头像图片
@property(nonatomic,retain)UILabel *nameLb;//人物名称
@property(nonatomic,retain)UILabel *timeLb;//用时
@property(nonatomic,retain)UILabel *placeLb;//地点
@property(nonatomic,retain)UIImageView *diamondImg;//钻石图片
@property(nonatomic,retain)UILabel *diamondLb;//钻石数量


@end
