//
//  TBCycleView.h
//  TBCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弧线半径
 */
#define TBLineWidth 2.0
/**
 *  弧线颜色
 */
#define TBStrokeColor [UIColor colorWithHexString:@"1193D7"]

@interface TBCycleView : UIView

@property (nonatomic, strong) UILabel *label;

- (void)drawProgress:(CGFloat )progress;

@end
