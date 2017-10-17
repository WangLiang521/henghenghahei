//
//  TotalRecordView.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/5.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TotalRecordView.h"

@implementation TotalRecordView







- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    //坐标控制画圆
//    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, self.bounds.size.width*2, self.bounds.size.height));
    CGFloat height=self.bounds.size.height;
    CGFloat width=self.bounds.size.width;
    //圆心坐标控制画圆
    CGContextAddArc(ctx,width/2,height+0.1, SCREEN_HEIGHT-self.frame.origin.y, -M_PI, 0, 0);
    //边缘线宽度
    CGContextSetLineWidth(ctx, 0.1);
    
    [[UIColor whiteColor]set];
//    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);

}

@end
