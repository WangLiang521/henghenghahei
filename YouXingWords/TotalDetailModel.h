//
//  TotalDetailModel.h
//  YouXingWords
//
//  Created by wangliang on 2016/12/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalDetailModel : NSObject


@property (copy, nonatomic)  NSString * exName;
@property (copy, nonatomic)  NSString * username;
@property (copy, nonatomic)  NSString * name;
@property (copy, nonatomic)  NSString * obUsername;
@property (copy, nonatomic)  NSString * obName;
@property (copy, nonatomic)  NSString * createTim;
@property (copy, nonatomic)  NSString * usernameImage;
@property (copy, nonatomic)  NSString * obUsernameImage;
@property (assign, nonatomic)  long userTime;
@property (assign, nonatomic)  long obUseTime;
@property (assign, nonatomic)  long userValue;
@property (assign, nonatomic)  long obValue;
@property (assign, nonatomic)  long obRanking;
@property (assign, nonatomic)  long userRanking;
@property (assign, nonatomic)  NSInteger isWin;
@property (assign, nonatomic)  NSInteger exType;

@end
