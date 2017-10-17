//
//  PayTypeCell.m
//  LuoKeLock
//
//  Created by Apple on 2017/3/24.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "PayTypeCell.h"

@interface PayTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageCheck;


@end


@implementation PayTypeCell

- (void)setDataWithModel:(GDBaseCellModel *)model{
    self.lblTitle.text = model.titleBase;
    self.imageTitle.image = [UIImage imageNamed:model.leftImageName];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _imageCheck.image = [UIImage imageNamed:@"icon_check.png"];
    }else{
        _imageCheck.image = [UIImage imageNamed:@"icon_uncheck.png"];
    }
}

- (void)otherInit{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
