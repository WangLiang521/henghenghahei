//
//  NotebookVC.m
//  YouXingWords
//
//  Created by LDJ on 16/10/8.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NotebookVC.h"
#import "NotebookCell.h"

#define CURRENT_NOTEBOOK_ID @"noteBookid"
@interface NotebookVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UIView *littleWhiteV;
    UIButton *grade;
    UIButton *course;
    
    UITableView *gradeTable;
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,assign)NSInteger indexPage;
@property (nonatomic,retain)NSNumber* bookId;

@property (nonatomic,retain)NSMutableArray *gradeList;//年级 里面是字典  字典keys grade，books（数组）
@property (nonatomic,retain)NSMutableArray *BookList;//教材

@property (nonatomic,assign)BOOL isGrade; // Yes:grade  NO:course
@end

@implementation NotebookVC

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
-(NSMutableArray *)BookList{
    if (!_BookList) {
        _BookList = [NSMutableArray array];
    }
    return _BookList;
}
-(NSNumber *)bookId{
    if (!_bookId) {
        _bookId = @1;
    }
    return _bookId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self addCategory];
    //加载网络数据
    [self addNetData];
//    [self addTableView];
//    [self addGradeTableView];
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    if ([df valueForKey:CURRENT_NOTEBOOK_ID]) {
//        self.bookId = [df valueForKey:CURRENT_NOTEBOOK_ID];
//    }
//    else{
//    }
//    [NetWorkingUtils postWithUrl:WrongOptions params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
//        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
//            _gradeList = [NSMutableArray arrayWithArray:[response valueForKey:@"data"]];
//            if (_gradeList.count>=1) {
//                _BookList = [_gradeList[0] valueForKey:@"books"];
//                
//                if (![df valueForKey:CURRENT_NOTEBOOK_ID]) {
//                    if (_BookList.count>=1) {
//                        
//                        self.bookId = [_BookList[0]valueForKey:@"bookId"];
//                        [df setValue:self.bookId forKey:CURRENT_NOTEBOOK_ID];
//                    }
//                }
////                [self.tableView.mj_header beginRefreshing];
//
//            }
//        }
//        
//    } errorResult:^(NSError *error) {
//        _gradeList = [NSMutableArray array];
//    }];

    // Do any additional setup after loading the view.
}
#pragma mark-----加载网络数据获取错题信息
-(void)addNetData
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"bookId":[[NSUserDefaults standardUserDefaults]objectForKey:@"noteBookid"],@"page":@"0",@"size":@"20"};
    
    [NetWorkingUtils postWithUrl:WrongList params:paraDic successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
        
        }
    } errorResult:^(NSError *error) {
    }];}
-(void)initNavi{
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    backImg.userInteractionEnabled = YES;
    
    [self.view addSubview:backImg];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"错题本";
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
//    CGFloat littleWhiteWidth =SCREEN_WIDTH-(AutoTrans(30))*2;
    
//    grade = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteWidth/4-(AutoTrans(50)), 0, AutoTrans(100), AutoTrans(80))];
//    [grade setTitle:@"年级" forState:UIControlStateNormal];
//    grade.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
//    [grade setTitleColor:[UIColor colorWithHexString:@"#35b6e6"] forState:UIControlStateNormal];
//    [grade setImage:[UIImage imageNamed:@"icon_lowertriangular_blue"] forState:UIControlStateNormal];
//    [grade addTarget:self action:@selector(gradeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [grade setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(60), 0, -(AutoTrans(60)))];
//    [grade setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
//    [littleWhiteV addSubview:grade];
    
    course = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(littleWhiteV.frame), AutoTrans(80))];
    //start
#pragma mark gd_教材— 显示当前教材名称  2017-01-16
    NSString * title = [LGDUtils isValidStr:[CommonShare share].currentBookName]?[CommonShare share].currentBookName:@"教材";
    [course setTitle:title forState:UIControlStateNormal];
