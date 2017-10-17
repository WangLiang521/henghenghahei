//
//  DDCollectionViewHorizontalLayout.h
//  YouXingWords
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCollectionViewHorizontalLayout : UICollectionViewFlowLayout
// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@end
