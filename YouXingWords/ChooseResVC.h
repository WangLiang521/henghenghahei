//
//  ChooseResVC.h
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseResProtocal <NSObject>

-(void)didChooseComplete;

@end
@interface ChooseResVC : UIViewController

@property (nonatomic,assign) id<ChooseResProtocal> delegate;

@end
