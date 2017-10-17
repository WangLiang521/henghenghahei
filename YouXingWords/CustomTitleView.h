//
//  CustomTitleView.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBtAction)();

typedef void(^rightBtAction)();

@interface CustomTitleView : UIView

//左边按钮
@property(nonatomic,retain)UIButton *leftBt;
//中间label
@property(nonatomic,retain)UILabel *titleLb;
//右边按钮
@property(nonatomic,retain)UIButton *rightBt;


+(instancetype)customTitleView:(NSString *)mainTitle
            rightTitle:(NSString *)rightTitle
          leftBtAction:(leftBtAction)leftBtBlock
         rightBtAction:(rightBtAction)rightBtBlock;


@end
