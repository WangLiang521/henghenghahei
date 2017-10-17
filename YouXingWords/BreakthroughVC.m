//
//  BreakthroughVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BreakthroughVC.h"
#import "LexiconViewController.h"
#import "AlreadyWordNum.h"


#import "BarrierSuccessVC.h"
#import "WrongWordVC.h"
#import "BarrierDetailVC.h"
#import "PronunciationVC.h"
#import "Reachability.h"

#import "ReportListVC.h"
#import "TimerTools.h"

#import "ChooseResVC.h"

#import "CourseSyn.h"




@interface BreakthroughVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UIButton *lexiconBreak;
@property (nonatomic,retain)UIButton *grammerBreak;
@property (nonatomic,retain)UIButton *courseBreak;

//已背单词数量
@property (nonatomic,retain)UILabel *alreadyNumLabel;
//已学习时长
@property (nonatomic,retain)UILabel *alreadyTimeLabel;
@property (nonatomic,retain)UILabel *TimeCategoryLabel;
//当前排名
@property (nonatomic,retain)UILabel *rankNumLabel;

@property(strong) Reachability * netReach;


@property (strong, nonatomic)  UITableView *tableView;



@end

@implementation BreakthroughVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}



-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    
    //    上次保存 studyTimeToday 的日期
    NSString * lastSaveDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSaveDate"];
    NSString * todayStr = [LGDUtils stringFromDate:[NSDate date] WithFormatterString:FormatterStringyyyy_MM_dd];
    if (!(lastSaveDate && [lastSaveDate isEqualToString:todayStr])) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"studyTimeToday"];
    }
    
    
    //start
#pragma mark gd_增加reSaveTimeNew 到闯关页面  2017-03-14 10:01:59
    [TimerTools reSaveTimeNew];
    //end
    
    //start
#pragma mark gd_- [ ] 学习时间不对(闯关首页)  0115
    [self refreshHeader];
    
    //end
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initNavi];

    [self addTopViewWithSuperView:self.view];
    [self setUpTableView];
    
//    [self addButtonsViewWithSuperView:self.view];

    WS(weakSelf);
    [[NSNotificationCenter defaultCenter] addObserverForName:@"studyInfo" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshHeader];
    }];
}



 #pragma mark 学习时间刷新
- (void)refreshHeader{
    [NetWorkingUtils networkReachable:^{
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSString *token = [df valueForKey:@"token"];
        if (token) {
            NSDictionary *paramsDic = @{@"token":token};
            [NetWorkingUtils postWithUrl:timeRanking params:paramsDic successResult:^(id response) {
                [self.tableView.mj_header endRefreshing];
                if ([[response valueForKey:@"status"] integerValue]==1) {
                    NSNumber *ranking = [response valueForKey:@"rangking"];
                    if ([ranking integerValue]==-1) {
                        _rankNumLabel.text = @"未进入排名";
                        _rankNumLabel.font = [UIFont systemFontOfSize:AutoTrans(36)];
                        _rankNumLabel.adjustsFontSizeToFitWidth = YES;
                    }else{
                        _rankNumLabel.text = [NSString stringWithFormat:@"%@",[response valueForKey:@"rangking"]];
                        _rankNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)];

                    }
                    NSString * todayStr = [LGDUtils stringFromDate:[NSDate date] WithFormatterString:FormatterStringyyyy_MM_dd];
                    [[NSUserDefaults standardUserDefaults] setObject:todayStr forKey:@"LastSaveDate"];
                    
//                    计算学习时间
                    NSString *timeStr  = [NSString stringWithFormat:@"%@",response[@"studyTime0"]];
                    
                    [df setObject:timeStr forKey:@"studyTimeToday"];
                    
                    timeStr = [Utils isValidStr:timeStr]?timeStr:@"0";
                    
                    NSString *strBendi= [TimerTools getStudyTimeNew];
                    
                    NSInteger timeAll = [strBendi integerValue] + [timeStr integerValue];
                    timeStr = [NSString stringWithFormat:@"%zd",timeAll];
                    
                    NSInteger studyTime = [LGDUtils changeSecondsToMinute:timeStr];
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",studyTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)]}];
                    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(24)]}];
                    [str appendAttributedString:str2];
                    _alreadyTimeLabel.attributedText = str;
                    
                    
                }else{
                    [Utils showAlter:[response valueForKey:@"error"] WithTime:1.0];
                }
            } errorResult:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
                NSLog(@"%@",error);
                
                //                    计算学习时间
                NSString *timeStr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"studyTimeToday"];
                
                timeStr = [Utils isValidStr:timeStr]?timeStr:@"0";
                
                NSString *strBendi= [TimerTools getStudyTimeNew];
                
                NSInteger timeAll = [strBendi integerValue] + [timeStr integerValue];
                timeStr = [NSString stringWithFormat:@"%zd",timeAll];
                
                NSInteger studyTime = [LGDUtils changeSecondsToMinute:timeStr];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",studyTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)]}];
                NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(24)]}];
                [str appendAttributedString:str2];
                _alreadyTimeLabel.attributedText = str;

            }];
            
            
            
            //start
