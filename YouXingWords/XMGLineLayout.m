//
//  XMGLineLayout.m
//  02-自定义布局
//
//  Created by xiaomage on 15/8/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGLineLayout.h"

@implementation XMGLineLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
//    目的是为了让cell居中
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray * arrayOrign = [super layoutAttributesForElementsInRect:rect];
    // 获得super已经计算好的布局属性
    NSArray *array = [self deepCopyWithArray:arrayOrign];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for ( int i = 0 ; i < array.count ;i++) {
        UICollectionViewLayoutAttributes *attrs = array[i];
        // cell的中心点x 和 collectionView最中心点的x值 的间距
//        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值 计算 cell的缩放比例
//        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
//
//        if (scale < 0.8) {
//            scale = 0.8;
//
//        }
//        attrs.alpha = scale * scale;
        // 设置缩放比例
//        attrs.transform = CGAffineTransformMakeScale(scale, scale);

    }



    
    
    return array;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];


    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for ( int i = 0 ; i < array.count ;i++) {
        UICollectionViewLayoutAttributes *attrs = array[i];
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;

        }
    }

    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

/*
 http://blog.csdn.net/xytgr/article/details/49402099
 在升级XCode7.0使用UICollectionViewLayout进行自定义布局时，调试台会出现以下的警告打印。
 
 UICollectionViewFlowLayout has cached frame mismatch for index path {length = 2, path = 0 - 0} - cached value: {{122, 15}, {170, 170}}; expected value: {{157, 50}, {100, 100}}
 This is likely occurring because the flow layout subclass LineLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
 这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝。拷贝代码如下：
 */
- (NSArray *)deepCopyWithArray:(NSArray *)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    
    for (UICollectionViewLayoutAttributes *attris in array) {
        [copys addObject:[attris copy]];
    }
    return copys;
}

@end




/**
 1.cell的放大和缩小
 2.停止滚动时：cell的居中
 */



