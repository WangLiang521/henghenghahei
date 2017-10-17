//
//  ContestVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/22.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ContestVC.h"
#import "WaitStartVC.h"
#import <SVProgressHUD.h>
#import "SARUnArchiveANY.h"
#import "ContestReportVC.h"
#import "ContestResultVC.h"
@interface ContestVC ()<UIAlertViewDelegate>
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//滑动视图
@property(nonatomic,retain)UIScrollView *myScrollView;
@property(nonatomic,retain)UIView *contestView;//比赛的view
//数据源
@property(nonatomic,copy)NSArray *dataArr;
@property(nonatomic,copy)NSArray *contentArr;
//
//@property (nonatomic,copy)NSString *resID;

@property (assign, nonatomic)  BreakthroughType type;

@end

@implementation ContestVC
-(NSArray *)rankImgArr
{
    NSArray *arr=@[@"icon_one",@"icon_two",@"icon_three"];
    return arr;
}

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
    
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
 
    //添加网络数据
    [self addNetData];

}
#pragma mark---添加网络数据
-(void)addNetData
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken]};
    [NetWorkingUtils postWithUrl:GetJoinContestList params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        _dataArr=response[@"data"];
        
        //添加滑动视图
        [self addMyScrollView];

    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
    WS(weakSelf);
//    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(weakSelf);
//    }];
}
#pragma mark---添加表头
-(void)addTitleView
{
    _titleView=[CustomTitleView customTitleView:@"竞技场" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---滑动视图
-(void)addMyScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-30-(AutoTrans(80)))];
    _myScrollView.bounces=NO;
    _myScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_myScrollView];
    //添加比赛的view
    //宽度
    CGFloat contestViewWidth=SCREEN_WIDTH-(AutoTrans(40))*2;
    //高度
    CGFloat contestViewHeight=300;
    for (int i=0;i<_dataArr.count;i++) {
        NSString *str=[NSString stringWithFormat:@"组织机构: %@",_dataArr[i][@"fromSourceName"]];
        NSString *str1=[NSString stringWithFormat:@"参赛资格: %@",_dataArr[i][@"qualification"]];
        NSString *str2=[NSString stringWithFormat:@"奖励规则: 前3名%@个优钻,4-10名%@个优钻",_dataArr[i][@"firstNum"],_dataArr[i][@"fourthToTen"]];
        _contentArr=@[str,str1,str2];
        
        
        _contestView=[[UIView alloc]initWithFrame:CGRectMake(AutoTrans(40), 10+(contestViewHeight+(AutoTrans(20)))*i, contestViewWidth, contestViewHeight)];
        _contestView.backgroundColor=[UIColor whiteColor];
        _contestView.layer.cornerRadius=CGRectGetWidth(_contestView.frame)/16;
        _contestView.layer.masksToBounds=YES;
        [_myScrollView addSubview:_contestView];
        //比赛名称
        UILabel *contestName=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(20), SCREEN_WIDTH/2-30, AutoTrans(50))];
        contestName.text=_dataArr[i][@"name"];
        contestName.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [_contestView addSubview:contestName];
        //时间
        UILabel *timeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_contestView.frame)-20-120, CGRectGetMinY(contestName.frame), 120, CGRectGetHeight(contestName.frame))];
        timeLb.text=[NSString stringWithFormat:@"%@开战",[Utils timeByTimeStamp:_dataArr[i][@"startTime"]]];
        timeLb.font=[UIFont systemFontOfSize:AutoTrans(25)];
        timeLb.textAlignment=NSTextAlignmentRight;
        timeLb.textColor=[UIColor colorWithHexString:@"#333333"];
        //start
#pragma mark gd_时间显示不全  2017-06-06 14:51:00
        [timeLb sizeToFit];
        //end
        [_contestView addSubview:timeLb];
        //表的图片