#pragma mark gd_- [ ] 学习时间不对(闯关首页)  0115
//            [NetWorkingUtils postWithUrlWithoutHUD:GetUserInfo params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
//                NSString *timeStr  = [NSString stringWithFormat:@"%@",[response[@"info"] valueForKey:@"studyTime0"]];
//                
//                [df setObject:timeStr forKey:@"studyTimeToday"];
//                
//                timeStr = [Utils isValidStr:timeStr]?timeStr:@"0";
//
//                NSString *strBendi= [TimerTools getStudyTimeNew];
//
//                NSInteger timeAll = [strBendi integerValue] + [timeStr integerValue];
//                timeStr = [NSString stringWithFormat:@"%zd",timeAll];
//
//                NSInteger studyTime = [LGDUtils changeSecondsToMinute:timeStr];
//
//                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",studyTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)]}];
//                NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(24)]}];
//                [str appendAttributedString:str2];
//                _alreadyTimeLabel.attributedText = str;
//                
//                [[NSUserDefaults standardUserDefaults]setObject:response[@"info"] forKey:@"userInfo"];
//            } errorResult:^(NSError *error) {
//                NSLog(@"%@",error);
//                
//            }];
            //end
            
            
            
        }



    } AndUnreachable:^{
        [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
        [self.tableView.mj_header endRefreshing];
        //                    计算学习时间
        NSString *timeStr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"studyTimeToday"];
        
        timeStr = [Utils isValidStr:timeStr]?timeStr:@"0";
        
        NSString *strBendi= [TimerTools getStudyTimeNew];
        
        NSInteger timeAll = [strBendi integerValue] + [timeStr integerValue];
        timeStr = [NSString stringWithFormat:@"%zd",timeAll];
        
        NSInteger studyTime = [LGDUtils changeSecondsToMinute:timeStr];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",studyTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)]}];
        NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(24)]}];
        [str appendAttributedString:str2];
        _alreadyTimeLabel.attributedText = str;
    }];
    
    
    
    NSString *numStr = [NSString stringWithFormat:@"%ld",[AlreadyWordNum getAlreadyNum]];
    _alreadyNumLabel.text = [numStr length]>0?numStr:@"0";
    
}



- (void)setUpTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    __weak __block UIViewController * weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view);
    }];

    self.tableView.backgroundColor = [UIColor clearColor];


    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = SCREEN_HEIGHT - 49 - 64;
//    self.tableView.estimatedRowHeight = 100;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    [self.tableView registerNib:[UINib nibWithNibName:@"LiuChengCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LiuchengModel class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    MJRefreshNormalHeader * mj_Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    // 隐藏时间
    mj_Header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    mj_Header.stateLabel.hidden = YES;
    self.tableView.mj_header = mj_Header;
//    [self.tableView.mj_header beginRefreshing];

    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];


}

#pragma mark TableView -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    [self addButtonsViewWithSuperView:cell];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView.backgroundColor = [UIColor clearColor];
//}


