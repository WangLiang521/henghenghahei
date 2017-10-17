//
//  UIView+LGDExtension.h
//  自定义Tabbar
//
//  Created by liguodong on 16/4/11.
//  Copyright © 2016年 liguodong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIImageAndHeightBlock)(UIImage * image,CGFloat Height);

@interface UIView (LGDExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/


/**
 *  调整image 图片大小
 *
 *  @param image  需要调整大小的Image
 *  @param reSize 调整后的图片大小
 *
 *  @return 调整后的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;


/**
 *  固定宽度，调整Image的高度，使其在不改变比例的情况下，完全展示图片
 *
 *  @param image       待调整的图片
 *  @param width       调整后的宽度
 *  @param finishBlock 调整后的图片及其高度
 */
+ (void)fitWidthImage:(UIImage *)image toWidth:(CGFloat)width finishBlock:(UIImageAndHeightBlock)finishBlock;

/**
 *  快速为view设置一个阴影
 *
 *  @param view 需要设置阴影的view
 */
+ (void)setShadowView:(UIView *)view;


/**
 *  快速设置 CornerRadius 半圆
 *
 *  @param view        需要设置的view
 *  @param color       字体颜色及边界颜色
 *  @param borderWidth 边界厚度
 */
+(void)setCornerRadiusToView:(UIView *)view Color:(UIColor *)color BorderWidth:(CGFloat)borderWidth;

/**
 *  裁切图片中部，以适应图片框
 *
 *  @param originalImage 待裁切的图片
 *  @param size          裁切后的大小
 *
 *  @return 裁切后的图片
 */
+ (UIImage *)CutImage:(UIImage *)originalImage withSize:(CGSize)size;


/**
 *  截图,截取orgView 区域内的图片
 *  @return 裁切后的图片
 */
+(UIImage *)captureImageFromViewLow:(UIView *)orgView;

/**
 *  快速为一个 View 添加点击事件
 */
-(void)tapBlock:(TapBlock)block;

@end



















