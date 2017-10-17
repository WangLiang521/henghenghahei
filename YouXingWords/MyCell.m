//
//  MyCell.m
//  YouXingWords
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(25), AutoTrans(36), AutoTrans(36))];
        [self.contentView addSubview:_leftImage];
        
        _contentLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame)+(AutoTrans(10)), _leftImage.frame.origin.y, AutoTrans(200), AutoTrans(40))];
        _contentLable.textColor=[UIColor colorWithHexString:@"#666666"];
        _contentLable.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [self.contentView addSubview:_contentLable];
        
        _rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_contentLable.frame)+(AutoTrans(370)), self.center.y-(AutoTrans(10)),AutoTrans(20), AutoTrans(20))];
        _rightImage.image=[UIImage imageNamed:@"icon_kuozhanjiao"];
        [self.contentView addSubview:_rightImage];
        
        
        if ([reuseIdentifier isEqualToString:@"cellID"]) {
            
            _detailLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_contentLable.frame)+(AutoTrans(20)), _contentLable.frame.origin.y+(AutoTrans(5)), AutoTrans(300), AutoTrans(30))];
            _detailLable.textColor=[UIColor colorWithHexString:@"#999999"];
            _detailLable.text=@"英语词汇快速突破初级班上";
            _detailLable.textAlignment = NSTextAlignmentRight;
            
            _detailLable.font=[UIFont systemFontOfSize:AutoTrans(24)];
            
            [self.contentView addSubview:_detailLable];
            
        }
        
        
    }
    return self;
}


@end