-(void)initNavi{
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
#pragma mark gd_背景图
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    [self.view addSubview:backImg];
    [self.navigationItem setTitle:@"闯关"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
//    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    NSLog(@"[familyNames count]===%lu",(unsigned long)[familyNames count]);
//    for(indFamily=0;indFamily<[familyNames count];++indFamily)
//        
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        
//        for(indFont=0; indFont<[fontNames count]; ++indFont)
//            
//        {
//            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
//            
//        }
//        
//    }
    

}
-(void)addTopViewWithSuperView:(UIView *)superView{
    UIImageView *waveImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, AutoTrans(330), SCREEN_WIDTH, AutoTrans(50))];
    [waveImg setImage:[UIImage imageNamed:@"bg_barrier_bottom"]];
    [self.view addSubview:waveImg];
     waveImg.tag = 200;
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(waveImg.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(waveImg.frame))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    
    
    
    

    UILabel *alreadyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    alreadyLabel.textColor = [UIColor colorWithHexString:@"#b4e3f2"];
    alreadyLabel.textAlignment =1;
    alreadyLabel.text = @"已背单词";
    [self.view addSubview:alreadyLabel];
    
    UILabel *kTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    kTimeLabel.textColor = [UIColor colorWithHexString:@"#b4e3f2"];
    kTimeLabel.textAlignment =1;
    kTimeLabel.text = @"学习时间";
    [self.view addSubview:kTimeLabel];
    
    UILabel *kRankLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    kRankLabel.textColor = [UIColor colorWithHexString:@"#b4e3f2"];
    kRankLabel.textAlignment =1;
    kRankLabel.text = @"当前排名";
    [self.view addSubview:kRankLabel];
    
    [alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.bottom.mas_equalTo(waveImg.mas_top).offset(-(AutoTrans(54)));
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.width.mas_equalTo(kTimeLabel.mas_width);
    }];
    
    [kTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alreadyLabel.mas_right);
        make.bottom.mas_equalTo(alreadyLabel.mas_bottom);
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.width.mas_equalTo(kRankLabel.mas_width);
    }];
    
    [kRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kTimeLabel.mas_right);
        make.bottom.mas_equalTo(alreadyLabel.mas_bottom);
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    _alreadyNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _alreadyNumLabel.textColor = [UIColor whiteColor];
    _alreadyNumLabel.textAlignment =1;
    _alreadyNumLabel.text = @"33";
    _alreadyNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)];
    [self.view addSubview:_alreadyNumLabel];
    
    [_alreadyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alreadyLabel.mas_centerX);
        make.centerY.mas_equalTo(alreadyLabel.mas_centerY).offset(-(AutoTrans(66)));
        make.height.mas_equalTo(@(AutoTrans(72)));
        make.width.mas_equalTo(alreadyLabel.mas_width);
    }];
    
    _alreadyTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _alreadyTimeLabel.textColor = [UIColor whiteColor];
    _alreadyTimeLabel.textAlignment =1;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)]}];
    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AutoTrans(24)]}];
    [str appendAttributedString:str2];
    _alreadyTimeLabel.attributedText = str;
//    _alreadyTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)];
    [self.view addSubview:_alreadyTimeLabel];
    
    [_alreadyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kTimeLabel.mas_centerX);
        make.centerY.mas_equalTo(kTimeLabel.mas_centerY).offset(-(AutoTrans(66)));
        make.height.mas_equalTo(@(AutoTrans(72)));
        make.width.mas_equalTo(kTimeLabel.mas_width);
    }];
    
    _rankNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _rankNumLabel.textColor = [UIColor whiteColor];
    _rankNumLabel.textAlignment =1;
    _rankNumLabel.text = @"0";
    _rankNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:AutoTrans(72)];
    [self.view addSubview:_rankNumLabel];
    
    [_rankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kRankLabel.mas_centerX);
        make.centerY.mas_equalTo(kRankLabel.mas_centerY).offset(-(AutoTrans(66)));
        make.height.mas_equalTo(@(AutoTrans(72)));
        make.width.mas_equalTo(kRankLabel.mas_width);
    }];
}
-(void)addButtonsViewWithSuperView:(UIView *)superView{
    _lexiconBreak = [[UIButton alloc]initWithFrame:YXFrame(0, 0, 746-65*2, 200) ];
    _lexiconBreak.center = CGPointMake(self.view.center.x, CGRectGetMaxY([self.view viewWithTag:200].frame)+(AutoTrans(66))+(AutoTrans(200))/2);
//    _lexiconBreak.center = CGPointMake(self.view.center.x, 100);
    [_lexiconBreak setBackgroundImage:[UIImage imageNamed:@"barrier_bg_lexicon"] forState:UIControlStateNormal];
    [_lexiconBreak setImage:[UIImage imageNamed:@"barrier_icon_lexicon"] forState:UIControlStateNormal];
    //140 150是测试出来的近似值
    [_lexiconBreak setTitleEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(140), 0, 0)];
    [_lexiconBreak setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,AutoTrans(150))];
    [_lexiconBreak setTitle:@"词汇快速突破" forState:UIControlStateNormal];
    _lexiconBreak.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(36)];
    [_lexiconBreak addTarget:self action:@selector(lexiconBreakOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_lexiconBreak];
    
    _grammerBreak = [[UIButton alloc]initWithFrame:YXFrame(0, 0, 746-65*2, 200) ];
    _grammerBreak.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_lexiconBreak.frame)+(AutoTrans(160)));
    [_grammerBreak setBackgroundImage:[UIImage imageNamed:@"barrier_bg_grammar"] forState:UIControlStateNormal];
    [_grammerBreak setImage:[UIImage imageNamed:@"barrier_icon_grammar"] forState:UIControlStateNormal];
    //140 150是测试出来的近似值
    [_grammerBreak setTitleEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(140), 0, 0)];
    [_grammerBreak setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,AutoTrans(150))];
    [_grammerBreak setTitle:@"语法快速突破" forState:UIControlStateNormal];
    _grammerBreak.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(36)];
    [_grammerBreak addTarget:self action:@selector(grammerBreakOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_grammerBreak];
    
    _courseBreak = [[UIButton alloc]initWithFrame:YXFrame(0, 0, 746-65*2, 200) ];
    _courseBreak.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_grammerBreak.frame)+(AutoTrans(60))+(AutoTrans(200))/2);
    [_courseBreak setBackgroundImage:[UIImage imageNamed:@"barrier_bg_shcool"] forState:UIControlStateNormal];
    [_courseBreak setImage:[UIImage imageNamed:@"barrier_icon_shcool"] forState:UIControlStateNormal];
    //140 150是测试出来的近似值
    [_courseBreak setTitleEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(140), 0, 0)];
    [_courseBreak setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,AutoTrans(150))];
    [_courseBreak setTitle:@"学校课程同步" forState:UIControlStateNormal];
    _courseBreak.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(36)];
    [_courseBreak addTarget:self action:@selector(courseBreakOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_courseBreak];
}
//词汇闯关
-(void)lexiconBreakOnClick:(UIButton *)button{
//    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
//    lexiconVC.hidesBottomBarWhenPushed = YES;
//
//    [self.navigationController pushViewController:lexiconVC animated:YES];
    
    [self checkAndRequestWords];
}
//语法突破
-(void)grammerBreakOnClick:(UIButton *)button{
//    [SVProgressHUD showErrorWithStatus:@"敬请期待"];
    [SVProgressHUD showInfoWithStatus:@"敬请期待"];
//    ReportListVC *lexiconVC = [[ReportListVC alloc]init];
//    lexiconVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:lexiconVC animated:YES];

}
//课程同步
-(void)courseBreakOnClick:(UIButton *)button{
//    [SVProgressHUD showInfoWithStatus:@"敬请期待"];
//    CourseSyn * courseSyn = [[CourseSyn alloc] init];
//    courseSyn.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:courseSyn animated:YES];
    [self checkAndRequestCourse];
}

