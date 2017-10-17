//
//  MessageCell.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/16.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //iconImg
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(30), AutoTrans(84), AutoTrans(84))];
//        _iconImg.backgroundColor=[UIColor lightGrayColor];
        _iconImg.layer.cornerRadius=AutoTrans(84)/2;
        _iconImg.layer.cornerRadius=CGRectGetWidth(_iconImg.frame)/2;
        _iconImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_iconImg];
        //name
        _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame) +(AutoTrans(20)), AutoTrans(30), AutoTrans(500), AutoTrans(50))];
        _nameLb.textColor=[UIColor colorWithHexString:@"#333333"];
        _nameLb.font=[UIFont systemFontOfSize:AutoTrans(34)];
        [self.contentView  addSubview:_nameLb];
        //_content
        _contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLb.frame), CGRectGetMaxY(_nameLb.frame), CGRectGetWidth(_nameLb.frame), CGRectGetHeight(_nameLb.frame))];
        _contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
        _contentLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        _contentLb.numberOfLines=0;
        [self.contentView  addSubview:_contentLb];
        //时间
        _timeLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(240)), CGRectGetMinY(_nameLb.frame), AutoTrans(200), CGRectGetHeight(_nameLb.frame))];
        _timeLb.textAlignment=NSTextAlignmentRight;
        _timeLb.textColor=[UIColor colorWithHexString:@"#999999"];
        _timeLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        [self.contentView  addSubview:_timeLb];
        //消息个数
        _msgCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLb.frame)-(AutoTrans(40)), CGRectGetMaxY(_timeLb.frame)+(AutoTrans(7)), AutoTrans(36), AutoTrans(36))];
        _msgCountLb.backgroundColor=[UIColor colorWithHexString:@"#f74c31"];
        _msgCountLb.textAlignment=NSTextAlignmentCenter;
        _msgCountLb.textColor=[UIColor whiteColor];
        _msgCountLb.layer.cornerRadius=(AutoTrans(36))/2;
        _msgCountLb.layer.masksToBounds=YES;
        _msgCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        [self.contentView  addSubview:_msgCountLb];
        //未读小红点
        _noReadLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLb.frame)+(AutoTrans(10)), CGRectGetMinY(_timeLb.frame)-(AutoTrans(10)), AutoTrans(8), AutoTrans(8))];
        _noReadLb.backgroundColor=[UIColor redColor];
        _noReadLb.layer.cornerRadius=CGRectGetWidth(_noReadLb.frame)/2;
        _noReadLb.layer.masksToBounds=YES;
        _noReadLb.hidden=YES;
        [self.contentView  addSubview:_noReadLb];
        
        
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
