//
//  MoreInfoVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfoVC : UIViewController

@property(nonatomic,copy)NSDictionary *dataDic;//获取的数据字典


//用来修改备注和分组的中间传值的字典
@property(nonatomic,copy)NSDictionary *tempDic;//

@property(nonatomic,copy)NSString *groupStr;//分组字符串
@property(nonatomic,copy)NSString *noteStr;//备注字符串

@end