- (void)checkAndRequestWords{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *strzip = [NSString stringWithFormat:@"Documents/%@/%@.zip",[Utils getResFolder],[AnswerTools getBookID]];
//    NSString *filePathzip = [NSHomeDirectory() stringByAppendingPathComponent:strzip];
//    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getBookID]];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    
    NSString *strzip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getBookIDWith:BreakthroughTypeWord],ArchiveType];
    NSString *filePathzip = [NSHomeDirectory() stringByAppendingPathComponent:strzip];
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getBookIDWith:BreakthroughTypeWord]];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    
    //end
    
    
    
    NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
    
    
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && ![[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }else{
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && [[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
            
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
            [Utils unArchive:filePathzip andPassword:nil destinationPath:filePathDest completionBlock:^{
                
            } failureBlock:^{
                
            }];

            
            
            __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES afterDelay:0.5];
                
                hud.completionBlock = ^{
                    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                    //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
                    LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:BreakthroughTypeWord];
                    //end
                    lexiconVC.hidesBottomBarWhenPushed = YES;
                
                    [self.navigationController pushViewController:lexiconVC animated:YES];
                };
                
            });
        }else{
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
            //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
            LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:BreakthroughTypeWord];
            //end
            lexiconVC.hidesBottomBarWhenPushed = YES;
        
            [self.navigationController pushViewController:lexiconVC animated:YES];
        }
    }
}

/**
 *  点击学校课程同步
 */
- (void)checkAndRequestCourse{
    NSString *strzip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getCourseBookID],ArchiveType];
    NSString *filePathzip = [NSHomeDirectory() stringByAppendingPathComponent:strzip];
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getCourseBookID]];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    
    NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
    
    
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && ![[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }else{
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && [[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
            
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
            [Utils unArchive:filePathzip andPassword:nil destinationPath:filePathDest completionBlock:^{
                
            } failureBlock:^{
                
            }];
            
            __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES afterDelay:0.5];
                
                hud.completionBlock = ^{
                    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                    //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
                    LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:BreakthroughTypeCourse];
                    //end
                    lexiconVC.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:lexiconVC animated:YES];
                };
                
            });
        }else{
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
            //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
            LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:BreakthroughTypeCourse];
            //end
            lexiconVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:lexiconVC animated:YES];
        }
        
    }
     
}


#pragma mark---提示框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex==1) {
        
        ChooseResVC *chooseVC = [[ChooseResVC alloc]init];
//        chooseVC.delegate = self;
        [self presentViewController:chooseVC animated:YES completion:^{
            
        }];
    }
}



@end
