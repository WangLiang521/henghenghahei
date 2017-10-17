//
//  MessageViewController.m
//  YouXingWords
//
//  Created by Apple on 2017/1/19.
//  Copyright © 2017年 孙赵凯. All rights reserved.
// 消息-消息

#import "MessageViewController.h"

#import "MessageModel.h"
#import "MessageTypeModel.h"
#import "MessageCell.h"

#import "MessageMoreInfoVC.h"
#import "NewFriendsVC.h"

//#import "AddFriendsVC.h"

NSComparator cmptr = ^(MessageTypeModel * obj1, MessageTypeModel* obj2){
    
//    return (NSComparisonResult)NSOrderedAscending;
//    1.判断是否有数据,如果一个有数据一个没数据,则有数据的放在前面,都有数据继续第二步,都没有数据,保持顺序
    if ((obj1.messages.count == 0) && (obj2.messages.count > 0)) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ((obj1.messages.count > 0) && (obj2.messages.count == 0)) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    
    if ((obj1.messages.count == 0) && (obj2.messages.count == 0)) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    
    
    
//    2.判断未读,未读的放在已读的之前
    if (obj1.unReadCount > 0 && obj2.unReadCount == 0) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    
    if (obj1.unReadCount == 0 && obj2.unReadCount > 0) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ((obj1.unReadCount == 0 && obj2.unReadCount == 0) || (obj1.unReadCount > 0 && obj2.unReadCount > 0)) {
        
       //    3.判断最后一天的时间,后接收的放在前面
        if (obj1.lastMessageCreatTim > obj2.lastMessageCreatTim) {
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedDescending;
        }

    }
    
    return (NSComparisonResult)NSOrderedSame;
};

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray  *dataSource;

@property (assign, nonatomic)  NSInteger page;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpTableView];
    
    
    

}

//-(void)fanhui {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (NSArray *)getAllMessageType{
    MessageTypeModel * modelXitong = [MessageTypeModel new];
    modelXitong.title =@"系统通知";
    modelXitong.image =@"message_icon_notice";
    modelXitong.type = messageTypeXitong;
    //    messageTypeXitong,
    //    messageTypeMeiri,
    //    messageTypeLeitai,
    //    messageTypeFriend
    
    MessageTypeModel * modelzhanbao = [MessageTypeModel new];
    modelzhanbao.title =@"每日战报";
    modelzhanbao.image =@"message_icon_report";
    modelzhanbao.type = messageTypeMeiri;
    
    MessageTypeModel * modelLeitai = [MessageTypeModel new];
    modelLeitai.title =@"擂台赛";
    modelLeitai.image =@"message_icon_game";
    modelLeitai.type = messageTypeLeitai;
    
    MessageTypeModel * modelFriend = [MessageTypeModel new];
    modelFriend.title =@"好友申请";
    modelFriend.type = messageTypeFriend;
    modelFriend.image =@"message_icon_default";
    
    MessageTypeModel * modelPK = [MessageTypeModel new];
    modelPK.title =@"好友PK";
    modelPK.type = messageTypePK;
    modelPK.image =@"message_icon_default";
    return @[modelXitong,modelzhanbao,modelLeitai,modelFriend,modelPK];
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObjectsFromArray:[self getAllMessageType]];
    }
    return _dataSource;
}



- (void)requestNewDataSourceNewer:(BOOL)newer effectMj:(BOOL)effectMj{
    
    if (newer) {
        self.page = 0;
    }
    
//    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"createTim":@"0"};
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    parameters[@"createTim"] = @(self.page);
    [LGDHttpTool POST:UserMsgList parameters:parameters success:^(NSDictionary *dictJSON) {
        
        if ([dictJSON[@"status"] integerValue] == 1) {
            
            NSArray * array = [self jiexi:dictJSON[@"data"]];
            
            if (array.count > 0 && newer) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray: array];
            [self.tableView reloadData];
            _page ++;
        }
        if (effectMj) {
            if (newer) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        [self requestComplete];
    } failure:^(NSError *error) {
        if (effectMj) {
            if (newer) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [self requestComplete];
        
    }];
}


- (void)requestComplete{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestNewDataSourceNewer:YES effectMj:NO];
    });
}




