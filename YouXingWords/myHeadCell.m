//
//  myHeadCell.m
//  YouXingWords
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "myHeadCell.h"

@implementation myHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius=10;
        self.layer.masksToBounds=YES;
        //头像
        _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(44), AutoTrans(32), AutoTrans(154), AutoTrans(154))];
        _headerImg.layer.cornerRadius=CGRectGetWidth(_headerImg.frame)/2;
        _headerImg.layer.masksToBounds=YES;
        _headerImg.userInteractionEnabled=YES;
        [self.contentView addSubview:_headerImg];
        //名字
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headerImg.frame)+(AutoTrans(20)), AutoTrans(74), AutoTrans(200), AutoTrans(50))];
        _nameLab.text=@"王书香";
        _nameLab.adjustsFontSizeToFitWidth = YES;
        _nameLab.tintColor=[UIColor blackColor];
        _nameLab.font=[UIFont systemFontOfSize:AutoTrans(36)];
        [self.contentView addSubview:_nameLab];
        //手机号
        _phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x, CGRectGetMaxY(_nameLab.frame)+(AutoTrans(15)), AutoTrans(250), AutoTrans(50))];
        _phoneLab.text=@"13370895476";
        _phoneLab.textColor=[UIColor grayColor];
        _phoneLab.adjustsFontSizeToFitWidth = YES;

        _phoneLab.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [_phoneLab sizeToFit];
        [self.contentView addSubview:_phoneLab];
        
        //砖石tupian
        _zhuanImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(200)), _nameLab.frame.origin.y, AutoTrans(38), AutoTrans(30))];
        _zhuanImg.image=[UIImage imageNamed:@"icon_gold"];
        [self.contentView addSubview:_zhuanImg];
        
        //分数
        _numberLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_zhuanImg.frame)+(AutoTrans(5)), _zhuanImg.frame.origin.y, AutoTrans(160), AutoTrans(30))];
        _numberLab.text=@"3005";
        _numberLab.textColor=[UIColor colorWithRed:0.918 green:0.439 blue:0.000 alpha:1.000];
        _numberLab.font=[UIFont systemFontOfSize:AutoTrans(25)];
//        [_numberLab sizeToFit];
        [self.contentView addSubview:_numberLab];
#warning 显示抽奖

        if (![TestUserName isEqualToString:[Utils getCurrentUserName]]) {
            _chouJiaBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_zhuanImg.frame)+(AutoTrans(10)), CGRectGetMaxY(_zhuanImg.frame)+(AutoTrans(10)), AutoTrans(102), AutoTrans(48))];
            _chouJiaBtn.backgroundColor=[UIColor colorWithHexString:@"#38b7e5"];
            [_chouJiaBtn setTitle:@"抽奖" forState:UIControlStateNormal];
            [_chouJiaBtn addTarget:self action:@selector(pushToLuckyDraw:) forControlEvents:UIControlEventTouchUpInside];
            _chouJiaBtn.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(24)];
        }
        
        
        _chouJiaBtn.layer.cornerRadius=5;
        _chouJiaBtn.layer.masksToBounds=YES;
        
        [self.contentView addSubview:_chouJiaBtn];

    }
    
    return self;
}
-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(30))*2;
    [super setFrame:frame];
}

#warning 隐藏抽奖
-(void)pushToLuckyDraw:(UIButton *)button{
    [self.delegate pushToLucky];
}


@end
