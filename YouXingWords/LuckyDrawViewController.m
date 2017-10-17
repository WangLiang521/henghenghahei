//
//  LuckyDrawViewController.m
//  YouXingWords
//
//  Created by LDJ on 16/10/9.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "LuckyDrawViewController.h"



@interface LuckyDrawViewController ()<CAAnimationDelegate>
/** 旋转的起始角度 */
@property (nonatomic, assign)   CGFloat beginAngle;

/** 旋转的终止角度 */
@property (nonatomic, assign)   CGFloat endAngle;


@property (strong, nonatomic)  UIButton *beginButton;

/**
 *  规则 label
 */
@property (strong, nonatomic)  UILabel *ruleLabel;
@property (strong, nonatomic)  UILabel *diamondsNum;

/**
 *  转盘
 */
@property (strong, nonatomic)  UIImageView *rouletteImgV;

@property (strong, nonatomic)NSNumber * spendU;
@property (strong, nonatomic)NSNumber * spendAllCount;
@property (strong, nonatomic)NSNumber * spendHaveCount;
@property (strong, nonatomic)NSNumber * coins;
@property (copy, nonatomic)  NSString * prizeImage;

@property (strong, nonatomic)  CABasicAnimation* rotationAnimation;

@end

@implementation LuckyDrawViewController

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _coins = @(0);
    self.beginAngle = 0;
    self.endAngle = 0;
    [self initNavi];
    [self addUserInfo];
    [self addRoulette];
    [self addRules];

    
    [self requestData];
}

- (void)requestData{
    __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:PrizeInfo parameters:parameters success:^(NSDictionary * dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            _spendU = dictJSON[@"info"][@"consumeCoins"];
            _spendAllCount = dictJSON[@"info"][@"prizeCount"];
            _spendHaveCount = dictJSON[@"info"][@"counts"];
            _prizeImage = dictJSON[@"info"][@"prizeImage"];
//            _coins = dictJSON[@"info"][@"coins"];
            [self updateUI];
        }else{
            hud.labelText = dictJSON[@"error"];
        }
        
        [hud hide:YES afterDelay:0.5];
        hud.completionBlock = ^{};
    } failure:^(NSError *error) {
        hud.labelText = @"获取抽奖信息失败,请检查网络";
        [hud hide:YES afterDelay:0.5];
        hud.completionBlock = ^{};
    }];
}

- (void)updateUI{
    
    _ruleLabel.text = [NSString stringWithFormat:@"1.抽中话费的童鞋请在意见反馈处提交姓名和电话，我们会及时充值。\n2.代金券用于所在学校新课程优惠使用，详情咨询学习中心老师。\n3.每次抽奖需要扣除%@优钻，扣除的积分不退还，每天有%@次抽奖机会,剩余%@次机会\n4.此活动由优行英语公司发起,与苹果公司无关!",_spendU,_spendAllCount,_spendHaveCount];
    _ruleLabel.adjustsFontSizeToFitWidth = YES;

    if (![LGDUtils isNonnull:_coins] || _coins.integerValue != 0) {
        _diamondsNum.text = [NSString stringWithFormat:@"目前优钻:%@",_coins];
    }else{
//        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//        _coins = @([userInfo[@"coins"] integerValue]);
        _coins = [Utils getCoinsCount];
        _diamondsNum.text = [NSString stringWithFormat:@"目前优钻:%@",_coins];
        
    }
    
    [_rouletteImgV sd_setImageWithURL:[NSURL URLWithString:_prizeImage] placeholderImage:[UIImage imageNamed:@""]];
}

