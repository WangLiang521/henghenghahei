//
//  BrowerCell.m
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BrowerCell.h"

@interface BrowerCell ()
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UIButton *transButton;

@property (nonatomic,assign) BOOL isSelected;
@end
@implementation BrowerCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(40))*2;
    [super setFrame:frame];
}
-(void)layoutSubviews{
    [super layoutSubviews];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.transButton];

        _isSelected = NO;
        
    }
    return  self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(25), 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        //_titleLabel.text = @"hahahah";
    }
    return _titleLabel;
}
-(UIButton *)transButton{
    if (!_transButton) {
        _transButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(60))-(AutoTrans(25)), self.frame.size.height/2-(AutoTrans(30)), AutoTrans(60),AutoTrans(60))];
        [_transButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_normal"] forState:UIControlStateNormal];
    }
    return _transButton;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#dddddd"].CGColor);
    CGFloat lengths[] = {4,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, AutoTrans(25), rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width- (AutoTrans(25))*2, rect.size.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);

}
-(void)buttonOnClick:(UIButton *)button{
    self.isSelected = !_isSelected;
    if (self.block) {
        self.block();
    }
//    if (!_isSelected) {
//        [_transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_selected"] forState:UIControlStateNormal];
//        _titleLabel.text = _item.qExplain;
//        _isSelected = YES;
//    }else{
//        [_transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_normal"] forState:UIControlStateNormal];
//        _titleLabel.text = _item.qWord;
//        _isSelected = NO;
//    }
}
-(void)setItem:(QsModel *)item{
    
    _item = item;
    [self setIsSelected:item.isSelected];

}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [self.transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_selected"] forState:UIControlStateNormal];
        self.titleLabel.text = _item.qExplain;
    }else{
        [self.transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_normal"] forState:UIControlStateNormal];
        self.titleLabel.text = _item.qWord;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
