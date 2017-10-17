//
//  BaseTableViewController.m
//  YouXingWords
//
//  Created by Apple on 2017/1/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.
    }];

}



@end
