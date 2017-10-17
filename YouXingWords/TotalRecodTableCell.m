//
//  TotalRecodTableCell.m
//  YouXingWords
//
//  Created by wangliang on 2016/12/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TotalRecodTableCell.h"

@implementation TotalRecodTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView{

    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#fbfbfb"];
    self.contentView.layer.cornerRadius = 60;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0.677 alpha:1.000].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    //日期
    _dateLb =[[UILabel alloc]initWithFrame:CGRectMake(60,10, 80, 15)];
    _dateLb.text=@"7月1号";
    _dateLb.font=[UIFont systemFontOfSize:12];
    _dateLb.textColor=[UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_dateLb];
    //左边小头像
    _smallIconImg =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_dateLb.frame), CGRectGetMaxY(_dateLb.frame)+5,40, 40)];
    _smallIconImg.layer.cornerRadius= 20;
    _smallIconImg.layer.masksToBounds=YES;
    _smallIconImg.image=[UIImage imageNamed:DefaultUserHeadImg];
    [self.contentView addSubview:_smallIconImg];

    //名称+时间(左)
    _nameLabelleft = [[UILabel alloc] init];
    _nameLabelleft.font=[UIFont systemFontOfSize:12];
    _nameLabelleft.textColor=[UIColor colorWithHexString:@"#333333"];
    _nameLabelleft.textAlignment=NSTextAlignmentCenter;
    _nameLabelleft.text = @"我sanfe";
    [self.contentView addSubview:_nameLabelleft];
    [_nameLabelleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_smallIconImg.mas_centerX);
        make.top.equalTo(_smallIconImg.mas_bottom).offset(5);
    }];
    //正确单词数量（左）
    _wordLabelleft = [[UILabel alloc] init];
    _wordLabelleft.font=[UIFont systemFontOfSize:12];
    _wordLabelleft.textColor=[UIColor colorWithHexString:@"#333333"];
    _wordLabelleft.textAlignment=NSTextAlignmentCenter;
    _wordLabelleft.text = @"正确30词/90秒";
    [self.contentView addSubview:_wordLabelleft];
    [_wordLabelleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_nameLabelleft.mas_centerX);
        make.top.equalTo(_nameLabelleft.mas_bottom).offset(5);
    }];

    //胜利的皇冠图片（左）
    _winImgLeft = [[UIImageView alloc] init];
    _winImgLeft.image = [UIImage imageNamed:@"icon_goldcrown"];
    _winImgLeft.transform = CGAffineTransformMakeRotation(M_PI*1.4);
    [self.contentView addSubview:_winImgLeft];
    [_winImgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_smallIconImg.mas_centerY).offset(-8);
        make.left.equalTo(self.contentView).offset(50);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    //右边头像
    _titleImage = [[UIImageView alloc] init];
    _titleImage.layer.cornerRadius = 20;
    _titleImage.layer.masksToBounds = YES;
    _titleImage.image = [UIImage imageNamed:DefaultUserHeadImg];
    [self.contentView addSubview:_titleImage];
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_smallIconImg.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-60);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    //胜利的皇冠图片
    _winImg = [[UIImageView alloc] init];
    _winImg.image = [UIImage imageNamed:@"icon_goldcrown"];
    _winImg.transform = CGAffineTransformMakeRotation(-M_PI*0.05);
    [self.contentView addSubview:_winImg];
    [_winImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleImage.mas_centerY).offset(-8);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    //名称+时间(右)
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font=[UIFont systemFontOfSize:12];
    _nameLabel.textColor=[UIColor colorWithHexString:@"#333333"];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.text = @"我sanfe";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleImage.mas_centerX);
        make.top.equalTo(_titleImage.mas_bottom).offset(5);
    }];

    //正确单词数量（右）
    _wordLabel = [[UILabel alloc] init];
    _wordLabel.font=[UIFont systemFontOfSize:12];
    _wordLabel.textColor=[UIColor colorWithHexString:@"#333333"];
    _wordLabel.textAlignment=NSTextAlignmentCenter;
    _wordLabel.text = @"正确30词/90秒";
    [self.contentView addSubview:_wordLabel];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_nameLabel.mas_centerX);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
    }];

    _pkLabel = [[UILabel alloc] init];
    _pkLabel.text = @"好友PK";
    _pkLabel.textColor=[UIColor colorWithHexString:@"#fd7900"];
    _pkLabel.font=[UIFont boldSystemFontOfSize:AutoTrans(30)];
    _pkLabel.textAlignment=NSTextAlignmentCenter;
    _pkLabel.numberOfLines=0;
    [self.contentView addSubview:_pkLabel];
    [_pkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-10);
    }];

    _resultL = [[UILabel alloc] init];
    _resultL.text = @"输了";
    _resultL.textAlignment=NSTextAlignmentCenter;
    _resultL.textColor=[UIColor whiteColor];
    _resultL.font=[UIFont systemFontOfSize:12];
    _resultL.layer.cornerRadius=10.5;
    _resultL.layer.masksToBounds=YES;

    [self.contentView addSubview:_resultL];
    [_resultL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pkLabel.mas_bottom).offset(5);
        make.centerX.equalTo(_pkLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(48, 21));
    }];

    //名称+时间
