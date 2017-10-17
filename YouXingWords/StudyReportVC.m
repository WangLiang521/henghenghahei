//
//  StudyReportVC.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "StudyReportVC.h"
#import "StudyReportCell.h"
@interface StudyReportVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UIView *littleWhiteV;
    UIButton *grade;
    UIButton *course;
    UIButton *whoButton;
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *list;
@end

@implementation StudyReportVC

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
    [self addCategory];
    [self addTableView];
    // Do any additional setup after loading the view.
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
    titleLabel.text = @"学习报告";
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
-(void)addCategory{
    littleWhiteV = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(140), SCREEN_WIDTH-(AutoTrans(30))*2, AutoTrans(80))];
    littleWhiteV.tag = 0x1234;
    littleWhiteV.layer.masksToBounds = YES;
    littleWhiteV.layer.cornerRadius = AutoTrans(30);
    littleWhiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:littleWhiteV];
    CGFloat littleWhiteWidth =SCREEN_WIDTH-(AutoTrans(30))*2;
    grade = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteWidth/6-(AutoTrans(50)), 0, AutoTrans(100), AutoTrans(80))];
    [grade setTitle:@"年级" forState:UIControlStateNormal];
    grade.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
    [grade setTitleColor:[UIColor colorWithHexString:@"#35b6e6"] forState:UIControlStateNormal];
    [grade setImage:[UIImage imageNamed:@"icon_lowertriangular_blue"] forState:UIControlStateNormal];
    [grade addTarget:self action:@selector(gradeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [grade setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(60), 0, -(AutoTrans(60)))];
    [grade setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [littleWhiteV addSubview:grade];
    
    
    course = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteWidth*3/6-(AutoTrans(50)), 0, AutoTrans(100), AutoTrans(80))];
    [course setTitle:@"教材" forState:UIControlStateNormal];
    course.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
    [course setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [course setImage:[UIImage imageNamed:@"icon_lowertriangular_gray"] forState:UIControlStateNormal];
    [course addTarget:self action:@selector(courseButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [course setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(60), 0, -(AutoTrans(60)))];
    [course setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [littleWhiteV addSubview:course];
    
    
    
    
    whoButton = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteWidth*5/6-(AutoTrans(50)), 0, AutoTrans(100), AutoTrans(80))];
    [whoButton setTitle:@"Who" forState:UIControlStateNormal];
    whoButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
    [whoButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [whoButton setImage:[UIImage imageNamed:@"icon_lowertriangular_gray"] forState:UIControlStateNormal];
    [whoButton addTarget:self action:@selector(whoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whoButton setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(60), 0, -(AutoTrans(60)))];
    [whoButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [littleWhiteV addSubview:whoButton];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, AutoTrans(48))];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    line.center = CGPointMake(littleWhiteV.frame.size.width*1/3, littleWhiteV.frame.size.height/2);
    [littleWhiteV addSubview:line];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, AutoTrans(48))];
    line2.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    line2.center = CGPointMake(littleWhiteV.frame.size.width*2/3, littleWhiteV.frame.size.height/2);
    [littleWhiteV addSubview:line2];
    
}
-(void)addTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(littleWhiteV.frame)+(AutoTrans(20)), CGRectGetWidth(littleWhiteV.frame), SCREEN_HEIGHT-CGRectGetMaxY(littleWhiteV.frame)-(AutoTrans(60))-(AutoTrans(20)))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = AutoTrans(40);
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID2 = @"StudyReportCell";
    StudyReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (!cell) {
        cell = [[StudyReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            cell.block = ^( ){
        //                ((QsModel *)self.list[indexPath.row]).isSelected = !((QsModel *)self.list[indexPath.row]).isSelected;
        //            };
    }
    cell.item = self.list[indexPath.row];
    
    
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

-(void)gradeButtonOnClick:(UIButton *)button{
    
}
-(void)courseButtonOnClick:(UIButton *)button{
    
}
-(void)whoButtonOnClick:(UIButton*)button{
    
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
