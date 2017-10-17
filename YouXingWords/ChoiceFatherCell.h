//
//  ChoiceFatherCell.h
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChioceModel.h"
@interface ChoiceFatherCell : UICollectionViewCell
@property (nonatomic,retain) ChioceModel *item;
-(void)didSelected;
-(void)resetGreen;

-(void)toGray;
-(void)setWrong;
@end