//    UILabel *nameAndTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(smallIconImg.center.x-80, CGRectGetMaxY(smallIconImg.frame)+(AutoTrans(10)), 160, AutoTrans(40))];
//
//    nameAndTimeLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//    nameAndTimeLb.textColor=[UIColor colorWithHexString:@"#333333"];
//    nameAndTimeLb.textAlignment=NSTextAlignmentCenter;
//    [self.contentView addSubview:nameAndTimeLb];
//    //改变字体颜色
//    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:nameAndTimeLb.text];
//    NSRange stringRange =NSMakeRange(1, 4); //该字符串的位置
//    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange];
//    [nameAndTimeLb setAttributedText: noteString];
//    //正确单词数量
//
//        UILabel *wordsCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameAndTimeLb.frame), CGRectGetMaxY(nameAndTimeLb.frame), CGRectGetWidth(nameAndTimeLb.frame), CGRectGetHeight(nameAndTimeLb.frame))];
//        wordsCountLb.textColor=[UIColor colorWithHexString:@"#999999"];
//        wordsCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//        wordsCountLb.text=@"正确30词/90秒";
//        wordsCountLb.textAlignment=NSTextAlignmentCenter;
//        [self.contentView addSubview:wordsCountLb];

//    //PK类型
//    UILabel *PKTypeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_recordInfoView.frame)/2-30, CGRectGetMinY(smallIconImg.frame), 60, CGRectGetHeight(smallIconImg.frame))];
//    PKTypeLb.textColor=[UIColor colorWithHexString:@"#fd7900"];
//    PKTypeLb.font=[UIFont boldSystemFontOfSize:AutoTrans(30)];
//    PKTypeLb.textAlignment=NSTextAlignmentCenter;
//    PKTypeLb.numberOfLines=0;
//    if (i==0) {
//        PKTypeLb.text=@"好友PK";
//    }else{
//        PKTypeLb.text=@"竞技场\n山师附小";
//        //改变字体颜色和大小
//        NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:PKTypeLb.text];
//        NSRange stringRange =NSMakeRange(3, 5); //该字符串的位置
//        [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange];
//        [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(24)] range:stringRange];
//        [PKTypeLb setAttributedText: noteString];
//    }
//    [_recordInfoView addSubview:PKTypeLb];
    //比赛结果
//    UILabel *resultLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(PKTypeLb.frame), CGRectGetMaxY(PKTypeLb.frame)+(AutoTrans(10)), CGRectGetWidth(PKTypeLb.frame), AutoTrans(40))];
//    resultLb.textAlignment=NSTextAlignmentCenter;
//    resultLb.textColor=[UIColor whiteColor];
//    resultLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//    resultLb.layer.cornerRadius=CGRectGetHeight(resultLb.frame)/2;
//    resultLb.layer.masksToBounds=YES;
//    if (i==0) {
//        resultLb.text=@"输了";
//        resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[1]];
//    }else if(i==1){
//        resultLb.text=@"平局";
//        resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[2]];
//    }else if(i==2){
//        resultLb.text=@"胜利";
//        resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[0]];
//    }
//    [_recordInfoView addSubview:resultLb];
    //其他人的小头像
