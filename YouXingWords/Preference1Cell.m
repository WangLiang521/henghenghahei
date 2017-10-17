//
//  Preference1Cell.m
//  YouXingWords
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "Preference1Cell.h"

@implementation Preference1Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _contentLable=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(34), AutoTrans(200), AutoTrans(26))];
        _contentLable.font=[UIFont systemFontOfSize:AutoTrans(30)];
        _contentLable.backgroundColor=[UIColor colorWithHexString:@"#333333"];
        
        [self.contentView addSubview:_contentLable];
        
        _aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame)-(AutoTrans(20)), AutoTrans(22), AutoTrans(100), AutoTrans(50))];
        [_aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        _aSwitch setBackgroundColor:[UIColor colorWithHexString:@""]
        [self.contentView addSubview:_aSwitch];
        
        
    }
    return self;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
       
    }else {
       
    }
}
@end
