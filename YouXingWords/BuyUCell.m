//
//  BuyUCell.m
//  YouXingWords
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "BuyUCell.h"


@interface BuyUCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblCoins;


@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

@end


@implementation BuyUCell

- (void)setModel:(BuyUModel *)model{
    self.lblCoins.text = [NSString stringWithFormat:@"%@优钻",model.coins];
    self.lblMoney.text = [NSString stringWithFormat:@"%0.2f元",[model.money doubleValue]];
    
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.lblMoney.textColor = [UIColor whiteColor];
        self.lblCoins.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor orangeColor];
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.lblMoney.textColor = [UIColor orangeColor];
        self.lblCoins.textColor = [UIColor orangeColor];
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}

- (void)otherInit{
    self.lblMoney.textColor = [UIColor orangeColor];
    self.lblCoins.textColor = [UIColor orangeColor];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat cornerRadius = 3.0;
    self.layer.cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
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


@end
