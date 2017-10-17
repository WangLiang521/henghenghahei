//
//  NewNoteBookCell.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NewNoteBookCell.h"

@implementation NewNoteBookCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _nameLb.backgroundColor=[UIColor grayColor];
//        [self.contentView addSubview:_nameLb];
        
    }
    return self;
}

- (void)setModel:(NoteModel *)model{
    _model = model;
    self.textLabel.text=model.word;
    self.detailTextLabel.text=[NSString stringWithFormat:@"错误%@次",model.wrongCounts];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#38b7e5"];
        self.textLabel.textColor=[UIColor whiteColor];
        self.detailTextLabel.textColor=[UIColor whiteColor];
        
        
        //start
#pragma mark gd_将dic改为model  2017-01-16

        self.textLabel.text=_model.explain;
        //end
    }else{
        
        self.textLabel.textColor=[UIColor colorWithHexString:@"#38b7e5"];
        self.detailTextLabel.textColor=[UIColor colorWithHexString:@"#999999"];
        
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.text=_model.word;
        self.detailTextLabel.text=[NSString stringWithFormat:@"错误%@次",_model.wrongCounts];
    }
    
}



@end
