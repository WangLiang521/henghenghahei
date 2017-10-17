//
//  BaseWebViewVC.m
//  BaiLifeShop
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "BaseWebViewVC.h"

@interface BaseWebViewVC ()

@end

@implementation BaseWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self customizeConfigure];
    [self initWKWebView];
    [self customizeWKWebView];
    [self initProgressView];

}

- (void)customizeConfigure{
    
}

- (void)customizeWKWebView{
    
}

- (void)doJsWith:(NSString *)jsString completionHandler:(void (^ _Nullable)(_Nullable id object, NSError * _Nullable error))completionHandler{
     [self.webView evaluateJavaScript:[NSString stringWithFormat:@"window.%@",jsString] completionHandler:^(id _Nullable object, NSError * _Nullable error) {
         if (completionHandler) {
             completionHandler(object,error);
         }
    }];
    
}

- (NSString*)resourcePathInBundle:(NSString*)subpath {
    
    return [[NSBundle mainBundle] pathForResource:[subpath stringByDeletingPathExtension] ofType:subpath.pathExtension];
}

- (NSString*)fileURLAbsoluteString:(NSString*)subpath {
    NSString * resourcePath = [self resourcePathInBundle:subpath];
//    NSString * resourceWithParametter = [[resourcePath stringByAppendingFormat:@"?%@",_parameters] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL * fileUrl = [NSURL fileURLWithPath:resourceWithParametter];
//    NSString * absoluteString = fileUrl.absoluteString;
    
    NSString *encodedPath = [resourcePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *absoluteString = nil;
    if (![LGDUtils isValidStr:self.parameters]) {
        absoluteString = [NSString stringWithFormat:@"file://%@", encodedPath];
    }
    else {
        absoluteString = [NSString stringWithFormat:@"file://%@?%@", encodedPath, self.parameters];
    }
    return absoluteString;
}


- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    for (NSString * methodName in self.methodNames) {
        [configuration.userContentController addScriptMessageHandler:self name:methodName];
    }
    
//    [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"Location"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"Share"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"Color"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"Pay"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"Shake"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"GoBack"];
//    [configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    
    
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    WS(weakSelf);
    
    
    
    //    NSString *urlStr = @"http://www.baidu.com";
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //    [self.webView loadRequest:request];
    
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
//    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
//    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
    NSString * string;
    
    if ([_url containsString:@"http"]) {
        string = _url;
    }else{
        string = [self fileURLAbsoluteString:_url];
    }
    NSURL * url = [NSURL URLWithString: string];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(self.webViewEdgeInsets);
    }];
}
- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //    message.body  --  Allowed types are NSNumber, NSString, NSDate,           NSArray,NSDictionary, and NSNull.
    NSLog(@"body:%@",message.body);
//    if ([message.name isEqualToString:@"ScanAction"]) {
//        
//    } else if ([message.name isEqualToString:@"Location"]) {
//        
//    } else if ([message.name isEqualToString:@"Share"]) {
//        
//    } else if ([message.name isEqualToString:@"Color"]) {
//        
//    } else if ([message.name isEqualToString:@"Pay"]) {
//        
//    } else if ([message.name isEqualToString:@"Shake"]) {
//        
//    } else if ([message.name isEqualToString:@"GoBack"]) {
//        
//    } else if ([message.name isEqualToString:@"PlaySound"]) {
//        
//    }
    
    if ([message.body isEqual:[NSNull null]]) {
        SEL method = NSSelectorFromString(message.name);
        if ([self respondsToSelector:method]) {
             [self performSelector:method withObject:nil];
        }
       
    }else{
        SEL method = NSSelectorFromString([NSString stringWithFormat:@"%@:",message.name]);
        if ([self respondsToSelector:method]) {
             [self performSelector:method withObject:message.body];
        }
       
    }
}

- (void)dealloc{
    for (NSString * methodName in self.methodNames) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }
    
}

@end
