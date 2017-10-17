//
//  YXTimeProgress.h
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXTimeProgressDelegate <NSObject>

-(void)arriveEnd;

@end
@interface YXTimeProgress : UIView
@property (nonatomic,assign) NSInteger  sum;
@property (nonatomic,assign) NSInteger  current;
@property (nonatomic,assign) id<YXTimeProgressDelegate>  delegate;


@property (nonatomic,assign)BOOL isMoving;

-(void)beginMove;
-(void)stop;
-(void)start;
@end
