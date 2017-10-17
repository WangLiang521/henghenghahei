//
//  AddNewFriendVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/13.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface AddNewFriendVC : UIViewController

/**
 *  如果从上一页直接闯过来 username, 则不需要用户数据,直接查询
 */
@property (copy, nonatomic)  NSString * preUserName;


@property (assign, nonatomic)  AddFriendType addType;

@end
