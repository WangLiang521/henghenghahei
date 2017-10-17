
//
//  GDTextViewVC.m
//  BaiLifeShop
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "GDTextViewVC.h"
//#import "GDTextView.h"


@interface GDTextViewVC ()






@property (copy, nonatomic)  NSString * placeHolder;

@end

@implementation GDTextViewVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.hidden = YES;
    [super viewWillDisappear:animated];
}

+(instancetype)VCWithTittle:(NSString *)title placeHolder:(NSString *)placeHolder completeBlock:(CompleteBlock )completeBlock{
    GDTextViewVC * vc = [[GDTextViewVC alloc] initWithNibName:@"GDTextViewVC" bundle:nil];
    vc.title = title;
    vc.placeHolder = placeHolder;
    vc.completeBlock = completeBlock;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.gdTextV.placeHolder.text = @"请输入";
//    GDTextView * text = [GDTextView new];
//    [self.gdTextV addSubview:text];
//    text.placeHolder.text = @"sfad";
    self.gdTextV.textView.text = self.text;
    
}

- (void)setUpViews{
    self.btnComplete.layer.cornerRadius = 5;
    self.gdTextV.placeHolder.text = self.placeHolder;
}

- (IBAction)tapComplete:(id)sender {
    
    if (!self.canEmpty && self.gdTextV.text.length == 0) {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    
    if (!_saveUrl) {
        if (self.completeBlock) {
            self.completeBlock(self.gdTextV.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSMutableDictionary * parameters = nil;
        if (self.otherParameters) {
            parameters = [NSMutableDictionary dictionaryWithDictionary:self.otherParameters];
        }else{
             parameters = [NSMutableDictionary dictionary];
        }
//        parameters[@"token"] = [InfoManager sharedInstance].token;
        
        if (_key) {
            parameters[_key] = self.gdTextV.text;
        }
        
        __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        WS(weakSelf);
        [LGDHttpTool POST:self.saveUrl parameters:parameters success:^(id dictJSON) {
            if ([dictJSON[@"status"] integerValue] == 1) {
                hud.labelText = @"提交成功";
                [hud hide:YES afterDelay:0.5];
                hud.completionBlock = ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
            } else{
                hud.labelText =  dictJSON[@"error"];
                [hud hide:YES afterDelay:0.5];
                hud.completionBlock = ^{};
            }
        } failure:^(NSError *error) {
            hud.labelText = @"提交失败,请检查网络";
            [hud hide:YES afterDelay:0.5];
            hud.completionBlock = ^{};
        }];
        
        
    }
}


@end
