//
//  PayChooseVC.h
//  LuoKeLock
//
//  Created by Apple on 2017/3/24.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "BaseViewController.h"
//#import "SellerModel.h"
@interface PayChooseVC : BaseViewController

//@property (strong, nonatomic)  SellerModel * model;
@property (copy, nonatomic)  NSString  *orderNo;
@property (copy, nonatomic)  NSString  *money;

/**
 *  这个传的是 orderNo 上一个其实是 id
 */
@property (copy, nonatomic)  NSString  *orderNumber;
@end
