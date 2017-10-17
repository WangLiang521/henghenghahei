//
//  ChoiceLong.m
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChoiceLong.h"

@interface ChoiceLong ()

@property (nonatomic,retain)UIView *whiteView;
@property (nonatomic,retain)UILabel *titleLabel;
@end
@implementation ChoiceLong

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithHexString:@"#fdfbfe"];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        _greenView = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(6), AutoTrans(6), frame.size.width-((AutoTrans(6))*2), frame.size.height-((AutoTrans(6))*2))];
        _greenView.backgroundColor = [UIColor colorWithHexString:@"#79cc51"];
        _greenView.layer.masksToBounds = YES;
        _greenView.layer.cornerRadius = 10;
        _greenView.hidden = YES;
        [self addSubview:_greenView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:_greenView.frame];

        //start
#pragma mark gd_修改字体大小  2017-03-15 11:48:55
//        _titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28.8)];
        _titleLabel.font = [UIFont systemFontOfSize:FontSizeAnswerText];
        //end
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment =1;
        [self addSubview:_titleLabel];
        
        
        
    }
    return self;
}
-(void)setItem:(ChioceModel *)item{
    [super setItem:item];
    _titleLabel.text = item.title;
}
-(void)didSelected{
    _greenView.backgroundColor = [UIColor colorWithHexString:@"#79cc51"];

    self.greenView.hidden = NO;
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self didSelected];
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self resetGreen];
//}
-(void)resetGreen{
    self.backgroundColor = [UIColor whiteColor];

    _greenView.backgroundColor = [UIColor colorWithHexString:@"#79cc51"];

    self.greenView.hidden = YES;

}
//-(void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];
//    if (highlighted) {
//        [self didSelected];
//    }else{
//        [self resetGreen];
//    }
//}
-(void)setWrong{
    _greenView.backgroundColor = [UIColor colorWithRed:1.000 green:0.254 blue:0.268 alpha:1.000];
    
    self.greenView.hidden = NO;
}
-(void)toGray{
    self.backgroundColor = [UIColor grayColor];
}   
@end
