//
//  BaseTableViewController.h
//  YouXingWords
//
//  Created by Apple on 2017/1/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UIViewController

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataSource;
@property (copy, nonatomic)  NSString * url;
@property (copy, nonatomic)  NSString * listPath;
//@property (copy, nonatomic)  NSString * cellClass;
//@property (copy, nonatomic)  NSString * cellModelClass;

/**
 *  @[@{cellModelClass:cellClass}]
 */
@property (strong, nonatomic)  NSArray *classDicts;

@end
