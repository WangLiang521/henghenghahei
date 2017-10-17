//
//  TaskCell.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell ()
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UIImageView *diamondImg;
@property (nonatomic,retain)UILabel *diamondNumLabel;
@property (nonatomic,retain)UIButton *action;
@property (nonatomic,retain)UILabel *line;


@end
@implementation TaskCell
-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(30))*2;
    frame.size.height =AutoTrans(100);
    [super setFrame:frame];}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(35), 0, AutoTrans(150), self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//        _titleLabel.textAlignment = 1;
        _diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0, AutoTrans(60), self.frame.size.height)];
        _diamondImg.contentMode  = UIViewContentModeCenter;
        _diamondImg.image = [UIImage imageNamed:@"icon_gold"];
        _diamondNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondImg.frame), 0, AutoTrans(60), self.frame.size.height)];
        _diamondNumLabel.textColor = [UIColor colorWithHexString:@"#ff9154"];
        
        _action = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-(AutoTrans(35))-(AutoTrans(120)), AutoTrans(25), AutoTrans(120), AutoTrans(50))];
        _action.layer.masksToBounds = YES;
        _action.layer.cornerRadius = AutoTrans(8);
        _action.layer.borderWidth = 1;
        _action.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _action.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        
        WS(weakSelf)
        
        [_action tapBlock:^{
            if (weakSelf.tapblock) {
                weakSelf.tapblock();
            }
        }];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(35), (AutoTrans(100))-1, self.frame.size.width-(AutoTrans(35))*2, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.diamondImg];
        [self.contentView addSubview:self.diamondNumLabel];
        [self.contentView addSubview:self.action];
        [self.contentView addSubview:self.line];
        
    }
    return  self;
}

-(void)setItem:(TaskModel *)item{
    _item = item;
    self.titleLabel.text = item.title;
    self.diamondNumLabel.text = item.num;
    if (item.isDiamond) {
        self.diamondImg.hidden = NO;
        self.diamondNumLabel.hidden = NO;
    }else{
        self.diamondImg.hidden = YES;
        self.diamondNumLabel.hidden = YES;
    }
    
    if (item.isComplete) {
        [self.action setTitle:@"已完成" forState:UIControlStateNormal];
        [self.action setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.action.backgroundColor = [UIColor whiteColor];
//        self.action.layer.borderWidth = 1;
    }else{
        [self.action setTitle:@"前往" forState:UIControlStateNormal];
        [self.action setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.action.backgroundColor = [UIColor colorWithHexString:@"#57c8f1"];
//        self.action.layer.borderWidth = 0;
    }
    
    if ([item.title isEqualToString:@"每日签到"]) {
        self.action.hidden = YES;
    }else{
        self.action.hidden = NO;
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
