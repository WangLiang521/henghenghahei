//
//  ReportListVC.m
//  YouXingWords
//
//  Created by LDJ on 16/11/9.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ReportListVC.h"
#import "ReportWordCell.h"
@interface ReportListVC ()<UITableViewDelegate,UITableViewDataSource>
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//添加tableivew
@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSArray *listArr;
@end

@implementation ReportListVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self addBackgroundView];
    [self addTitleView];
    [self addMyTableView];
}
-(void)getData{
    if (self.isRight) {
        NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]]];
        BOOL isDir = YES;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *rightPath = [NSString stringWithFormat:@"%@/right.plist",Dir];
        NSString *wrongPath = [NSString stringWithFormat:@"%@/wrong.plist",Dir];
        NSArray * arrayRight = [NSArray arrayWithContentsOfFile:rightPath];

        NSMutableArray  * arrayShow = [NSMutableArray array];
        for (id object in arrayRight) {
            if (![arrayShow containsObject:object]) {
                [arrayShow addObject:object];
            }
        }
        _listArr = [NSArray arrayWithArray:arrayShow];
//        _listArr = [_listArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    }else{
        NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]]];
        BOOL isDir = YES;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *rightPath = [NSString stringWithFormat:@"%@/right.plist",Dir];
        NSString *wrongPath = [NSString stringWithFormat:@"%@/wrong.plist",Dir];
        NSArray * arrayWrong = [NSArray arrayWithContentsOfFile:wrongPath];

        NSMutableArray  * arrayShow = [NSMutableArray array];
        for (id object in arrayWrong) {
            if (![arrayShow containsObject:object]) {
                [arrayShow addObject:object];
            }
        }
        _listArr = [NSArray arrayWithArray:arrayShow];
    }
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
    NSString *title = @"错误单词";
    if (_isRight) {
        title = @"正确单词";
    }
    _titleView=[CustomTitleView customTitleView:title rightTitle:nil leftBtAction:^{
        //返回根目录
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加tableview
-(void)addMyTableView
{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(20),(AutoTrans(80))+30, SCREEN_WIDTH-(AutoTrans(40)),SCREEN_HEIGHT-(AutoTrans(170)))];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(20);
    [self.view addSubview:whiteView];
    
    
    
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30),(AutoTrans(90))+30, SCREEN_WIDTH-(AutoTrans(60)),SCREEN_HEIGHT-(AutoTrans(180))) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.backgroundColor = [UIColor whiteColor];
//    _myTableView.layer.masksToBounds = YES;
//    _myTableView.layer.cornerRadius = AutoTrans(30);
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
    _myTableView.showsVerticalScrollIndicator=NO;
    //    _myTableView.backgroundColor=[UIColor colorWithHexString:@"#f6fafc"];
    [self.view addSubview:_myTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellID = @"cell";
        ReportWordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ReportWordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor=[UIColor colorWithHexString:@"#f6fafc"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.block = ^( ){
                
            };
        }
    cell.isEven = indexPath.row%2==0;
    cell.isRight  = self.isRight;
    cell.word = [self.listArr[indexPath.row]valueForKey:@"word"];
    cell.explain = [self.listArr[indexPath.row]valueForKey:@"explain"];
    return cell;
        
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
