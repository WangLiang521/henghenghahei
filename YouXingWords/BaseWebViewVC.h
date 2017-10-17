//
//  BaseWebViewVC.h
//  BaiLifeShop
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface BaseWebViewVC : UIViewController<WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic)   WKWebView*  webView;

@property (assign, nonatomic)  UIEdgeInsets webViewEdgeInsets;

/**
 *  default:隐藏
 */
@property (strong, nonatomic)   UIProgressView              *progressView;

/**
 *  本地路径,或网上路径
 */
@property (copy, nonatomic)  NSString * url;

@property (copy, nonatomic)  NSString *parameters;

/**
 *  js调用源生的方法名 (注意,不要加冒号 ":")
 */
@property (strong, nonatomic)  NSArray *methodNames;

/**
 *  初始化 url 和 methodNames
 */
- (void)customizeConfigure;

/**
 *  WKWebView 创建完成
 */
- (void)customizeWKWebView;

/**
 *  源生调用 js 方法  示例@"checkTitle()"
 */
- (void)doJsWith:(NSString *)jsString completionHandler:(void (^ _Nullable)(_Nullable id object, NSError * _Nullable error))completionHandler;





@end
