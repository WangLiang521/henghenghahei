//
//  MessageCell.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/16.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(nonatomic,retain)UILabel *noReadLb;//未读小红点
@property(nonatomic,retain)UIImageView *iconImg;//图片
@property(nonatomic,retain)UILabel *nameLb;//名称
@property(nonatomic,retain)UILabel *contentLb;//内容
@property(nonatomic,retain)UILabel *timeLb;//时间
@property(nonatomic,retain)UILabel *msgCountLb;//消息个数

@end
