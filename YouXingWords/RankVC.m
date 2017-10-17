//
//  RankVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "RankVC.h"
#import "RankCell.h"
#import "RankModel.h"
#import "FriendRankVC.h"

@interface RankVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)CustomTitleView *titleView;
//数据源
@property(nonatomic,copy)NSMutableArray *rankDataArr;

//分类view
@property(nonatomic,retain)UIView *typeView;
@property(nonatomic,retain)UIButton *typeBt;//分类按钮
@property(nonatomic,retain)UILabel *typeLb;//分类lb
@property(nonatomic,retain)NSArray *typeArr;//分类的数组

//排行榜的tableview
@property(nonatomic,retain)UITableView *rankTableView;

@property (copy, nonatomic)  NSString * paimingStr;

@end

@implementation RankVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

#pragma mark 数据源
-(NSMutableArray *)rankDataArr
{
    if (_rankDataArr==nil) {
        _rankDataArr=[NSMutableArray array];
    }
    return _rankDataArr;
}

#pragma mark 分类数组
-(NSArray *)personTypeArr
{
    NSArray *arr=@[@"昨天",@"上周",@"财富榜"];
//    NSArray *arr=@[@"昨天",@"上周",@"排名",@"财富榜"];
    return arr;
}
#pragma mark 团队排行榜
-(NSArray *)teamTypeArr
{
    NSArray *arr=@[@"昨天",@"上周",@"财富榜"];
    return arr;
}

#pragma mark 前三个cellname颜色数组
-(NSArray *)cellColorArr
{
    NSArray *arr=@[@"#ffa200",@"#4075a5",@"#a25d03"];
    return arr;
}
#pragma mark 前三个cell排行的图片
-(NSArray *)rankCellImgArr
{
    NSArray *arr=@[@"icon_first",@"icon_second",@"icon_third"];
    return arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.titleStr isEqualToString:@"排行榜"]) {
        self.typeArr=self.personTypeArr;
        
    }else if ([self.titleStr isEqualToString:@"团队排行榜"]){
        self.typeArr=self.teamTypeArr;
    }
    if ([Utils getCurrentToken]!=nil) {
        //添加网络数据
        [self addNetData:@"1"];
        //没有登陆或者没有网络
    }else{
        [NetWorkingUtils networkReachable:^{
            [Utils showAlter:@"用户未登陆，有些功能需要登陆后才能使用！" WithTime:2];
        } AndUnreachable:^{
            [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
        }];
    }

    
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加分类view
    [self addTypeView];
}

#pragma mark---加载网络数据
-(void)addNetData:(NSString *)type
{
    
    NSDictionary * userInfo  = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    //移除数据
    [self.rankDataArr removeAllObjects];
    
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"type":type};
    [NetWorkingUtils postWithUrl:self.urlStr params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        //请求成功
        if ([response[@"status"] integerValue]==1) {
            self.paimingStr = @"未进入排名,被鄙视了";
            NSArray * dataArray = response[@"data"];
            NSInteger i = 1;
            for (NSDictionary *dicc in dataArray) {
                RankModel *model=[RankModel rankModelWith:dicc];
                [self.rankDataArr addObject:model];
                if ([self.titleStr isEqualToString:@"排行榜"]) {
                    if ([userInfo[@"username"] isEqualToString:model.username]) {
                        self.paimingStr = [NSString stringWithFormat:@"我的排名:第%zd名",i];
                    }
                }else{
                    if ([userInfo[@"username"] integerValue] == [model.schId integerValue]) {
                        self.paimingStr = [NSString stringWithFormat:@"我的团队排名:第%zd名",i];
                    }
                }
                
                
                i ++;
            }
            if (_rankTableView==nil) {
                //添加排行榜
                [self addRankTableView];
            }else{
                [_rankTableView reloadData];
            }
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
        if (_rankTableView==nil) {
            //添加排行榜
            [self addRankTableView];
        }else{
            [_rankTableView reloadData];
        }
    }];
}

