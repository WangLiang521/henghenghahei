//
//  AwardSignInVC.m
//  YouXingWords
//
//  Created by LDJ on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "AwardSignInVC.h"

@interface AwardSignInVC ()

@end

@implementation AwardSignInVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBarAndBackImg];
    // Do any additional setup after loading the view.
}
#pragma mark - UI初始化
-(void)initNaviBarAndBackImg{
    
    //    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    /**
     背景图
     */
    UIImageView *backgroundImgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backgroundImgV setImage:[UIImage imageNamed:@"bg_loginaward"]];
    [self.view addSubview:backgroundImgV];
    /**
     返回键 
     */
    UIButton *backButton=[[UIButton alloc]initWithFrame:YXFrame(44, 19, 116, 117)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back_loginaward"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    /**
     题目-闯关
     */
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21, 80, 40)];
    titleImage.center = CGPointMake(self.view.center.x, titleImage.bounds.size.height/2);
    [titleImage setImage:[UIImage imageNamed:@"barrier_bg_lexicon"]];
    // [self.view addSubview:titleImage];
    UILabel *titleLabel;
    if (is_3x) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, trans2_3x(142), trans2_3x(76))];
    }
    else{
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, trans2_2x(142), trans2_2x(76))];
    }
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.center = CGPointMake(self.view.center.x, backButton.center.y);
    titleLabel.textAlignment=1;
    titleLabel.font = [UIFont fontWithName:HYTAIJI size:40];
    titleLabel.text = @"积分";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIImageView *contentImg = [[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(72), AutoTrans(220), SCREEN_WIDTH-(AutoTrans(72))*2, (SCREEN_WIDTH-(AutoTrans(72))*2)/643*402)];
}
-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
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
