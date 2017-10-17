//
//  LoginVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/6.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "LoginVC.h"
#import "BaseTabBarController.h"

#import "AppDelegate.h"

#import "EaseUI.h"

#import "RegisterVC.h"

#import "PassList.h"

@interface LoginVC ()

//自定义导航栏
@property(nonatomic,retain)CustomTitleView *customTitleView;
@property(nonatomic,retain)UITextField *accountTextField;//账号输入框
@property(nonatomic,retain)UITextField *passwordTextField;//密码输入框
@property(nonatomic,retain)UIButton *loginBt;//登陆按钮

@end

@implementation LoginVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor=[UIColor grayColor];
    //添加背景图
    [self addBackgroundView];
    //添加标题
    [self addCustomTitleView];
    //添加输入框
    [self addTextField];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
}
#pragma mark---添加导航栏标题
-(void)addCustomTitleView
{
    //start
#pragma mark gd_不在显示跳过  2017-02-04-1
    //    _customTitleView=[CustomTitleView customTitleView:@"登陆" rightTitle:@"跳过" leftBtAction:^{
    //        //
    //    } rightBtAction:^{
    //        //跳转到BaseTabBarController
    //        BaseTabBarController *base=[[BaseTabBarController alloc]init];
    //        [self presentViewController:base animated:YES completion:nil];
    //    }];
    
//    _customTitleView=[CustomTitleView customTitleView:@"登录" rightTitle:@"" leftBtAction:^{
//        //
//    } rightBtAction:^{
//        //跳转到BaseTabBarController
////        BaseTabBarController *base=[[BaseTabBarController alloc]init];
////        [self presentViewController:base animated:YES completion:nil];
//    }];
    //end

    
    
    //隐藏左边返回按钮
    _customTitleView.leftBt.hidden=YES;
    [self.view addSubview:_customTitleView];
}
#pragma mark----添加输入框
-(void)addTextField
{
    //账号输入框
    _accountTextField=[[UITextField alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(400), SCREEN_WIDTH-(AutoTrans(60)), AutoTrans(80))];
    _accountTextField.placeholder=@"账号";
    _accountTextField.keyboardType = UIKeyboardTypePhonePad;
    _accountTextField.backgroundColor=[UIColor whiteColor];
    _accountTextField.borderStyle=UITextBorderStyleRoundedRect;
    NSString *accountStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
    //为了测试方便，不必要每次输入密码，实际应用删除
//    if (accountStr==nil) {
//        accountStr=@"18560126362";
//    }
    _accountTextField.text=accountStr;
    [self.view addSubview:_accountTextField];
    //密码输入框
    _passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(_accountTextField.frame), CGRectGetMaxY(_accountTextField.frame)+(AutoTrans(30)), CGRectGetWidth(_accountTextField.frame), CGRectGetHeight(_accountTextField.frame))];
    _passwordTextField.placeholder=@"密码";
    _passwordTextField.backgroundColor=[UIColor whiteColor];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.borderStyle=UITextBorderStyleRoundedRect;
    NSString *passwordStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
