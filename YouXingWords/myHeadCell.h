//
//  myHeadCell.h
//  YouXingWords
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LuckyDrawDelegate <NSObject>

-(void)pushToLucky;

@end
@interface myHeadCell : UITableViewCell


@property(nonatomic,retain)UIImageView *headerImg;//头像
@property(nonatomic,retain)UILabel *nameLab;//名字
@property(nonatomic,retain)UILabel *phoneLab;//手机号
@property(nonatomic,retain)UIImageView *zhuanImg;
@property(nonatomic,retain)UILabel *numberLab;
@property(nonatomic,retain)UIButton *chouJiaBtn;

@property(nonatomic,assign)id<LuckyDrawDelegate> delegate;

@end
