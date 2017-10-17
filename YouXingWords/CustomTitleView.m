//
//  CustomTitleView.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "CustomTitleView.h"

@interface CustomTitleView ()

//左边按钮点击事件
@property(nonatomic,copy)leftBtAction leftBtActionBlock;
//右边按钮点击事件
@property(nonatomic,copy)rightBtAction rightBtActionBlock;
//页面主标题
@property(nonatomic,copy)NSString *mainTitle;
//右边标题
@property(nonatomic,copy)NSString *rightTitle;


@end

@implementation CustomTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //左边按钮
//        _leftBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(20), 0, AutoTrans(120), frame.size.height)];
        _leftBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(20), 0, AutoTrans(120), frame.size.height)];
        [_leftBt setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
        _leftBt.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        [_leftBt setTitle:@" 返回" forState:UIControlStateNormal];
        [_leftBt addTarget:self action:@selector(leftBtClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBt];
        //title
        _titleLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(AutoTrans(150)), 0, AutoTrans(300), frame.size.height)];
        _titleLb.textAlignment=NSTextAlignmentCenter;
        _titleLb.textColor=[UIColor whiteColor];
        _titleLb.font=[UIFont systemFontOfSize:AutoTrans(40)];
        [self addSubview:_titleLb];
        //右边按钮
        _rightBt=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-(AutoTrans(100))-10, 0, AutoTrans(100), frame.size.height)];
        _rightBt.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        [_rightBt addTarget:self action:@selector(rightBtClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBt];
    }
    return self;
}
+(instancetype)customTitleView:(NSString *)mainTitle
            rightTitle:(NSString *)rightTitle
          leftBtAction:(leftBtAction)leftBtBlock
         rightBtAction:(rightBtAction)rightBtBlock;
{
    CustomTitleView *customTitleView=[[CustomTitleView alloc]initWithFrame:CGRectMake(0,30, SCREEN_WIDTH, AutoTrans(80))];
    customTitleView.mainTitle=mainTitle;
    customTitleView.rightTitle=rightTitle;
    customTitleView.leftBtActionBlock=leftBtBlock;
    customTitleView.rightBtActionBlock=rightBtBlock;

    return customTitleView;
}
-(void)setMainTitle:(NSString *)mainTitle
{
    _titleLb.text=mainTitle;
}
-(void)setRightTitle:(NSString *)rightTitle
{
    if ([rightTitle isEqualToString:@""]) {
        _rightBt.hidden=YES;
    }else{
        [_rightBt setTitle:rightTitle forState:UIControlStateNormal];
    }
}
#pragma mark---左边按钮点击事件
-(void)leftBtClick
{
    self.leftBtActionBlock();
}
#pragma mark---右边按钮点击事件
-(void)rightBtClick
{
    self.rightBtActionBlock();

}




@end
