//
//  InfoModel.h
//  BaiLifeShop
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "GDBaseCellModel.h"

//#import "ShopHotelImageModel.h"

@interface InfoModel : GDBaseCellModel

@property (copy, nonatomic)  NSString * key;



@property (assign, nonatomic)  long long  timeInterVal;

@property (strong, nonatomic)  NSString *placeHolderImageName;

@property (assign, nonatomic)  CGFloat height;

//@property (strong, nonatomic)  NSMutableArray<ShopHotelImageModel *> *images;

@property (copy, nonatomic)  NSString * placeHolder;


/**
 *  当 infoType 为 infoTypeText 时,可能需要弹出选择,这个是待选择数组
 */
@property (strong, nonatomic)  NSArray *arrChoose;

/**
 *  可能会用到的,如果是 InfoTypeText 类型,可能需要选择类型,存在这个属性里
 */

@property (strong, nonatomic)  id objChoose;

/**
 *  如果是 InfoTypeTextField 类型,此值有效
 */
@property (assign, nonatomic)  UIKeyboardType keyboardType;

/**
 *  cell 重用的Identifier,
 InfoTypeText 默认为 Identifier= @"SCTableViewCell",如果赋值则覆盖
 
 */
@property (copy, nonatomic)  NSString * Identifier;


/**
 *  如果是 InfoTypeImage 类型,此值有效,默认值弹出图片照相选择器的方法,可覆盖
 */
@property (assign, nonatomic)  SEL method;


#pragma  mark 暂时添加
@property (strong, nonatomic)  NSArray *goodsSpecsList;

@end
