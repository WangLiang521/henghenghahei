//
//  NewFriendsCell.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NewFriendsCell.h"

@implementation NewFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //iconImg
        //start
#pragma mark gd_改变 frame 和 layer 因为图像切成尖头的了  2017-04-04 19:46:24
//        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(30), AutoTrans(84), AutoTrans(84))];
//        _iconImg.layer.cornerRadius=AutoTrans(84)/2;
        
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(GDAutoTrans(30), GDAutoTrans(30), GDAutoTrans(84), GDAutoTrans(84))];
        _iconImg.layer.cornerRadius=GDAutoTrans(84)/2;
        
        //end
        
        _iconImg.backgroundColor=[UIColor lightGrayColor];
        _iconImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_iconImg];
        //name
        _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame) +10, AutoTrans(30), AutoTrans(160), AutoTrans(50))];
        _nameLb.textColor=[UIColor colorWithHexString:@"#333333"];
        _nameLb.font=[UIFont systemFontOfSize:AutoTrans(34)];
        [self.contentView  addSubview:_nameLb];
        //name1
        _nameLb1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLb.frame), AutoTrans(30), AutoTrans(200), AutoTrans(50))];
        _nameLb1.textColor=[UIColor colorWithHexString:@"#999999"];
        _nameLb1.font=[UIFont systemFontOfSize:AutoTrans(24)];
        [self.contentView  addSubview:_nameLb1];
        //_content
        _contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLb.frame), CGRectGetMaxY(_nameLb.frame), AutoTrans(500), CGRectGetHeight(_nameLb.frame))];
        _contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
        _contentLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        [self.contentView  addSubview:_contentLb];
        //同意按钮
        _agreeBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(160)), AutoTrans(37), AutoTrans(130), AutoTrans(56))];
        [self.contentView  addSubview:_agreeBt];
//        
//        //消息个数
//        _msgCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_agreeBt.frame)+(AutoTrans(10)), CGRectGetMaxY(_nameLb.frame)+(AutoTrans(7)), AutoTrans(36), AutoTrans(36))];
//        _msgCountLb.backgroundColor=[UIColor colorWithHexString:@"#f74c31"];
//        _msgCountLb.textAlignment=NSTextAlignmentCenter;
//        _msgCountLb.textColor=[UIColor whiteColor];
//        _msgCountLb.layer.cornerRadius=(AutoTrans(36))/2;
//        _msgCountLb.layer.masksToBounds=YES;
//        _msgCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//        [self.contentView  addSubview:_msgCountLb];
    }
    return self;
}

@end
