
//
//  CustomLayout.m
//  YouXingWords
//
//  Created by tih on 16/9/13.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()
@property (nonatomic,retain)NSMutableArray *allAttributes;

@end
@implementation CustomLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.allAttributes = [NSMutableArray array];
    NSInteger count  = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.allAttributes addObject:attributes];
    }
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger item = indexPath.item;
//    if (item==2||item==3||item==4) {
//        NSIndexPath *index2 = [NSIndexPath indexPathForItem:item*2-1 inSection:0];
//        return [super layoutAttributesForItemAtIndexPath:index2];
//    }
//    if (item==5||item==6||item==7) {
//        NSIndexPath *index2 = [NSIndexPath indexPathForItem:item-(8-item) inSection:0];
//        return [super layoutAttributesForItemAtIndexPath:index2];
//    }
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSArray * deepCopy = [self deepCopyWithArray:array];
    for (UICollectionViewLayoutAttributes *attr in deepCopy) {
        int a = attr.indexPath.item%8;
        float UpCenterY;
        float CenterX;
        float DownCenterY;

        if (a==0) {
            UpCenterY = attr.center.y;
            CenterX = attr.center.x;
        }
        if (a==1) {
            DownCenterY = attr.center.y;
        }
        if (a>=1&&a<=3) {
            attr.center=CGPointMake(CenterX+attr.frame.size.width*a, UpCenterY);
        }
        if (a>=4&&a<=6) {
            attr.center = CGPointMake(CenterX+attr.frame.size.width*(a-4), DownCenterY);
        }
        
    }
//    NSMutableArray *temp = [NSMutableArray array];
//    for (int i=0; i<arr.count; i++) {
//        for (int j=0; j<self.allAttributes.count; j++) {
//            if (((UICollectionViewLayoutAttributes *)arr[i]).indexPath.item==((UICollectionViewLayoutAttributes *)self.allAttributes[j]).indexPath.item) {
//                [temp addObject:(UICollectionViewLayoutAttributes *)self.allAttributes[j]];
//            }
//        }
//    }
    return deepCopy;
}

- (NSArray *)deepCopyWithArray:(NSArray *)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    
    for (UICollectionViewLayoutAttributes *attris in array) {
        [copys addObject:[attris copy]];
    }
    return copys;
}
@end
