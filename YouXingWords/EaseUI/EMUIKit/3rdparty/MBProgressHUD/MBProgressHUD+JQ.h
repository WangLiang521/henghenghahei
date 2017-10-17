//
//  MBProgressHUD+JQ.h
//  JQ
//
//  Created by Ibokan on 15/9/29.
//  Copyright (c) 2015年 家强. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (JQ)

/**
 *  快速显示一个成功的提示消息
 *
 *  @param success 显示的成功提示文本信息
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  显示一个成功提示消息(指定View)
 *
 *  @param success 显示的成功提示文本信息
 *  @param view    指定View
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;


/**
 *  快速显示一个错误提示消息
 *
 *  @param error 显示的错误提示文本信息
 */
+ (void)showError:(NSString *)error;
/**
 *  显示一个错误提示消息(指定View)
 *
 *  @param error 显示的错误提示文本信息
 *  @param view  指定View
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示一个消息提示框(不指定View)，需要手动隐藏的方法
 *
 *  @param message 消息内容
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

/**
 *  隐藏消息提示框
 */
+ (void)hideHUD;

/**
 *  指定View显示一个消息提示框,需要手动隐藏的方法
 *
 *  @param message 消息内容
 *  @param view    指定View
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
/**
 *  隐藏消息提示框
 *
 *  @param view 指定View
 */
+ (void)hideHUDForView:(UIView *)view;


@end