//    UIImageView *otherImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_recordInfoView.frame)-(AutoTrans(120))-(AutoTrans(80)), CGRectGetMinY(smallIconImg.frame), CGRectGetWidth(smallIconImg.frame), CGRectGetWidth(smallIconImg.frame))];
//    otherImg.layer.cornerRadius=CGRectGetWidth(otherImg.frame)/2;
//    otherImg.layer.masksToBounds=YES;
//    otherImg.image=[UIImage imageNamed:@"icon_me"];
//    [_recordInfoView addSubview:otherImg];
//    //名称+时间
//    UILabel *otherNameAndTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(otherImg.center.x-80, CGRectGetMaxY(otherImg.frame)+(AutoTrans(10)), 160, AutoTrans(40))];
//    if (i==0) {
//        otherNameAndTimeLb.text=@"他 5分钟";
//    }else{
//        otherNameAndTimeLb.text=@"他 第1名";
//    }
//    otherNameAndTimeLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//    otherNameAndTimeLb.textColor=[UIColor colorWithHexString:@"#333333"];
//    otherNameAndTimeLb.textAlignment=NSTextAlignmentCenter;
//    [_recordInfoView addSubview:otherNameAndTimeLb];
//    //改变字体颜色
//    NSMutableAttributedString *otherNoteString = [[NSMutableAttributedString alloc] initWithString:otherNameAndTimeLb.text];
//    NSRange stringRange3 =NSMakeRange(1, 4); //该字符串的位置
//    [otherNoteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange3];
//    [otherNameAndTimeLb setAttributedText: otherNoteString];
//    //正确单词数量
//    if (i!=0) {
//        UILabel *wordsCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(otherNameAndTimeLb.frame), CGRectGetMaxY(otherNameAndTimeLb.frame), CGRectGetWidth(otherNameAndTimeLb.frame), CGRectGetHeight(otherNameAndTimeLb.frame))];
//        wordsCountLb.textColor=[UIColor colorWithHexString:@"#ff8d55"];
//        wordsCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
//        wordsCountLb.text=@"正确30词/60秒";
//        wordsCountLb.textAlignment=NSTextAlignmentCenter;
//        [_recordInfoView addSubview:wordsCountLb];
//    }
}