//        UIImageView *alarmImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeLb.frame)-CGRectGetHeight(timeLb.frame)+(AutoTrans(10))*2, CGRectGetMinY(timeLb.frame)+(AutoTrans(10)),CGRectGetHeight(timeLb.frame)-(AutoTrans(10))*2,CGRectGetHeight(timeLb.frame)-(AutoTrans(10))*2)];
        UIImageView *alarmImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeLb.frame)-CGRectGetHeight(timeLb.frame)+(AutoTrans(10))*2 - 10, CGRectGetMinY(timeLb.frame)+(AutoTrans(10)),(AutoTrans(10))*2,(AutoTrans(10))*2)];
        alarmImg.image=[UIImage imageNamed:@"icon_time"];
        [_contestView addSubview:alarmImg];
        //虚线
        UILabel *lineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(25), CGRectGetMaxY(contestName.frame)+(AutoTrans(20)), CGRectGetWidth(_contestView.frame)-(AutoTrans(25))*2, 0.8)];
        lineLb.backgroundColor=[UIColor colorWithHexString:@"#eeeeee"];
        [_contestView addSubview:lineLb];
        //组织机构，参赛资格，奖励规则
        UIImageView *rankImg;
        for (int i=0; i<3; i++) {
            //排行图标
            //start
#pragma mark gd_修改 UI  2017-06-07 10:33:06
            //            rankImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(60), CGRectGetMaxY(lineLb.frame)+(AutoTrans(50))+((AutoTrans(40)+(AutoTrans(45)))*i), AutoTrans(40), AutoTrans(40))];
            CGFloat y = CGRectGetMaxY(lineLb.frame)+(AutoTrans(20))+((AutoTrans(40))+(AutoTrans(15)))*i;
            rankImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(60), y, AutoTrans(40), AutoTrans(40))];
            //end
            rankImg.layer.cornerRadius=CGRectGetWidth(rankImg.frame)/2;
            rankImg.layer.masksToBounds=YES;
            rankImg.image=[UIImage imageNamed:self.rankImgArr[i]];
            [_contestView addSubview:rankImg];
            //组织机构，参赛资格，奖励规则
            UILabel *contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rankImg.frame)+5, CGRectGetMinY(rankImg.frame), CGRectGetWidth(_contestView.frame)-CGRectGetMaxX(rankImg.frame), CGRectGetHeight(rankImg.frame))];
            contentLb.text=_contentArr[i];
            contentLb.textColor=[UIColor colorWithHexString:@"#666666"];
            contentLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
            [_contestView addSubview:contentLb];
        }
        //报名按钮
        UIButton *joinContestBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(60), CGRectGetMaxY(rankImg.frame)+(AutoTrans(40)), CGRectGetWidth(_contestView.frame)-(AutoTrans(120)), AutoTrans(80))];
        joinContestBt.backgroundColor=[UIColor colorWithHexString:@"#7bcff0"];
        joinContestBt.layer.cornerRadius=CGRectGetHeight(joinContestBt.frame)/2;
        joinContestBt.layer.masksToBounds=YES;
        //未报名
        if ([_dataArr[i][@"isSign"] integerValue]==0) {
            [joinContestBt setTitle:@"报名入场" forState:UIControlStateNormal];
        }else{
            //报名未提交
            if ([_dataArr[i][@"isSubmit"] integerValue]==0) {
                [joinContestBt setTitle:@"已报名(开始答题)" forState:UIControlStateNormal];
            //报名并提交
            }else{
                [joinContestBt setTitle:@"已提交(查看答题报告)" forState:UIControlStateNormal];
            }
        }
        
        
        
        joinContestBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(40)];
        [joinContestBt addTarget:self action:@selector(joinContestBtClick:) forControlEvents:UIControlEventTouchUpInside];
        joinContestBt.tag=555+i;
        
        //当前时间
        NSDate *nowDate=[NSDate date];
        NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970]*1000;
        //截止报名时间
        NSTimeInterval signUpDeadline=[_dataArr[i][@"signUpDeadline"] integerValue];
        //是否过了报名截止时间
        if (signUpDeadline<=nowTimeInterval) {
            joinContestBt.enabled = NO;
            [joinContestBt setTitle:@"报名已截止" forState:UIControlStateNormal];
            [joinContestBt setBackgroundColor:[UIColor lightTextColor]];
        }
            
            
        [_contestView addSubview:joinContestBt];
        //报名人数
        UILabel *enterNum=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(joinContestBt.frame)+(AutoTrans(20)), CGRectGetWidth(_contestView.frame), AutoTrans(40))];
        enterNum.textColor=[UIColor colorWithHexString:@"#666666"];
        enterNum.textAlignment=NSTextAlignmentCenter;
        enterNum.text=[NSString stringWithFormat:@"已有%@人报名",_dataArr[i][@"currSignNum"]];
        enterNum.font=[UIFont systemFontOfSize:AutoTrans(36)];
        [_contestView addSubview:enterNum];
        //重写view
        _contestView.frame=CGRectMake(AutoTrans(40), 10+(CGRectGetMaxY(enterNum.frame)+(AutoTrans(60)))*i, contestViewWidth, CGRectGetMaxY(enterNum.frame)+(AutoTrans(30)));
    }
    //_myScrollView的contentsize
    _myScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(_contestView.frame)+(AutoTrans(30)));
}
#pragma mark---报名按钮点击
-(void)joinContestBtClick:(UIButton *)sender
{
    //记录一下擂台赛截止时间
    [[NSUserDefaults standardUserDefaults]setObject:_dataArr[sender.tag-555][@"endTime"] forKey:[NSString stringWithFormat:@"endTime%@",_dataArr[sender.tag-555][@"id"]]];
    //未参赛
    if ([sender.titleLabel.text isEqualToString:@"报名入场"]) {
        //当前时间
        NSDate *nowDate=[NSDate date];
        NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970]*1000;
        //截止报名时间
        NSTimeInterval signUpDeadline=[_dataArr[sender.tag-555][@"signUpDeadline"] integerValue];
        //是否过了报名截止时间
        if (signUpDeadline<=nowTimeInterval) {
            [Utils showAlter:@"已超过报名截止时间,停止报名"];
        }else{
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定参加此次比赛并下载比赛题目吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.tag=sender.tag+555;
            [alterView show];
        }
    }else{
        //参赛未提交
        if ([sender.titleLabel.text isEqualToString:@"已报名(开始答题)"]) {
            //判断一下是否存在本地数据
            NSString *strPKRes = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getPKID]];
            NSString *filePathBasePKRes = [NSHomeDirectory() stringByAppendingPathComponent:strPKRes];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePathBasePKRes]){
//            if ([[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@_%@",_dataArr[sender.tag-555][@"id"],[Utils getCurrentToken]]] isEqualToString:@"loadSuccess"]){
               //有数据包直接跳转
                NSNumber *pkID =_dataArr[sender.tag-555][@"createTim"];
                [AnswerTools setPKID:pkID];
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                WaitStartVC *waitStart=[[WaitStartVC alloc]init];
                WaitStartVC *waitStart=[[WaitStartVC alloc]initWith:_type];
                //end
                
                waitStart.dataDic=_dataArr[sender.tag-555];
                [self.navigationController pushViewController:waitStart animated:YES];
            }else{
                //创建文件
                NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]]];
                BOOL isDir = YES;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
                if ( !(isDir == YES && existed == YES) )
                {
                    [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
                }
                //设置模式为进度框形的
                __block MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.dimBackground = YES;
                HUD.labelText =@"下载中...";
                HUD.mode=MBProgressHUDModeDeterminate;
                [HUD show:YES ];
                
                //开始下载
                //start
#pragma mark gd_后台给加了http:// 前台不用再添加了  2017-06-07 21:21:49
                //                NSString *urlStr=[NSString stringWithFormat:@"http://%@.%@",_dataArr[sender.tag-555][@"resourceUrl"],ArchiveType];
                NSString *urlStr=[NSString stringWithFormat:@"%@.%@",_dataArr[sender.tag-555][@"resourceUrl"],ArchiveType];
                //end
                [NetWorkingUtils getRarWithUrl:urlStr params:nil progressResult:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HUD.progress = [response fractionCompleted];
                    });
                    
                } successResult:^(id response) {
//                    self.resID = @"1478139066246";
                    NSNumber *pkID =_dataArr[sender.tag-555][@"createTim"];
                    [AnswerTools setPKID:pkID];
                    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getPKID],ArchiveType];
                    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
                    [(NSData*)response writeToFile:filePath atomically:NO];
                    HUD.labelText =@"解压中...";
                    [HUD hide:YES afterDelay:2];
                    NSString *str2 = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getPKID]];
                    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str2];
