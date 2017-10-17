//
//  MessageModel.h
//  YouXingWords
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    messageTypeXitong = 0, //系统
    messageTypeMeiri = 1,   //每日
    messageTypeLeitai = 2,  //擂台
    messageTypeFriend = 3,  //好友
    messageTypePK = 4       //PK
} messageType;

@interface MessageModel : NSObject

@property (copy, nonatomic)  NSString * id;
@property (copy, nonatomic)  NSString * content;
@property (copy, nonatomic)  NSString * contentId;
@property (copy, nonatomic)  NSString * contentType;
@property (copy, nonatomic)  NSString * createTim;
@property (copy, nonatomic)  NSString * delFlag;
@property (copy, nonatomic)  NSString * fromUser;
@property (copy, nonatomic)  NSString * fromUserImage;
@property (copy, nonatomic)  NSString * fromUsername;
@property (copy, nonatomic)  NSString * group;
@property (copy, nonatomic)  NSString * hasOper;
@property (copy, nonatomic)  NSString * images;
@property (copy, nonatomic)  NSString * isAddFriend;
@property (copy, nonatomic)  NSString * isLike;
@property (copy, nonatomic)  NSString * isRead;
@property (copy, nonatomic)  NSString * likeCount;
@property (copy, nonatomic)  NSString * range;
@property (copy, nonatomic)  NSString * replyCount;
@property (copy, nonatomic)  NSString * title;
@property (assign, nonatomic)  messageType type;
@property (copy, nonatomic)  NSString * typeName;
@property (copy, nonatomic)  NSString * username;

@property (strong, nonatomic)  NSDictionary *dict;



@end
