//
//  WaveContentView.h
//  TabHoldandRecord
//
//  Created by tih on 16/10/26.
//  Copyright © 2016年 Ashish Tripathi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveContentView : UIView
- (void) addAveragePoint:(CGFloat)averagePoint andPeakPoint:(CGFloat)peakPoint;
-(void)clearPoints;
@end
