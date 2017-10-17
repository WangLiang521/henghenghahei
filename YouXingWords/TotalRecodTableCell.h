//
//  TotalRecodTableCell.h
//  YouXingWords
//
//  Created by wangliang on 2016/12/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TotalDetailModel.h"

@interface TotalRecodTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *dateLb;
@property (strong, nonatomic) UIImageView *smallIconImg;
@property (strong, nonatomic) UILabel *nameLabelleft;
@property (strong, nonatomic) UILabel *wordLabelleft;
@property (strong, nonatomic) UIImageView *winImgLeft;
@property (strong, nonatomic) UIImageView *titleImage;
@property (strong, nonatomic) UIImageView *winImg;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *wordLabel;
@property (strong, nonatomic) UILabel *pkLabel;
@property (strong, nonatomic) UILabel *resultL;

@property (strong, nonatomic)  TotalDetailModel *model;

@end
