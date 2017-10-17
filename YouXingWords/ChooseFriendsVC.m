//
//  ChooseFriendsVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/26.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseFriendsVC.h"
#import "ChooseFriendsCell.h"
#import "PKVC.h"

@interface ChooseFriendsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//本地数据
@property(nonatomic,copy)NSArray *dataArr;
//表头是否展开
@property(nonatomic,copy)NSMutableDictionary *isOpenDic;
@property(nonatomic,copy)NSString *isOpen;//是否展开
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//搜索输入框
@property(strong, nonatomic) UITextField *myTextField;
//数据列表
@property(nonatomic,retain)UITableView *myTableView;
//每行是否被选中
@property(nonatomic,copy)NSMutableArray *isChooseArr;
@property(nonatomic,copy)NSMutableDictionary *isChooseDic;
@property(nonatomic,copy)NSMutableDictionary *isChooseDic1;
@property(nonatomic,copy)NSMutableDictionary *isChooseDic2;
//选中的个数
@property(nonatomic,assign)NSInteger chooseCount;
//备注数组
@property(nonatomic,copy)NSMutableArray *remarkNameArr;
//名称数组
@property(nonatomic,copy)NSMutableArray *nameArr;
//账号数组
@property(nonatomic,copy)NSMutableArray *friAccountArr;

//确定按钮
@property(nonatomic,retain)UIButton *sureBt;

@end
@implementation ChooseFriendsVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

