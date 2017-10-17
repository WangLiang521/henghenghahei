//
//  GDDownLoadView.h
//  TBCycleProgress
//
//  Created by Apple on 2017/2/4.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ImageStart @"icon_start"
#define ImageStop @"icon_stop"

#define StartBtnWH 25.0

@interface GDDownLoadView : UIView

@property (copy, nonatomic)  NSString * downUrl;
@property (copy, nonatomic)  NSString * FileName;
@property (copy, nonatomic)  NSString * muPath;

@end
