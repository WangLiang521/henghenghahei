//
//  MoreInfoVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "MoreInfoVC.h"
#import "ReviseNoteVC.h"

@interface MoreInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,retain)UITableView *myTableView;

@property(nonatomic,copy)NSArray *titleArr;
@property(nonatomic,copy)NSMutableArray *contentArr;

@end

@implementation MoreInfoVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSArray *)noteArr
{
    NSArray *arr=@[@"修改备注",@"修改分组"];
    return arr;
}
-(NSArray *)titleArr
{
    _titleArr=@[@"姓名",@"备注",@"分组",@"优行账号",@"加盟校",@"地区",@"学校",@"年级"];
    return _titleArr;
}
-(NSArray *)contentArr
{
    if (_contentArr==nil) {
        _contentArr=[NSMutableArray array];
        NSArray *arr=@[self.dataDic[@"name"],self.noteStr,self.groupStr,self.dataDic[@"username"],self.dataDic[@"jmxName"],self.dataDic[@"address"],self.dataDic[@"schName"],self.dataDic[@"className"]];
        [_contentArr addObjectsFromArray:arr];
    }
    return _contentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"更多";
    
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];

    NSLog(@"----%@",arr);

    NSLog(@"+++++%@",self.dataDic);
    
    //添加tableview
    [self addMyTableView];
    
}
#pragma mark----添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor=[UIColor colorWithHexString:@"#e8edf1"];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.bounces=NO;
//    _myTableView.tableFooterView=[UIView new];
    [self.view addSubview:_myTableView];
    
    
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(90);
}
#pragma mark----cell表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark---cell表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return AutoTrans(200);
}
#pragma mark----加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text=self.titleArr[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#333333"];
    cell.detailTextLabel.text=self.contentArr[indexPath.row];
    
    if (indexPath.row==1||indexPath.row==2) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1||indexPath.row==2) {
        ReviseNoteVC *reviseNote=[[ReviseNoteVC alloc]init];
        reviseNote.noteStr=self.contentArr[indexPath.row];
        reviseNote.username=self.dataDic[@"username"];
        reviseNote.groupStr=self.groupStr;
        reviseNote.tempDic=self.tempDic;
        reviseNote.titleStr=self.noteArr[indexPath.row-1];
        reviseNote.block=^(NSString *noteStr){
            NSLog(@"++++++%@",noteStr);
            //更改数组数据
            [self.contentArr replaceObjectAtIndex:indexPath.row withObject:noteStr];
            //刷新相应的row
            [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:reviseNote animated:YES];
    }
}
#pragma mark---表尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(200))];
    
    UIButton *delFriendBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(100), AutoTrans(30), SCREEN_WIDTH-(AutoTrans(200)), AutoTrans(100))];
    delFriendBt.backgroundColor=[UIColor colorWithHexString:@"#ea4424"];
    delFriendBt.layer.cornerRadius=CGRectGetHeight(delFriendBt.frame)/2;
    delFriendBt.layer.masksToBounds=YES;
    [delFriendBt setTitle:@"删除好友" forState:UIControlStateNormal];
    [delFriendBt addTarget:self action:@selector(delFriendBtClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:delFriendBt];
    
    return bottomView;
}
#pragma mark---删除好友按钮点击
-(void)delFriendBtClick
{
    UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
    
}
#pragma mark---提示框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        // 1. 删除网络数据数据
        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":self.dataDic[@"username"]};
        [NetWorkingUtils postWithUrlWithoutHUD:DeleteFriend params:paraDic successResult:^(id response) {
            if ([response[@"status"] integerValue]==1) {
                //删除缓存数据
                [self removeLocalNoteData];
                //返回根目录
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } errorResult:^(NSError *error) {
        }];
    }
}
#pragma mark---删除缓存中的当前好友
-(void)removeLocalNoteData
{
    //获取本地缓存数据
    NSMutableArray *localAddressArr=[NSMutableArray array];
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    [localAddressArr addObjectsFromArray:arr];
    //组数
    NSInteger group=[self.tempDic[@"group"] integerValue];
    //行数
    NSInteger number=[self.tempDic[@"number"] integerValue];
    //更改行数对应的字典的值
//    NSDictionary *rowDic=localAddressArr[group][number];
//    NSMutableDictionary *rowMutableDic=[NSMutableDictionary dictionary];
//    [rowMutableDic setDictionary:rowDic];
//    [rowMutableDic setObject:noteStr forKey:@"remarkName"];
    //修改组数对应的数组的值
    NSMutableArray *sectionMutableArr=[NSMutableArray array];
    [sectionMutableArr addObjectsFromArray:localAddressArr[group]];
    [sectionMutableArr removeObjectAtIndex:number];
//    [sectionMutableArr replaceObjectAtIndex:number withObject:rowMutableDic];
    //替换修改之后的值
    [localAddressArr replaceObjectAtIndex:group withObject:sectionMutableArr];
    //再次添加到本地缓存中
    [[NSUserDefaults standardUserDefaults]setObject:localAddressArr forKey:@"address"];
}


@end