#pragma mark---是否选中
-(NSMutableArray *)isChooseArr
{
    if (_isChooseArr==nil) {
        _isChooseArr=[NSMutableArray array];
    }
    return _isChooseArr;
}
-(NSMutableDictionary *)isChooseDic
{
    if (_isChooseDic==nil) {
        _isChooseDic=[NSMutableDictionary dictionary];
    }
    return _isChooseDic;
}
-(NSMutableDictionary *)isChooseDic1
{
    if (_isChooseDic1==nil) {
        _isChooseDic1=[NSMutableDictionary dictionary];
    }
    return _isChooseDic1;
}
-(NSMutableDictionary *)isChooseDic2
{
    if (_isChooseDic2==nil) {
        _isChooseDic2=[NSMutableDictionary dictionary];
    }
    return _isChooseDic2;
}
#pragma mark---好友分组
-(NSArray *)typeArr
{
    NSArray *arr=@[@"家人",@"好友",@"同学"];
    return arr;
}
#pragma mark---获取缓存缓存数据
-(NSArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    }
    return _dataArr;
}
#pragma mark---备注数组
-(NSMutableArray *)remarkNameArr
{
    if (_remarkNameArr==nil) {
        _remarkNameArr=[NSMutableArray array];
        //家人
        for (NSDictionary *dicc in self.dataArr[0]) {
            [_remarkNameArr addObject:dicc[@"remarkName"]];
        }
        //朋友
        for (NSDictionary *dicc in self.dataArr[1]) {
            [_remarkNameArr addObject:dicc[@"remarkName"]];
        }
    }
    return _remarkNameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:_myTextField];
    
    //通讯录分组展开或者合并
    _isOpenDic=[NSMutableDictionary dictionary];
    for(int i=0; i<self.typeArr.count;i++){
        [_isOpenDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    //家人
    for (int i=0; i<[self.dataArr[0] count]; i++) {
        [self.isChooseDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [self.isChooseArr addObject:self.isChooseDic];
    //朋友
    for (int i=0; i<[self.dataArr[1] count]; i++) {
        [self.isChooseDic1 setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [self.isChooseArr addObject:self.isChooseDic1];
    //同学
    for (int i=0; i<[self.dataArr[2] count]; i++) {
        [self.isChooseDic2 setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [self.isChooseArr addObject:self.isChooseDic2];

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
    UITextField *textField=notification.object;
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", textField.text];
   NSArray *newArr=[self.remarkNameArr filteredArrayUsingPredicate:preicate];
    
    NSLog(@"%@",newArr);
    
    
    
//    if (self.searchList!= nil) {
//        [self.searchList removeAllObjects];
//    }
//    //过滤数据
//    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [_myTableView reloadData];
    
}
#pragma mark---数据列表
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(_myTextField.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(80)), SCREEN_HEIGHT-CGRectGetMaxY(_myTextField.frame)-(AutoTrans(170))) style:UITableViewStyleGrouped];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.layer.cornerRadius=CGRectGetWidth(_myTableView.frame)/20;
    _myTableView.layer.masksToBounds=YES;
    _myTableView.bounces=NO;
    _myTableView.showsVerticalScrollIndicator=NO;
    _myTableView.userInteractionEnabled=YES;
    [self.view addSubview:_myTableView];
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(130);
}
#pragma mark---cell表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AutoTrans(90);
}
#pragma mark---cell表尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark---cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _isOpen =[_isOpenDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    return [_isOpen isEqualToString:@"YES"]?[self.dataArr[section] count]:0;
}
#pragma mark---cell组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.typeArr.count;
}
#pragma mark---表头数据
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *typeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(90))];
    typeView.tag=333+section;
    typeView.backgroundColor=[UIColor whiteColor];
    //箭头
    UIImageView *arowImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(35), AutoTrans(30), AutoTrans(20))];
    arowImg.image=[UIImage imageNamed:@"contract_icon_group"];
    [typeView addSubview:arowImg];
    //分组类别
    UILabel *typeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(arowImg.frame)+(AutoTrans(20)), AutoTrans(20), AutoTrans(200), AutoTrans(50))];
    typeLb.text=[NSString stringWithFormat:@"%@",self.typeArr[section]];
    typeLb.textColor=[UIColor colorWithHexString:@"#333333"];
    typeLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [typeView addSubview:typeLb];
    //点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [typeView addGestureRecognizer:tap];
    return typeView;
}
#pragma mark---表头添加点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

    NSInteger section=tap.view.tag-333;
    _isOpen =[_isOpenDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    
    if ([_isOpen isEqualToString:@"YES"]) {
        _isOpen=@"NO";
    }else if ([_isOpen isEqualToString:@"NO"]){
        _isOpen=@"YES";
    }
    [_isOpenDic setObject:_isOpen forKey:[NSString stringWithFormat:@"%ld", section]];
    //刷新section
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:section];
    [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
    //头像icon
    NSURL *iconImgUrl=[NSURL URLWithString:self.dataArr[indexPath.section][indexPath.row][@"signPhoto"]];
    UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
    [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
    //非同学关系显示备注    isFriend 是否是朋友（0:同学关系，1朋友关系）
    NSInteger isFriend=[self.dataArr[indexPath.section][indexPath.row][@"isFriend"] integerValue];
    if (isFriend==0) {
        cell.nameLb.text=self.dataArr[indexPath.section][indexPath.row][@"name"];
    }else if(isFriend==1){
        //如果有备注显示备注，无备注显示真名
        NSString *remarkName=self.dataArr[indexPath.section][indexPath.row][@"remarkName"];
        if ([remarkName isEqualToString:@""]) {
            cell.nameLb.text=self.dataArr[indexPath.section][indexPath.row][@"name"];
        }else{
            cell.nameLb.text=remarkName;
        }
    }
    //昨天的练习时间
    //start
#pragma mark gd_修改学习不对,秒转分钟  2017-03-27 16:49:55-3
    NSInteger day1 = [LGDUtils changeSecondsToMinute:self.dataArr[indexPath.section][indexPath.row][@"st1day"]];
    //     NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%@分钟",self.dataArr[indexPath.section][indexPath.row][@"st1day"]];
    NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%zd分钟",day1];
    //end

    
    
    cell.contentLb.text=timeStr;
    //选中图片
    NSDictionary *dicc=self.isChooseArr[indexPath.section];
    if ([[dicc objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"NO"]) {
        cell.chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
        cell.isChooseBool=NO;
    }else if([[dicc objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"YES"]){
        cell.chooseImg.image=[UIImage imageNamed:@"barrier_ck_checked"];
        cell.isChooseBool=YES;
    }
    return cell;
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseFriendsCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isChooseBool==NO) {
        //修改状态图片
        cell.chooseImg.image=[UIImage imageNamed:@"barrier_ck_checked"];
        //家人
        if (indexPath.section==0) {
            [self.isChooseDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic];
        //朋友
        }else if (indexPath.section==1){
            [self.isChooseDic1 setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic1];
        //同学
        }else if (indexPath.section==2){
            [self.isChooseDic2 setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic2];
        }
        //选中人数+1
        _chooseCount++;
        NSString *titleStr=[NSString stringWithFormat:@"确定(已选%ld人)",_chooseCount];
        [_sureBt setTitle:titleStr forState:UIControlStateNormal];

        cell.isChooseBool=YES;
    }else if(cell.isChooseBool==YES){
        cell.chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
        //家人
        if (indexPath.section==0) {
            [self.isChooseDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic];
        //同学
        }else if (indexPath.section==1){
            [self.isChooseDic1 setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic1];
        //朋友
        }else if (indexPath.section==2){
            [self.isChooseDic2 setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.isChooseArr replaceObjectAtIndex:indexPath.section withObject:self.isChooseDic2];
        }
        //选中人数-1
        _chooseCount--;
        NSString *titleStr;
        if (_chooseCount==0){
            titleStr=@"确定";
        }else{
            titleStr=[NSString stringWithFormat:@"确定(已选%ld人)",_chooseCount];
        }
        [_sureBt setTitle:titleStr forState:UIControlStateNormal];
       
        cell.isChooseBool=NO;
    }
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
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"chanType":[NSString stringWithFormat:@"%ld",self.PKType],@"beChallenger":@"18560126369",@"coins":[NSString stringWithFormat:@"%ld",self.diamondNum]};
    NSLog(@"paraDic:%@",paraDic);
    [NetWorkingUtils postWithUrl:ChooseFriendChange params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==0) {
            [Utils showAlter:response[@"error"]];
        }else if ([response[@"status"] integerValue]==1){
            NSLog(@"%@",response);
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