//    //为了测试方便，不必要每次输入密码，实际应用删除
//    if (passwordStr==nil) {
//        passwordStr=@"123456";
//    }
    _passwordTextField.text=passwordStr;
    [self.view addSubview:_passwordTextField];
    //登陆按钮
    _loginBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame)+(AutoTrans(30)), CGRectGetWidth(_passwordTextField.frame), CGRectGetHeight(_passwordTextField.frame))];
    [_loginBt setTitle:@"登  录" forState:UIControlStateNormal];
    _loginBt.backgroundColor=[UIColor colorWithHexString:@"3eb9e4"];
    _loginBt.layer.cornerRadius=6;
    _loginBt.layer.masksToBounds=YES;
    [_loginBt addTarget:self action:@selector(loginBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBt];
    
    //注册按钮
    UIButton * registBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_loginBt.frame)+(AutoTrans(30)), 100, CGRectGetHeight(_passwordTextField.frame))];
    [registBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    WS(weakSelf)
    [registBtn tapBlock:^{
        RegisterVC * vc = [[RegisterVC alloc] init];
        vc.title = @"找回密码";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(_loginBt.frame)+(AutoTrans(30)));
        make.left.mas_equalTo(CGRectGetMinX(_passwordTextField.frame));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    //注册按钮
    UIButton * forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_loginBt.frame)+(AutoTrans(30)), 100, CGRectGetHeight(_passwordTextField.frame))];
    [forgetBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn tapBlock:^{
        RegisterVC * vc = [[RegisterVC alloc] init];
        vc.title = @"注册";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(_loginBt.frame)+(AutoTrans(30)));
        make.right.mas_equalTo(-CGRectGetMinX(_passwordTextField.frame));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    
    
//#ifdef DEBUG
//    _accountTextField.text = @"15000000002";
//    _passwordTextField.text = @"123456";
//#endif
}
#pragma mark---登陆按钮点击
-(void)loginBtClick
{   //关闭键盘
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];

    //账号:18560126362  密码:123456
    if ([_accountTextField.text isEqualToString:@""]) {
        [Utils showAlter:@"请输入账号"];
    }else if ([_passwordTextField.text isEqualToString:@""]){
        [Utils showAlter:@"请输入密码"];
    }else{
        //参数字典
        NSDictionary *paraDic=@{@"username":_accountTextField.text,@"password":_passwordTextField.text,@"deviceType":@"2"};
        //网络请求
        [NetWorkingUtils postWithUrl:LoginUrl params:paraDic successResult:^(id response) {
            //登陆成功
            if ([response[@"status"] integerValue]==1) {
                [PassList saveSysInfo:response[@"sysInfo"]];
                NSLog(@"%@",response);
                //登陆环信SDK
//                EMError *error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"yc_%@",_accountTextField.text] password:@"123456"];
//                if (!error) {
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLogin"]==NO) {
                        //跳转到BaseTabBarController
                        BaseTabBarController *base=[[BaseTabBarController alloc]init];
                        [self presentViewController:base animated:YES completion:nil];
                    }else{
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLogin"]==YES) {
                        if (self.returnBlock) {
                            self.returnBlock();
                        }
                   
//                        //发送通讯录通知
//                        [[NSNotificationCenter defaultCenter]postNotificationName:AddressNotification object:nil];
//
                    }
                
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                [NetWorkingUtils requestNoteBook];
                [NetWorkingUtils requestNoteBookWith:BreakthroughTypeCourse];
                [NetWorkingUtils requestNoteBookWith:BreakthroughTypeWord];
                //end
                
                
                    //设置自动登录
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    //已经登陆过
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstLogin"];
                    //将当前token保存到本地
                    [[NSUserDefaults standardUserDefaults]setObject:response[@"token"] forKey:@"token"];
                     //保存bookid
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                [AnswerTools setBookID:[response[@"info"] valueForKey:@"bookId"]];
                [AnswerTools setBookID:[response[@"info"] valueForKey:@"bookId"] With:BreakthroughTypeWord];
                //end
                
                    //保存个人信
               
                
                //start
#pragma mark gd_不再使用newBookId  2017-04-27 11:13:53
//                    //保存bookid
//                    [[NSUserDefaults standardUserDefaults] setObject:response[@"info"][@"bookId"] forKey:@"newBookId"];
                //end
                
                    [[NSUserDefaults standardUserDefaults]setObject:response[@"info"] forKey:@"userInfo"];
                    //保存账号
                    [[NSUserDefaults standardUserDefaults]setObject:_accountTextField.text forKey:@"account"];
                    //保存密码
                    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:@"password"];
                    //发送PK列表通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:PKFriendList object:nil];
//                }else{
//                    [Utils showAlter:error.errorDescription];
//                }
            //服务器登陆失败
            }else{
                [Utils showAlter:response[@"error"]];
            }
        } errorResult:^(NSError *error) {
            [Utils showAlter:@"网络连接失败"];
            
        }];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}

@end