#pragma mark 解析--添加数据
- (NSArray *)jiexi:(NSArray *)array{
    
    
    
    NSMutableArray * muArray = [NSMutableArray arrayWithArray:[self getAllMessageType]];
    
//    NSMutableArray * muArray = [NSMutableArray array];
    
    NSInteger unReadCount = 0;
    for (NSDictionary * dict  in array) {
        MessageModel * model= [MessageModel mj_objectWithKeyValues:dict];
        model.dict = dict;
        if ([model.isRead integerValue] == 0) {
            unReadCount ++;
            NSLog(@"unReadCount");
            NSLog(@"dict = %@",dict);
        }
        
        
        if (model.type <= 4) {
//            当前已经定义过的信息类型
            for (MessageTypeModel * typeModel in muArray) {
                if (model.type == typeModel.type) {
                    if (!typeModel.messages) {
                        typeModel.messages = [NSMutableArray array];
                    }
                    
                    [typeModel.messages addObject:model];
                    break;
                }
            }
        }else{
//            当前没有定义过的信息类型--后台自己加上了但是没给前台说  直接加到系统通知里
            MessageTypeModel * typeModel = [muArray firstObject];
            if (!typeModel.messages) {
                typeModel.messages = [NSMutableArray array];
            }
            [typeModel.messages addObject:model];
        }
        
        
    }
    
    NSArray * arraySort = [muArray sortedArrayUsingComparator:cmptr];
    NSArray *tabBarItems = self.tabBarController.tabBar.items;
    
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:0];
    
    if (unReadCount > 0) {
        
        personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",unReadCount];
    }else{
        personCenterTabBarItem.badgeValue = nil;
    }
    
    return [NSArray arrayWithArray:arraySort];
}

- (void)refreshHeader{
//    if (!self.dataSource) {
//        self.dataSource = [NSMutableArray array];
//    } else {
//        [self.dataSource removeAllObjects];
//    }
    
    [self requestNewDataSourceNewer:YES effectMj:YES];
}

- (void)refreshFooter{
    [self requestNewDataSourceNewer:NO effectMj:YES];
}



- (void)setUpTableView{
    
//    [[UITableView alloc]initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>]
//    WS(weakSelf);
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(weakSelf.view);
//    }];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageTypeModel class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    [self.tableView.mj_header beginRefreshing];
    
    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    
    
}

#pragma mark TableView -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTypeModel * model = self.dataSource[indexPath.row];
//    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageTypeModel class]) forIndexPath:indexPath];
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageTypeModel class]) ];
    if (cell==nil) {
        cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([MessageTypeModel class]) ];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.noReadLb.hidden=YES;
    //未读小红点
    cell.msgCountLb.hidden = (model.unReadCount == 0);
    
    if (model.unReadCount>99) {
        cell.msgCountLb.text=@"99+";
    }else{
        cell.msgCountLb.text=[NSString stringWithFormat:@"%ld",model.unReadCount];
    }
    
    
    //有数据时才显示时间
    cell.timeLb.hidden = (model.messages.count == 0);
    cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%lld",model.lastMessageCreatTim]];
    
    
    //标题图片
    if ([LGDUtils isValidStr:model.imageUrl]) {
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:model.image]];
    }else{
        cell.iconImg.image = [UIImage imageNamed:model.image];
    }
    
    
    //标题名称
    cell.nameLb.text = model.title;
    cell.contentLb.text = model.subtitle;
    return cell;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

#pragma mark---cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(130);
}
//#pragma mark---cell表头高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return tableView.tag==111?0.01:AutoTrans(90);
//}
#pragma mar k---cell表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark TableView -- delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTypeModel * model = self.dataSource[indexPath.row];
    
    if (model.type != messageTypeFriend ) {
        MessageMoreInfoVC *more=[[MessageMoreInfoVC alloc]init];
        more.iconImg=[UIImage imageNamed:model.image];
//        if (indexPath.row==0) {
            more.dataArr=model.messageDics;
            more.titleStr=model.title;
//        }else if (indexPath.row==1){
//            more.dataArr=self.dataArr1;
//            more.titleStr=@"每日战报";
//        }else if (indexPath.row==2){
//            more.dataArr=self.dataArr2;
//            more.titleStr=@"擂台赛";
//        }
        more.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:more animated:YES];
    }else{
        NewFriendsVC *newFriendVC=[[NewFriendsVC alloc]init];
        newFriendVC.dataArr=model.messageDics;
        newFriendVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newFriendVC animated:YES];
    }
}



@end
