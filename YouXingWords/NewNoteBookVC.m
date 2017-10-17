//
//  NewNoteBookVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NewNoteBookVC.h"
#import "NewNoteBookCell.h"

#import "NoteModel.h"

@interface NewNoteBookVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//分类view
@property(nonatomic,retain)UIButton *typeBt;
//tableview
@property(nonatomic,retain)UITableView *myTableView;

@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)NSMutableArray *bookDataArr;
@property(nonatomic,copy)NSString *currentBookStr;
@property(nonatomic,copy)NSNumber *currentBookId;

@property(nonatomic,assign)NSInteger pageIndex;


@property(nonatomic,retain)UIPickerView *pickerView;
@property(nonatomic,retain)UIView *bgView;
@property(nonatomic,retain)UIToolbar *toolBar;

@end

@implementation NewNoteBookVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSMutableArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
    
}
-(NSMutableArray *)bookDataArr
{
    if (_bookDataArr==nil) {
        _bookDataArr=[NSMutableArray array];
    }
    return _bookDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加背景图
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加分类bt
    [self addTypeBt];
    
    //start
#pragma mark gd_不再使用newBookId  2017-04-27 11:13:53
//    _currentBookId=[[NSUserDefaults standardUserDefaults]objectForKey:@"newBookId"];
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    _currentBookId=[AnswerTools getBookID];
    _currentBookId=[AnswerTools getBookIDWith:BreakthroughTypeWord];
    //end
    
    //end
    
    _pageIndex=0;
    //添加错误单词
    [self addErrorWordsNetData];
    
    [self addBookNetData];
    
    
    

}
#pragma mark---添加网络数据
-(void)addErrorWordsNetData
{
    [self.dataArr removeAllObjects];
    
    //start
#pragma mark gd_错题本打开显示的就应该是全部的错题。然后可以针对性的选择教材，出来相应的教材错题  2017-03-28 11:23:30-3
//    if (_currentBookId!=nil) {
//        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"bookId":_currentBookId,@"page":[NSString stringWithFormat:@"%zd",_pageIndex],@"size":@"20"};
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    parameters[@"bookId"] = _currentBookId;
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",_pageIndex];
    parameters[@"size"] = @"20";
        [NetWorkingUtils postWithUrl:WrongList params:parameters successResult:^(id response) {
            if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
                NSLog(@"+++%@",response);
                for (NSDictionary *dicc in response[@"data"]) {
                    //start
#pragma mark gd_将dic改为model  2017-01-16
                    NoteModel * model = [NoteModel mj_objectWithKeyValues:dicc];
                    [self.dataArr addObject:model];
                    //                    [self.dataArr addObject:dicc];
                    //end
                    
                }
                //结束刷新
                [_myTableView.mj_header endRefreshing];
                
                if (_myTableView==nil) {
                    //添加tableview
                    [self addMyTableView];
                }else{
                    [_myTableView reloadData];
                }
            }
        } errorResult:^(NSError *error) {
            //结束刷新
            [_myTableView.mj_header endRefreshing];
            
        }];
//    }else{
//        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"闯关之后才能查看错题本，请先闯关" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alterView show];
//    }
    //end
}
#pragma mark---获取教材网络数据
-(void)addBookNetData
{
    if (self.bookDataArr.count > 0) {
        //添加picker
        [self addPickerView];
    }else{
        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken]};

        [NetWorkingUtils postWithUrl:WrongOptions params:paraDic successResult:^(id response) {
            if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
                NSLog(@"%@",response);
                if ([response[@"status"] integerValue] == 1) {

                    for (NSDictionary *dicc in response[@"data"]) {
                        [self.bookDataArr addObject:dicc];
                    }
                    
                    //start
#pragma mark gd_默认选择当前学习的教材  2017-03-30 17:07:35
//                    _currentBookStr=self.bookDataArr[0][@"bookName"];
//                    _currentBookId=self.bookDataArr[0][@"bookId"];
                    for (int i = 0; i < self.bookDataArr.count; i ++) {
                        NSDictionary * dict = self.bookDataArr[i];
                        if ([dict[@"bookId"] integerValue] == [_currentBookId integerValue]) {
                            _currentBookStr=self.bookDataArr[i][@"bookName"];
                            _currentBookId=self.bookDataArr[i][@"bookId"];
                            [_typeBt setTitle:_currentBookStr forState:UIControlStateNormal];
                        }
                    }
                    //end
                    
                    
                    

                }

            }
        } errorResult:^(NSError *error) {
            
        }];
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
    _titleView=[CustomTitleView customTitleView:@"错题本" rightTitle:@"" leftBtAction:^{
        //返回根目录
        [self.navigationController popToRootViewControllerAnimated:YES];
    } rightBtAction:^{
    }];
    [self.view addSubview:_titleView];
}
#pragma mark----添加分类view
-(void)addTypeBt
{
    _typeBt = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_titleView.frame)+10, SCREEN_WIDTH-(AutoTrans(60)), AutoTrans(80))];
    
    //start
