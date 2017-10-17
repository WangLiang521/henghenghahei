//
//  GDHidenPassWordView.m
//  YouXingWords
//
//  Created by Apple on 2017/3/23.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "GDHidenPassWordView.h"


@interface GDHidenPassWordView ()

@property (strong, nonatomic) IBOutlet  UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;

@property (copy, nonatomic)  NSString * password;

@property (copy, nonatomic)  void(^rightPassBlock)(void) ;

@end


@implementation GDHidenPassWordView




+(instancetype)shareWithView:(UIView *)contentView PassRightBlock:(void(^)(void))passBlock{
    GDHidenPassWordView * pwView = [[[NSBundle mainBundle] loadNibNamed:@"GDHidenPassWordView" owner:nil options:nil] lastObject];
    pwView.rightPassBlock = passBlock;
    [contentView addSubview:pwView];
    CGRect frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    pwView.frame = frame;
    return pwView;
}


- (IBAction)tapBtn:(UIButton *)btn {
    self.password = [self.password stringByAppendingFormat:@"%zd",btn.tag];
    
    if ([self.password isEqualToString:GDHidenPassWord]) {
        if (self.rightPassBlock) {
            self.rightPassBlock();
        }
    }
    
    
}

- (NSString *)password{
    if (!_password) {
        _password = [NSString string];
    }
    return _password;
}


- (void)otherInit{
    
    self.backgroundColor = GDHidenColor;
    for (UIView * subview in self.subviews) {
        subview.backgroundColor = GDHidenColor;
    }
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
