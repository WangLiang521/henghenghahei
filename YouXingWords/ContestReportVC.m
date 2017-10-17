//
//  ContestReportVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/4.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ContestReportVC.h"
#import "ContestResultVC.h"
#import "ReportListVC.h"
#import "PKResultModel.h"


@interface ContestReportVC ()
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//用时label
@property(nonatomic,retain)UILabel *timeLb;
//添加tableivew
@property(nonatomic,retain)UITableView *myTableView;
//底部图片
@property(nonatomic,retain)UIImageView *bottomImg;

@property (nonatomic,assign) BOOL canSelected;

//添加查看比赛结果按钮
@property(nonatomic,retain)UIButton *watchReportBt;

@end

@implementation ContestReportVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //将用时，正确个数，错误个数，添加到本地
    [self addLocalData];
    //添加背景图
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加正确错误题数
    [self addContestStateView];
    //添加底部图片
    [self addBottomImg];
    //添加tableview
//    [self addMyTableView];
    //添加查看报告按钮
//    [self addWatchReportBt];
}
#pragma mark---处理本地数据
-(void)addLocalData
{
    NSDictionary *dataDic=@{@"correctNum":[NSString stringWithFormat:@"%ld",self.correctNum],
                            @"wrongtNum":[NSString stringWithFormat:@"%ld",self.wrongtNum],
                            @"useTime":[NSString stringWithFormat:@"%ld",(NSInteger)self.useTime]};
    [[NSUserDefaults standardUserDefaults]setObject:dataDic forKey:[NSString stringWithFormat:@"%@_%@",[Utils getCurrentToken],self.contestId]];
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
    _titleView=[CustomTitleView customTitleView:@"答题报告" rightTitle:@"关闭" leftBtAction:^{
    } rightBtAction:^{
        //返回根目录
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    _titleView.leftBt.hidden=YES;
    [self.view addSubview:_titleView];
}
#pragma mark---添加正确错误题目状态数
-(void)addContestStateView
{
    //上面分割线
    UILabel *topLineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(_titleView.frame)+40, SCREEN_WIDTH-(AutoTrans(80)), 0.6)];
    topLineLb.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topLineLb];
    //正确label
    UILabel *correctLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLineLb.frame)+(AutoTrans(20)), SCREEN_WIDTH/2, AutoTrans(40))];
    correctLb.text=@"正确";
    correctLb.textColor=[UIColor colorWithHexString:@"#c5e7f2"];
    correctLb.textAlignment=NSTextAlignmentCenter;
    correctLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [self.view addSubview:correctLb];
    
    //错误label
    UILabel *errorLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(correctLb.frame), CGRectGetMinY(correctLb.frame), SCREEN_WIDTH/2, AutoTrans(40))];
    errorLb.text=@"错误";
    errorLb.textColor=[UIColor colorWithHexString:@"#c5e7f2"];
    errorLb.textAlignment=NSTextAlignmentCenter;
    errorLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [self.view addSubview:errorLb];
    //正确题数
    UILabel *correctCountLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(correctLb.frame), SCREEN_WIDTH/2, AutoTrans(240))];
    correctCountLb.text=[NSString stringWithFormat:@"%ld",self.correctNum];
    correctCountLb.textColor=[UIColor whiteColor];
    correctCountLb.textAlignment=NSTextAlignmentCenter;
    correctCountLb.font=[UIFont systemFontOfSize:AutoTrans(160)];
    correctCountLb.userInteractionEnabled=YES;
    [self.view addSubview:correctCountLb];
    //添加手势
    UITapGestureRecognizer *correctTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(correctTap)];
    [correctCountLb addGestureRecognizer:correctTap];
    
    //分割线
    UILabel *lineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(correctCountLb.frame), CGRectGetMinY(correctCountLb.frame), 0.6, CGRectGetHeight(correctCountLb.frame))];
    lineLb.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lineLb];
    //错误题数
    UILabel *errorCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(correctCountLb.frame), CGRectGetMinY(correctCountLb.frame), SCREEN_WIDTH/2, CGRectGetHeight(correctCountLb.frame))];
    errorCountLb.text=[NSString stringWithFormat:@"%ld",self.wrongtNum];
    errorCountLb.textColor=[UIColor colorWithHexString:@"#f76262"];
    errorCountLb.textAlignment=NSTextAlignmentCenter;
    errorCountLb.font=[UIFont systemFontOfSize:AutoTrans(160)];
    errorCountLb.userInteractionEnabled=YES;
    [self.view addSubview:errorCountLb];
    //添加手势
    UITapGestureRecognizer *errorTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorTap)];
    [errorCountLb addGestureRecognizer:errorTap];
    //题目label
    UILabel *tLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(correctCountLb.frame), SCREEN_WIDTH/2, AutoTrans(40))];
    tLb.text=@"题";
    tLb.textColor=[UIColor colorWithHexString:@"#c5e7f2"];
    tLb.textAlignment=NSTextAlignmentCenter;
    tLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [self.view addSubview:tLb];
    //题目label1
    UILabel *tLb1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(errorCountLb.frame), SCREEN_WIDTH/2, AutoTrans(40))];
    tLb1.text=@"题";
    tLb1.textColor=[UIColor colorWithHexString:@"#c5e7f2"];
    tLb1.textAlignment=NSTextAlignmentCenter;
    tLb1.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [self.view addSubview:tLb1];
    //下面分割线
    UILabel *bottomLineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(tLb1.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(80)), 0.6)];
    bottomLineLb.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomLineLb];
    //用时label
    _timeLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, CGRectGetMaxY(bottomLineLb.frame)+40, 120, AutoTrans(80))];
    _timeLb.text=[NSString stringWithFormat:@"用时:%ld秒",(NSInteger)self.useTime];
    _timeLb.textColor=[UIColor whiteColor];
    _timeLb.textAlignment=NSTextAlignmentCenter;
    _timeLb.layer.cornerRadius=CGRectGetHeight(_timeLb.frame)/2;
    _timeLb.layer.masksToBounds=YES;
    _timeLb.layer.borderColor=[UIColor whiteColor].CGColor;
    _timeLb.layer.borderWidth=0.8;
    _timeLb.font=[UIFont systemFontOfSize:AutoTrans(35)];
    [self.view addSubview:_timeLb];
}
#pragma mark---正确label点击
-(void)correctTap
{
    ReportListVC *reportList=[[ReportListVC alloc]init];
    reportList.isRight=YES;
    [self.navigationController pushViewController:reportList animated:YES];
}
#pragma mark---错误label点击
-(void)errorTap
{
    ReportListVC *reportList=[[ReportListVC alloc]init];
    reportList.isRight=NO;
    [self.navigationController pushViewController:reportList animated:YES];
}


