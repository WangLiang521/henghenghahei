//
//  ReportWordCell.m
//  YouXingWords
//
//  Created by LDJ on 16/11/9.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ReportWordCell.h"

@interface ReportWordCell()
@property (nonatomic,retain)UIView *blueView;
@property (nonatomic,retain)UIImageView *checkImg;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *transLabel;
@property (nonatomic,retain)UIButton *transButton;

@end
@implementation ReportWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(30))*2;
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _blueView = [[UIView alloc]initWithFrame:self.bounds];
        _blueView.backgroundColor =         [UIColor colorWithRed:0.188 green:0.659 blue:0.878 alpha:1.000];
        [self addSubview:_blueView];
        _blueView.hidden = YES;
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(20), 0, AutoTrans(200), self.frame.size.height)];
        _titleLabel.textColor = [UIColor colorWithRed:0.188 green:0.659 blue:0.878 alpha:1.000];
        _titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        
        
        _transLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(20), 0, self.frame.size.width, self.frame.size.height)];
        _transLabel.textColor = [UIColor whiteColor];
        _transLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        _transLabel.hidden = YES;
        
        
        _checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(200), (self.frame.size.height-(AutoTrans(40)))/2, AutoTrans(40), AutoTrans(40))];
        _checkImg.image = [UIImage imageNamed:@"icon_smileface"];
        [self addSubview:_checkImg];
        [self addSubview:_titleLabel];
        [self addSubview:_transLabel];
        [self addSubview:self.transButton];
        
    }
    return  self;
}
-(UIButton *)transButton{
    if (!_transButton) {
        _transButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(60))-(AutoTrans(25)), self.frame.size.height/2-(AutoTrans(30)), AutoTrans(60),AutoTrans(60))];
        [_transButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_transButton setImage:[UIImage imageNamed:@"barrier_icon_swich_normal"] forState:UIControlStateNormal];
    }
    return _transButton;
}

-(void)setIsEven:(BOOL)isEven{
    _isEven = isEven;
    if (isEven) {
        self.backgroundColor =    [UIColor colorWithRed:0.961 green:0.980 blue:0.992 alpha:1.000];
    }else{
        self.backgroundColor =    [UIColor whiteColor];
    }
}
-(void)setIsRight:(BOOL)isRight{
    _isRight = isRight;
    if (isRight) {
        _checkImg.image = [UIImage imageNamed:@"icon_smile"];

    }else{
        _checkImg.image = [UIImage imageNamed:@"icon_smileface"];

    }
}
-(void)buttonOnClick:(UIButton *)button{
    _blueView.hidden = !_blueView.hidden;
    
    _transLabel.hidden = _blueView.hidden;
    _titleLabel.hidden = !_blueView.hidden;
    _checkImg.hidden = !_blueView.hidden;
    if (_blueView.hidden) {
        
    }
    if (self.block) {
        self.block();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setWord:(NSString *)word{
    _word =word;
    _titleLabel.text = word;
}
-(void)setExplain:(NSString *)explain{
    _explain = explain;
    _transLabel.text = explain;
}
@end
