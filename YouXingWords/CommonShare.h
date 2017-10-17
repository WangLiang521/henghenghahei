//
//  CommonShare.h
//  YouXingWords
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonShare : NSObject

@property (copy, nonatomic)  NSString * currentBookName;

+(instancetype)share;

@end