#pragma mark---添加底部view
-(void)addBottomImg
{
    _bottomImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH,SCREEN_HEIGHT-150)];
    _bottomImg.image=[UIImage imageNamed:@"bg_bolang"];
    _bottomImg.userInteractionEnabled=YES;
    [self.view addSubview:_bottomImg];
    //查看比赛结果按钮
    _watchReportBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(100), SCREEN_HEIGHT-(AutoTrans(180)), SCREEN_WIDTH-(AutoTrans(200)), AutoTrans(90))];
    _watchReportBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    _watchReportBt.layer.cornerRadius=CGRectGetHeight(_watchReportBt.frame)/2;
    _watchReportBt.layer.masksToBounds=YES;
    [_watchReportBt setTitle:@"查看比赛结果" forState:UIControlStateNormal];
    [_watchReportBt addTarget:self action:@selector(watchReportBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_watchReportBt];
    //比赛结束倒计时
    UILabel *endTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_watchReportBt.frame)-(AutoTrans(90)), SCREEN_WIDTH, AutoTrans(90))];
//    endTimeLb.text=[NSString stringWithFormat:@"距离比赛结束还有%@分钟",[self getCurrentTimeToStartTime]];
    endTimeLb.text=@"比赛已经结束";
    endTimeLb.textColor=[UIColor colorWithHexString:@"#666666"];
    endTimeLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    endTimeLb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:endTimeLb];
    //改变字体
    NSMutableAttributedString *noteString=[[NSMutableAttributedString alloc]initWithString:endTimeLb.text];
//    NSRange range=NSMakeRange(8, [self getCurrentTimeToStartTime].length);
//    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(50)] range:range];
//    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.329 green:0.733 blue:0.831 alpha:1.000] range:range];
    [endTimeLb setAttributedText:noteString];

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
#pragma mark---时间转换
-(NSString *)getCurrentTimeToStartTime
{
    //擂台赛结束时间时间戳
    NSString *endTime=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"endTime%@",self.contestId]];
    //当前时间
    NSDate *nowDate=[NSDate date];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    //计算时间差
    NSTimeInterval resultTime =[endTime integerValue]/1000-nowTimeInterval ;
    //分钟数
    NSInteger min=resultTime/60;
    
    return [NSString stringWithFormat:@"%ld",min];
    
}
#pragma mark----查看比赛报告
-(void)watchReportBtClick
{
    ContestResultVC *contestResult=[[ContestResultVC alloc]init];
//    [contestResult setTableViewDataSource:[NSArray arrayWithArray:dataSource]];
    contestResult.contestId = self.contestId;
    [self.navigationController pushViewController:contestResult animated:YES];
//    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"contestId":self.contestId};
//    [NetWorkingUtils postWithUrl:WatchRankInfo params:paraDic   successResult:^(id response) {
//        if ([response[@"status"] integerValue]==1) {
//
//            NSArray * data = response[@"data"];
//
//            NSMutableArray * dataSource = [NSMutableArray array];
//            for (NSDictionary * dict in data) {
//                PKResultModel * model = [PKResultModel mj_objectWithKeyValues:dict];
//                [dataSource addObject:model];
//            }
////            [Utils showAlter:@"功能完善中..."];
//
//            ContestResultVC *contestResult=[[ContestResultVC alloc]init];
//
//            [self.navigationController pushViewController:contestResult animated:YES];
//        }else{
//            [Utils showAlter:response[@"error"]];
//        }
//        
//    } errorResult:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
}



@end