//    [course setTitle:@"教材" forState:UIControlStateNormal];
    //end
    
    course.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
    [course setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [course setImage:[UIImage imageNamed:@"icon_lowertriangular_gray"] forState:UIControlStateNormal];
    [course addTarget:self action:@selector(courseButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [course setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(60), 0, -(AutoTrans(60)))];
    [course setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [littleWhiteV addSubview:course];


//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, AutoTrans(48))];
//    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
//    line.center = CGPointMake(littleWhiteV.frame.size.width/2, littleWhiteV.frame.size.height);
//    [littleWhiteV addSubview:line];
  
}
-(void)addTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(littleWhiteV.frame)+(AutoTrans(20)), CGRectGetWidth(littleWhiteV.frame), SCREEN_HEIGHT-CGRectGetMaxY(littleWhiteV.frame)-(AutoTrans(60))-(AutoTrans(20)))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = AutoTrans(100);
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = AutoTrans(40);
    _tableView.backgroundColor = [UIColor whiteColor];
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            //重新请求
            [self loadData];
            self.indexPage =0;
            //[self.collectionView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
            self.indexPage+=1;
            NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":self.bookId,@"page":@(self.indexPage),@"size":@20};
            [NetWorkingUtils postWithUrl:WrongList params:paramsDic successResult:^(id response) {
                if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
                    NSArray *SumArr      = [response valueForKey:@"data"];
                    
                    if (SumArr!=nil&& SumArr.count>0) {
                        for (int i = 0; i<SumArr.count; i++) {
                            NotebookModel *model = [NotebookModel notebookModelWithDic:SumArr[i]];
                            [self.list addObject:model];
                            
                        }
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [Utils showAlter:@"没有更多数据啦！"];
                        });
                        
                        self.indexPage -=1;
                        
                        [self.tableView.mj_footer endRefreshing];
                        
                    }
                }else{
                    [Utils showAlter:@"加载失败！"];
                    self.indexPage -=1;
                    [self.tableView.mj_footer endRefreshing];

                }
            
                
                
            } errorResult:^(NSError *error) {
                self.indexPage -=1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils showAlter:@"加载失败！"];
                });
                
                [self.tableView.mj_footer endRefreshing];
            }];
                       //[self footerRefreshWithCategory:self.categoryIndex AndPage:self.indexPage];
        });
    }];

    
    
    [self.view addSubview:_tableView];
}
-(void)loadData{
    NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":self.bookId,@"page":@(0),@"size":@20};
    [NetWorkingUtils postWithUrl:WrongList params:paramsDic successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSArray *SumArr      = [response valueForKey:@"data"];
            
            if (SumArr!=nil&& SumArr.count>0) {
                for (int i = 0; i<SumArr.count; i++) {
                    NotebookModel *model = [NotebookModel notebookModelWithDic:SumArr[i]];
                    [self.list addObject:model];
                    
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils showAlter:@"暂无数据！"];
                });
                
                self.indexPage -=1;
                
                [self.tableView.mj_footer endRefreshing];
                
            }
        }else{
            [Utils showAlter:@"加载失败！"];
            self.indexPage -=1;
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        
        
    } errorResult:^(NSError *error) {
        self.indexPage -=1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils showAlter:@"加载失败！"];
        });
        
        [self.tableView.mj_footer endRefreshing];
    }];

}
-(void)addGradeTableView{
    UIView *blackView = [[UIView alloc]initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.tag = 2001;
    blackView.alpha = 0.5;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewDismiss:)];
    [blackView addGestureRecognizer:tap];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(200), SCREEN_WIDTH-(AutoTrans(40))*2, SCREEN_HEIGHT-2*(AutoTrans(200)))];
    whiteView.layer.masksToBounds = YES;
    whiteView.tag = 2003;
    whiteView.layer.cornerRadius = AutoTrans(50);
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    gradeTable = [[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(250), SCREEN_WIDTH-(AutoTrans(40))*2, SCREEN_HEIGHT-2*(AutoTrans(250)))];
    gradeTable.delegate = self;
    gradeTable.dataSource = self;
    gradeTable.tag = 2002;
//    gradeTable.layer.masksToBounds = YES;
//    gradeTable.layer.cornerRadius = AutoTrans(20);
    gradeTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:gradeTable];
    blackView.hidden = YES;
    whiteView.hidden=YES;
    gradeTable.hidden = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2002) {
        static NSString *cellID1 = @"gradeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //            cell.block = ^( ){
        }
        if (_isGrade) {
            cell.textLabel.text = [_gradeList[indexPath.row]valueForKey:@"grade"];

        }else{
            cell.textLabel.text = [_BookList[indexPath.row]valueForKey:@"bookName"];


        }
        return cell;
    }else{
        static NSString *cellID2 = @"NotebookCell";
        NotebookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell = [[NotebookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.block = ^( ){
            //                ((QsModel *)self.list[indexPath.row]).isSelected = !((QsModel *)self.list[indexPath.row]).isSelected;
            //            };
        }
        cell.item = self.list[indexPath.row];
        
        
        return cell;
    }
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2002) {
        if (_isGrade) {
            return _gradeList.count;
        }else{
            return self.BookList.count;
        }
    }
    return self.list.count;
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==2002) {
        if (_isGrade) {
            self.BookList = [_gradeList[indexPath.row] valueForKey:@"books"];
            [self tableViewDismiss:nil];
        }else{
            self.bookId  = [_BookList[indexPath.row] valueForKey:@"bookId"];
            NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
            [df setValue:self.bookId forKey:CURRENT_NOTEBOOK_ID];
            [self tableViewDismiss:nil];
        }
    }
}
-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableViewDismiss:(UITapGestureRecognizer *)tap{
    UIView *view = [self.view viewWithTag:2001];
    view.hidden = YES;
    UIView *view2 = [self.view viewWithTag:2003];
    view2.hidden = YES;
    gradeTable.hidden = YES;
}
-(void)gradeButtonOnClick:(UIButton *)button{
    if (!_gradeList) {
        [Utils showAlter:@"正在刷新列表..."];
        return;
    }
    if (_gradeList.count==0) {
        [Utils showAlter:@"暂无数据！"];
        return;
    }
    _isGrade = YES;
    UIView *view = [self.view viewWithTag:2001];
    view.hidden = NO;
    UIView *view2 = [self.view viewWithTag:2003];
    view2.hidden = NO;
    gradeTable.hidden = NO;
    [gradeTable reloadData];
}
-(void)courseButtonOnClick:(UIButton *)button{
    if (!_gradeList) {
        [Utils showAlter:@"正在刷新列表..."];
        return;
    }
    if (_gradeList.count==0) {
        [Utils showAlter:@"暂无数据！"];
        return;
    }
    _isGrade = NO;
    UIView *view = [self.view viewWithTag:2001];
    view.hidden = NO;
    UIView *view2 = [self.view viewWithTag:2003];
    view2.hidden = NO;
    gradeTable.hidden = NO;
    [gradeTable reloadData];
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
