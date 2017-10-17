//
//  NewFriendsVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NewFriendsVC.h"
#import "NewFriendsCell.h"
#import "NewFriendsInfoVC.h"

@interface NewFriendsVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;

@end

@implementation NewFriendsVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.dataArr);
    self.title=@"好友申请";
    //添加tableview
    [self addMyTableView];
    
}
#pragma mark---添加tableview
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.tableFooterView=[UIView new];
    _myTableView.bounces=NO;
    [self.view addSubview:_myTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma mark---cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(130);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"mycell";
    NewFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[NewFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //头像icon
    NSURL *iconImgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"fromUserImage"]]];
    UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
    [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
    //name
    cell.nameLb.text=self.dataArr[indexPath.row][@"fromUser"];
    [cell.nameLb sizeToFit];
    //账号
    cell.nameLb1.frame=CGRectMake(CGRectGetMaxX(cell.nameLb.frame)+5, AutoTrans(30), AutoTrans(200), AutoTrans(50));
    cell.nameLb1.text=self.dataArr[indexPath.row][@"fromUsername"];
    //content
    cell.contentLb.text=self.dataArr[indexPath.row][@"content"];
    [cell.contentLb sizeToFit];
    //同意按钮
    NSInteger isAddFriend=[self.dataArr[indexPath.row][@"isAddFriend"] integerValue];
    NSLog(@"++++++%ld",isAddFriend);
    //未操作
    if (isAddFriend==0) {
        cell.agreeBt.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
        [cell.agreeBt setTitle:@"未操作" forState:UIControlStateNormal];
        [cell.agreeBt addTarget:self action:@selector(agreeBtClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.agreeBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(30)];
        cell.agreeBt.layer.cornerRadius=5;
        cell.agreeBt.layer.masksToBounds=YES;
        cell.agreeBt.tag=2000+indexPath.row;
        //同意
    }else if (isAddFriend==1){
        [cell.agreeBt setTitle:@"已同意" forState:UIControlStateNormal];
        cell.agreeBt.titleLabel.textColor=[UIColor blackColor];
        [cell.agreeBt setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
        cell.agreeBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(24)];
        //已经拒绝
    }else if (isAddFriend==-1){
        [cell.agreeBt setTitle:@"已拒绝" forState:UIControlStateNormal];
        [cell.agreeBt setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
        cell.agreeBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(24)];
    }
//    if (self.dataArr[indexPath.row][@"isRead"] && [self.dataArr[indexPath.row][@"isRead"] integerValue] != 0) {
//        cell.msgCountLb.text = @"1";
//        cell.msgCountLb.hidden = NO;
//    }else{
//        cell.msgCountLb.hidden = YES;
//    }
    return cell;
}
#pragma mark---同意按钮点击
-(void)agreeBtClick:(UIButton *)sender
{
    NewFriendsInfoVC *new=[[NewFriendsInfoVC alloc]init];
    new.userName=self.dataArr[sender.tag-2000][@"fromUsername"];
    new.viewTag=100;
    new.isFriend=[self.dataArr[sender.tag-2000][@"isAddFriend"] integerValue];
    [self.navigationController pushViewController:new animated:YES];
}
//#pragma mark---允许编辑
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//#pragma mark---滑动删除
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *rowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"删除第%ld行",indexPath.row);
//        
//        //        [self.dataArr removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }];
//    return @[rowAction];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.dataArr[indexPath.row];
    NSString * content = dict[@"content"];
    NewFriendsInfoVC *new=[[NewFriendsInfoVC alloc]init];
    new.userName=self.dataArr[indexPath.row][@"fromUsername"];
    new.viewTag=100;
    if ([LGDUtils isValidStr:content] && [content containsString:@"陪伴号"]) {
        new.addtype = AddFriendTypeFamily;
    }else{
        new.addtype = AddFriendTypeFriend;
    }
    new.isFriend=[self.dataArr[indexPath.row][@"isAddFriend"] integerValue];
    [self.navigationController pushViewController:new animated:YES];
    [self setMsgIsRead:indexPath];
}

#pragma mark---设置消息已读
-(void)setMsgIsRead:(NSIndexPath *)indexPath
{
    //设置消息为已读
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"msgIds":self.dataArr[indexPath.row][@"id"]};
    [NetWorkingUtils postWithUrlWithoutHUD:SetMsgRead params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
//            [_isReadArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            //刷新列表
            [_myTableView reloadData];
        }
    } errorResult:^(NSError *error) {
        
    }];
}

@end
