//
//  WordSeaTestVC.m
//  YouXingWords
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "WordSeaTestVC.h"

@interface WordSeaTestVC ()
@property(nonatomic,retain)CustomTitleView *titleView;
@end

@implementation WordSeaTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self ShowRightItemWithTitle:@"调用" action:@selector(custo) target:self];
    [self setNav];
}
#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
    [self.view sendSubviewToBack:backgroundImg];
    
}

- (void)setNav{
    [self addBackgroundView];
//        self.title = @"词汇量测试";
    _titleView=[CustomTitleView customTitleView:@"词汇量测试" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
        
    }];
    [self.view addSubview:_titleView];
    
    //    UIButton *_leftBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(120), AutoTrans(80))];
    //    [_leftBt setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    //    _leftBt.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
    //    [_leftBt setTitle:@" 返回" forState:UIControlStateNormal];
    //    [_leftBt addTarget:self action:@selector(leftBtClick) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBt];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    CustomTitleView * _titleView=[CustomTitleView customTitleView:@"好友" rightTitle:@"" leftBtAction:^{
    //        //返回上一个页面
    //        [self.navigationController popViewControllerAnimated:YES];
    //    } rightBtAction:^{
    //        //
    //
    //    }];
    //    _titleView.backgroundColor = [UIColor colorWithHexString:@"2FB4E8"];
    //    [self.view addSubview:_titleView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"2FB4E8"];
}

-(void)leftBtClick{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)customizeWKWebView{
    self.webView.scrollView.bounces = NO;
}
- (void)customizeConfigure{
    //    self.url = @"index.html";
    
    //    self.url = @"http://blog.csdn.net/crazy_frog/article/details/8664108/";
    self.url = @"wordtest/index.html";
//    self.parameters = [NSString stringWithFormat:@"token=%@?phone=%@",[Utils getCurrentToken],[Utils getCurrentUserName]];
    self.parameters = @"";
    self.methodNames = @[@"Location",@"Color"];
    self.webViewEdgeInsets = UIEdgeInsetsMake(30 + (AutoTrans(80)), 0, 0, 0);
    
}
- (void)Location:(NSString *)str{
    self.title = str;
}
- (void)Color{
    
}

@end