- (void)setModel:(TotalDetailModel *)model{

    _dateLb.text = [NSString stringWithFormat:@"%@",[Utils wltimeByTimeStamp:model.createTim]];


    [_titleImage sd_setImageWithURL:[NSURL URLWithString:model.usernameImage] placeholderImage:[UIImage imageNamed:DefaultUserHeadImg]];
    [_smallIconImg sd_setImageWithURL:[NSURL URLWithString:model.obUsernameImage] placeholderImage:[UIImage imageNamed:DefaultUserHeadImg]];

    _pkLabel.text = model.exName;

    if (model.isWin == 0) {
        _resultL.text = @"平局";
        _winImg.hidden = YES;
        _winImgLeft.hidden = YES;
        _resultL.backgroundColor=[UIColor colorWithHexString:@"#78b9f9"];

        if (model.exType == 1) {
            NSMutableAttributedString *otherNoteString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.obName,model.obUseTime/60]];
            NSRange stringRange1 =NSMakeRange(model.obName.length, otherNoteString1.length-model.obName.length); //该字符串的位置
            [otherNoteString1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange1];
            [_nameLabel setAttributedText: otherNoteString1];

            NSMutableAttributedString *otherNoteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.name,model.userTime/60]];
            NSRange stringRange3 =NSMakeRange(model.name.length, otherNoteString.length-model.name.length); //该字符串的位置
            [otherNoteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange3];
            [_nameLabelleft setAttributedText: otherNoteString];
            _wordLabel.hidden = YES;
            _wordLabelleft.hidden = YES;
        }else if (model.exType == 2){
            _nameLabelleft.text = [NSString stringWithFormat:@"%@ 第%ld名",model.name,model.userRanking];
            _nameLabel.text = [NSString stringWithFormat:@"%@ 第%ld名",model.obName,model.obRanking];
            _wordLabelleft.hidden = NO;
            _wordLabel.hidden = NO;
            _wordLabelleft.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.userValue,model.userTime/60];
            _wordLabel.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.obValue,model.obUseTime/60];
            _wordLabelleft.textColor = [UIColor colorWithHexString:@"#ff8d55"];
            _wordLabel.textColor = [UIColor colorWithHexString:@"#ff8d55"];
        }
        
    }else if (model.isWin == 1){
        _resultL.text = @"胜利";
        _winImgLeft.hidden = NO;
        _winImg.hidden = YES;
        _resultL.backgroundColor=[UIColor colorWithHexString:@"#db4213"];

        if (model.exType == 1) {
            NSMutableAttributedString *otherNoteString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.obName,model.obUseTime/60]];
            NSRange stringRange1 =NSMakeRange(model.obName.length, otherNoteString1.length-model.obName.length); //该字符串的位置
            [otherNoteString1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange1];
            [_nameLabel setAttributedText: otherNoteString1];

            NSMutableAttributedString *otherNoteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.name,model.userTime/60]];
            NSRange stringRange3 =NSMakeRange(model.name.length, otherNoteString.length-model.name.length); //该字符串的位置
            [otherNoteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange3];
            [_nameLabelleft setAttributedText: otherNoteString];
            _wordLabel.hidden = YES;
            _wordLabelleft.hidden = YES;
        }else if (model.exType == 2){
            _nameLabelleft.text = [NSString stringWithFormat:@"%@ 第%ld名",model.name,model.userRanking];
            _nameLabel.text = [NSString stringWithFormat:@"%@ 第%ld名",model.obName,model.obRanking];

            _wordLabelleft.hidden = NO;
            _wordLabel.hidden = NO;
            _wordLabelleft.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.userValue,model.userTime/60];
            _wordLabel.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.obValue,model.obUseTime/60];
            _wordLabelleft.textColor = [UIColor colorWithHexString:@"#ff8d55"];
            _wordLabel.textColor = [UIColor colorWithHexString:@"#999999"];

        }

    }else if (model.isWin == -1){
        _resultL.text = @"输了";
        _winImg.hidden = NO;
        _winImgLeft.hidden = YES;
        _resultL.backgroundColor=[UIColor colorWithHexString:@"#ffba00"];

        if (model.exType == 1) {
            NSMutableAttributedString *otherNoteString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.obName,model.obUseTime/60]];
            NSRange stringRange1 =NSMakeRange(model.obName.length, otherNoteString1.length-model.obName.length); //该字符串的位置
            [otherNoteString1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange1];
            [_nameLabel setAttributedText: otherNoteString1];

            NSMutableAttributedString *otherNoteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld分钟",model.name,model.userTime/60]];
            NSRange stringRange3 =NSMakeRange(model.name.length, otherNoteString.length-model.name.length); //该字符串的位置
            [otherNoteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange3];
            [_nameLabelleft setAttributedText: otherNoteString];
            _wordLabel.hidden = YES;
            _wordLabelleft.hidden = YES;
        }else if (model.exType == 2){
            _nameLabelleft.text = [NSString stringWithFormat:@"%@ 第%ld名",model.name,model.userRanking];
            _nameLabel.text = [NSString stringWithFormat:@"%@ 第%ld名",model.obName,model.obRanking];

            _wordLabelleft.hidden = NO;
            _wordLabel.hidden = NO;
            _wordLabelleft.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.userValue,model.userTime/60];
            _wordLabel.text = [NSString stringWithFormat:@"正确%ld词//%ld秒",model.obValue,model.obUseTime/60];
            _wordLabelleft.textColor = [UIColor colorWithHexString:@"#999999"];
            _wordLabel.textColor = [UIColor colorWithHexString:@"#ff8d55"];
        }

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
