//
//  WaitStartVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/18.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitStartVC : UIViewController

@property(nonatomic,copy)NSDictionary *dataDic;

- (instancetype)initWith:(BreakthroughType)type;

@end
