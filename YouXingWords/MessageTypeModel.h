//
//  MessageTypeModel.h
//  YouXingWords
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageModel.h"

@interface MessageTypeModel : NSObject


@property (assign, nonatomic)  messageType type;

@property (copy, nonatomic)  NSString * title;

/**
 *  本地图片（如果这条是聊天信息，那么，这个是占位图）
 */
@property (copy, nonatomic)  NSString * image;
/**
 *  网络图片
 */
@property (copy, nonatomic)  NSString * imageUrl;

@property (copy, nonatomic)  NSString * subtitle;

/**
 *  未读消息数
 */
@property (assign, nonatomic)  NSInteger unReadCount;

/**
 *  最后一条消息的创建时间
 */
@property (assign, nonatomic)  long long lastMessageCreatTim;

@property (strong, nonatomic)  NSMutableArray<MessageModel *> *messages;

@property (strong, nonatomic)  NSMutableArray<NSDictionary *> *messageDics;


@end
