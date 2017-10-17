//
//  GDHidenPassWordView.h
//  YouXingWords
//
//  Created by Apple on 2017/3/23.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GDHidenPassWord @"3434"
#define GDHidenColor [UIColor clearColor]//GDHidenPassWordTestRandomColor
//[UIColor clearColor]

////生成随机颜色
#define GDHidenPassWordrandom(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define GDHidenPassWordTestRandomColor GDHidenPassWordrandom(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 255)

@interface GDHidenPassWordView : UIView

+(instancetype)shareWithView:(UIView *)contentView PassRightBlock:(void(^)(void))passBlock;

@end
