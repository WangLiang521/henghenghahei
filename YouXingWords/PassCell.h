//
//  PassCell.h
//  YouXingWords
//
//  Created by LDJ on 16/8/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassModel.h"

@interface PassCell : UICollectionViewCell
@property (nonatomic,retain)PassModel *item;
@property (nonatomic,retain)UILabel *numberLabel;
@property (nonatomic,retain)NSNumber *number;
@property (nonatomic,retain)NSNumber *diamondNumber;
@property (strong, nonatomic)  NSIndexPath *indexPath;
@end
