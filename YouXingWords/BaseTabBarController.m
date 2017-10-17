//
//  BaseTabBarController.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BaseTabBarController.h"
#import "MessageVC.h"
#import "BreakthroughVC.h"
#import "PKVC.h"
#import "MineVC.h"

#import "MessageContentViewController.h"

#import "DSNavigationBar.h"//自定义navigationBar用的 ldj
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
        
    
    
    //设置UINavigationBar的背景图片
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"标题"] forBarMetrics:UIBarMetricsDefault];
    //UINavigationBar上面的背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#36b6e6"]];
    //UINavigationBar的文字颜色以及文字大小
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(38)]}];
    //UINavigationBar 返回的时候的文字颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    /*
    //将UITabBar背景颜色设置为白色
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    //设置UITabBarItem上点击之后字体的颜色及大小
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.094 green:0.631 blue:0.937 alpha:1.000], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:13.0], UITextAttributeFont,nil]forState:UIControlStateSelected];
    //设置UITabBarItem上没有点击的时候的字体的颜色及大小
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.290 green:0.294 blue:0.290 alpha:1.000], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
     */
    
    //添加TabBarItem
    [self addTabBarItem];
    
}
#pragma mark---添加TabBarItem
-(void)addTabBarItem
{
    //消息界面
    //start
#pragma mark gd_修改消息  2017-01-19
//    MessageVC *message=[[MessageVC alloc]init];
//    //    message.title=@"消息";
//    message.tabBarItem.image = [UIImage imageNamed:@"icon_message_normal"];
//    message.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_message_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UINavigationController *nv1=[[UINavigationController alloc]initWithRootViewController:message];
//    nv1.tabBarItem.title=@"消息";
    
    MessageContentViewController *message=[[MessageContentViewController alloc]init];
    //    message.title=@"消息";
    message.tabBarItem.image = [UIImage imageNamed:@"icon_message_normal"];
    message.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_message_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nv1=[[UINavigationController alloc]initWithRootViewController:message];
    nv1.tabBarItem.title=@"消息";
    
    //end
    
    //闯关界面
    BreakthroughVC *breakthrough=[[BreakthroughVC alloc]init];
    breakthrough.title=@"闯关";
    breakthrough.tabBarItem.image = [UIImage imageNamed:@"icon_barrier_normal"];
    breakthrough.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_barrier_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nv2=[[UINavigationController alloc]initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];
    
    [nv2 addChildViewController:breakthrough];
    [[DSNavigationBar appearance]setNavigationBarWithColor:[UIColor clearColor]];

    //PK界面
    PKVC *pk=[[PKVC alloc]init];
    pk.title=@"PK";
    pk.tabBarItem.image = [UIImage imageNamed:@"icon_pk_normal"];
    pk.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_pk_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nv3=[[UINavigationController alloc]initWithRootViewController:pk];
    //我的界面
    MineVC *mine=[[MineVC alloc]init];
    mine.title=@"我的";
    mine.tabBarItem.image = [UIImage imageNamed:@"icon_me_normal"];
    mine.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nv4=[[UINavigationController alloc]initWithRootViewController:mine];
    
    self.viewControllers=@[nv1,nv2,nv3,nv4];
    self.selectedIndex = 1;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    self.selectedIndex=0;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
