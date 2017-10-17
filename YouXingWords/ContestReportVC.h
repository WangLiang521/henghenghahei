//
//  ContestReportVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/4.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContestReportVC : UIViewController

@property(nonatomic,assign)NSInteger correctNum;//正确题数
@property(nonatomic,assign)NSInteger wrongtNum;//错误题数
@property(nonatomic,assign)NSTimeInterval useTime;//用时

@property (nonatomic,copy)NSString *contestId;//比赛ID

@end
