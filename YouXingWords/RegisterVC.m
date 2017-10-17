//
//  RegisterVC.m
//  BaiLifeShop
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "RegisterVC.h"

#import "MBProgressHUD.h"

@interface RegisterVC ()

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UITextField *textUserName;
@property (strong, nonatomic)  UITextField *textPassWord;

@property (strong, nonatomic)  UIButton *btnLogin;
@property (strong, nonatomic)  UIButton *btnFindpwd;
@property (strong, nonatomic)  UIButton *btnRegUser;
@property (strong, nonatomic)  UIButton *btnGetCode;
@property (strong, nonatomic)  UILabel *labLine1;
@property (strong, nonatomic)  UILabel *labLine2;
@property (strong, nonatomic)  UILabel *labLine3;

@property (strong, nonatomic)  UITextField *textCode;

@property (strong, nonatomic)  UITextField *textTuijianren;

@property (strong, nonatomic)  UIButton *btnReg;
@property (assign, nonatomic)  NSInteger numTimer;
@property (strong, nonatomic)  NSTimer *timer;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _numTimer = 60;
    // Do any additional setup after loading the view.
//    self.title = @"找回密码";
    [self addBackgroundView];
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
}


#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
}

- (void)setUpViews{
    
    CGFloat sizeFont = 14;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    _scrollView.scrollEnabled = YES;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(1);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    //_backView
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius=5;
    contentView.layer.masksToBounds=YES;
    [_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        
        make.height.mas_equalTo(203);
    }];
    
//    UIImageView *leftVN = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_yingyetime"]];
//    leftVN.frame = CGRectMake(0, 0, 50, 20);
//    leftVN.contentMode = UIViewContentModeCenter;
    self.textUserName=[UITextField new];
    self.textUserName.placeholder=@"请输入手机号";
    self.textUserName.font=[UIFont systemFontOfSize:sizeFont];
    self.textUserName.keyboardType=UIKeyboardTypeNumberPad;
    self.textUserName.leftViewMode = UITextFieldViewModeAlways;
//    self.textUserName.leftView = leftVN;
    self.textUserName.borderStyle=UITextBorderStyleNone;
    
    [contentView addSubview:self.textUserName];
    [self.textUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView);
        make.left.mas_equalTo(contentView).offset(10);
        make.right.mas_equalTo(contentView).offset(-10);
        make.height.mas_equalTo(50);
        
    }];
    
    _btnGetCode=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _btnGetCode.titleLabel.font=[UIFont systemFontOfSize:sizeFont];
    [_btnGetCode.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_btnGetCode.layer setCornerRadius:5];
    [_btnGetCode.layer setBorderWidth:1];//设置边界的宽度
    //_btnGetCode.hidden=YES;
    [_btnGetCode addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
//    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.957,0.722,0.220,1});
    [_btnGetCode setTitleColor:ColorRegisterVC forState:UIControlStateNormal];
    [_btnGetCode.layer setBorderColor:ColorRegisterVC.CGColor];
    _btnGetCode.layer.cornerRadius = 5;
    [contentView addSubview:_btnGetCode];
    
    [_btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textUserName.mas_top).offset(5);
        make.right.mas_equalTo(_textUserName.mas_right).offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        
    }];
    
    
    _labLine1=[UILabel new];
    _labLine1.backgroundColor=ColorBaseBGGray;
    [contentView addSubview:_labLine1];
    [_labLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textUserName.mas_bottom);
        make.left.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView);
        make.height.mas_equalTo(1);
        
    }];
    
//    UIImageView *leftpwd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_yingyetime"]];
//    leftpwd.frame = CGRectMake(0, 0, 50, 20);
//    leftpwd.contentMode = UIViewContentModeCenter;
    self.textCode=[UITextField new];
    self.textCode.placeholder=@"请输入验证码";
    self.textCode.font=[UIFont systemFontOfSize:sizeFont];
    //self.textPassWord.secureTextEntry=YES;
    self.textCode.leftViewMode = UITextFieldViewModeAlways;
//    self.textCode.leftView = leftpwd;
    self.textCode.borderStyle=UITextBorderStyleNone;
    
    [contentView addSubview:self.textCode];
    [self.textCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labLine1.mas_bottom);
        make.left.mas_equalTo(contentView).offset(10);
        make.right.mas_equalTo(contentView).offset(-10);
        make.height.mas_equalTo(50);
        
    }];
    _labLine2=[UILabel new];
    _labLine2.backgroundColor=ColorBaseBGGray;
    [contentView addSubview:_labLine2];
    [_labLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textCode.mas_bottom);
        make.left.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView);
        make.height.mas_equalTo(1);
        
    }];
    
//    UIImageView *leftcode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_yingyetime"]];
//    leftcode.frame = CGRectMake(0, 0, 50, 20);
//    leftcode.contentMode = UIViewContentModeCenter;
    self.textPassWord=[UITextField new];
    self.textPassWord.placeholder=@"请输入密码";
    self.textPassWord.font=[UIFont systemFontOfSize:sizeFont];
    self.textPassWord.secureTextEntry=YES;
    self.textPassWord.leftViewMode = UITextFieldViewModeAlways;
