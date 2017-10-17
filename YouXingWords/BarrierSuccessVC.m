//
//  BarrierSuccessVC.m
//  YouXingWords
//
//  Created by LDJ on 16/8/12.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BarrierSuccessVC.h"
#import "BrowerWordsVC.h"
#import "AnswerTools.h"
#import "PassList.h"

#import <SVProgressHUD.h>
#import "LexiconViewController.h"
#import "TimerTools.h"
#import "DakaView.h"
@interface BarrierSuccessVC ()
@property (nonatomic,retain)UIImageView *centerDiamond;
@property (nonatomic,retain)UIImageView *leftDiamond;
@property (nonatomic,retain)UIImageView *rightDiamond;
@property (nonatomic,retain)UILabel     *BarrierInfoLabel;

@property (assign, nonatomic)  BreakthroughType type;
//    gd_过关时获得了多少优钻
@property (strong, nonatomic)  NSNumber *getCoinsCount;
@end

@implementation BarrierSuccessVC


- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (instancetype)initWith:(BreakthroughType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBarAndBackImg];
    [self addSuccessInfo];
    [self addDakaView];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    [PassList unlockNext];
    [PassList unlockNextWith:_type];
    //end
    
     
    //1.刚做完的学习时间
    NSString * currentStudyTime = [TimerTools getTime];
    //2.之前做过的学习时间
    NSString * studybefore = [[NSUserDefaults standardUserDefaults] objectForKey:@"studyTimeToday"];
    
    //3.总和
    NSString * todayTotalStudyTime = [NSString stringWithFormat:@"%zd",[currentStudyTime integerValue] + [studybefore integerValue]];
    [[NSUserDefaults standardUserDefaults] setObject:todayTotalStudyTime forKey:@"todayTotalStudyTime"];
    

    [TimerTools reSaveTimeNew];
    
    [PassList savePassedPassIdsWith:self.passId BookId:[AnswerTools getBookIDWith:_type]];
   
#warning 暂时隐藏
//    [TimerTools clear];
    
    
//    NSMutableDictionary * passInfo = [NSMutableDictionary dictionary];
//    passInfo[@"bookId"] = [AnswerTools getBookIDWith:_type];
//    passInfo[@"coins"] = _getCoinsCount;
//    passInfo[@"isPass"] = @"1";
//    passInfo[@"passId"] = self.passId;
//    passInfo[@"username"] = [Utils getCurrentUserName];
    

    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
    //        [NetWorkingUtils uploadBarrierInfoPassfail:NO passId:self.passId passTime:self.time_second currentVC:self];
    [NetWorkingUtils uploadBarrierInfoPassfail:NO passId:self.passId passTime:self.time_second currentVC:self With:_type];
    //end
    
    
    
    

}



