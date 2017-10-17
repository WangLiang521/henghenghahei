//
//  AboutUsVC.m
//  YouXingWords
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@property (weak, nonatomic) IBOutlet UIImageView *imageIC;


@property(nonatomic,retain)CustomTitleView *titleView;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSMutableString *currentVersion = [[NSMutableString alloc]initWithFormat:@"优行单词：%@",[infoDic objectForKey:@"CFBundleShortVersionString"] ];
    self.lblVersion.text = currentVersion;
    
    [self addTitleView];
    self.imageIC.layer.cornerRadius = 5;
    self.imageIC.layer.masksToBounds = YES;
}

#pragma mark---添加表头
-(void)addTitleView
{
    _titleView=[CustomTitleView customTitleView:@"关于我们" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
        
    }];
    [self.view addSubview:_titleView];
}


//- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
////        self.navigationController.navigationBar.hidden = NO;
////    self.navigationController.navigationBar.hidden = NO;
//    [super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    //    self.navigationController.navigationBar.hidden = YES;
//    [super viewWillDisappear:animated];
//}


@end
