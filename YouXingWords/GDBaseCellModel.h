//
//  BaseCellModel.h
//  EasyWedding
//
//  Created by wangliang on 16/8/22.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    InfoTypeText,
    InfoTypeImage,
    InfoTypeTextField,
    //    InfoTypeImageArr,
    InfoTypeSwitch,
    InfoTypeTextView,
    InfoTypeOther} InfoType;

@interface GDBaseCellModel : NSObject

@property (copy, nonatomic)  NSString * titleBase;
@property (copy, nonatomic)  NSString * subtitleBase;

/**
 *  左侧图片
 */
@property (copy, nonatomic)  NSString *leftImageName;

/**
 *  右侧图片
 */
@property (strong, nonatomic)  UIImage *image;
@property (assign, nonatomic)  UITableViewCellAccessoryType cellAccessoryType;
@property (strong, nonatomic)  UIView *cellAccessoryView;

@property (assign, nonatomic)  InfoType infoType;

/**
 *  textfield 修改之前的值  这个值会在第一次自动创建 textfield 时赋值,之后不再自动维护
 */
@property (copy, nonatomic)  NSString * preTftSubtitleBase;

- (NSString *)check:(NSString *)pro;


@end






