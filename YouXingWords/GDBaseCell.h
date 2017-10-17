//
//  BaseCell.h
//  EasyWedding
//
//  Created by wangliang on 16/8/22.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDBaseCellModel.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

typedef void(^TapCellBtnBlock)(NSDictionary * info);

@protocol TapCellButtonProtocol <NSObject>
@optional
/**
 *  当用户点击cell中的btn等时触发的方法，有点击事件的VC应当遵守此协议
 *
 *  @param buttonName 点击的button的名称（也可能是点击的别的view的名称）
 *  @param info       某些可能携带的参数
 */
- (void)tapbutton:(NSString *)buttonName info:(NSDictionary *)info;


//- (void)reloadCellAtIndexPathWithUrl:(NSString *)imageUrl;


@end

@interface GDBaseCell : UITableViewCell

- (void)setDataWithModel:(GDBaseCellModel*)model;

/**
 *  第一次走layoutSubviews时调用
 */
- (void)setUpViews;

@property (assign, nonatomic)  id<TapCellButtonProtocol> cellDelegate;

/**
 *  typedef void(^TapCellBtnBlock)(NSDictionary * info);
 */
@property (copy, nonatomic)  TapCellBtnBlock tapCellBtnBlock;

- (void)setCutImageWith:(UIImageView *)imageView imageUrl:(NSString *)iamgeUrl;

/**
 *  记录当前cell的  indexPath 在高度不定的图片 cell 中会用到
 */
@property (strong, nonatomic)  NSIndexPath *indexPath;


/**
 *  是否显示分割线
 */
@property (assign, nonatomic)  BOOL showSeparatorLine;

@end
