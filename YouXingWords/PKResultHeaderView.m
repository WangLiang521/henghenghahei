//
//  PKResultHeaderView.m
//  YouXingWords
//
//  Created by wangliang on 16/11/22.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PKResultHeaderView.h"


@interface PKResultHeaderView ()


@property (weak, nonatomic) IBOutlet UILabel *lblGetD;

@property (weak, nonatomic) IBOutlet UILabel *lblMIngci;


@end


@implementation PKResultHeaderView

+(instancetype)shareWith:(NSString *)uZuan Mingci:(NSString *)mingci{

    PKResultHeaderView * pkView = [[[NSBundle mainBundle] loadNibNamed:@"PKResultHeaderView" owner:nil options:nil] lastObject];
    pkView.lblGetD.text = [NSString stringWithFormat:@"X%@",uZuan];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜您!获得第%@名!",mingci]];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, attributeString.string.length)];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(6, mingci.length)];

    pkView.lblGetD.attributedText = attributeString;


    return pkView;
}


@end
