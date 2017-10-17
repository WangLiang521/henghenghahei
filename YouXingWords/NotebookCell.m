//
//  NotebookCell.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NotebookCell.h"


@interface NotebookCell()
@property (nonatomic,retain)UIView *backView;
@property (nonatomic,retain)UILabel *wordLabel;
@property (nonatomic,retain)UILabel *timeLabel;

@end
@implementation NotebookCell

-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(30))*2;
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _backView = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(20), 0, self.frame.size.width-(AutoTrans(20))*2, self.frame.size.height)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#f6fafc"];
        [self addSubview:_backView];
        _wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(20), AutoTrans(0), AutoTrans(500), AutoTrans(40))];
        _wordLabel.textColor = [UIColor colorWithHexString:@"#38b7e5"];
        _wordLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
        [self.backView addSubview:_wordLabel];
//        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36),CGRectGetMaxY(_nameLabel.frame)+(AutoTrans(10)), AutoTrans(500), AutoTrans(40))];
//        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//        _descriptionLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//        //_titleLabel.text = @"hahahah";
//        [self addSubview:_descriptionLabel];
//        _checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(62))-(AutoTrans(36)), AutoTrans(45), AutoTrans(62),AutoTrans(62))];
//        _checkImg.image =[UIImage imageNamed:@"icon_jujiao"];
//        [self addSubview:_checkImg];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36), AutoTrans(153)-1, self.frame.size.width-(AutoTrans(36))*2, 1)];
        label.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [self addSubview:label];
        
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
