//
//  ContestResultVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/6.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ContestResultVC.h"

#import "PKResultCell.h"
#import "PKResultModel.h"


#import "PKResultHeaderView.h"

@interface ContestResultVC ()<UITableViewDelegate,UITableViewDataSource>
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;

@property (strong, nonatomic)  NSArray *dataSource;

@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation ContestResultVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    //添加背景图
    [self addBackgroundView];
    //添加表头
    [self addTitleView];

    [self watchReportBtClick];

}

#pragma mark----查看比赛报告
-(void)watchReportBtClick
{

    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"contestId":self.contestId};
    [NetWorkingUtils postWithUrl:WatchRankInfo params:paraDic   successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {

            NSArray * data = response[@"data"];

            NSMutableArray * dataSource = [NSMutableArray array];
            NSString * mingci = nil;
            NSString * uZuan = nil;
            for ( int i = 0 ; i < data.count ;i++) {
                NSDictionary * dict  = data[i];
                PKResultModel * model = [PKResultModel mj_objectWithKeyValues:dict];
                [dataSource addObject:model];
                if ([model.username isEqualToString:[Utils getCurrentUserName]]) {
                    mingci = [NSString stringWithFormat:@"%d",i];
                    uZuan = model.coins;
                }
            }
            PKResultHeaderView * pkView = [PKResultHeaderView shareWith:uZuan Mingci:mingci];
            CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
            pkView.frame = frame;
            self.tableView.tableHeaderView = pkView;

            self.dataSource = [NSArray arrayWithArray:dataSource];
            [self.tableView reloadData];
        }else{
            [Utils showAlter:response[@"error"]];
        }

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
    [self.view sendSubviewToBack:backgroundImg];
}
#pragma mark---添加表头
-(void)addTitleView
{
    _titleView=[CustomTitleView customTitleView:@"比赛结果" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{

    }];
    
    [self.view addSubview:_titleView];
}



- (void)setUpTableView{
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
//    WS(weakSelf);
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
//    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = 64;
    frame.size.height -= 64;
    self.tableView.frame = frame;


    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
//    self.tableView.estimatedRowHeight = 100;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"PKResultCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PKResultModel class])];



    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];


}

#pragma mark TableView -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PKResultModel * model = self.dataSource[indexPath.row];
    PKResultCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([model class]) forIndexPath:indexPath];

    [cell setDataWithModel:model indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


#pragma mark TableView -- delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
