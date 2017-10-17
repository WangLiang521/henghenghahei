//
//  MessageContentViewController.m
//  YouXingWords
//
//  Created by Apple on 2017/1/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "MessageContentViewController.h"
#import "MessageVC.h"
#import "MessageViewController.h"
#import "AddNewFriendVC.h"
#import "AddFriendsTypeVC.h"
@interface MessageContentViewController ()

@property (strong, nonatomic)  UISegmentedControl *segmentedControl;


@property (assign, nonatomic)  BOOL alreadySetUp;
@property (strong, nonatomic)  MessageVC *messageVC;

@end

@implementation MessageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WS(weakSelf);
    //    通过通知中心接收通知  接收精选和最新切换的通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"YZDisplayViewClickOrScrollDidFinshNote" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([note.object isKindOfClass:[MessageVC class]]) {
            weakSelf.segmentedControl.selectedSegmentIndex = 1;
            if (weakSelf.messageVC.addressTableView) {
                [weakSelf.messageVC addAddressNetData];
            }
            
        }else if ([note.object isKindOfClass:[MessageViewController class]]) {
            weakSelf.segmentedControl.selectedSegmentIndex = 0;
            
        }
        
    }];
    
     [self setUpAfterLog];
    

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIView reSizeImage:[UIImage imageNamed:@"icon_AddNew"] toSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.messageVC addAddressNetData];
    }
    
}

- (void)addFriend{
//    AddNewFriendVC *vc = [[AddNewFriendVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//#import "AddFriendsTypeVC.h"
    AddFriendsTypeVC *vc = [[AddFriendsTypeVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = AddFriendTypeFriend;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpAfterLog{
    self.alreadySetUp = YES;
    [self setUpTittleView];
    
    [self setUpStyle];
    [self setUpAllViewController];

}

- (void)setUpTittleView{
    UISegmentedControl * segmentControl  = [[UISegmentedControl alloc] initWithItems:@[@"消息",@"通讯录"]];
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
        
        CGFloat contentY = 0;
        
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
    
    
    MessageViewController * fineViewController  =[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    fineViewController.title = @"消息";
    
    [self addChildViewController:fineViewController];
    
    MessageVC * newViewController = [[MessageVC alloc] init];
    newViewController.title = @"通讯录";
    _messageVC = newViewController;
    [self addChildViewController:newViewController];
    
    
    
}


@end







