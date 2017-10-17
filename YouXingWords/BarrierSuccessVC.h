//
//  BarrierSuccessVC.h
//  YouXingWords
//
//  Created by LDJ on 16/8/12.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestartOrNextDelegate.h"

@interface BarrierSuccessVC : UIViewController
@property (nonatomic,assign)id<RestartOrNextDelegate> delegate;

@property (nonatomic,copy) NSString *successInfo;

@property (nonatomic,retain)NSNumber *passId;//为了上传做题情况
@property (nonatomic,retain)NSNumber *time_second;//做题时间

- (instancetype)initWith:(BreakthroughType)type;

@end
