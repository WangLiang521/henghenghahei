//
//  PKResultCell.m
//  YouXingWords
//
//  Created by wangliang on 16/11/22.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PKResultCell.h"


@interface PKResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewJ;

@property (weak, nonatomic) IBOutlet UIImageView *imageHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *lblRight;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UILabel *lblCoins;

@property (weak, nonatomic) IBOutlet UILabel *lblMingci;


@end


@implementation PKResultCell

- (void)setDataWithModel:(PKResultModel *)model indexPath:(NSIndexPath *)indexPath{
    self.lblCoins.text = [NSString stringWithFormat:@"X%@",model.coins];
    self.lblRight.text = model.rightCounts;
    self.lblTime.text = model.userTime;
    [self.imageHeaderView sd_setImageWithURL:[NSURL URLWithString:model.signPhoto] placeholderImage:[UIImage imageNamed:@"message_icon_default"]];

    switch (indexPath.row) {
        case 0:
            self.imageViewJ.image = [UIImage imageNamed:@"icon_number1.png"];
//            self.imageViewJ.hidden = NO;
            self.lblMingci.hidden = YES;
            break;

        case 1:
            self.imageViewJ.image = [UIImage imageNamed:@"icon_number1.png"];
//            self.imageViewJ.hidden = NO;
            break;

        case 2:
            self.imageViewJ.image = [UIImage imageNamed:@"icon_number1.png"];
//            self.imageViewJ.hidden = NO;
            self.lblMingci.hidden = YES;
            break;

        case 3:
//            self.imageViewJ.hidden = YES;
            self.lblMingci.hidden = NO;
            self.imageViewJ.image = [UIImage imageNamed:@"icon_other"];
            self.lblMingci.text = [NSString stringWithFormat:@"%zd",indexPath.row];
            break;

        default:
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageHeaderView.layer.cornerRadius = 25;
    self.imageHeaderView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