-(void)initNavi{
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"bg_money_red"]];
    backImg.userInteractionEnabled = YES;
    
    [self.view addSubview:backImg];
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 120, 60)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
    UILabel *_titleLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(AutoTrans(150)), AutoTrans(44), AutoTrans(300), 40)];
    _titleLb.textAlignment=NSTextAlignmentCenter;
    _titleLb.text = @"抽奖";
    _titleLb.textColor=[UIColor whiteColor];
    _titleLb.font=[UIFont systemFontOfSize:AutoTrans(40)];
    [self.view addSubview:_titleLb];
    
}
-(void)addUserInfo{
    UIImageView *headerIcon = [[UIImageView alloc]initWithFrame:YXFrame(67, 136, 54, 54)];
    headerIcon.image = [UIImage imageNamed:@"barrier_icon_again"];
    headerIcon.hidden = YES;
    [self.view addSubview:headerIcon];
//
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerIcon.frame)+(AutoTrans(10)), AutoTrans(136), AutoTrans(250), AutoTrans(54))];
//    nameLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//    nameLabel.textColor = [UIColor colorWithHexString:@"#fba058"];
//    nameLabel.text = @"马云 YOUCAN";
//    [self.view addSubview:nameLabel];
    
    
//    UILabel *signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(245)), AutoTrans(136), AutoTrans(150), AutoTrans(54))];
//    signInLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//    signInLabel.textColor = [UIColor colorWithHexString:@"#fba058"];
//    signInLabel.text = @"已签到";
//    signInLabel.textAlignment = 2;
//    [self.view addSubview:signInLabel];
    
    UIImageView *lineFrameImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(AutoTrans(160)), CGRectGetMaxY(headerIcon.frame)+(AutoTrans(10)), AutoTrans(320), AutoTrans(59))];

    lineFrameImgV.image = [UIImage imageNamed:@"icon_xuxiankuang"];
    [self.view addSubview:lineFrameImgV];
    
    UILabel *diamondsNum = [[UILabel alloc]initWithFrame:lineFrameImgV.frame];
    diamondsNum.font = [UIFont systemFontOfSize:AutoTrans(30)];
    diamondsNum.textAlignment =1;
    diamondsNum.textColor = [UIColor whiteColor];
    diamondsNum.text = @"目前优钻:0";
    _diamondsNum = diamondsNum;
    [self.view addSubview:diamondsNum];

}

/** 监听开始按钮 */
- (void)wheelButtonClick:(UIButton *)btn{
    
    
    
//    if (_coins.integerValue <= 0) {
//        [MBProgressHUD showError:[NSString stringWithFormat:@"您的今天的抽奖次数%@次已全部用完",_spendAllCount]];
//        return;
//    }
//    
//    if (_spendHaveCount.integerValue <= 0) {
//        [MBProgressHUD showError:[NSString stringWithFormat:@"您的今天的抽奖次数%@次已全部用完",_spendAllCount]];
//        return;
//    }
    
//    if (self.spendHaveCount.integerValue) {
//        NSInteger count = self.spendHaveCount.integerValue - 1;
//        self.spendHaveCount = count >= 0?@(count):@(0);
//    }
//    [self updateUI];
    
//    // 健壮性判断
//    if (!self.awards.count) return;
    
    // 关闭按钮响应
    btn.userInteractionEnabled = NO;
    
//    // 随机获取旋转角度
//    self.endAngle = [self angleRandom];
    

    [self tapChoujiang];
}

- (void)resetRotationAnimation{
    // 创建核心动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.delegate = self;
    rotationAnimation.fromValue = @(self.beginAngle);   // 旋转的起始角度
//    rotationAnimation.toValue = @([self angleRadian:90]);       // 旋转的终止角度
    rotationAnimation.toValue = @(self.endAngle);       // 旋转的终止角度
    rotationAnimation.duration = 4.0;    // 动画持续时间
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];           // 淡入淡出效果
    rotationAnimation.removedOnCompletion = NO;         // 不移除动画完成后的效果
    rotationAnimation.fillMode = kCAFillModeBoth;       // 保持
    
    // 添加动画到开始按钮上
    [self.beginButton.layer addAnimation:rotationAnimation forKey:nil];
    _rotationAnimation = rotationAnimation;
 
    
}



