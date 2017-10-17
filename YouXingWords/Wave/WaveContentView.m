//
//  WaveContentView.m
//  TabHoldandRecord
//
//  Created by tih on 16/10/26.
//  Copyright © 2016年 Ashish Tripathi. All rights reserved.
//

#import "WaveContentView.h"
#import "WaveView.h"

@interface  WaveContentView()
{
    WaveView *wv;

}

@end

@implementation WaveContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        wv = [[WaveView alloc] initWithFrame:CGRectMake(5,5, frame.size.width-10 , frame.size.height-10)];
        wv.layer.masksToBounds = YES;
        wv.layer.cornerRadius = 10;
        wv.backgroundColor = [UIColor colorWithRed:0.142 green:0.611 blue:0.537 alpha:1.000];
        [self addSubview:wv];
    }
    return self;
}
- (void) addAveragePoint:(CGFloat)averagePoint andPeakPoint:(CGFloat)peakPoint{
    [wv addAveragePoint:averagePoint andPeakPoint:peakPoint];
}
-(void)clearPoints{
    [wv removeAllPoints];
}
@end
