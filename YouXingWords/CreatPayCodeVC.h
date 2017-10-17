//
//  CreatPayCodeVC.h
//  LuoKeLock
//
//  Created by Apple on 2017/3/25.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatPayCodeVC : BaseViewController
@property (copy, nonatomic)  NSString * payUrl;


@property (weak, nonatomic) IBOutlet UIImageView *imageCode;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@end
