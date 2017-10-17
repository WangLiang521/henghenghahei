//
//  WaitStartVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/18.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "WaitStartVC.h"
#import "PKDetailVC.h"
@interface WaitStartVC ()

//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//底部图片
@property(nonatomic,retain)UIImageView *bottomImg;
//倒计时时间label
@property(nonatomic,retain)UILabel *timeLb;
//组织方,奖品，开始时间label
@property(nonatomic,retain)UILabel *contentLb;
//确定按钮
@property(nonatomic,retain)UIButton *sureBt;
//倒计时时间
@property(nonatomic,assign)NSInteger timerCount;

@property(nonatomic,retain)NSTimer *timer;

@property(nonatomic,copy)NSArray *contentArr;

@property (assign, nonatomic)  BreakthroughType type;

@end

@implementation WaitStartVC

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


-(NSArray *)contentArr
{
    if (_contentArr==nil) {
        _contentArr=@[[NSString stringWithFormat:@"      组织机构:  %@",_dataDic[@"fromSourceName"]],
                      [NSString stringWithFormat:@"      奖励规则:  前3名%@个优钻,4-10名%@个优钻",_dataDic[@"firstNum"],_dataDic[@"fourthToTen"]],
                      [NSString stringWithFormat:@"      开始时间:  %@",[Utils timeByTimeStamp:_dataDic[@"startTime"]]]];
    }
    return _contentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef DEBUG
    //测试测试
    _timerCount=5;
    //实际应用
//    _timerCount=[self getCurrentTimeToStartTime:_dataDic[@"startTime"]];
#else
    //实际应用
    _timerCount=[self getCurrentTimeToStartTime:_dataDic[@"startTime"]];
#endif
    

    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加倒计时label
    [self addTimeLb];
    //添加底部view
    [self addBottomImg];
    //添加定时器
    [self addTimer];
    
}
#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
}
#pragma mark---添加表头
-(void)addTitleView
{
    _titleView=[CustomTitleView customTitleView:@"词汇比赛" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加倒计时label
-(void)addTimeLb
{
    _timeLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+(AutoTrans(40)), SCREEN_WIDTH, AutoTrans(200))];
    _timeLb.text=[self timeChange:_timerCount];
    _timeLb.font=[UIFont systemFontOfSize:AutoTrans(100)];
    _timeLb.textAlignment=NSTextAlignmentCenter;
    _timeLb.textColor=[UIColor whiteColor];
    [self.view addSubview:_timeLb];
    //改变字体
//    [self fontChange];
    //倒计时label
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLb.frame), SCREEN_WIDTH, AutoTrans(30))];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:AutoTrans(36)];
    label.text=@"倒计时";
    [self.view addSubview:label];
}
#pragma mark---添加定时器
-(void)addTimer
{
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
}
#pragma mark---定时器运行
-(void)timerAction
{
    NSLog(@"%ld",_timerCount);
    _timerCount--;
    _timeLb.text=[self timeChange:_timerCount];
    if (_timerCount<=0) {
        //定时器停止
        [_timer invalidate];
        _timer=nil;
        
        [_sureBt setTitle:@"开始答题" forState:UIControlStateNormal];
        _sureBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    }
    //改变字体
//    [self fontChange];
}
#pragma mark---添加底部view
-(void)addBottomImg
{
    _bottomImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLb.frame)+(AutoTrans(100)), SCREEN_WIDTH,SCREEN_HEIGHT-(CGRectGetMaxY(_timeLb.frame)+(AutoTrans(100))))];
    _bottomImg.image=[UIImage imageNamed:@"bg_bolang"];
    _bottomImg.userInteractionEnabled=YES;
    [self.view addSubview:_bottomImg];
    UIView * lastView  = [UIView new];
    lastView.frame = CGRectMake(0, 30, 1, 1);
    //组织方 奖品 开始时间
    for (int i=0; i<3; i++) {
        CGFloat y = CGRectGetMaxY(lastView.frame) + 10 ;
        _contentLb=[[UILabel alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, AutoTrans(60))];
        _contentLb.textColor=[UIColor colorWithHexString:@"#333333"];
        _contentLb.font=[UIFont systemFontOfSize:AutoTrans(36)];
        _contentLb.text=self.contentArr[i];
        [_bottomImg addSubview:_contentLb];
        lastView = _contentLb;
    }
    //确定按钮
    _sureBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(100), CGRectGetMaxY(_contentLb.frame)+(AutoTrans(80)), SCREEN_WIDTH-(AutoTrans(200)), AutoTrans(90))];
    _sureBt.layer.cornerRadius=CGRectGetHeight(_sureBt.frame)/2;
    _sureBt.layer.masksToBounds=YES;
    if (_timerCount<=0) {
        [_sureBt setTitle:@"开始答题" forState:UIControlStateNormal];
        _sureBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    }else{
        [_sureBt setTitle:@"请等待" forState:UIControlStateNormal];
        _sureBt.backgroundColor=[UIColor colorWithHexString:@"#999999"];
    }
    [_sureBt addTarget:self action:@selector(sureBtClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [_bottomImg addSubview:_sureBt];
}
#pragma mark---开始答题按钮点击
-(void)sureBtClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"开始答题"]) {
        NSLog(@"开始答题");
        
//        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken]};
//        [NetWorkingUtils postWithUrl:StartAnswer params:paraDic successResult:^(id response) {
//            if ([response[@"status"] integerValue]==1) {
        
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        PKDetailVC *detailVC = [[PKDetailVC alloc]init];
        PKDetailVC *detailVC = [[PKDetailVC alloc]initWith:_type];
        //end
        
                //解析qs.txt
                NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
                NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getPKID],@"txt/qs.txt"];


