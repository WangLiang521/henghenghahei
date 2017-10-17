//
//  DetailVC.m
//  YouXingWords
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblDetail.text = self.detail;
    // Do any additional setup after loading the view from its nib.
}



@end
