//
//  RankCell.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"cellID"]) {
            //排行图片
            _rankImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(50), AutoTrans(80), AutoTrans(80))];
            _rankImg.layer.cornerRadius=CGRectGetWidth(_rankImg.frame)/2;
            _rankImg.layer.masksToBounds=YES;
            [self.contentView addSubview:_rankImg];
        }else if ([reuseIdentifier isEqualToString:@"cellID1"]){
            //排行label
            _rankLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(50), AutoTrans(80), AutoTrans(80))];
            _rankLb.backgroundColor=[UIColor colorWithWhite:0.892 alpha:1.000];
            _rankLb.layer.cornerRadius=CGRectGetWidth(_rankLb.frame)/2;
            _rankLb.layer.masksToBounds=YES;
            _rankLb.textAlignment=NSTextAlignmentCenter;
            _rankLb.font=[UIFont systemFontOfSize:AutoTrans(36)];
            _rankLb.layer.borderColor=[UIColor colorWithWhite:0.727 alpha:1.000].CGColor;
            _rankLb.layer.borderWidth=1.2;
            [self.contentView addSubview:_rankLb];
        }
        //人物头像
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(140),AutoTrans(40), AutoTrans(100), AutoTrans(100))];
        _iconImg.layer.cornerRadius=CGRectGetWidth(_iconImg.frame)/2;
        _iconImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_iconImg];
        //人物名称
        _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame)+(AutoTrans(20)), CGRectGetMinY(_iconImg.frame)+(AutoTrans(10)), AutoTrans(100), CGRectGetHeight(_iconImg.frame)/2)];
        _nameLb.font=[UIFont systemFontOfSize:AutoTrans(36)];
        _nameLb.textColor=[UIColor colorWithHexString:@"#919191"];
        [self.contentView addSubview:_nameLb];
        //用时
        _timeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLb.frame), CGRectGetMaxY(_nameLb.frame), CGRectGetWidth(_nameLb.frame), CGRectGetHeight(_nameLb.frame))];
        _timeLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
        _timeLb.textColor=[UIColor colorWithHexString:@"#c3c3c3"];
        [self.contentView addSubview:_timeLb];
        //地点
        _placeLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(300)), CGRectGetMinY(_nameLb.frame), AutoTrans(200), CGRectGetHeight(_nameLb.frame))];
        _placeLb.textAlignment=NSTextAlignmentRight;
        _placeLb.textColor=[UIColor colorWithHexString:@"#999999"];
        _placeLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [self.contentView addSubview:_placeLb];
        //钻石数量
        _diamondLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(200)), CGRectGetMinY(_timeLb.frame), AutoTrans(100), CGRectGetHeight(_timeLb.frame))];
        _diamondLb.textAlignment=NSTextAlignmentCenter;
        _diamondLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
        _diamondLb.textColor=[UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_diamondLb];
        //钻石图片
        _diamondImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_diamondLb.frame)-CGRectGetHeight(_timeLb.frame), CGRectGetMinY(_timeLb.frame),CGRectGetHeight(_timeLb.frame), CGRectGetHeight(_timeLb.frame))];
        _diamondImg.image=[[UIImage imageNamed:@"icon_gold"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        [self.contentView addSubview:_diamondImg];
        
        
        
        
        
        
        
    }
    return self;
}

@end
