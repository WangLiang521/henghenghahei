//
//  LexiconViewController.h
//  YouXingWords
//
//  Created by tih on 16/8/10.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface LexiconViewController : UIViewController
@property (nonatomic,copy)NSString* testPoint;

//@property (assign, nonatomic)  BreakthroughType type;



- (void)reloadData;

-(void)initNaviBarAndBackImg;

- (instancetype)initWith:(BreakthroughType)type;

@end
