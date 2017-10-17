//
//  UIView+Color.m
//  YouXingWords
//
//  Created by tih on 16/8/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "UIView+Color.h"
@implementation UIView (Color)

-(void)didMoveToSuperview{
//    if (DEBUG) {
//#if 0
//        if ([self isKindOfClass:[UIImageView class]]||[self isKindOfClass:[UILabel class]]||[self isKindOfClass:[UIButton class]]||[self isKindOfClass:[UIScrollView class]]) {
//            self.backgroundColor = [self randomColor];
//
//        }
//#endif
//        
//    }
}
typedef struct _Color {
    CGFloat red, green, blue;
} Color;

static Color _colors[12] = {
    {237, 230, 4},  // Yellow just to the left of center
    {158, 209, 16}, // Next color clockwise (green)
    {80, 181, 23},
    {23, 144, 103},
    {71, 110, 175},
    {159, 73, 172},
    {204, 66, 162},
    {255, 59, 167},
    {255, 88, 0},
    {255, 129, 0},
    {254, 172, 0},
    {255, 204, 0}
};

- (UIColor *)randomColor {
    Color randomColor = _colors[arc4random_uniform(12)];
    return [UIColor colorWithRed:(randomColor.red / 255.0f) green:(randomColor.green / 255.0f) blue:(randomColor.blue / 255.0f) alpha:0.8f];
}

@end