//                    [self unArchive:filePath andPassword:nil destinationPath:nil];
                    NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                    NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
                    [Utils unArchive:filePath andPassword:nil destinationPath:filePathDest completionBlock:^{
                        
                    } failureBlock:^{
                        
                    }];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSNumber *pkID1 =_dataArr[sender.tag-555][@"createTim"];
                        [AnswerTools setPKID:pkID1];
                        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                        //                WaitStartVC *waitStart=[[WaitStartVC alloc]init];
                        WaitStartVC *waitStart=[[WaitStartVC alloc]initWith:_type];
                        //end
                        waitStart.dataDic=_dataArr[sender.tag-555];
                        [self.navigationController pushViewController:waitStart animated:YES];
                    });
                } errorResult:^(NSError *error) {
                    NSLog(@"--------%@",error);
                    [HUD hide:YES];
                    [SVProgressHUD showErrorWithStatus:@"请求失败"];
                }];
            }

        //参赛并提交查看答题报告
        }else{
            //获取缓存数据
            NSDictionary *localDic=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@_%@",[Utils getCurrentToken],_dataArr[sender.tag-555][@"id"]]];
            //跳转到
            ContestReportVC *contestReport=[[ContestReportVC alloc]init];
            contestReport.hidesBottomBarWhenPushed=YES;
            contestReport.correctNum=[localDic[@"correctNum"] integerValue];
            contestReport.wrongtNum=[localDic[@"wrongtNum"] integerValue];
            contestReport.useTime=[localDic[@"useTime"] integerValue];
            contestReport.contestId=_dataArr[sender.tag-555][@"id"];
            [self.navigationController pushViewController:contestReport animated:YES];
        }
    }
}
- (void)checkAndDownloadRes{
    
}

