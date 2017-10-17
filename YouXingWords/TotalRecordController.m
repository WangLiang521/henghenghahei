//
//  TotalRecordController.m
//  YouXingWords
//
//  Created by wangliang on 2016/12/28.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TotalRecordController.h"
#import "TotalRecordView.h"
#import "TotalRecodTableCell.h"
#import "TotalDetailModel.h"

@interface TotalRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgImage;
    UITableView *_tableView;
}
//自定义导航栏
@property (strong, nonatomic)  CustomTitleView *customTitleView;
//弧形View
@property (strong, nonatomic)  UILabel * victory;
@property (strong, nonatomic)  UILabel * failure;
@property (strong, nonatomic)  UILabel * adraw;
@property(nonatomic,retain)UIImageView *iconImg;//头像img
@property(nonatomic,retain)UILabel *mainNameLb;//名称
@property (strong, nonatomic)  NSMutableArray *dataList;
@end

@implementation TotalRecordController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

-(NSArray *)colorArr
{
    NSArray *arr=@[@"#db4213",@"#78b9f9",@"#ffba00"];
    return arr;
}
-(NSArray *)recordArr
{
    NSArray *arr=@[@"胜",@"平",@"负"];
    return  arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImage.userInteractionEnabled = YES;
    bgImage.image = [UIImage imageNamed:@"bg_zongzhanji"];

    [self loadData];
    [self.view addSubview:bgImage];

    [self addCustomTitleView];
    //添加总战绩弧形view
    [self addTotalRecordView];

}

- (void)loadData{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"timeStatmped":@0};
    [NetWorkingUtils postWithUrl:TotleRecodePK params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);

        if ([response[@"status"]isEqual:@1]) {
            NSArray *data = response[@"data"];

            for (NSDictionary *dic in data) {
                TotalDetailModel *model = [TotalDetailModel mj_objectWithKeyValues:dic];
                [self.dataList addObject:model];
            }

            NSString *record1 = [NSString stringWithFormat:@"%@ 胜",response[@"winCounts"]];

            NSString *record2 = [NSString stringWithFormat:@"%@ 负",response[@"loseCounts"]];
            NSString *record3 = [NSString stringWithFormat:@"%@ 平",response[@"equalCounts"]];
            //大字体
            NSMutableAttributedString *noteString1 = [[NSMutableAttributedString alloc] initWithString:record1];
            NSRange stringRange = NSMakeRange(0, noteString1.length-1); //该字符串的位置
            [noteString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 weight:1.2] range:stringRange];
            [self.victory setAttributedText: noteString1];

            //大字体
            NSMutableAttributedString *noteString2 = [[NSMutableAttributedString alloc] initWithString:record2];
            NSRange stringRange2 = NSMakeRange(0, noteString2.length-1); //该字符串的位置
            [noteString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 weight:1.2] range:stringRange2];
            [self.failure setAttributedText: noteString2];

            //大字体
            NSMutableAttributedString *noteString3 = [[NSMutableAttributedString alloc] initWithString:record3];
            NSRange stringRange3 = NSMakeRange(0, noteString3.length-1); //该字符串的位置
            [noteString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 weight:1.2] range:stringRange3];
            [self.adraw setAttributedText: noteString3];

            [_tableView reloadData];
        }

    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark---自定义导航栏
-(void)addCustomTitleView
{
    _customTitleView=[CustomTitleView customTitleView:@"总战绩" rightTitle:@"" leftBtAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{

    }];
    [self.view addSubview:_customTitleView];
}
#pragma mark---添加总战绩弧形view
-(void)addTotalRecordView
{
    
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    //头像背景
    UIView *iconBgView = [[UIView alloc] init];
    iconBgView.layer.cornerRadius = 40;
    iconBgView.layer.masksToBounds = YES;
    iconBgView.backgroundColor = [UIColor colorWithRed:0.107 green:0.593 blue:0.808 alpha:1.000];
    [bgImage addSubview:iconBgView];
    [iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage.mas_centerX);
        make.top.mas_equalTo(bgImage.frame.size.height*140/667-40);
        make.size.mas_equalTo(CGSizeMake(82, 82));
    }];

    //头像img
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 76.5, 76.5)];
//    _iconImg.image=[UIImage imageNamed:@"icon_me"];
    _iconImg.layer.cornerRadius=37;
    _iconImg.layer.masksToBounds=YES;
    [iconBgView addSubview:_iconImg];
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:userInfo[@"signPhoto"]] placeholderImage:[UIImage imageNamed:DefaultUserHeadImg]];
    

    //名称
    _mainNameLb = [[UILabel alloc] init];
    _mainNameLb.text=[LGDUtils isValidStr:userInfo[@"name"]]?userInfo[@"name"]:@"";
    _mainNameLb.textAlignment=NSTextAlignmentCenter;
    _mainNameLb.font=[UIFont systemFontOfSize:15];
    [bgImage addSubview:_mainNameLb];

    [_mainNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconBgView.mas_bottom).offset(7.5);
        make.left.equalTo(bgImage).offset(100);
        make.right.equalTo(bgImage).offset(-100);
        make.height.equalTo(@16);
    }];

    CGFloat recordLWidth = (SCREEN_WIDTH-80)/3;
    for (int i = 0; i < 3; i++) {
        UILabel *record = [[UILabel alloc] init];
        record.backgroundColor = [UIColor colorWithHexString:self.colorArr[i]];
        record.layer.cornerRadius = 21;
        record.layer.masksToBounds=YES;
        record.textAlignment=NSTextAlignmentCenter;
        record.textColor=[UIColor whiteColor];
        record.font=[UIFont systemFontOfSize:17.5];
        record.text=[NSString stringWithFormat:@"0 %@",self.recordArr[i]];
        [bgImage addSubview:record];

        [record mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mainNameLb.mas_bottom).offset(11);
            make.left.equalTo(bgImage).offset(30+(recordLWidth+10)*i);
            make.size.mas_equalTo(CGSizeMake(recordLWidth, 42));
        }];

        if (i == 0) {
            self.victory = record;
        }
        if (i == 1) {
            self.adraw = record;
        }
        if (i == 2) {
            self.failure = record;
        }
    }

    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgImage addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.victory.mas_bottom).offset(15);
        make.left.equalTo(bgImage).offset(10);
        make.right.equalTo(bgImage).offset(-10);
        make.bottom.equalTo(bgImage).offset(-15);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TotalRecodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if (!cell) {
        cell = [[TotalRecodTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recordCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    TotalDetailModel *model = _dataList[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    return footView;
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
