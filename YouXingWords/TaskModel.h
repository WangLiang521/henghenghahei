//
//  TaskModel.h
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * num;
@property (nonatomic,assign) BOOL  isDiamond;
@property (nonatomic,assign) BOOL  isComplete;
+(instancetype)taskModelWithTitle:(NSString *)title AndNum:(NSString *)num AndIsDiam:(BOOL)isDiam AndIsComp:(BOOL)isComp;
@end