#pragma mark 点击抽奖
- (void)tapChoujiang{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:UserPrize parameters:parameters success:^(id dictJSON) {

        if ([dictJSON[@"status"] integerValue] == 1) {
            self.endAngle = [self angleRadian:[dictJSON[@"info"][@"angle"] doubleValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 添加动画到开始按钮上
                [self resetRotationAnimation];
            });
//            _spendU = dictJSON[@"info"][@"consumeCoins"];
//            _spendAllCount = dictJSON[@"info"][@"prizeCount"];
            _spendHaveCount = dictJSON[@"info"][@"prizeCount"];
//            _prizeImage = dictJSON[@"info"][@"prizeImage"];
            _coins = dictJSON[@"info"][@"userCoins"];
            
            
            NSLog(@"dictJSON = %@",dictJSON);
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [MBProgressHUD showSuccess:dictJSON[@"info"][@"note"]];
            });
        }else{
            // 恢复开始按钮可交互
            self.beginButton.userInteractionEnabled = YES;
            [MBProgressHUD showSuccess:dictJSON[@"error"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"抽奖失败,请检查网络"];
    }];
}

/** 角度值转弧度制 */
- (CGFloat)angleRadian:(CGFloat)angle{
    return (angle + 360*8) * M_PI / 180;
}

#pragma mark - 核心动画代理方法
/** 动画代理方法:动画播放完毕调用 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // 更新起始角度(下次点击旋转不会从初始角度开始)
    self.beginAngle = self.endAngle;
    
    // 防止逆向旋转和小角度旋转
    if (self.beginAngle >= self.endAngle) {
        self.beginAngle = self.beginAngle - [self angleRadian:360 * 5.0];
    }
    
//    // 显示抽奖结果
//    NSString *alertMessage = self.awards[self.intRandom][@"title"];
//    [self alertViewShowMessage:alertMessage];
    [self updateUI];
    // 恢复开始按钮可交互
    self.beginButton.userInteractionEnabled = YES;
    
}

//轮盘
-(void)addRoulette{
    UIImageView *rouletteImgV = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(95), AutoTrans(300), SCREEN_WIDTH-(AutoTrans(95))*2, SCREEN_WIDTH-(AutoTrans(95))*2)];
    rouletteImgV.image = [UIImage imageNamed:@"icon_zhuanpan"];
    rouletteImgV.tag = 0x1234;
    [self.view addSubview:rouletteImgV];
    _rouletteImgV = rouletteImgV;
    
//    UIButton *beginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(190),AutoTrans(190))];
    UIButton *beginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(200),AutoTrans(246))];
    [beginButton setImageEdgeInsets:UIEdgeInsetsMake(AutoTrans(-23), 0, AutoTrans(23), 0)];
    [beginButton setImage:[UIImage imageNamed:@"icon_zhuanzhen"] forState:UIControlStateNormal];
    beginButton.center = rouletteImgV.center;
    [beginButton addTarget:self action:@selector(wheelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    _beginButton = beginButton;
    
}
-(void)addRules{
    CGFloat height = AutoTrans(352);
    CGRect frameRule = CGRectMake(AutoTrans(82), CGRectGetMaxY([self.view viewWithTag:0x1234].frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(82))*2, height);
    UIImageView *ruleFrame = [[UIImageView alloc]initWithFrame:frameRule];
    ruleFrame.image = [UIImage imageNamed:@"icon_rulekuang"];
    [self.view addSubview:ruleFrame];
    
    CGFloat y = height * 93 / 352;
    
    UILabel *ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(50), y, ruleFrame.frame.size.width-(AutoTrans(50))*2, AutoTrans(255))];
    ruleLabel.font = [UIFont systemFontOfSize:AutoTrans(26)];
//    ruleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    ruleLabel.numberOfLines = 0;
    ruleLabel.textAlignment = NSTextAlignmentLeft;
    ruleLabel.textColor = [UIColor whiteColor];
    ruleLabel.text = @"1.抽中话费的童鞋请在意见反馈处提交姓名和电话，我们会及时充值。\n2.代金券用于所在学校新课程优惠使用，详情咨询学习中心老师。\n3.每次抽奖需要扣除1优钻，扣除的积分不退还，每天有10次抽奖机会\n4.此活动由优行英语公司发起,与苹果公司无关!";
    [ruleFrame addSubview:ruleLabel];
    _ruleLabel = ruleLabel;
}



-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