#pragma mark---添加背景图
-(void)addBackgroundView
{
    CGRect frame = frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);;

    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:frame];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
}
#pragma mark---添加表头
-(void)addTitleView
{
    WS(weakSelf);
    if ([self.titleStr isEqualToString:@"排行榜"]) {
//        _titleView=[CustomTitleView customTitleView:self.titleStr rightTitle:@"好友" leftBtAction:^{
//            //返回上一个页面
//            [self.navigationController popViewControllerAnimated:YES];
//        } rightBtAction:^{
//            //
//            NSLog(@"rightBtAction");
//            FriendRankVC * vc = [FriendRankVC new];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }];
    }else{
        _titleView=[CustomTitleView customTitleView:self.titleStr rightTitle:@"" leftBtAction:^{
            //返回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
        } rightBtAction:^{
            //
            
        }];
    }
  
    [self.view addSubview:_titleView];
}
#pragma mark---添加分类view
-(void)addTypeView
{
    _typeView=[[UIView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_titleView.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(60)), AutoTrans(80))];
    _typeView.backgroundColor=[UIColor whiteColor];
    _typeView.layer.cornerRadius=CGRectGetHeight(_typeView.frame)/4;
    _typeView.layer.masksToBounds=YES;
    _typeView.clipsToBounds=YES;
    [self.view addSubview:_typeView];
    for (int i=0; i<self.typeArr.count; i++) {
        CGFloat typeBtWidth=(CGRectGetWidth(_typeView.frame)-(AutoTrans(40)))/self.typeArr.count;
        //分类按钮
        _typeBt=[[UIButton alloc]initWithFrame:CGRectMake((AutoTrans(20))+typeBtWidth*i, 0, typeBtWidth, CGRectGetHeight(_typeView.frame))];
        [_typeBt setTitle:self.typeArr[i] forState:UIControlStateNormal];
        _typeBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(36)];
        if (i==0) {
            [_typeBt setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateNormal];
            //分类的label
            _typeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_typeBt.frame), CGRectGetHeight(_typeView.frame)-3, typeBtWidth, 3)];
            _typeLb.backgroundColor=[UIColor colorWithHexString:@"#ffa200"];
            [_typeView addSubview:_typeLb];
        }else{
            [_typeBt setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }
        _typeBt.tag=600+i;
        [_typeBt addTarget:self action:@selector(typeBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [_typeView addSubview:_typeBt];
    }
}
#pragma mark---分类按钮点击事件
-(void)typeBtClick:(UIButton *)sender
{
    //分类按钮下的横条滑动
    UIButton *button=(UIButton *)[self.view viewWithTag:600];
    [UIView animateWithDuration:0.3 animations:^{
        _typeLb.frame=CGRectMake(CGRectGetMinX(button.frame)+CGRectGetWidth(sender.frame)*(sender.tag-600), CGRectGetHeight(_typeView.frame)-3, CGRectGetWidth(sender.frame), 3);
    }];
    //按钮字体颜色变换
    for (int i=0; i<self.typeArr.count; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:i+600];
        if (button.tag==sender.tag) {
            [button setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }
    }
    
    if ([self.titleStr isEqualToString:@"团队排行榜"]&&sender.tag==602) {
        //点击按钮刷新列表
//        [self addNetData:@"4"];
        if ([Utils getCurrentToken]!=nil) {
            //添加网络数据
            [self addNetData:@"4"];
            //没有登陆或者没有网络
        }else{
            [NetWorkingUtils networkReachable:^{
                [Utils showAlter:@"用户未登陆，有些功能需要登陆后才能使用！" WithTime:2];
            } AndUnreachable:^{
                [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
            }];
        }

    }else{
        //点击按钮刷新列表
        NSString *type=[NSString stringWithFormat:@"%ld",sender.tag-600+1];
        if ([Utils getCurrentToken]!=nil) {
            //添加网络数据
            [self addNetData:type];
            //没有登陆或者没有网络
        }else{
            [NetWorkingUtils networkReachable:^{
                [Utils showAlter:@"用户未登陆，有些功能需要登陆后才能使用！" WithTime:2];
            } AndUnreachable:^{
                [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
            }];
        }
    }
    
    
    
}
#pragma mark---排行榜的tableview
-(void)addRankTableView
{
    CGFloat rankTableViewHeight=SCREEN_HEIGHT-30-(AutoTrans(80))-(AutoTrans(100))-(AutoTrans(20))-(AutoTrans(50));
    
    _rankTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_typeView.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(60)), rankTableViewHeight) style:UITableViewStyleGrouped];
    _rankTableView.delegate=self;
    _rankTableView.dataSource=self;
    _rankTableView.backgroundColor = [UIColor whiteColor];
    UIView * footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, _rankTableView.width, 1);
    _rankTableView.tableFooterView=footerView;
    _rankTableView.layer.cornerRadius=(SCREEN_WIDTH-(AutoTrans(60)))/16;
    _rankTableView.layer.masksToBounds=YES;
    _rankTableView.bounces=NO;
    _rankTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _rankTableView.showsVerticalScrollIndicator=NO;
