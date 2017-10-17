 //
//  TestResultViewController.m
//  YouXingWords
//
//  Created by tih on 16/8/12.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TestResultViewController.h"
#import "LexiconViewController.h"
@interface TestResultViewController ()
@property (nonatomic,retain)UILabel *scoreLabel;
@property (nonatomic,retain)UILabel *rightLabel;
@property (nonatomic,retain)UILabel *wrongLabel;

@property (nonatomic,retain)UILabel *TipLabel;




@property (assign, nonatomic)  BreakthroughType type;
@end

@implementation TestResultViewController

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
    [self initNavi];
    [self addScoreLabel];
    [self addRightAndWrongNumLabel];
    [self addWaveView];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    float a = self.rightNum*1.00/(self.rightNum+self.wrongNum);
    NSInteger b = a*100;
    NSString *str = [NSString stringWithFormat:@"%d",b];
    
    [df setValue:str forKey:@"beforeTest"];
   _scoreLabel.text =str;

    //start
#pragma mark gd_修改 bookId 获取方式  2017-05-02 21:48:35
//    NSDictionary *dic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookID],@"rightCounts":@(self.rightNum),@"wrongCounts":@(self.wrongNum)};
    NSDictionary *dic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookIDWith:_type],@"rightCounts":@(self.rightNum),@"wrongCounts":@(self.wrongNum)};
    //end
    [NetWorkingUtils postWithUrlWithoutHUD:SubmitTest params:dic successResult:^(NSProgress *response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSLog(@"学前测试结果上传成功");
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)initNavi{

    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    backImg.userInteractionEnabled = YES;

    [self.view addSubview:backImg];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"闯关成功";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset((AutoTrans(30))+20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(38)));
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 90, 34)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
    
//    UIImageView *backView = [[UIImageView alloc]initWithFrame:YXFrame(15, 67, 34, 34)];
//    backView.userInteractionEnabled = YES;
//    [backView setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"]];
//    [self.view addSubview:backView];
//    
//    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backView.frame), AutoTrans(67), AutoTrans(60), AutoTrans(34))];
//    backLabel.textColor = [UIColor whiteColor];
//    backLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//    backLabel.text = @"返回";
//    [self.view addSubview:backLabel];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(naviPop:)];
//    [backView addGestureRecognizer:tap];
//    [backLabel addGestureRecognizer:tap];

    //TODO 上面的不管用
}
-(void)addScoreLabel{
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, AutoTrans(200), SCREEN_WIDTH, AutoTrans(200))];
//    NSAttributedString *str = [NSAttributedString alloc]initWithString:@"20" attributes:@{NSFontAttributeName}
    _scoreLabel.font = [UIFont fontWithName:@"PingFangTC-Thin" size:AutoTrans(200)];
    _scoreLabel.textAlignment =1;
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.text = @"20";
    [self.view addSubview:_scoreLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:AutoTrans(30)];
    label.textAlignment =1;
    label.textColor = [UIColor whiteColor];
    label.text = @"得分";
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scoreLabel.mas_centerX);
        make.top.mas_equalTo(_scoreLabel.mas_bottom);
        make.width.mas_equalTo(_scoreLabel.mas_width);
    }];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scoreLabel.frame)+(AutoTrans(110)), SCREEN_WIDTH, 1)];
    [lineView setImage:[UIImage imageNamed:@"barrier_bg_split"]];
    [self.view addSubview:lineView];
    
    UIImageView *lineViewVertical = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(lineView.frame), 1, AutoTrans(100))];
    [lineViewVertical setImage:[UIImage imageNamed:@"barrier_bg_split"]];
    [self.view addSubview:lineViewVertical];
    
}
-(void)addRightAndWrongNumLabel{
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:YXFrame(109, 529, 52, 52)];
    [rightImg setImage:[UIImage imageNamed:@"barrier_icon_check"]];
    [self.view addSubview:rightImg];
    
    _rightLabel = [[UILabel alloc]initWithFrame:YXFrame(109+52+16, 529, 100, 52)];
    _rightLabel.textColor = [UIColor whiteColor];
    _rightLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
    _rightLabel.text = [NSString stringWithFormat:@"%ld题",self.rightNum];
    [self.view addSubview:_rightLabel];
    
    UIImageView *wrongImg = [[UIImageView alloc]initWithFrame:YXFrame(746/2+109, 529, 52, 52)];
    [wrongImg setImage:[UIImage imageNamed:@"barrier_icon_false"]];
    [self.view addSubview:wrongImg];
    
    _wrongLabel = [[UILabel alloc]initWithFrame:YXFrame(109+52+16+746/2, 529, 100, 52)];
    _wrongLabel.textColor = [UIColor whiteColor];
    _wrongLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
    _wrongLabel.text = [NSString stringWithFormat:@"%ld题",self.wrongNum];
    [self.view addSubview:_wrongLabel];
}
-(void)addWaveView{
    UIImageView *waveImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, (AutoTrans(210))+CGRectGetMaxY(_scoreLabel.frame), SCREEN_WIDTH, AutoTrans(50))];
    [waveImg setImage:[UIImage imageNamed:@"bg_barrier_bottom"]];
    [self.view addSubview:waveImg];
    waveImg.tag = 200;
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(waveImg.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(waveImg.frame))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    _TipLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(96), CGRectGetMaxY(waveImg.frame)+(AutoTrans(46)), SCREEN_WIDTH-(AutoTrans(96))*2, AutoTrans(70))];
    _TipLabel.textAlignment = 1;
    _TipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _TipLabel.font = [UIFont systemFontOfSize:AutoTrans(26)];
    _TipLabel.numberOfLines = 0;
    _TipLabel.text=@"你的成绩有很大的提升空间，快点开始学习吧。\n我来学习只有一个目标，让自己100%完美";
    if (_wrongNum<3) {
        _TipLabel.text=@"你已经做得很不错了，保持下去！\n我来学习只有一个目标，让自己100%完美";

    }
    [self.view addSubview:_TipLabel];
    
    UIButton *startStudy = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(98), CGRectGetMaxY(_TipLabel.frame)+(AutoTrans(40)), SCREEN_WIDTH-(AutoTrans(98))*2, AutoTrans(90))];
    [startStudy setBackgroundColor:[UIColor colorWithHexString:@"#64bfff"]];
    startStudy.layer.masksToBounds = YES;
    startStudy.layer.cornerRadius = (AutoTrans(90))/2;
    [startStudy setTitle:@"开始学习" forState:UIControlStateNormal];
    [startStudy addTarget:self action:@selector(startStudy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startStudy];

}
-(void)startStudy:(UIButton *)button{
    [self naviPop:nil];
    
}
#pragma mark - 界面跳转
-(void)naviPop:(UITapGestureRecognizer *)tap{
//    [[self.navigationController.viewControllers objectAtIndex:1] setValue:_scoreLabel.text forKey:@"testPoint"];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    //start
#pragma mark gd_更改返回方式解决,复习关重复  2017-03-27 16:33:41-3
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
