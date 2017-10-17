//
//  YXProgressBar.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "YXProgressBar.h"

@interface YXProgressBar()
{
    __block MASConstraint *newConstraint;

}

@end
@implementation YXProgressBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat hight4White = AutoTrans(30);
        CGFloat hight4Blue = AutoTrans(22);
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = hight4White/2;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *blueView = [[UIView alloc]initWithFrame:CGRectZero];
        blueView.tag = 222;
        blueView.layer.masksToBounds = YES;
        blueView.layer.cornerRadius =hight4Blue/2;
        blueView.backgroundColor = [UIColor colorWithHexString:@"#0999ff"];
        [self addSubview:blueView];
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset((AutoTrans(4)));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(@(hight4Blue));
            newConstraint =  make.width.mas_equalTo(@(0));

        }];
        
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        infoLabel.textColor = [UIColor colorWithHexString:@"#adadad"];
        infoLabel.textAlignment =1;
        infoLabel.font = [UIFont systemFontOfSize:AutoTrans(18)];
        infoLabel.tag = 333;
        [self addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(@(hight4Blue));
            
        }];
        
        
        
    }
    return self;
}
-(void)setSum:(NSInteger)sum{
    _sum = sum;
    if (_sum==0) {
        _sum=1;
        self.hidden = YES;
    }
    ((UILabel *)[self viewWithTag:333]).text = [NSString stringWithFormat:@"%ld/%ld",(long)_current,(long)sum];
    
}
-(void)setCurrent:(NSInteger)current{
    _current = current;
    NSLog(@"%lu",_current);
    ((UILabel *)[self viewWithTag:333]).text = [NSString stringWithFormat:@"%ld/%ld",(long)_current,(long)_sum];
    if (_current > _sum / 2) {
        ((UILabel *)[self viewWithTag:333]).textColor = [UIColor whiteColor];
    }else{
        ((UILabel *)[self viewWithTag:333]).textColor = [UIColor colorWithHexString:@"#adadad"];
    }
    //[self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [((UILabel *)[self viewWithTag:222]) mas_updateConstraints:^(MASConstraintMaker *make) {
            [newConstraint uninstall];
            CGFloat multiple =_current*1.0/_sum;
            newConstraint = make.width.mas_equalTo(self.mas_width).multipliedBy(multiple).offset(-(AutoTrans(8)));
            [newConstraint install];

        }];
        
        [self layoutIfNeeded];
    }];
    

}
@end
