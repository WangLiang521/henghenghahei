//
//  GetCoinModel.h
//  YouXingWords
//
//  Created by Apple on 2017/5/27.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "GDBaseCellModel.h"

@interface GetCoinModel : GDBaseCellModel


@property (copy, nonatomic)  NSString * operType;
@property (copy, nonatomic)  NSString * descs;
@property (copy, nonatomic)  NSNumber * coins;
@property (assign, nonatomic)  double createTim;




@end