#pragma mark---alterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"取消");
        }
            break;
        case 1:{
            //报名
            NSString *contestIdStr=_dataArr[alertView.tag-555-555][@"id"];
            NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"contestId":contestIdStr};
            [NetWorkingUtils postWithUrl:JoinContest params:paraDic successResult:^(id response) {
                NSLog(@"response = %@",response);
                //报名成功之后下载文件
                if ([response[@"status"] integerValue]==1) {
                    //创建文件
                    NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]]];
                    BOOL isDir = YES;
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
                    if ( !(isDir == YES && existed == YES) )
                    {
                        [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    //设置模式为进度框形的
                    __block MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.dimBackground = YES;
                    HUD.labelText =@"下载中...";
                    HUD.mode=MBProgressHUDModeDeterminate;
                    [HUD show:YES ];

                    //开始下载
                    NSString *urlStr=[NSString stringWithFormat:@"%@.%@",_dataArr[alertView.tag-555-555][@"resourceUrl"],ArchiveType];
                    [NetWorkingUtils getRarWithUrl:urlStr params:nil progressResult:^(id response) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HUD.progress = [response fractionCompleted];
                        });
                        
                    } successResult:^(id response) {
                        
//                        self.resID = @"1478139066246";
                        NSNumber *pkID =_dataArr[alertView.tag-555-555][@"createTim"];
                        [AnswerTools setPKID:pkID];
                        //                    [AnswerTools setBookID:bookid];
                        NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getPKID],ArchiveType];
                        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
                        [(NSData*)response writeToFile:filePath atomically:NO];
                        
                        HUD.labelText =@"解压中...";
                        [HUD hide:YES afterDelay:2];
                        NSString *str2 = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getPKID]];
                        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str2];
//                        [self unArchive:filePath andPassword:nil destinationPath:nil];
                        
                        NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                        NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
                        [Utils unArchive:filePath andPassword:nil destinationPath:filePathDest completionBlock:^{
                            
                        } failureBlock:^{
                            
                        }];
                        
                        //记录下载成功
                        [[NSUserDefaults standardUserDefaults]setObject:@"loadSuccess" forKey:[NSString stringWithFormat:@"%@_%@",contestIdStr,[Utils getCurrentToken]]];

                        
                        //下载完成后改变按钮名称
                        UIButton *button=(UIButton *)[self.view viewWithTag:alertView.tag-555];
                        [button setTitle:@"已报名(开始答题)" forState:UIControlStateNormal];
                        
                    } errorResult:^(NSError *error) {
                        NSLog(@"--------%@",error);
                        
                        [HUD hide:YES];
                        
                        [SVProgressHUD showErrorWithStatus:@"请求失败"];
                    }];
                }else{
                    [Utils showAlter:response[@"error"]];
                }
            } errorResult:^(NSError *error) {
                NSLog(@"error = %@",error.localizedDescription);
            }];

            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 解压缩
- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
            NSLog(@"US Presidents app is installed.");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
        }
        
        for (NSString *filename in filePaths) {
            //NSLog(@"File: %@", filename);
        }
    };
    unarchive.failureBlock = ^(){
        //        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
}

@end
