//
//  MessageMoreInfoVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/7.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "MessageMoreInfoVC.h"
#import "MessageCell.h"
#import "DetailVC.h"

@interface MessageMoreInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,copy)NSMutableArray *newDataArr;

@property(nonatomic,copy)NSMutableArray *isReadArr;

@property(nonatomic,retain)NSIndexPath *myIndexPath;


@end

@implementation MessageMoreInfoVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSMutableArray *)newDataArr
{
    if (_newDataArr==nil) {
        _newDataArr=[NSMutableArray array];
        [self.newDataArr addObjectsFromArray:self.dataArr];
    }
    return _newDataArr;
}
-(NSMutableArray *)isReadArr
{
    if (_isReadArr==nil) {
        _isReadArr=[NSMutableArray array];
        
        for (NSDictionary *dicc in self.dataArr) {
            [_isReadArr addObject:dicc[@"isRead"]];
        }
    }
    return _isReadArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@",self.dataArr);
    self.title=self.titleStr;
    //添加tableview
    [self addMyTableView];
}

- (void)setNav{
    
}
#pragma mark---添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.tableFooterView=[UIView new];
    _myTableView.bounces=NO;
    //下拉刷新
    if ([self.title isEqualToString:@"每日战报"]||[self.title isEqualToString:@"擂台赛"]) {
        _myTableView.bounces=YES;
        NSString *urlStr;
        if ([self.title isEqualToString:@"每日战报"]) {
            urlStr=GetReportList;
        }
        if ([self.title isEqualToString:@"擂台赛"]) {
            urlStr=GetContestList;
        }
        _myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //参数字典
            NSDictionary *paramDic= nil;
            if (self.dataArr.count > 0) {
                paramDic = @{@"token":[Utils getCurrentToken],@"createTim":self.dataArr[0][@"createTim"]};
            }else{
                paramDic = @{@"token":[Utils getCurrentToken],@"createTim":@(0)};
            }
            //post请求
            [NetWorkingUtils postWithUrlWithoutHUD:urlStr params:paramDic successResult:^(id response) {
                NSLog(@"%@",response);
                if ([response[@"size"] integerValue]!=0) {
                    for (NSDictionary *dicc in response[@"data"]) {
                        [self.newDataArr insertObject:dicc atIndex:0];
                    }
                }else{
                    [Utils showAlter:@"已经获取到全部数据"];
                }
                self.dataArr=self.newDataArr;
                
                [_isReadArr removeAllObjects];
                for (NSDictionary *dicc in self.dataArr) {
                    [_isReadArr addObject:dicc[@"isRead"]];
                }
                [_myTableView reloadData];
                //结束下拉刷新
                [_myTableView.mj_header endRefreshing];
            } errorResult:^(NSError *error) {
                //结束下拉刷新
                [_myTableView.mj_header endRefreshing];
            }];
        }];
    }
    [self.view addSubview:_myTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
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
    cell.iconImg.image=self.iconImg;
    cell.nameLb.text=self.titleStr;
    cell.contentLb.text=self.dataArr[indexPath.row][@"content"];
    cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"createTim"]]];
    //start
