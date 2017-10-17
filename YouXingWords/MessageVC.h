//
//  MessageVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageVC : UIViewController
@property(nonatomic,retain)UITableView *addressTableView;//通讯录tableView
#pragma mark---加载通讯录网络数据
-(void)addAddressNetData;
@end
