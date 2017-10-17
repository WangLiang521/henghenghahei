//
//  BaseCell.m
//  EasyWedding
//
//  Created by wangliang on 16/8/22.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.


#import "GDBaseCell.h"

@interface GDBaseCell   ()

@property (assign, nonatomic)  BOOL notFirst;

@end

@implementation GDBaseCell

- (void)setDataWithModel:(GDBaseCellModel *)model{
    if (!model) {
        return;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_notFirst) {
        [self setUpViews];
        if (self.showSeparatorLine) {
            UIImageView *separatorImage = [UIImageView new];
            separatorImage.backgroundColor = ColorBaseBGGray;
            WS(weakSelf);
            [self.contentView addSubview:separatorImage];
            [separatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(weakSelf.contentView);
                make.left.mas_equalTo(20);
                make.width.mas_equalTo(SCREEN_WIDTH - 20);
                make.height.mas_equalTo(1);
            }];
        }
    }
    _notFirst = YES;
}
- (void)setUpViews {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCutImageWith:(UIImageView *)imageView imageUrl:(NSString *)iamgeUrl{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iamgeUrl]];
        UIImage * image =[UIImage imageWithData:data];
        UIImage * imageCuted = [UIView CutImage:image withSize:imageView.size];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = imageCuted;
        });
    });
}



@end
