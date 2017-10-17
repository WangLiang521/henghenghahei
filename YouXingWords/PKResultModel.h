//
//  PKResultModel.h
//  YouXingWords
//
//  Created by wangliang on 16/11/22.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKResultModel : NSObject


@property (copy, nonatomic)  NSString * contentId;

@property (copy, nonatomic)  NSString * username;

@property (copy, nonatomic)  NSString * name;

@property (copy, nonatomic)  NSString * rightCounts;

@property (copy, nonatomic)  NSString * wrongCounts;

@property (copy, nonatomic)  NSString * accuracyRate;

@property (copy, nonatomic)  NSString * userTime;

@property (copy, nonatomic)  NSString * submitStatus;

@property (copy, nonatomic)  NSString * coins;

@property (copy, nonatomic)  NSString * signPhoto;

@property (copy, nonatomic)  NSString * subjectId;

@end