#pragma mark - UI初始化
-(void)initNaviBarAndBackImg{
    
    [self setNeedsStatusBarAppearanceUpdate];
    /**
     背景图
     */
    UIImageView *backgroundImgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backgroundImgV setImage:[UIImage imageNamed:@"barrier_bg"]];
    [self.view addSubview:backgroundImgV];
    /**
     返回键
     */
    UIButton *backButton=[[UIButton alloc]initWithFrame:YXFrame(44, 19, 116, 117)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    /**
     题目-闯关
     */
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21, 80, 40)];
    titleImage.center = CGPointMake(self.view.center.x, titleImage.bounds.size.height/2);
    [titleImage setImage:[UIImage imageNamed:@"barrier_bg_lexicon"]];
    // [self.view addSubview:titleImage];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:YXFrame(0, 0, 142, 76)];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.center = CGPointMake(self.view.center.x, backButton.center.y);
    titleLabel.textAlignment=1;
    titleLabel.font = [UIFont fontWithName:HYTAIJI size:40];
    titleLabel.text = @"过关";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
  
}
#pragma mark 显示优钻数
-(void)addSuccessInfo{
    UIImageView *infoBackImg = [[UIImageView alloc]initWithFrame:YXFrame(43, 247, 660, 486)];
    [infoBackImg setImage:[UIImage imageNamed:@"barrier_icon_barrier_bg"]];
    [self.view addSubview:infoBackImg];
    
    UIImageView *successImg = [[UIImageView alloc]initWithFrame:YXFrame(137, 196, 476, 124)];
    [successImg setImage:[UIImage imageNamed:@"barrier_icon_success_title@3x"]];
    [self.view addSubview:successImg];
    
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
//    if ([AnswerTools getRate]>0.9) {
//        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
//        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_selected_right"]];
//        [self.view addSubview:_rightDiamond];
//        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
//        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected_center"]];
//        [self.view addSubview:_centerDiamond];
//        
//        [PassList gotUdiamondNum:@3];
//    }else if([AnswerTools getRate]>0.8){
//        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
//        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_normal_right"]];
//        [self.view addSubview:_rightDiamond];
//        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
//        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected_center"]];
//        [self.view addSubview:_centerDiamond];
//        [PassList gotUdiamondNum:@2];
//    }else {
//        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
//        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_normal_right"]];
//        [self.view addSubview:_rightDiamond];
//        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
//        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal_center"]];
//        [self.view addSubview:_centerDiamond];
//        [PassList gotUdiamondNum:@1];
//    }
    if ((6-[AnswerTools getLives]) <= [PassList getSysInfo:3]) {
        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_selected_right"]];
        [self.view addSubview:_rightDiamond];
        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected_center"]];
        [self.view addSubview:_centerDiamond];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        [PassList gotUdiamondNum:@3];
        [PassList gotUdiamondNum:@3 With:_type];
        //end
        _getCoinsCount = @3;
    }else if ((6-[AnswerTools getLives]) <= [PassList getSysInfo:2]) {
        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_normal_right"]];
        [self.view addSubview:_rightDiamond];
        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected_center"]];
        [self.view addSubview:_centerDiamond];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
        //        [PassList gotUdiamondNum:@2];
        [PassList gotUdiamondNum:@2 With:_type];
        //end
        _getCoinsCount = @2;
    }else {
        _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
        [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_normal_right"]];
        [self.view addSubview:_rightDiamond];
        _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
        [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal_center"]];
        [self.view addSubview:_centerDiamond];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
        //        [PassList gotUdiamondNum:@1];
        [PassList gotUdiamondNum:@1 With:_type];
        //end
        _getCoinsCount = @1;
    }
    
    //end

    //151 是算出来的
    _leftDiamond = [[UIImageView alloc]initWithFrame:YXFrame(151, 371, 128, 108)];
    [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_selected_left"]];
    [self.view addSubview:_leftDiamond];
    

    
    UIButton *restartButton=[[UIButton alloc]initWithFrame:YXFrame(209, 639, 132, 136)];
    [restartButton addTarget:self action:@selector(restartOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [restartButton setImage:[UIImage imageNamed:@"barrier_icon_again"] forState:UIControlStateNormal];
    [self.view addSubview:restartButton];
    
    UIButton *nextButton=[[UIButton alloc]initWithFrame:YXFrame(32+373, 639, 132, 136)];
    [nextButton addTarget:self action:@selector(nextOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"barrier_icon_nextbarrier"] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    _BarrierInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerDiamond.frame), SCREEN_WIDTH, CGRectGetMinY(restartButton.frame)-CGRectGetMaxY(_centerDiamond.frame))];
    _BarrierInfoLabel.textAlignment =1;
    _BarrierInfoLabel.font = [UIFont fontWithName:HYCHAOCU size:AutoTrans(33)];
    _BarrierInfoLabel.numberOfLines = 3;
    _BarrierInfoLabel.textColor = [UIColor whiteColor];
    _BarrierInfoLabel.shadowColor = [UIColor colorWithHexString:@"#3a230a"];
    _BarrierInfoLabel.shadowOffset =CGSizeMake(-1, 1);
    _BarrierInfoLabel.text = self.successInfo;
    [self.view addSubview:_BarrierInfoLabel];
    
}
- (void)addDakaView{
    DakaView * dkView = [DakaView shareWithCurrentVC:self];
    [self.view addSubview:dkView];
    [self.view bringSubviewToFront:dkView];
    self.view.userInteractionEnabled = YES;
    DEFINE_WEAK(dkView);
    [dkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GDAutoTrans(56));
        make.right.mas_equalTo(-GDAutoTrans(56));
        make.bottom.mas_equalTo(-GDAutoTrans(200));
        make.height.mas_equalTo(wdkView.mas_width).multipliedBy(312.0/644);
    }];
}
-(void)restartOnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate needRestart];
}
#pragma mark 点击下一题
-(void)nextOnClick:(UIButton *)button{
    if (self.navigationController.viewControllers[2]) {
        BrowerWordsVC *vc =self.navigationController.viewControllers[2];
        [vc.removeList removeAllObjects];
        [vc.list removeAllObjects];
        [vc.selectList removeAllObjects];
        vc.removeList = nil;
        vc.selectList = nil;
        vc.list = nil;
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        if ([PassList canGetNext]) {
        if ([PassList canGetNextWith:_type]) {
        //end
        
            vc.item = [PassList getNext];
            
            [self.navigationController popToViewController:vc animated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"没有下一关或下一关没有解锁"];
            UIViewController * firstVC = [self.navigationController.viewControllers objectAtIndex:0];
            [self.navigationController popToViewController:firstVC animated:NO];
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
            //        LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
            LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:_type];
            //end
            lexiconVC.hidesBottomBarWhenPushed = YES;
            
            [firstVC.navigationController pushViewController:lexiconVC animated:NO];
//            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
    }
}
#pragma mark - 视图变化 消失出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

#pragma mark - 界面跳转1
-(void)naviPop:(UIButton *)button{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //start
#pragma mark gd_先返回到首页,在push过来  2017-01-19
    
//    UIViewController * vc = self.navigationController.viewControllers[0];
//    [self.navigationController popToViewController:vc animated:NO];
////    vc.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
//    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
//    lexiconVC.hidesBottomBarWhenPushed = YES;
//    
//    [vc.navigationController pushViewController:lexiconVC animated:NO];
    
    UIViewController * firstVC = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:firstVC animated:NO];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
    LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:_type];
    //end

    
    
    lexiconVC.hidesBottomBarWhenPushed = YES;
    
    [firstVC.navigationController pushViewController:lexiconVC animated:NO];
    //end
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
