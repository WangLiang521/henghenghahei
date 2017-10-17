//
//  MessageTypeModel.m
//  YouXingWords
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "MessageTypeModel.h"

@interface MessageTypeModel()

/**
 *  记录是否已经计算过一次 lastMessageCreatTim，subtitle 这两个值只在 （lastMessageCreatTim或subtitle或unReadCount的get方法中）计算一次
 */
@property (assign, nonatomic)  BOOL oldSet;

@property (strong, nonatomic)  MessageModel *lastModel;



@end

@implementation MessageTypeModel



- (NSInteger)unReadCount{
    __block NSInteger count = _unReadCount;
    
    if (!self.oldSet) {
        [self calculateBlock:^(NSInteger unReadCount, NSString *subtitle, long long lastMessageCreatTim) {
            count =  unReadCount;
        }];
        self.oldSet = YES;
    }
    
    
    
    return count;
}


- (long long)lastMessageCreatTim{
    __block long long creatTim = _lastMessageCreatTim;
    
    if (!self.oldSet) {
        [self calculateBlock:^(NSInteger unReadCount, NSString *subtitle, long long lastMessageCreatTim) {
            creatTim =  lastMessageCreatTim;
        }];
        self.oldSet = YES;
    }
    
    return creatTim;
}

- (NSString *)subtitle{
    __block NSString * string = [NSString stringWithString:_subtitle];
    if (!self.oldSet) {
        [self calculateBlock:^(NSInteger unReadCount, NSString *subtitle, long long lastMessageCreatTim) {
            string = [NSString stringWithString:subtitle];
        }];
        self.oldSet = YES;
    }
    return string;
}


- (void)calculateBlock:(void(^)(NSInteger unReadCount,NSString *subtitle,long long lastMessageCreatTim))block{
    NSInteger count = 0;
    long long creatTim = 0;
    NSString * sub = @"暂无数据";
    self.messageDics = [NSMutableArray array];
    for (MessageModel * model in self.messages) {
        if ([model.isRead integerValue] == 0) {
            count ++;
        }
        
        if ([model.createTim longLongValue] >= creatTim) {
            
            _lastModel = model;
            
            creatTim = [model.createTim longLongValue];
            sub = [LGDUtils isValidStr:model.content]?model.content:@"暂无数据";
        }
        
        [self.messageDics  addObject:model.dict];
    }
    
    
    self.lastMessageCreatTim = creatTim;
    self.subtitle = sub;
    self.unReadCount = count;
    if (block) {
        block(count,sub,creatTim);
    }
}

- (NSString *)imageUrl{
    if (_lastModel && _type != messageTypeXitong && _type != messageTypeMeiri && _type != messageTypeLeitai ) {
        return _lastModel.fromUserImage;
    }
    return nil;
}

- (void)setMessages:(NSMutableArray<MessageModel *> *)messages{
    _messages = messages;
    self.oldSet = NO;
}



@end
