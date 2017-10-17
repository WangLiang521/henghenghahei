//
//  CreatPayCodeVC.m
//  LuoKeLock
//
//  Created by Apple on 2017/3/25.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "CreatPayCodeVC.h"

#import "SGQRCodeTool.h"

@interface CreatPayCodeVC ()


@end

@implementation CreatPayCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString * userName = [Utils getCurrentUserName];
    _imageCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:userName imageViewWidth:SCREEN_WIDTH - 100];
    
//    self.lblTitle.text =[NSString stringWithFormat:@"打开%@扫码收款",_payType];
    [self setUpNav];
}

- (void)setUpNav{
    self.title = @"我的二维码";
}




@end
