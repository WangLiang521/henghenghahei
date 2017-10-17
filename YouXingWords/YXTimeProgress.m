//
//  YXTimeProgress.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "YXTimeProgress.h"

@interface YXTimeProgress()
{
    __block MASConstraint *newConstraint;
    
}
@property (nonatomic,retain)UIImageView *circleImg;
@property (nonatomic,assign)BOOL isStop;
@end
@implementation YXTimeProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isStop = NO;
        CGFloat hight4White = AutoTrans(6);
        CGFloat hight4Blue = AutoTrans(6);
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = hight4White/2;
        self.backgroundColor = [UIColor clearColor];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius =hight4Blue/2;
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#e8edf1"];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(@(hight4Blue));
            make.width.mas_equalTo(self.mas_width);
            
        }];
        
        
        UIView *blueView = [[UIView alloc]initWithFrame:CGRectZero];
        blueView.tag = 2222;
        blueView.layer.masksToBounds = YES;
        blueView.layer.cornerRadius =hight4Blue/2;
        blueView.backgroundColor = [UIColor colorWithHexString:@"#0999ff"];
        [self addSubview:blueView];
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(@(hight4Blue));
            newConstraint =  make.width.mas_equalTo(@(0));
            
        }];
        
        
        _circleImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_circleImg setImage:[UIImage imageNamed:@"barrier_bg_timer_p"]];
        
        [self addSubview:_circleImg];
        [_circleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(blueView.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(@(hight4Blue*2));
            make.width.mas_equalTo(@(hight4Blue*2));
            
        }];
        
        
        
    }
    return self;
}
-(void)setSum:(NSInteger)sum{
    _sum = sum;
    ((UILabel *)[self viewWithTag:3333]).text = [NSString stringWithFormat:@"%ld/%ld",(long)_current,(long)sum];
    
}
-(void)setCurrent:(NSInteger)current{
    if (_isStop) {
        return;
    }
    if (_sum<_current-1) {
        return;
    }
    
    _current = current;
    if (_current==0) {
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [((UILabel *)[self viewWithTag:2222]) mas_updateConstraints:^(MASConstraintMaker *make) {
                [newConstraint uninstall];
                
                newConstraint = make.width.mas_equalTo(@0);
                [newConstraint install];
                
            }];
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    ((UILabel *)[self viewWithTag:3333]).text = [NSString stringWithFormat:@"%ld/%ld",(long)current,(long)_sum];
    
    if (_sum!=0) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [((UILabel *)[self viewWithTag:2222]) mas_updateConstraints:^(MASConstraintMaker *make) {
                [newConstraint uninstall];
                
                newConstraint = make.width.mas_equalTo(self.mas_width).multipliedBy((current)*1.00/_sum).offset(-(AutoTrans(8)));
                [newConstraint install];
                
            }];
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (_sum!=0) {
        if (_sum==_current-1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate arriveEnd];
            });
        }
    }
    

    
//    if (_sum<_current) {
//        return;
//    }
//    _current = current;
//    
//    ((UILabel *)[self viewWithTag:3333]).text = [NSString stringWithFormat:@"%ld/%ld",(long)current,(long)_sum];
//
//    if (_sum!=0) {
//        [self layoutIfNeeded];
//        [UIView animateWithDuration:1 animations:^{
//            [((UILabel *)[self viewWithTag:2222]) mas_updateConstraints:^(MASConstraintMaker *make) {
//                [newConstraint uninstall];
//                
//                newConstraint = make.width.mas_equalTo(self.mas_width).multipliedBy(current*1.00/_sum).offset(-(AutoTrans(8)));
//                [newConstraint install];
//                
//            }];
//            
//            [self layoutIfNeeded];
//        }];
//    }
//   
//    if (_sum!=0) {
//        if (_sum==_current) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.delegate arriveEnd];
//            });
//        }
//    }
    
}
-(void)beginMove{
    _isMoving = YES;
    if (_sum!=0) {
        [self layoutIfNeeded];
        [self viewWithTag:2222].frame = CGRectMake(0, 0, 0, AutoTrans(6));
        _circleImg.frame = CGRectMake(0, 0, AutoTrans(12), AutoTrans(12));
        _circleImg.center =CGPointMake(0, self.center.y);

        [UIView animateWithDuration:_sum animations:^{
            [self viewWithTag:2222].frame = CGRectMake(0, 0, self.frame.size.width-(AutoTrans(8)), AutoTrans(6));
            _circleImg.center =CGPointMake(self.frame.size.width-(AutoTrans(8)), self.center.y);


        }];
//        [UIView animateWithDuration:0 animations:^{
////            [((UILabel *)[self viewWithTag:2222]) mas_updateConstraints:^(MASConstraintMaker *make) {
////                [newConstraint uninstall];
////                
////                newConstraint = make.width.mas_equalTo(self.mas_width).multipliedBy(0/_sum).offset(-(AutoTrans(8)));
////                [newConstraint install];
////                
////            }];
//            
//            [self layoutIfNeeded];
//        }];
//        
//        
//        [UIView animateWithDuration:10 animations:^{
//            [((UILabel *)[self viewWithTag:2222]) mas_updateConstraints:^(MASConstraintMaker *make) {
//                [newConstraint uninstall];
//                
//                newConstraint = make.width.mas_equalTo(self.mas_width).multipliedBy(_sum*1.00/_sum).offset(-(AutoTrans(8)));
//                [newConstraint install];
//                
//            }];
//            
//            [self layoutIfNeeded];
//        }];
    }
}
-(void)start{
    self.isStop = NO;
}
-(void)stop{
    self.isStop = YES;
}
@end
