//
//  GDEasySetting.h
//  YouXingWords
//
//  Created by Apple on 2017/3/23.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDEasySetting : NSObject

/**
 *  过关z数 : 做对几个题会跳到答题成功页面 默认为极大值 // MAXFLOAT 不得小于1
 */
@property (assign, nonatomic)  NSInteger PassSuccessCount;



+(instancetype)share;


@end
