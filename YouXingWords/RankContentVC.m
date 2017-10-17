//
//  RankContentVC.m
//  YouXingWords
//
//  Created by Apple on 2017/5/11.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "RankContentVC.h"
#import "RankVC.h"
#import "FriendRankVC.h"

@interface RankContentVC ()

@property (strong, nonatomic)  UISegmentedControl *segmentedControl;


@property (assign, nonatomic)  BOOL alreadySetUp;


@end

@implementation RankContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WS(weakSelf);
    //    通过通知中心接收通知  接收精选和最新切换的通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"YZDisplayViewClickOrScrollDidFinshNote" object:nil queue:nil usingBlock:^(NSNotification *note) {
        FriendRankVC * vc = note.object;
//        if ([note.object isKindOfClass:[RankVC class]]) {
        if ([vc.type isEqualToString:@"2"]) {
            weakSelf.segmentedControl.selectedSegmentIndex = 0;
           
            
        }else if ([note.object isKindOfClass:[FriendRankVC class]]) {
            weakSelf.segmentedControl.selectedSegmentIndex = 1;
            
        }
        
    }];
    
    [self setUpAfterLog];
    
    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIView reSizeImage:[UIImage imageNamed:@"icon_AddNew"] toSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
//    [button sizeToFit];
//    [button addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.title = @"self.navigationItem.rightBarButtonItem";
//    [self setUpTittleView];
//    [self setUpStyle];
//    [self setUpAllViewController];
}



- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//        self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    self.navigationController.navigationBar.hidden = YES;
    [super viewWillDisappear:animated];
}

- (void)setUpAfterLog{
    self.alreadySetUp = YES;
    [self setUpTittleView];
    
    [self setUpStyle];
    [self setUpAllViewController];
    [self setNav];

}


- (void)setNav{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    //        [button setImage:[UIImage imageNamed:backBarbuttonItemHighlightedImageName] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(70, 40);
    //        // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        //        [button sizeToFit];
    //        // 让按钮的内容往左边偏移10
    //        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    ////        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ////        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //
    //        // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTittleView{
    UISegmentedControl * segmentControl  = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"好友"]];
    segmentControl.frame = CGRectMake(0, 0, 200, 30);
    //设置回调方法
    [segmentControl addTarget:self action:@selector(tapSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    //设置segmentControl默认按键
    segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentControl;
    self.segmentedControl = segmentControl;
}

- (void)tapSegmentedControl:(UISegmentedControl * )sender{
    if (sender.selectedSegmentIndex == 0) {
        //        选中了商家
        [self setSelectIndex:0];
        
    }else{
        //        选中了优婚品
        [self setSelectIndex:1];
        
        
    }
}

- (void)setUpStyle{
    // 设置整体内容尺寸（包含标题滚动视图和底部内容滚动视图）
    [self setUpContentViewFrame:^(UIView *contentView) {
        
        CGFloat contentX = 0;
        
        CGFloat contentY = 64;
        
        CGFloat contentH = SCREEN_HEIGHT ;
        
        contentView.frame = CGRectMake(contentX, contentY, SCREEN_WIDTH, contentH);
        
    }];
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        //        *norColor = ColorTextLightRed;
        //        *selColor = ColorTextRed;
        //
        //        *titleWidth = [UIScreen mainScreen].bounds.size.width / 2;
        *titleHeight = 0;
    }];
    
}



- (void)setUpAllViewController{
    
    
    
    
//    RankVC * rank = [[RankVC alloc] init];
//    rank.title = @"全部";
//    rank.titleStr=@"排行榜";
//    rank.urlStr=FriendRank;
    FriendRankVC * rank  =[[FriendRankVC alloc] init];
    rank.title = @"排行榜";
    rank.type = @"2";
    [self addChildViewController:rank];
    
    FriendRankVC * fineViewController  =[[FriendRankVC alloc] init];
    fineViewController.title = @"好友";
    fineViewController.type = @"1";
    
    [self addChildViewController:fineViewController];
    
}

@end
