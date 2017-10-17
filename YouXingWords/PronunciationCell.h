//
//  PronunciationCell.h
//  YouXingWords
//
//  Created by tih on 16/9/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PronunciationModel.h"
typedef void (^PronunciationCellBlock)();
@interface PronunciationCell : UICollectionViewCell
@property (nonatomic,retain) PronunciationModel * item;
@property (nonatomic,copy)PronunciationCellBlock block;
@end
