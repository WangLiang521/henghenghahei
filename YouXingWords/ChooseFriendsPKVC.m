//
//  ChooseFriendsPKVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/10/26.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseFriendsPKVC.h"
#import "ChooseFriendsCell.h"

@interface ChooseFriendsPKVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//本地数据
@property(nonatomic,copy)NSMutableArray *dataArr;
//本地数据
@property(nonatomic,copy)NSMutableArray *newDataArr;
//本地数据
@property(nonatomic,copy)NSMutableDictionary *dataDic;
//搜索出来的数组
@property(nonatomic,copy)NSMutableArray *searchDataArr;
//账号数组
@property(nonatomic,copy)NSMutableArray *accountDataArr;
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//搜索输入框
@property(strong, nonatomic) UITextField *myTextField;
//数据列表
@property(nonatomic,retain)UITableView *myTableView;
//确定按钮
@property(nonatomic,retain)UIButton *sureBt;
//选中的好友的账号
@property(nonatomic,copy)NSString *chooseAccount;

@end

@implementation ChooseFriendsPKVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

#pragma mark---获取缓存缓存数据
-(NSMutableArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
        NSArray *localArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
        for (NSDictionary *dicc in localArr[0]) {
            if (dicc[@"friAccount"]) {
                [_dataArr addObject:dicc];
            }
        }
        for (NSDictionary *dicc in localArr[1]) {
            if (dicc[@"friAccount"]) {
                [_dataArr addObject:dicc];
            }
        }
        for (NSDictionary *dicc in localArr[2]) {
            if (dicc[@"friAccount"]) {
                [_dataArr addObject:dicc];
            }
        }
    }
    return _dataArr;
}
#pragma mark---拷贝出来的
-(NSMutableArray *)newDataArr
{
    if (_newDataArr==nil) {
        _newDataArr=[NSMutableArray array];
        _newDataArr=[self.dataArr copy];
    }
    return _newDataArr;
}
#pragma mark----账号数组
-(NSMutableArray *)accountDataArr
{
    if (_accountDataArr==nil) {
        _accountDataArr=[NSMutableArray array];
        for (NSDictionary *dicc in self.dataArr) {
            if (dicc[@"friAccount"]) {
                [_accountDataArr addObject:dicc[@"friAccount"]];
            }
        }
    }
    return _accountDataArr;
}
#pragma mark---获取搜索出来的数组
-(NSMutableArray *)searchDataArr
{
    if (_searchDataArr==nil) {
        _searchDataArr=[NSMutableArray array];
    }
    return _searchDataArr;
}
#pragma mark---获取搜
-(NSMutableDictionary *)dataDic
{
    if (_dataDic==nil) {
        _dataDic=[NSMutableDictionary dictionary];
        for (NSDictionary *dicc in self.dataArr) {
            if (dicc[@"friAccount"]) {
                [_dataDic setObject:dicc forKey:dicc[@"friAccount"]];
            }
        }
    }
    return _dataDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.dataArr);
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:_myTextField];
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加搜索框
    [self addMySearchBar];
    //添加数据列表
    [self addMyTableView];
    //添加确定按钮
    [self addSureBt];
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
    _titleView=[CustomTitleView customTitleView:@"选择好友" rightTitle:@"" leftBtAction:^{
        //关闭键盘
        [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
        
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加搜索框
-(void)addMySearchBar
{
    //放大镜图片
    UILabel *searchImg=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(80), AutoTrans(80))];
    searchImg.text=@"🔍";
    searchImg.textAlignment=NSTextAlignmentCenter;
    
    _myTextField=[[UITextField alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(_titleView.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(80)), AutoTrans(80))];
    _myTextField.backgroundColor=[UIColor whiteColor];
    _myTextField.layer.cornerRadius=CGRectGetHeight(_myTextField.frame)/2;
    _myTextField.layer.masksToBounds=YES;
    _myTextField.placeholder=@"搜索";
    _myTextField.leftView=searchImg;
    _myTextField.leftViewMode=UITextFieldViewModeAlways;
    _myTextField.delegate=self;
    [self.view addSubview:_myTextField];
}
#pragma mark---监听输入框
-(void)textChangeAction:(NSNotification *)notification
{
    for (int i=0; i<self.dataArr.count; i++) {
        UIImageView *chooseImg=(UIImageView *)[self.view viewWithTag:300+i];
        chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
    }
    _chooseAccount=@"(null)";
    
    
    [self.searchDataArr removeAllObjects];
    UITextField *textField=notification.object;
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", textField.text];
    NSArray *newArr=[self.accountDataArr filteredArrayUsingPredicate:preicate];
    for (NSString *key in newArr) {
        [self.searchDataArr addObject:self.dataDic[key]];
    }
    if ([textField.text isEqualToString:@""]) {
        self.dataArr=self.newDataArr;
    }else{
        self.dataArr=self.searchDataArr;
    }
    [_myTableView reloadData];
}
#pragma mark---数据列表
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(_myTextField.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(80)), SCREEN_HEIGHT-CGRectGetMaxY(_myTextField.frame)-(AutoTrans(170))) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.layer.cornerRadius=CGRectGetWidth(_myTableView.frame)/20;
    _myTableView.layer.masksToBounds=YES;
    _myTableView.bounces=NO;
    _myTableView.showsVerticalScrollIndicator=NO;
    _myTableView.userInteractionEnabled=YES;
    _myTableView.tableFooterView=[UIView new];
    [self.view addSubview:_myTableView];
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(130);
}
#pragma mark---cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    ChooseFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[ChooseFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //选择图片
    cell.chooseImg.tag=300+indexPath.row;
    //头像icon
    NSURL *iconImgUrl=[NSURL URLWithString:self.dataArr[indexPath.row][@"signPhoto"]];
    UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
    [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
    //有备注显示备注 无备注显示名称    isFriend 是否是朋友（0:同学关系，1朋友关系）
    NSString *remarkName=self.dataArr[indexPath.row][@"remarkName"];
    if ([remarkName isEqualToString:@""]) {
        cell.nameLb.text=self.dataArr[indexPath.row][@"name"];
    }else{
        cell.nameLb.text=self.dataArr[indexPath.row][@"remarkName"];
    }
    
    //start
#pragma mark gd_修改学习不对,秒转分钟  2017-03-27 16:49:55-3
    NSInteger day1 = [LGDUtils changeSecondsToMinute:self.dataArr[indexPath.row][@"st1day"]];
    //     NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%@分钟",self.dataArr[indexPath.row][@"st1day"]];
    NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%zd分钟",day1];
    //end
    //昨天的练习时间
    
    cell.contentLb.text=timeStr;

    return cell;
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i<self.dataArr.count; i++) {
        UIImageView *chooseImg=(UIImageView *)[self.view viewWithTag:300+i];
        if (chooseImg.tag==indexPath.row+300) {
            chooseImg.image=[UIImage imageNamed:@"barrier_ck_checked"];
        }else{
            chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
        }
    }
    //选中好友的账号
    _chooseAccount=self.dataArr[indexPath.row][@"friAccount"];
    
    
}
#pragma mark---确定按钮
-(void)addSureBt
{
    _sureBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(100), CGRectGetMaxY(_myTableView.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(200)), AutoTrans(90))];
    _sureBt.layer.cornerRadius=CGRectGetHeight(_sureBt.frame)/2;
    _sureBt.layer.masksToBounds=YES;
    _sureBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    [_sureBt setTitle:@"确定" forState:UIControlStateNormal];
    _sureBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [_sureBt addTarget:self action:@selector(sureBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureBt];
}
#pragma mark---确定按钮点击
-(void)sureBtClick
{
    
    NSString *chooseAccountStr=[NSString stringWithFormat:@"%@",_chooseAccount];
    if ([chooseAccountStr isEqualToString:@"(null)"]) {
        [Utils showAlter:@"请先选择好友"];
    }else{
        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"chanType":[NSString stringWithFormat:@"%ld",self.PKType],@"beChallenger":chooseAccountStr,@"coins":[NSString stringWithFormat:@"%ld",self.diamondNum]};
        NSLog(@"%@",paraDic);
        [NetWorkingUtils postWithUrl:ChooseFriendChange params:paraDic successResult:^(id response) {
            if ([response[@"status"] integerValue]==0) {
                [Utils showAlter:response[@"error"]];
            }else if ([response[@"status"] integerValue]==1){
                [Utils showAlter:@"PK请求已发送"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:PKFriendList object:nil];
                    //返回根目录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        } errorResult:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
#pragma mark---关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
#pragma mark---删除通知
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
