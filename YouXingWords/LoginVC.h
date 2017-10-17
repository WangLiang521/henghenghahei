//
//  LoginVC.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/6.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock)();

@interface LoginVC : UIViewController

@property(nonatomic,copy)ReturnBlock returnBlock;

@end
