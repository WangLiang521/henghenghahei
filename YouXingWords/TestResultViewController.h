//
//  TestResultViewController.h
//  YouXingWords
//
//  Created by tih on 16/8/12.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestResultViewController : UIViewController
@property (nonatomic,assign)NSInteger rightNum;
@property (nonatomic,assign)NSInteger wrongNum;

- (instancetype)initWith:(BreakthroughType)type;
@end