#pragma mark gd_修改获取资源包方式
        NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
        NSError *error;

//                NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//                NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//                
//                NSError *error;
//                NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (!firstDic) {
                    NSLog(@"%@",error);
                }
                NSArray *listArr = [firstDic valueForKey:@"datas"];
                //        for (int i=0; i<listArr.count; i++) {
                //            PassModel *model = [PassModel modelWithDic:listArr[0]];
                //
                //        }
                PassModel *model = [PassModel modelWithDic:listArr[0]];
                detailVC.timeStr = _dataDic[@"endTime"];
                detailVC.contestId = _dataDic[@"id"];
                detailVC.item =model;
                [self.navigationController pushViewController:detailVC animated:YES];
//            }
//        } errorResult:^(NSError *error) {
//            
//        }];
        
        
    }else{
        NSLog(@"请等待");
    }
}
#pragma mark---时间格式转化（int型转00:00）
-(NSString *)timeChange:(NSInteger)num
{
    //小时
    NSInteger hour=num/3600;
    //分钟数
    NSInteger min=(num%3600)/60;
    //秒数
    NSInteger sec=num%60;
    return [NSString stringWithFormat:@"%ld时%ld分%ld秒",hour,min,sec];
}
#pragma mark---获取当前时间与开始时间的时间差
-(NSTimeInterval)getCurrentTimeToStartTime:(id)timeStamp
{
    NSString*str= [NSString stringWithFormat:@"%@",timeStamp];//时间戳
    NSTimeInterval lateTimeInterval=[str doubleValue]/1000;
    //当前时间
    NSDate *nowDate=[NSDate date];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    //计算时间差
    NSTimeInterval resultTime =lateTimeInterval - nowTimeInterval ;
    return resultTime;
}
#pragma mark---改变字体
-(void)fontChange
{
    //改变字体
    NSMutableAttributedString *noteString=[[NSMutableAttributedString alloc]initWithString:_timeLb.text];
    NSRange range=NSMakeRange(2, 1);
    NSRange range1=NSMakeRange(5, 1);
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(40)] range:range];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(40)] range:range1];
    [_timeLb setAttributedText:noteString];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer=nil;
    
}



@end
