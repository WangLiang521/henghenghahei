//
//  NewFriendsInfoVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendsInfoVC : UIViewController

//添加一个viewTag用来区分从哪个页面跳转进来的(好友申请界面viewTag:100 通讯录界面viewTag:200 搜索界面viewTag：300)
@property(nonatomic,assign)NSInteger viewTag;

@property(nonatomic,assign)NSInteger isFriend;//从好友申请页面跳转过来，如果是已经拒绝的，则不显示 底部的按钮

@property(nonatomic,copy)NSString *userName;//账号

//用来修改备注和分组的中间传值的字典
@property(nonatomic,copy)NSDictionary *tempDic;
@property(nonatomic,copy)NSString *groupStr;//分组字符串
@property(nonatomic,copy)NSString *noteStr;//备注字符串



@property (assign, nonatomic)  AddFriendType addtype;

@end
