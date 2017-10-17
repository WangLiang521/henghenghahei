//
//  BrowerChooseCell.m
//  YouXingWords
//
//  Created by tih on 16/9/7.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BrowerChooseCell.h"

@interface BrowerChooseCell ()
@property (nonatomic,retain)UIImageView *checkImg;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UIButton *transButton;

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isNOTShow;
@end
@implementation BrowerChooseCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(40))*2;
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(20), (self.frame.size.height-(AutoTrans(60)))/2, AutoTrans(60), AutoTrans(60))];
        _checkImg.image = [UIImage imageNamed:@"barrier_ck_checked"];
        [self addSubview:_checkImg];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(90), 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        //_titleLabel.text = @"hahahah";
        [self addSubview:_titleLabel];
        _transButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(138))-(AutoTrans(20)), self.frame.size.height/2-(AutoTrans(24)), AutoTrans(138),AutoTrans(48))];
        [_transButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _transButton.layer.masksToBounds = YES;
        _transButton.layer.cornerRadius =AutoTrans(12);
        _transButton.layer.borderWidth =1;
        _transButton.layer.borderColor = [UIColor colorWithHexString:@"#d6d6d6"].CGColor;
        _transButton.backgroundColor = [UIColor colorWithHexString:@"#fbfdfe"];
        [_transButton setTitle:@"查看解释" forState:UIControlStateNormal];
        [_transButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _transButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(24)];
        [self addSubview:_transButton];
        _isSelected = NO;
        
    }
    return  self;
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
    [self setIsNOTShow:item.isNOTShow];
    
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [_transButton setTitle:@"单词" forState:UIControlStateNormal];
        _titleLabel.text = _item.qExplain;
    }else{
        [_transButton setTitle:@"查看解释" forState:UIControlStateNormal];
        _titleLabel.text = _item.qWord;
    }
    
}
-(void)setIsNOTShow:(BOOL)isNOTShow{
    _isNOTShow = isNOTShow;
    if (_isNOTShow) {
        [_checkImg setImage:[UIImage imageNamed:@"barrier_ck_unchecked"]];
    }
    else{
        [_checkImg setImage:[UIImage imageNamed:@"barrier_ck_checked"]];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
