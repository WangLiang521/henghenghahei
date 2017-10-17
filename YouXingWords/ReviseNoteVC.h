//
//  ReviseNoteVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/25.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

//传值的block
typedef void(^passNoteBlock)(NSString *noteStr);

@interface ReviseNoteVC : UIViewController

@property(nonatomic,copy)passNoteBlock block;
//备注字符串
@property(nonatomic,copy)NSString *noteStr;

//朋友的账号
@property(nonatomic,copy)NSString *username;
//分组字符串
@property(nonatomic,copy)NSString *groupStr;

//用来修改备注和分组的中间传值的字典
@property(nonatomic,copy)NSDictionary *tempDic;//


//标题
@property(nonatomic,copy)NSString *titleStr;


@end
