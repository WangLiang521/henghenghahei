//
//  ReferralVC.m
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ReferralVC.h"

@interface ReferralVC ()
{
    UILabel *titleLabel ;
    UILabel *numLabel;
    UILabel *keyLabel;
}
@end

@implementation ReferralVC
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self addTopView];
    [NetWorkingUtils postWithUrl:ReferralCode params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
        NSLog(@"%@",response);
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            keyLabel.text = [NSString stringWithFormat:@"我的推荐码%@",[response valueForKey:@"referralCode"]];
            numLabel.text =[NSString stringWithFormat:@"×%@",[response valueForKey:@"coins"]];
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)initNavi{
    //    self.navigationController.navigationBarHidden = YES;
    //    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    [self.view addSubview:backImg];
    [self.navigationItem setTitle:@"推荐码"];
    self.view.backgroundColor = [UIColor whiteColor];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"推荐码";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset((AutoTrans(30))+20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(38)));
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 120, 60)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
//    UIButton *rightButton = [[UIButton alloc]initWithFrame:YXFrame(746-15-34-90, 67, 130, 34)];
//    //    [rightButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
//    [rightButton setTitle:@"选词" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
//    [rightButton addTarget:self action:@selector(chooseWords:) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.hidden = YES;
//    [self.view addSubview:rightButton];
    
    

    
    
}
-(void)addTopView{
    
    UIImageView *waveImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, AutoTrans(440), SCREEN_WIDTH, AutoTrans(50))];
    [waveImg setImage:[UIImage imageNamed:@"bg_barrier_bottom"]];
    [self.view addSubview:waveImg];
    waveImg.tag = 200;
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(waveImg.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(waveImg.frame))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    //180 160
    UIImageView * diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(180), AutoTrans(160), AutoTrans(160), AutoTrans(130))];
    diamondImg.image = [UIImage imageNamed:@"Diamond-Yellow2"];
    [self.view addSubview:diamondImg];
    
    numLabel =[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(180+160), AutoTrans(160), AutoTrans(200), AutoTrans(130))];
    numLabel.text = @"×0";
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:AutoTrans(100)];
    [self.view addSubview:numLabel];
    
    
    UILabel *descLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(300), AutoTrans(130))];
    descLabel.center = CGPointMake(self.view.center.x, AutoTrans(160+130+20));
    descLabel.text = @"推荐好友累计获得优钻";
    descLabel.textColor = [UIColor whiteColor];
    descLabel.font = [UIFont systemFontOfSize:AutoTrans(24)];
    [self.view addSubview:descLabel];
    
    //138 190  120
    UIImageView *keyContentImg = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(138), CGRectGetMaxY(descLabel.frame)+(AutoTrans(190)), SCREEN_WIDTH-(AutoTrans(138))*2, AutoTrans(120))];
    keyContentImg.image = [UIImage imageNamed:@"icon_tuijianma"];
    [self.view addSubview:keyContentImg];
    
    keyLabel = [[UILabel alloc]initWithFrame:keyContentImg.frame];
    keyLabel.textAlignment=1;
    keyLabel.textColor = [UIColor whiteColor];
    keyLabel.font = [UIFont systemFontOfSize:AutoTrans(34)];
    keyLabel.text = @"我的推荐码：";
    [self.view addSubview:keyLabel];
    
    //110 999999 26
    UILabel *descLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(keyLabel.frame.origin.x, keyLabel.frame.origin.y+(AutoTrans(230)), keyLabel.frame.size.width, AutoTrans(30))];
    descLabel2.text = @"把推荐码推荐给别人使用越多，奖励越多";
    descLabel2.textAlignment = 1;
    descLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
    descLabel2.font = [UIFont systemFontOfSize:AutoTrans(26)];
    [self.view addSubview:descLabel2];
    // 96 30 90
    UIButton *shareBTN = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(96), (AutoTrans(30))+CGRectGetMaxY(descLabel2.frame), SCREEN_WIDTH-(AutoTrans(96))*2, AutoTrans(90))];
    [shareBTN setBackgroundColor:[UIColor colorWithHexString:@"#38b7e5"]];
    shareBTN.layer.masksToBounds = YES;
    shareBTN.layer.cornerRadius = (AutoTrans(90))/2;
    [shareBTN setTitle:@"分享" forState:UIControlStateNormal];
    [shareBTN addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBTN];

    
    
    

    
}



#pragma mark - 界面跳转
-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button点击
-(void)share:(UIButton *)button{
    NSLog(@"分享");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
