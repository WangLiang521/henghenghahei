//
//  PassCell.m
//  YouXingWords
//
//  Created by LDJ on 16/8/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PassCell.h"

@interface PassCell()
@property (nonatomic,retain)UIImageView *lockImg;
//@property (nonatomic,retain)UIImageView *numberImgV;
@property (nonatomic,retain)UILabel *classLabel;


@property (nonatomic,retain)UIImageView *centerDiamond;
@property (nonatomic,retain)UIImageView *leftDiamond;
@property (nonatomic,retain)UIImageView *rightDiamond;
@end
@implementation PassCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /**
         前8后6  上8下6
         */
        UIImageView *backImg = [[UIImageView alloc]initWithFrame:YXFrame(8, 8, 130, 162)];
        [backImg setImage:[UIImage imageNamed:@"barrier_bg_class"]];
        [self addSubview:backImg];
        
        _lockImg = [[UIImageView alloc]initWithFrame:YXFrame(0, 0, 50, 64)];
        [_lockImg setImage:[UIImage imageNamed:@"barrier_icon_lock"]];
        [self addSubview:_lockImg];
        
        _classLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(100), AutoTrans(20))];
        _classLabel.center = CGPointMake(backImg.center.x, AutoTrans(34));
        _classLabel.textAlignment =1;
        _classLabel.font = [UIFont fontWithName:HYCHAOCU size:AutoTrans(18)];
        _classLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _classLabel.shadowColor = [UIColor colorWithHexString:@"#3a230a"];
        _classLabel.shadowOffset = CGSizeMake(-1, 1);
        _classLabel.text = @"第一课";
        [self addSubview:_classLabel];
        
        _numberLabel = [[UILabel alloc]initWithFrame:YXFrame(0, 0, 80, 80)];
        _numberLabel.center = backImg.center;
        _numberLabel.textAlignment =1;
        _numberLabel.font = [UIFont fontWithName:HYCHAOCU size:AutoTrans(64)];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _numberLabel.shadowColor = [UIColor colorWithHexString:@"#3a230a"];
        _numberLabel.shadowOffset = CGSizeMake(-1, 1);
        _numberLabel.text = @"1";
        _numberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_numberLabel];
        //16=32/2 120是估计
        _centerDiamond = [[UIImageView alloc]initWithFrame:CGRectMake(backImg.center.x-(AutoTrans(16)),AutoTrans(120), AutoTrans(32), AutoTrans(32))];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [self addSubview:_centerDiamond];
        
        //数据同上 除了x坐标为center-32
        _leftDiamond = [[UIImageView alloc]initWithFrame:CGRectMake(_centerDiamond.frame.origin.x-(AutoTrans(32)), _centerDiamond.frame.origin.y, _centerDiamond.frame.size.width, _centerDiamond.frame.size.height)];
        [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [self addSubview:_leftDiamond];
        
        //数据同上 除了x坐标为center+32
        _rightDiamond = [[UIImageView alloc]initWithFrame:CGRectMake(_centerDiamond.frame.origin.x+(AutoTrans(32)), _centerDiamond.frame.origin.y, _centerDiamond.frame.size.width, _centerDiamond.frame.size.height)];
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [self addSubview:_rightDiamond];
        
    }
    return self;
}
-(void)setItem:(PassModel *)item{
  
    _item = item;
    if (_item.isNULL) {
        self.hidden = YES;
//        self.alpha = 0;
    }else{
//        self.alpha = 1;
        self.hidden =NO;
    }
    _classLabel.text = item.course;

    _numberLabel.text = item.passName;
    
    //start
#pragma mark gd_隐藏复习关钻石  2017-01-19
    if ([item.passName isEqualToString:@"复习关"] ) {
        self.leftDiamond.hidden = YES;
        self.centerDiamond.hidden = YES;
        self.rightDiamond.hidden = YES;
    }else{
        self.leftDiamond.hidden = NO;
        self.centerDiamond.hidden = NO;
        self.rightDiamond.hidden = NO;
    }
    //end

}
-(void)setNumber:(NSNumber *)number{
    _number = number;
    if ([_number isEqualToNumber:@1]) {
        _lockImg.hidden = YES;
    }else{
        _lockImg.hidden = NO;

    }
}
-(void)setDiamondNumber:(NSNumber *)diamondNumber{
    _diamondNumber = diamondNumber;
    if ([diamondNumber isEqualToNumber:@3]) {
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];

    }
    else if ([diamondNumber isEqualToNumber:@2]){
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
        [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
    }
    else if ([diamondNumber isEqualToNumber:@1]){
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
        [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected"]];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
    }else{
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
        [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal"]];
    }
}
@end
