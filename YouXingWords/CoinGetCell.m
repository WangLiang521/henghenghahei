//
//  CoinGetCell.m
//  YouXingWords
//
//  Created by Apple on 2017/5/27.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "CoinGetCell.h"


@interface CoinGetCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblCoins;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;


@end


@implementation CoinGetCell

- (void)setItem:(GetCoinModel *)item{
    [self setModel:item];
}

- (void)setModel:(GetCoinModel *)model{
    self.lblTitle.text = model.operType;
    self.lblCoins.text = [NSString stringWithFormat:@"%@",model.coins];
    self.lblTime.text = [LGDUtils stringFromTimeInterval:model.createTim WithFormatterString:FormatterStringyyyy_MM_dd];
}


- (void)otherInit{
    _lblTitle.font = [UIFont systemFontOfSize:AutoTrans(30)];
    _lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    
    
    _lblCoins.textColor = [UIColor colorWithHexString:@"#ff9154"];
    _lblCoins.font = [UIFont systemFontOfSize:AutoTrans(30)];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self otherInit];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self otherInit];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self otherInit];
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
