//
//  IntegralTaskVC.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "IntegralTaskVC.h"
#import "TaskCell.h"
//#import "PayChooseVC.h"

#import "CoinGetCell.h"

#import "LexiconViewController.h"
#import "RankContentVC.h"
#import "LuckyDrawViewController.h"
//#import "ReferralVC.h"
#import "ChooseResVC.h"
@interface IntegralTaskVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UILabel *titleLabel;
    UIView *littleWhiteV;
    UIButton *task;
    UIButton *takeRecords;
    UIButton *expenseRecords;
    UILabel *orangeLabel;
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *list;

@property (strong, nonatomic)  NSMutableArray *taskArray;
@property (strong, nonatomic)  NSMutableArray *coinGetArray;
@property (strong, nonatomic)  NSMutableArray *coinUseArray;

@end

@implementation IntegralTaskVC
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self addResCategory];
//    [self turnToTaskRes];
    [self addTableView];

    [self requestBuylist];
    [self addBuyButtons:nil];
    
    [self requestTask];
    [self requestCoinGetList];
    [self requestCoinUseList];
}

- (void)requestTask{
    [NetWorkingUtils postWithUrl:TaskList params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSArray *dataArr = [response valueForKey:@"data"];
            self.taskArray = [NSMutableArray array];
            for (NSDictionary * dict in dataArr) {
                TaskModel *model = [TaskModel taskModelWithTitle:dict[@"taskName"] AndNum:[NSString stringWithFormat:@"%@",dict[@"coins"]] AndIsDiam:YES AndIsComp:NO];
                [self.taskArray addObject:model];
            }
            self.list = [NSMutableArray arrayWithArray:self.taskArray];
            [self.tableView reloadData];
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)requestCoinGetList{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:CoinsGainsList parameters:parameters success:^(NSDictionary * dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            self.coinGetArray = [NSMutableArray array];
            NSArray *dataArr = [dictJSON valueForKey:@"data"];
            for (NSDictionary * dict in dataArr) {
                GetCoinModel *model = [GetCoinModel mj_objectWithKeyValues:dict];
                [self.coinGetArray addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestCoinUseList{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:CoinsUseHistoryList parameters:parameters success:^(NSDictionary * dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            self.coinUseArray = [NSMutableArray array];
            NSArray *dataArr = [dictJSON valueForKey:@"data"];
            for (NSDictionary * dict in dataArr) {
                GetCoinModel *model = [GetCoinModel mj_objectWithKeyValues:dict];
                [self.coinUseArray addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestBuylist{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    [LGDHttpTool POST:CoinsBuyList parameters:parameters success:^(id dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            [self addBuyButtons:dictJSON[@"data"]];
        }else{
            [MBProgressHUD showError: dictJSON[@"error"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取优钻购买列表失败,请检查网络"];
    }];
}

-(void)initNavi{
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    backImg.userInteractionEnabled = YES;
    
    [self.view addSubview:backImg];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"积分任务";
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
    
}
-(void)addResCategory{
    littleWhiteV = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(140), SCREEN_WIDTH-(AutoTrans(30))*2, AutoTrans(80))];
    littleWhiteV.tag = 0x1234;
    littleWhiteV.layer.masksToBounds = YES;
    littleWhiteV.layer.cornerRadius = AutoTrans(30);
    littleWhiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:littleWhiteV];
    
    task = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), 0, AutoTrans(120), AutoTrans(80))];
    task.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    [task setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [task setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [task setTitle:@"积分任务" forState:UIControlStateNormal];
    [task addTarget:self action:@selector(taskOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [littleWhiteV addSubview:task];
    
    takeRecords = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), 0, AutoTrans(120), AutoTrans(80))];
    takeRecords.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    takeRecords.center =CGPointMake(littleWhiteV.frame.size.width/2, AutoTrans(40));
    [takeRecords setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [takeRecords setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [takeRecords setTitle:@"获取记录" forState:UIControlStateNormal];
    [takeRecords addTarget:self action:@selector(takeRecordsOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleWhiteV addSubview:takeRecords];
    
    expenseRecords = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteV.frame.size.width-(AutoTrans(80))-(AutoTrans(120)), 0, AutoTrans(120), AutoTrans(80))];
    expenseRecords.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    [expenseRecords setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [expenseRecords setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [expenseRecords setTitle:@"消费记录" forState:UIControlStateNormal];
    [expenseRecords addTarget:self action:@selector(expenseRecordsOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleWhiteV addSubview:expenseRecords];
    
    orangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(120), AutoTrans(5))];
    orangeLabel.center = CGPointMake(task.center.x, littleWhiteV.frame.size.height-(AutoTrans(5))/2);
    orangeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffa200"];
    [littleWhiteV addSubview:orangeLabel];
}

-(void)addTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(littleWhiteV.frame)+(AutoTrans(20)), CGRectGetWidth(littleWhiteV.frame),AutoTrans(1050))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = AutoTrans(100);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = AutoTrans(40);
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[TaskCell class] forCellReuseIdentifier:NSStringFromClass([TaskModel class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CoinGetCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GetCoinModel class])];
}
-(void)addBuyButtons:(NSDictionary *)info{
//    UIButton *buy10 = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(97), CGRectGetMaxY(_tableView.frame)+(AutoTrans(40)), SCREEN_WIDTH-(AutoTrans(97))*2, AutoTrans(90))];
//    buy10.backgroundColor = [UIColor colorWithHexString:@"#20d393"];
//    buy10.layer.masksToBounds = YES;
//    buy10.layer.cornerRadius = AutoTrans(45);
//    [buy10 setTitle:@"购买10优钻" forState:UIControlStateNormal];
//    buy10.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(29)];
//    [buy10 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [self.view addSubview:buy10];
//    WS(weakSelf);
//    [buy10 tapBlock:^{
//        [weakSelf openPayPage:@{@"orderNo":@"123",@"money":@"123"}];
//    }];
//    
//    UIButton *buy50 = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(97), CGRectGetMaxY(buy10.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(97))*2, AutoTrans(90))];
//    buy50.backgroundColor = [UIColor colorWithHexString:@"#ff9154"];
//    buy50.layer.masksToBounds = YES;
//    buy50.layer.cornerRadius = AutoTrans(45);
//    [buy50 setTitle:@"购买50优钻" forState:UIControlStateNormal];
//    buy50.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(29)];
//    [buy50 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:buy50];
//
//    
//    UIButton *buy100 = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(97),  CGRectGetMaxY(buy50.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(97))*2, AutoTrans(90))];
//    buy100.backgroundColor = [UIColor colorWithHexString:@"#38b7e5"];
//    buy100.layer.masksToBounds = YES;
//    buy100.layer.cornerRadius = AutoTrans(45);
//    [buy100 setTitle:@"购买100优钻" forState:UIControlStateNormal];
//    buy100.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(29)];
//    [buy100 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:buy100];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    id model = self.list[indexPath.row];
    
    NSString *cellID2 = NSStringFromClass([model class]);
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.item = self.list[indexPath.row];
    
    
    if ([cell isKindOfClass:[TaskCell class]]) {
        WS(weakSelf);
        cell.tapblock = ^{
            [weakSelf tapGoToVC:((TaskModel *)model).title];
        };
    }
    
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.list.count;
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击前往
- (void)tapGoToVC:(NSString *)title{
    if ([title isEqualToString:@"闯关"]) {
        [self checkAndRequestWords];
    } else if ([title isEqualToString:@"PK"]) {
        RankContentVC * rankContent = [[RankContentVC alloc] init];
        rankContent.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankContent animated:YES];
    }else if ([title isEqualToString:@"抽奖"]) {
        
        
        LuckyDrawViewController * rankContent = [[LuckyDrawViewController alloc] init];
        rankContent.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rankContent animated:YES];
        
    }
    else if ([title isEqualToString:@"推荐码"]) {
        [MBProgressHUD showError:@"该功能暂未实现，请先选择其他方式"];
//        ReferralVC * rankContent = [[ReferralVC alloc] init];
//        rankContent.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:rankContent animated:YES];
    }
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
    
    
    
    
    
    
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && ![[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }else{
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && [[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
            
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
            [Utils unArchive:filePathzip andPassword:nil destinationPath:nil completionBlock:^{
                
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

#pragma mark - button点击
-(void)taskOnClick:(UIButton *)button{
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    takeRecords.selected = NO;
    expenseRecords.selected = NO;
    [self turnToTaskRes];
}
#pragma mark 点击积分任务
-(void)turnToTaskRes{
    [self.list removeAllObjects];
    self.list = [NSMutableArray arrayWithArray:self.taskArray];
    [self.tableView reloadData];
//    TaskModel *model1 = [[TaskModel alloc]init];
//    model1.title = @"每日登陆";
//    model1.num =@"1";
//    model1.isComplete = YES;
//    model1.isDiamond = YES;
//    
//    TaskModel *model2 = [TaskModel taskModelWithTitle:@"闯关" AndNum:@"2" AndIsDiam:YES AndIsComp:NO];
//    TaskModel *model3 = [TaskModel taskModelWithTitle:@"PK" AndNum:@"2" AndIsDiam:NO AndIsComp:NO];
//    TaskModel *model4 = [TaskModel taskModelWithTitle:@"抽奖" AndNum:@"2" AndIsDiam:NO AndIsComp:NO];
//    TaskModel *model5 = [TaskModel taskModelWithTitle:@"完善资料" AndNum:@"3" AndIsDiam:YES AndIsComp:NO];
//    
//    [self.list addObject:model1];
//    [self.list addObject:model2];
//    [self.list addObject:model3];
//    [self.list addObject:model4];
//    [self.list addObject:model5];

}
#pragma mark 点击获取记录
-(void)takeRecordsOnClick:(UIButton *)button{
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    task.selected = NO;
    expenseRecords.selected = NO;
    
    [self.list removeAllObjects];
    self.list = [NSMutableArray arrayWithArray:self.coinGetArray];
    [self.tableView reloadData];
}
#pragma mark 点击消费记录
-(void)expenseRecordsOnClick:(UIButton *)button{
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    task.selected = NO;
    takeRecords.selected = NO;
    
    [self.list removeAllObjects];
    self.list = [NSMutableArray arrayWithArray:self.coinUseArray];
    [self.tableView reloadData];
}

- (void)openPayPage:(NSDictionary*)dict{
    //    NSLog(@"%@",dict);
//    PayChooseVC *payVC = [[PayChooseVC alloc] init];
//    payVC.orderNo = dict[@"orderNo"];
//    payVC.money = dict[@"money"];
//    [self.navigationController pushViewController:payVC animated:YES];
}


@end
