
//
//  FriendRankVC.m
//  YouXingWords
//
//  Created by Apple on 2017/3/22.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "FriendRankVC.h"

@interface FriendRankVC ()

@end

@implementation FriendRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self ShowRightItemWithTitle:@"调用" action:@selector(custo) target:self];
    [self setNav];
}
- (void)setNav{
//    self.title = @"好友";
    
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}

//- (void)custo{
//    [self doJsWith:@"locationClick()" completionHandler:^(id _Nullable str , NSError * _Nullable error) {
//        NSLog(@"custo");
//    }];
//}
- (void)customizeWKWebView{
    self.webView.scrollView.bounces = NO;
}
- (void)customizeConfigure{
//    self.url = @"index.html";
    
//    self.url = @"http://blog.csdn.net/crazy_frog/article/details/8664108/";
    self.url = @"production/index.html";
    self.parameters = [NSString stringWithFormat:@"token=%@&phone=%@&type=%@",[Utils getCurrentToken],[Utils getCurrentUserName],self.type];
    self.methodNames = @[@"Location",@"Color"];
    self.webViewEdgeInsets = UIEdgeInsetsMake(-(AutoTrans(20)), 0, 0, 0);

}
- (void)Location:(NSString *)str{
    self.title = str;
}
- (void)Color{
    
}

@end
