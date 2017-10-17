//
//  ChooseFriendsCell.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/27.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseFriendsCell.h"

@implementation ChooseFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //选择按钮
        _chooseImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(20), AutoTrans(45), AutoTrans(40), AutoTrans(40))];
        _chooseImg.layer.cornerRadius=CGRectGetWidth(_chooseImg.frame)/2;
        _chooseImg.layer.masksToBounds=YES;
        _chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
        [self.contentView addSubview:_chooseImg];
        //iconImg
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_chooseImg.frame)+(AutoTrans(20)), AutoTrans(23), AutoTrans(84), AutoTrans(84))];
        _iconImg.backgroundColor=[UIColor lightGrayColor];
        _iconImg.layer.cornerRadius=AutoTrans(84)/2;
        _iconImg.layer.cornerRadius=CGRectGetWidth(_iconImg.frame)/2;
        _iconImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_iconImg];
        //name
        _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame) +(AutoTrans(20)), AutoTrans(23), AutoTrans(500), AutoTrans(50))];
        _nameLb.textColor=[UIColor colorWithHexString:@"#333333"];
        _nameLb.font=[UIFont systemFontOfSize:AutoTrans(34)];
        [self.contentView  addSubview:_nameLb];
        //_content
        _contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLb.frame), CGRectGetMaxY(_nameLb.frame), CGRectGetWidth(_nameLb.frame), CGRectGetHeight(_nameLb.frame))];
        _contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
        _contentLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        _contentLb.numberOfLines=0;
        [self.contentView  addSubview:_contentLb];
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

@end