#pragma mark gd_修改未读消息小红点样式  2017-01-19
    //    cell.msgCountLb.hidden=YES;
    //    //未读小红点
    //    if ([self.isReadArr[indexPath.row] integerValue]==0) {
    //        cell.noReadLb.hidden=NO;
    //    }else if([self.isReadArr[indexPath.row] integerValue]==1){
    //        cell.noReadLb.hidden=YES;
    //    }
    cell.noReadLb.hidden=YES;
    
    //未读小红点
    if ([self.isReadArr[indexPath.row] integerValue]==0) {
        cell.msgCountLb.hidden=NO;
        cell.msgCountLb.text = @"1";
    }else if([self.isReadArr[indexPath.row] integerValue]==1){
        cell.msgCountLb.hidden=YES;
    }
    
    //content自适应高度
    //    CGFloat contentLbHeight=[Utils getTextHeight:cell.contentLb.text font:[UIFont systemFontOfSize:AutoTrans(28)] forWidth:SCREEN_WIDTH-(AutoTrans(30+84+20))];
    //    _cellHeight=contentLbHeight+(AutoTrans(80))+5;
    //    cell.contentLb.frame=CGRectMake(CGRectGetMinX(cell.nameLb.frame), CGRectGetMaxY(cell.nameLb.frame), SCREEN_WIDTH-(AutoTrans(30+84+20)), contentLbHeight);
    
    
    CGFloat contentLbHeight=[Utils getTextHeight:cell.contentLb.text font:[UIFont systemFontOfSize:AutoTrans(28)] forWidth:CGRectGetWidth(cell.nameLb.frame)];
    
    if (contentLbHeight < CGRectGetHeight(cell.nameLb.frame)){
        contentLbHeight =  CGRectGetHeight(cell.nameLb.frame);
    }
    
    _cellHeight=contentLbHeight+(AutoTrans(80))+5;
    cell.contentLb.frame=CGRectMake(CGRectGetMinX(cell.nameLb.frame), CGRectGetMaxY(cell.nameLb.frame), CGRectGetWidth(cell.nameLb.frame), contentLbHeight);
    //end
    

    
    
    return cell;
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"系统通知"]) {
        [self setMsgIsRead:indexPath];
        DetailVC * vc = [[DetailVC alloc] initWithNibName:@"DetailVC" bundle:nil];
        vc.title = @"通知详情";
        vc.detail = self.dataArr[indexPath.row][@"content"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.title isEqualToString:@"擂台赛"]){
        [self setMsgIsRead:indexPath];
        DetailVC * vc = [[DetailVC alloc] initWithNibName:@"DetailVC" bundle:nil];
        vc.title = @"详情";
        vc.detail = self.dataArr[indexPath.row][@"content"];
        [self.navigationController pushViewController:vc animated:YES];
    }else  if ([self.title isEqualToString:@"每日战报"]){
        if ([self.dataArr[indexPath.row][@"isRead"] integerValue]==0) {
            _myIndexPath=indexPath;
            NSString *subStr=self.dataArr[indexPath.row][@"hasOper"];
            if ([subStr integerValue]==0) {
                UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"每日战报" message:self.dataArr[indexPath.row][@"content"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                alter.tag=222;
                [alter show];
            }else{
                UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"每日战报" message:self.dataArr[indexPath.row][@"content"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"拒绝",@"接受", nil];
                alter.tag=333;
                [alter show];
            }
        }
    }else{
        [self setMsgIsRead:indexPath];
        DetailVC * vc = [[DetailVC alloc] initWithNibName:@"DetailVC" bundle:nil];
        vc.title = @"详情";
        vc.detail = self.dataArr[indexPath.row][@"content"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==333) {
        NSString *urlStr;
        switch (buttonIndex) {
            case 0:{
                //拒绝
                urlStr=RsfuseUserPKByMsg;
            }
                break;
            case 1:{
                //接受
                urlStr=AcceptUserPKByMsg;
            }
                break;
            default:
                break;
        }
        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"id":self.dataArr[_myIndexPath.row][@"id"]};
        
        [NetWorkingUtils postWithUrl: urlStr params:paraDic successResult:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"status"] integerValue]==1) {
                //设置为已读
                [self setMsgIsRead:_myIndexPath];
                //发送通知
                [[NSNotificationCenter defaultCenter]postNotificationName:PKFriendList object:nil];
            }else{
                [Utils showAlter:response[@"error"]];
                //设置为已读
                [self setMsgIsRead:_myIndexPath];
            }
        } errorResult:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        //设置为已读
        [self setMsgIsRead:_myIndexPath];
    }
}
#pragma mark---设置消息已读
-(void)setMsgIsRead:(NSIndexPath *)indexPath
{
    //设置消息为已读
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"msgIds":self.dataArr[indexPath.row][@"id"]};
    [NetWorkingUtils postWithUrlWithoutHUD:SetMsgRead params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
            [_isReadArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            //刷新列表
            [_myTableView reloadData];
        }
    } errorResult:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
