
//
//  ChooseResModel.h
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseResModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *bookType;
@property (nonatomic,retain)NSNumber *bookID;
@property (nonatomic,retain)NSNumber *isLocked;
@property (nonatomic,retain)NSNumber *coins;
@property (nonatomic,retain)NSNumber *isUsed;

@property (nonatomic,retain)NSNumber *passesCount;
@property (nonatomic,retain)NSNumber *passedCount;
@property (nonatomic,retain)NSNumber *bookStyle;


@property (copy, nonatomic)  NSString *bookUrl;
@property (copy, nonatomic)  NSString * fileName;

@property (copy, nonatomic)  NSString *status;


/**
 *  在收到通知的时候会改变
 */
@property (strong, nonatomic)  NSNumber *progress;


+(instancetype)chooseResModelWithDic:(NSDictionary *)dic;
@end