//    self.textPassWord.leftView = leftcode;
    self.textPassWord.borderStyle=UITextBorderStyleNone;
//    if ([Utils isValidStr:account.username]) {
//        self.textUserName.text=account.username;
//    }
    [contentView addSubview:self.textPassWord];
    [self.textPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labLine2.mas_bottom);
        make.left.mas_equalTo(contentView).offset(10);
        make.right.mas_equalTo(contentView).offset(-10);
        make.height.mas_equalTo(50);
        
    }];
    
    _labLine3=[UILabel new];
    _labLine3.backgroundColor=ColorBaseBGGray;
    [contentView addSubview:_labLine3];
    [_labLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textPassWord.mas_bottom);
        make.left.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView);
        make.height.mas_equalTo(1);
        
    }];
    
//    UIImageView *leftIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_yingyetime"]];
//    leftIcon.frame = CGRectMake(0, 0, 50, 20);
//    leftIcon.contentMode = UIViewContentModeCenter;
    self.textTuijianren=[UITextField new];
    self.textTuijianren.placeholder=@"请再次输入密码";
    self.textTuijianren.secureTextEntry=YES;
    self.textTuijianren.font=[UIFont systemFontOfSize:sizeFont];
    self.textTuijianren.leftViewMode = UITextFieldViewModeAlways;
//    self.textTuijianren.leftView = leftIcon;
    self.textTuijianren.borderStyle=UITextBorderStyleNone;
    
    [contentView addSubview:self.textTuijianren];
    [self.textTuijianren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textPassWord.mas_bottom);
        make.left.mas_equalTo(contentView).offset(10);
        make.right.mas_equalTo(contentView).offset(-10);
        make.height.mas_equalTo(50);
        
    }];
    
    _btnReg=[UIButton new];
    NSString * strTitle = nil;
    if ([self.title isEqualToString:@"注册"]) {
        strTitle = @"注  册";
    }else{
        strTitle = @"找回密码";
    }
    [_btnReg setTitle:strTitle forState:UIControlStateNormal];
    _btnReg.backgroundColor=ColorRegisterVC;
    _btnReg.layer.cornerRadius=5;
    [_btnReg addTarget:self action:@selector(regAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnReg];
    
    [_btnReg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];

}


#pragma mark action
- (void)getCodeAction{
    
    if (self.textUserName.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    
    _btnGetCode.userInteractionEnabled = NO;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRepeats) userInfo:nil repeats:YES];
        
    }else{
        [_timer setFireDate:[NSDate distantPast]];
    }
    
//    self.lblGetVerficationCode.text = @"60s";
    
    [_btnGetCode setTitle:@"60s" forState:UIControlStateNormal];
    
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.textUserName.text;
    
    
    NSString * url = nil;
    if ([self.title isEqualToString:@"注册"]) {
        url = BaiLife_GetRegisterTelCode_Url;
    }else{
        url = BaiLife_GetTelCode_Url;
    }
    
    [LGDHttpTool POST:url parameters:parameters success:^(NSDictionary * dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        }else{

            [MBProgressHUD showError: dictJSON[@"error"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError: @"发送失败"];

    }];
}

- (void)timerRepeats{
    if (_numTimer == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        _numTimer = 60;
        [_btnGetCode setTitle:@"重新获取" forState:UIControlStateNormal];
//        self.lblGetVerficationCode.text = @"重新获取";
        _btnGetCode.userInteractionEnabled = YES;
    }else{
        _numTimer --;
        [_btnGetCode setTitle:[NSString stringWithFormat:@"%zds",_numTimer] forState:UIControlStateNormal];
//        self.lblGetVerficationCode.text = [NSString stringWithFormat:@"%zds",_numTimer];
    }
    
    
}

- (void)regAction{
    
    
    
    if (![LGDUtils quikTipsWhenTextFieldsNeroWith:@[self.textUserName,self.textCode,self.textPassWord,self.textTuijianren]]) {
        return;
    }
    
    if (![self.textPassWord.text isEqualToString:self.textTuijianren.text]) {
        [MBProgressHUD showError:@"您两次输入的密码不一致"];
        return;
    }
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.textUserName.text;
    parameters[@"telCode"] = self.textCode.text;
    parameters[@"password"] = self.textPassWord.text;
    
    
    
    NSString * url = nil;
    if ([self.title isEqualToString:@"注册"]) {
        url = BaiLife_Register_Url;
    }else{
        url = BaiLife_ChangePassword_Url;
    }
    
    [LGDHttpTool POST:url parameters:parameters success:^(NSDictionary* dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            
            if ([self.title isEqualToString:@"注册"]) {
                [MBProgressHUD showSuccess:@"注册成功"];
            }else{
                [MBProgressHUD showSuccess:@"密码修改成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:dictJSON[@"error"]];

        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败,请检查网络"];

    }];
    
}






@end