#pragma mark gd_教材— 显示当前教材名称  2017-01-16
    NSString * title = [LGDUtils isValidStr:[CommonShare share].currentBookName]?[CommonShare share].currentBookName:@"教材";
    [_typeBt setTitle:title forState:UIControlStateNormal];
    //    [_typeBt setTitle:@"教材" forState:UIControlStateNormal];
    //end
    
    
    _typeBt.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(30) ];
    [_typeBt setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_typeBt setImage:[UIImage imageNamed:@"icon_lowertriangular_gray"] forState:UIControlStateNormal];
    [_typeBt addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _typeBt.layer.masksToBounds = YES;
    _typeBt.layer.cornerRadius = AutoTrans(30);
    _typeBt.backgroundColor = [UIColor whiteColor];
    [_typeBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, AutoTrans(40))];
//    [_typeBt setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [self.view addSubview:_typeBt];
}
#pragma mark----分类按钮点击
-(void)typeBtnClick:(UIButton *)sender
{
    [self addBookNetData];
    
}
#pragma mark----添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_typeBt.frame)+(AutoTrans(20)), CGRectGetWidth(_typeBt.frame), SCREEN_HEIGHT-CGRectGetMaxY(_typeBt.frame)-(AutoTrans(20+60))) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.layer.masksToBounds = YES;
    _myTableView.layer.cornerRadius = AutoTrans(40);
    _myTableView.tableFooterView=[UIView new];
    [self.view addSubview:_myTableView];
    // 下拉刷新
    _myTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pageIndex++;
        [self addErrorWordsNetData];
        
        
    }];
    
    //start
#pragma mark gd_支持多选  2017-01-16
    _myTableView.allowsMultipleSelection = YES;
    //end
    

}
#pragma mark--cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma makr---cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(100);
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NotebookCell";
    NewNoteBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NewNoteBookCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }else{
        cell.backgroundColor=[UIColor colorWithHexString:@"#f6fafc"];
    }
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#38b7e5"];
    cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    
    cell.tag=999+indexPath.row;
    //start
#pragma mark gd_将dic改为model  2017-01-16
    NoteModel * model = self.dataArr[indexPath.row];
//    cell.textLabel.text=self.dataArr[indexPath.row][@"word"];
//    cell.textLabel.text=model.word;
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"错误%@次",model.wrongCounts];
    cell.model = model;
    //end
    
    
    
    
    return cell;
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
//    for (NSInteger i; i<self.dataArr.count; i++) {
//        UITableViewCell *cell=(UITableViewCell *)[self.view viewWithTag:i+999];
//        if (i==indexPath.row) {
//            cell.backgroundColor=[UIColor colorWithHexString:@"#38b7e5"];
//            cell.textLabel.textColor=[UIColor whiteColor];
//            cell.detailTextLabel.textColor=[UIColor whiteColor];
//           
//            
//            //start
//#pragma mark gd_将dic改为model  2017-01-16
//            NoteModel * model = self.dataArr[indexPath.row];
//            //     cell.textLabel.text=self.dataArr[i][@"explain"];
//            cell.textLabel.text=model.explain;
//            //end
//
//        }else{
//            cell.textLabel.text=self.dataArr[i][@"word"];
//            cell.textLabel.textColor=[UIColor colorWithHexString:@"#38b7e5"];
//            cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"#999999"];
//            if (i%2==0) {
//                cell.backgroundColor=[UIColor whiteColor];
//            }else{
//                cell.backgroundColor=[UIColor colorWithHexString:@"#f6fafc"];
//            }
//        }
//    }
    
    
}

#pragma mark---添加pickerView
-(void)addPickerView
{
    //添加背景颜色
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor=[UIColor blackColor];
    _bgView.alpha=0.5;
    [self.view addSubview:_bgView];
    //添加点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_bgView addGestureRecognizer:tap];
    
    _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH,200)];
    _pickerView.dataSource=self;
    _pickerView.delegate=self;
    _pickerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    //toolbar
    _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200-40, SCREEN_WIDTH, 40)];
    _toolBar.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_toolBar];
    UIBarButtonItem *cancelBarBt=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarBtClick)];
    UIBarButtonItem *middeleBarBt=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBarBt=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarBtClick)];

    _toolBar.items=@[cancelBarBt,middeleBarBt,doneBarBt];
}
#pragma mark----取消按钮点击
-(void)cancelBarBtClick
{
    [_toolBar removeFromSuperview];
    [_bgView removeFromSuperview];
    [_pickerView removeFromSuperview];
}
#pragma mark---完成按钮点击
-(void)doneBarBtClick
{
    [_toolBar removeFromSuperview];
    [_bgView removeFromSuperview];
    [_pickerView removeFromSuperview];
    
    
    //start
#pragma mark gd_解决不切换教材直接点击确定无法选择第一个教材的问题  2017-03-30 17:05:12
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    _currentBookStr=self.bookDataArr[row][@"bookName"];
    _currentBookId=self.bookDataArr[row][@"bookId"];
    //end
    
    [_typeBt setTitle:_currentBookStr forState:UIControlStateNormal];
    
    _pageIndex=0;
    [self addErrorWordsNetData];
    
}
#pragma mark----tap
-(void)tap:(UITapGestureRecognizer *)tap
{
    [_toolBar removeFromSuperview];
    [_bgView removeFromSuperview];
    [_pickerView removeFromSuperview];
}
#pragma mark---datasource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.bookDataArr.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
#pragma mark--delegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.bookDataArr[row][@"bookName"];
}
#pragma mark--行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return AutoTrans(70);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _currentBookStr=self.bookDataArr[row][@"bookName"];
    _currentBookId=self.bookDataArr[row][@"bookId"];
}


@end
