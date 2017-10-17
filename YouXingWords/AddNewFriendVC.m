//
//  AddNewFriendVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/13.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "AddNewFriendVC.h"
#import "MessageCell.h"
#import "NewFriendsInfoVC.h"

@interface AddNewFriendVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UISearchBar *mySearchBar;
@property(nonatomic,retain)UITableView *myTableView;
//数据源
@property(nonatomic,copy)NSMutableArray *dataArr;
@end

@implementation AddNewFriendVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addType == AddFriendTypeFamily) {
        self.title=@"添加陪伴号";
    }else{
        self.title=@"添加好友";
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    //添加搜索框
    [self addSearchBar];
    [self setNav];
}
- (void)setNav{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    //        [button setImage:[UIImage imageNamed:backBarbuttonItemHighlightedImageName] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(70, 40);
    //        // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        //        [button sizeToFit];
    //        // 让按钮的内容往左边偏移10
    //        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    ////        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ////        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //
    //        // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];  
}
- (void)back{
    if (self.preUserName) {
        UIViewController * vc = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addSearchBar
{
    //表头view
    _mySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, AutoTrans(110))];
    _mySearchBar.barTintColor=[UIColor colorWithHexString:@"#e8edf1"];
    
    //start
#pragma mark gd_通讯录里添加好友输入名字显示没有数据。（搜的已经注册的学生）。通过手机号找到人但是没法邀请添加  2017-03-27 17:41:29-9
//    _mySearchBar.placeholder=@"手机号/优行账号/姓名";
    _mySearchBar.placeholder=@"优行账号";
    //end
    
    _mySearchBar.delegate=self;
    _mySearchBar.searchBarStyle=UISearchBarStyleProminent;
    [self.view addSubview:_mySearchBar];
    
    if (self.preUserName) {
        self.mySearchBar.text = self.preUserName;
        [self searchUser];
    }
}
#pragma mark---键盘上搜索按钮点击
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self searchUser];
}

- (void)searchUser{
    //参数字典
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"username":_mySearchBar.text,@"page":@1,@"size":@10};
    [NetWorkingUtils postWithUrl:SearchUser params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        //个数大于0
        [self.dataArr removeAllObjects];
        
        if ([response[@"size"] integerValue]!=0) {
            for(NSDictionary *dicc in response[@"data"]){
                [self.dataArr addObject:dicc];
            }
        }else{
            [Utils showAlter:@"暂无数据"];
        }
        if (_myTableView==nil) {
            //加载tableview
            [self addMyTableView];
        }else{
            //刷新列表
            [_myTableView reloadData];
        }
    } errorResult:^(NSError *error) {
    }];
}

#pragma mark---添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mySearchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-(AutoTrans(110))-64) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.tableFooterView=[UIView new];
    [self.view addSubview:_myTableView];
}
#pragma mark---高度
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
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //头像icon
    UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
    if (![self.dataArr[indexPath.row][@"signPhoto"] isKindOfClass:[NSString class]]) {
        cell.iconImg.image=placeholderImage;
    }else{
        NSURL *iconImgUrl=[NSURL URLWithString:self.dataArr[indexPath.row][@"signPhoto"]];
        [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
    }
    //姓名昵称
    cell.nameLb.text=self.dataArr[indexPath.row][@"name"];
    //昨天的练习时间
    
    //start
#pragma mark gd_修改学习不对,秒转分钟  2017-03-27 16:49:55-3
    NSInteger day1 = [LGDUtils changeSecondsToMinute:self.dataArr[indexPath.row][@"st1day"]];
//     NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%@分钟",self.dataArr[indexPath.row][@"st1day"]];
     NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%zd分钟",day1];
    //end
   
    cell.contentLb.text=timeStr;
    cell.msgCountLb.hidden=YES;
    return cell;
}
#pragma mark----点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendsInfoVC *new=[[NewFriendsInfoVC alloc]init];
    new.userName=self.dataArr[indexPath.row][@"username"];
    new.viewTag=300;
    new.addtype = self.addType;
    [self.navigationController pushViewController:new animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //收起键盘
//    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