//    _rankTableView.style = UITableViewStyleGrouped;
    [self.view addSubview:_rankTableView];
}
#pragma mark---cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankDataArr.count;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(160);
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (indexPath.row<3) {
        static NSString *cellID=@"cellID";
        
        RankCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[RankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //加载model数据
        RankModel *model=self.rankDataArr[indexPath.row];
        //排行图片
        cell.rankImg.image=[UIImage imageNamed:self.rankCellImgArr[indexPath.row]];
        //头像icon
        NSURL *iconImgUrl=[NSURL URLWithString:model.signPhoto];
        UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
        [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
        //名称
//        cell.nameLb.textColor=[UIColor colorWithHexString:self.cellColorArr[indexPath.row]];
        cell.nameLb.text=model.name;
        [cell.nameLb sizeToFit];
        //start
#pragma mark gd_排名的地方苹果版没有显示时间  2017-03-11 21:46:07
        //        cell.nameLb.text=model.name;
        //        [cell.timeLb sizeToFit];
        NSString * strTime = nil;
        if ([model.sdutyTime isEqual:[NSNull null]]) {
            strTime = @"0分钟";
        }else{
            //start
#pragma mark gd_排行榜时间不正确  2017-03-22 11:02:05-4
            //            strTime = [NSString stringWithFormat:@"%@分钟",model.sdutyTime];
            strTime = [LGDUtils changeSecondsToHour:model.sdutyTime];
            //end
        }
        cell.timeLb.text = strTime;
        [cell.timeLb sizeToFit];
        //end
        //地点
        if ([self.titleStr isEqualToString:@"团队排行榜"]) {
            cell.placeLb.hidden=YES;
        }else{
            cell.placeLb.text=model.address;
        }
        //钻石数量
        cell.diamondLb.text=[NSString stringWithFormat:@"%@",model.coins];
        
        if ([model.schId integerValue] == [userInfo[@"schId"] integerValue]) {
            cell.nameLb.textColor = [UIColor redColor];
        }
        return cell;
    }else{
        static NSString *cellID=@"cellID1";
        
        RankCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[RankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //排行label
        cell.rankLb.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        //加载model数据
        RankModel *model=self.rankDataArr[indexPath.row];
        //头像icon
        NSURL *iconImgUrl=[NSURL URLWithString:model.signPhoto];
        UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
        [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
        //名称
        cell.nameLb.text=model.name;
        [cell.nameLb sizeToFit];
        //时间

        //start
#pragma mark gd_排名的地方苹果版没有显示时间  2017-03-11 21:46:07
        //        cell.nameLb.text=model.name;
        //        [cell.timeLb sizeToFit];
        NSString * strTime = nil;
        if ([model.sdutyTime isEqual:[NSNull null]]) {
            strTime = @"0分钟";
        }else{
            //start
#pragma mark gd_排行榜时间不正确  2017-03-22 11:02:05-4
            
//            strTime = [NSString stringWithFormat:@"%@分钟",model.sdutyTime];
            strTime = [LGDUtils changeSecondsToHour:model.sdutyTime];
            //end
           
        }
        cell.timeLb.text = strTime;
        [cell.timeLb sizeToFit];
        //end
        
        //地点
        if ([self.titleStr isEqualToString:@"团队排行榜"]) {
            cell.placeLb.hidden=YES;
        }else{
            cell.placeLb.text=model.address;
        }
        //钻石数量
        cell.diamondLb.text=[NSString stringWithFormat:@"%@",model.coins];
        if ([model.schId integerValue] == [userInfo[@"schId"] integerValue]) {
            cell.nameLb.textColor = [UIColor redColor];
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * lblRank = [UILabel new];
    lblRank.textAlignment = NSTextAlignmentCenter;
    lblRank.font = [UIFont systemFontOfSize:15];
    lblRank.textColor = [UIColor colorWithHexString:@"333333"];
    lblRank.text = self.paimingStr;
    lblRank.backgroundColor = [UIColor whiteColor];
//    headerView.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    lblRank.frame = CGRectMake(0, 8, SCREEN_WIDTH, 20);
    [headerView addSubview:lblRank];
    return headerView;
}


@end
