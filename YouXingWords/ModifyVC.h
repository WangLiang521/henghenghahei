//
//  ModifyVC.h
//  YouXingWords
//
//  Created by tih on 16/11/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModifyVC : UIViewController
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *contentStr;
@property (nonatomic,copy)NSString *contentKey;
@property (copy, nonatomic)  TapIdBlock completeBlock;
@end
