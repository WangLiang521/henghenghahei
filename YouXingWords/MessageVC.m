//
//  MessageVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//消息-通讯录

#import "MessageVC.h"
#import "MessageCell.h"
#import "NewFriendsVC.h"//好友申请
#import "MessageMoreInfoVC.h"//消息详情
#import "NewFriendsInfoVC.h"//好友详情
#import "AddNewFriendVC.h"//添加好友详情

#import "AddFriendsTypeVC.h"

#import "EaseUI.h"

#import "MessageViewController.h"

@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

//数据源
//消息界面
@property(nonatomic,copy)NSMutableArray *contentDataArr;
@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *dataArr1;
@property(nonatomic,copy)NSMutableArray *dataArr2;
@property(nonatomic,copy)NSMutableArray *dataArr3;
//小红点上的个数
@property(nonatomic,copy)NSMutableArray *dataCountArr;
@property(nonatomic,copy)NSMutableArray *dataCountArr1;
@property(nonatomic,copy)NSMutableArray *dataCountArr2;
@property(nonatomic,copy)NSMutableArray *dataCountArr3;



//通讯录界面
@property(nonatomic,copy)NSMutableArray *addressContentArr;

@property (nonatomic) NSMutableDictionary *emotionDic;

@property(nonatomic,copy)NSMutableDictionary *isOpenDic;
@property(nonatomic,copy)NSString *isOpen;//是否展开

@property(nonatomic,assign)NSInteger sectionNum;//组
@property(nonatomic,assign)NSInteger rowNum;//行
//标题
@property(nonatomic,retain)UIView *tittleView;//标题view
@property(nonatomic,retain)UISegmentedControl *segmentBt;//分段按钮
//滑动视图
@property(nonatomic,retain)UIScrollView *myScrollView;//滑动视图
@property(nonatomic,retain)UITableView *msgTableView;//消息tableView


@end

@implementation MessageVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
    
    
    
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil]];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

#pragma mark---标题名称
-(NSArray *)titleArr
{
    NSArray *arr=@[@"系统通知",@"每日战报",@"擂台赛",@"好友申请"];
    return arr;
}
#pragma mark---标题的图片
-(NSArray *)titleImgArr
{
    NSArray *arr=@[@"message_icon_notice",@"message_icon_report",@"message_icon_game"];
    return arr;
}
-(NSMutableArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArr1
{
    if (_dataArr1==nil) {
        _dataArr1=[NSMutableArray array];
    }
    return _dataArr1;
}
-(NSMutableArray *)dataArr2
{
    if (_dataArr2==nil) {
        _dataArr2=[NSMutableArray array];
    }
    return _dataArr2;
}
-(NSMutableArray *)dataArr3
{
    if (_dataArr3==nil) {
        _dataArr3=[NSMutableArray array];
    }
    return _dataArr3;
}
#pragma mark---小红点个数数组
-(NSMutableArray *)dataCountArr
{
    if (_dataCountArr==nil) {
        _dataCountArr=[NSMutableArray array];
    }
    return _dataCountArr;
}
-(NSMutableArray *)dataCountArr1
{
    if (_dataCountArr1==nil) {
        _dataCountArr1=[NSMutableArray array];
    }
    return _dataCountArr1;
}
-(NSMutableArray *)dataCountArr2
{
    if (_dataCountArr2==nil) {
        _dataCountArr2=[NSMutableArray array];
    }
    return _dataCountArr2;
}
-(NSMutableArray *)dataCountArr3
{
    if (_dataCountArr3==nil) {
        _dataCountArr3=[NSMutableArray array];
    }
    return _dataCountArr3;
}
-(NSMutableArray *)contentDataArr
{
    if (_contentDataArr==nil) {
        _contentDataArr=[NSMutableArray array];
    }
    return _contentDataArr;
}
#pragma mark---通讯录分组标题
-(NSArray *)addressTitleArr
{
    NSArray *arr=@[@"陪伴号",@"朋友",@"同学"];
    return arr;
}
#pragma mark---通讯录分组具体内容
-(NSMutableArray *)addressContentArr
{
    if (_addressContentArr==nil) {
        _addressContentArr=[NSMutableArray array];
    }
    return _addressContentArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:AddressNotification object:nil];
    
    //解决导航栏坐标问题
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //通讯录分组展开或者合并
    _isOpenDic=[NSMutableDictionary dictionary];
    for(int i=0; i<self.addressTitleArr.count;i++){
        
        
        //start
#pragma mark gd_默认全部打开  2017-01-16
        [_isOpenDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",i]];
//        if (i==0) {
//            [_isOpenDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",i]];
//        }else{
//            [_isOpenDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
//        }
        //end
    }
    
    if ([Utils getCurrentToken]!=nil) {
        //添加消息界面网络数据
        [self addMessageNetData];
    //没有登陆或者没有网络
    }else{
        [NetWorkingUtils networkReachable:^{
            [Utils showAlter:@"用户未登陆，有些功能需要登陆后才能使用！" WithTime:2];
        } AndUnreachable:^{
            [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
        }];
    }
        
}
#pragma mark---请求消息界面网络数据
-(void)addMessageNetData
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"createTim":@"0"};
    [NetWorkingUtils postWithUrlWithoutHUD:UserMsgList params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
            if ([response[@"size"] integerValue]!=0) {
                _msgTableView.hidden=NO;
//                NSLog(@"%@",response);
                //移除原有的数据
                [self.dataArr removeAllObjects];
                [self.dataArr1 removeAllObjects];
                [self.dataArr2 removeAllObjects];
                [self.dataArr3 removeAllObjects];
                [self.contentDataArr removeAllObjects];
                [self.dataCountArr removeAllObjects];
                [self.dataCountArr1 removeAllObjects];
                [self.dataCountArr2 removeAllObjects];
                [self.dataCountArr3 removeAllObjects];
                
                for (NSDictionary *dicc in response[@"data"]) {
                    if ([dicc[@"type"] integerValue]==0) {
                        [self.dataArr addObject:dicc];
                    }else if ([dicc[@"type"] integerValue]==1){
                        [self.dataArr1 addObject:dicc];
                    }else if ([dicc[@"type"] integerValue]==2){
                        [self.dataArr2 addObject:dicc];
                    }else if ([dicc[@"type"] integerValue]==3){
                        [self.dataArr3 addObject:dicc];
                    }
                }
                
                NSInteger redCount = 0;
                //系统通知
                if (self.dataArr.count!=0) {
                    [self.contentDataArr addObject:self.dataArr[0]];
                    //添加小红点个数数组
                    for (NSDictionary *dicc in self.dataArr) {
                        if ([dicc[@"isRead"] integerValue]==0) {
                            [self.dataCountArr addObject:@"1"];
                            redCount ++;
                        }
                    }
                }else{
                    [self.contentDataArr addObject:@""];
                }
                //每日战报
                if (self.dataArr1.count!=0) {
                    [self.contentDataArr addObject:self.dataArr1[0]];
                    //添加小红点个数数组
                    for (NSDictionary *dicc in self.dataArr1) {
                        if ([dicc[@"isRead"] integerValue]==0) {
                            [self.dataCountArr1 addObject:@"1"];
                            redCount ++;
                        }
                    }
                }else{
                    [self.contentDataArr addObject:@""];
                }
                //擂台赛
                if (self.dataArr2.count!=0) {
                    [self.contentDataArr addObject:self.dataArr2[0]];
                    //添加小红点个数数组
                    for (NSDictionary *dicc in self.dataArr2) {
                        if ([dicc[@"isRead"] integerValue]==0) {
                            [self.dataCountArr2 addObject:@"1"];
                            redCount ++;
                        }
                    }
                }else{
                    [self.contentDataArr addObject:@""];
                }
                //好友申请
                if (self.dataArr3.count!=0) {
                    [self.contentDataArr addObject:self.dataArr3[0]];
                    //添加小红点个数数组
                    for (NSDictionary *dicc in self.dataArr3) {
                        if ([dicc[@"isRead"] integerValue]==0) {
                            [self.dataCountArr3 addObject:@"1"];
                            redCount ++;
                        }
                    }
                }else{
                    [self.contentDataArr addObject:@""];
                }
                
                if (redCount > 0) {
                    NSArray *tabBarItems = self.tabBarController.tabBar.items;
                    
                    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:0];
                    
                    personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",redCount];
                }
                
//                self.tabBarController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",redCount];
                
                if (_myScrollView==nil) {
                    //添加标题
                    [self addTitleView];
                    //添加滑动视图
                    [self addScrollView];
                }else{
                    [_msgTableView reloadData];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //实时请求数据
                    [self addMessageNetData];
                });
                

            }else{
                if (_myScrollView==nil) {
                    //添加标题
                    [self addTitleView];
                    //添加滑动视图
                    [self addScrollView];
                }else{
                    _msgTableView.hidden=YES;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //实时请求数据
                    [self addMessageNetData];
                });
            }
        }
    } errorResult:^(NSError *error) {
        NSLog(@"请求失败");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //实时请求数据
            [self addMessageNetData];
        });
    }];
}


#pragma mark---加载通讯录网络数据
-(void)addAddressNetData
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken]};
    [NetWorkingUtils postWithUrlWithoutHUD:UserPhoneAdress params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        
        [self.addressContentArr removeAllObjects];
        NSMutableArray *tempArr=[NSMutableArray array];
        
        NSMutableArray * arrayFamily = [NSMutableArray arrayWithArray:response[@"info"][@"family"]];
        
        [arrayFamily  addObject:@{@"addFamily":@"addFamily"} ];
        //家人
        [tempArr addObject:arrayFamily];
        //朋友
        [tempArr addObject:response[@"info"][@"friends"]];
        //同学
        [tempArr addObject:response[@"info"][@"classmates"]];
        //添加本地缓存
        [[NSUserDefaults standardUserDefaults]setObject:tempArr forKey:@"address"];
//        //获取本地缓存
//        NSArray *localArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
        [self.addressContentArr addObjectsFromArray:tempArr];
        
        if (_addressTableView==nil) {
            //创建通讯录view
            [self addAddressTableView];
        }else{
            [_addressTableView reloadData];
        }
    } errorResult:^(NSError *error) {
        
    }];
}
#pragma mark---添加标题
-(void)addTitleView
{
    //start
#pragma mark gd_  2017-01-19
//    _tittleView=[[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
//    _tittleView.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
//    //navigationBar添加分段按钮
//    [self.navigationController.navigationBar addSubview:_tittleView];
//    
//    //添加分段按钮
//    NSArray *itemsArr=@[@"消息",@"通讯录"];
//    _segmentBt=[[UISegmentedControl alloc]initWithItems:itemsArr];
//    _segmentBt.frame=CGRectMake(SCREEN_WIDTH/2-60,25,120, 33);
//    _segmentBt.tintColor=[UIColor whiteColor];
//    _segmentBt.selectedSegmentIndex=0;
//    [_segmentBt addTarget:self action:@selector(segmentBtClick:) forControlEvents:UIControlEventValueChanged];
//    [_tittleView addSubview:_segmentBt];
//    //➕按钮
//    UIButton *addBt=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, CGRectGetMinY(_segmentBt.frame)+6.5, 20, 20)];
//    addBt.titleLabel.font=[UIFont systemFontOfSize:30];
//    [addBt addTarget:self action:@selector(addBtClick) forControlEvents:UIControlEventTouchUpInside];
//    [addBt setTitle:@"+" forState:UIControlStateNormal];
//    [_tittleView addSubview:addBt];
    
    //end
}
//#pragma mark---添加好友界面
//-(void)addBtClick
//{
//    //添加好友界面
//    AddNewFriendVC *add=[[AddNewFriendVC alloc]init];
//    add.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:add animated:YES];
//}

#pragma mark---分段按钮点击
-(void)segmentBtClick:(UISegmentedControl *)segmentBt
{
    if (segmentBt.selectedSegmentIndex==0) {
        [_myScrollView setContentOffset:CGPointMake(0, 0)];
    }else{
        [_myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        //请求通讯录数据
        [self addAddressNetData];
    }
}
#pragma mark---添加滑动视图
-(void)addScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _myScrollView.backgroundColor=[UIColor whiteColor];
    _myScrollView.tag=888;
    _myScrollView.delegate=self;
    [self.view addSubview:_myScrollView];
    
    //添加消息界面
    [self addMessageView];
}
#pragma mark---添加消息界面
-(void)addMessageView
{
    //start
#pragma mark gd_隐藏原message  2017-01-19  
//        _msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_myScrollView.frame)) style:UITableViewStyleGrouped];
    
    _msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(_myScrollView.frame)) style:UITableViewStyleGrouped];
    _msgTableView.hidden = YES;
    
    
    //end
    _msgTableView.delegate=self;
    _msgTableView.dataSource=self;
    _msgTableView.tag=111;
    _msgTableView.backgroundColor=[UIColor whiteColor];
    _msgTableView.bounces=NO;
    
//    [_myScrollView addSubview:_msgTableView];
    
    [self addAddressNetData];
}
#pragma mark----添加通讯录界面
-(void)addAddressTableView
{
    //start
#pragma mark gd_隐藏原message  2017-01-19
    _addressTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-64-49)) style:UITableViewStyleGrouped];
//        _addressTableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_myScrollView.frame)) style:UITableViewStyleGrouped];
    //end
    _addressTableView.delegate=self;
    _addressTableView.dataSource=self;
    _addressTableView.tag=222;
    _addressTableView.bounces=NO;
    [_myScrollView addSubview:_addressTableView];
    //表头view
    //    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(98))];
    //    searchBar.barTintColor=[UIColor colorWithHexString:@"#e8edf1"];
    //    searchBar.placeholder=@"搜索";
    //    _addressTableView.tableHeaderView=searchBar;
}

#pragma mark---cell的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==111) {
        return self.contentDataArr.count;
    }else{
        _isOpen =[_isOpenDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
        NSInteger count = [_isOpen isEqualToString:@"YES"]?[self.addressContentArr[section] count]:0;
        return count;
    }
}
#pragma mark---cell组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView.tag==111?1:self.addressTitleArr.count;
}
#pragma mark---cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(130);
}
#pragma mark---cell表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.tag==111?0.01:AutoTrans(90);
}
#pragma mark---cell表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.8;
}
#pragma mark---表头数据
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==111) {
        return nil;
    }else{
        UIView *typeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(90))];
        typeView.tag=30+section;
        typeView.backgroundColor=[UIColor whiteColor];
        //箭头
        UIImageView *arowImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(35), AutoTrans(20), AutoTrans(20))];
        _isOpen =[_isOpenDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
        NSString * arrowName = [_isOpen isEqualToString:@"YES"]?@"icon_arrow_down":@"icon_arrow_Left";
        arowImg.image=[UIImage imageNamed:arrowName];
        [typeView addSubview:arowImg];
        //分组类别
        UILabel *typeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(arowImg.frame)+(AutoTrans(20)), AutoTrans(20), AutoTrans(200), AutoTrans(50))];
        typeLb.text=self.addressTitleArr[section];
        typeLb.textColor=[UIColor colorWithHexString:@"#333333"];
        typeLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [typeView addSubview:typeLb];
        //点击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [typeView addGestureRecognizer:tap];
        
        return typeView;
    }
}
#pragma mark---表头添加点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    NSInteger section=tap.view.tag-30;
    
    _isOpen =[_isOpenDic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    
    if ([_isOpen isEqualToString:@"YES"]) {
        _isOpen=@"NO";
    }else if ([_isOpen isEqualToString:@"NO"]){
        _isOpen=@"YES";
    }
    [_isOpenDic setObject:_isOpen forKey:[NSString stringWithFormat:@"%ld", section]];
    //刷新section
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:section];
    [_addressTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark---加载cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==111) {
        static NSString *cellID=@"mycell";
        MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //未读小红点
        cell.noReadLb.hidden=YES;
        //标题图片
        if (indexPath.row<3) {
            cell.iconImg.image=[UIImage imageNamed:self.titleImgArr[indexPath.row]];
        }else{
            NSURL *iconImgUrl;
            if (self.dataArr3.count!=0) {
               iconImgUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArr3[0][@"fromUserImage"]]];
            }else{
               iconImgUrl=[NSURL URLWithString:@""];
            }
            UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
            [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
        }
        //标题名称
        cell.nameLb.text = self.titleArr[indexPath.row];
        //详细内容
        //暂无数据
        if ([[self.contentDataArr[indexPath.row] class] isSubclassOfClass:[NSString class]]) {
            cell.contentLb.text=@"暂无数据";
        }else{
            cell.contentLb.text=self.contentDataArr[indexPath.row][@"content"];
        }
        //个数和时间
        //系统通知
        if (indexPath.row==0) {
            //没有未读数据时隐藏小红点和时间
            if (self.dataCountArr.count==0) {
                cell.msgCountLb.hidden=YES;
                cell.timeLb.hidden=YES;
            }else{
                cell.msgCountLb.hidden=NO;
                cell.timeLb.hidden=NO;
                //数据大于99时显示99
                if (self.dataCountArr.count>99) {
                    cell.msgCountLb.text=@"99";
                }else{
                    cell.msgCountLb.text=[NSString stringWithFormat:@"%ld",self.dataCountArr.count];
                }
                //有数据时才显示时间
                cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%@",self.dataArr[0][@"createTim"]]];
            }
        }
        //每日战报
        if (indexPath.row==1){
            //没有数据时隐藏小红点和时间
            if (self.dataCountArr1.count==0) {
                cell.msgCountLb.hidden=YES;
                cell.timeLb.hidden=YES;
            }else{
                cell.msgCountLb.hidden=NO;
                cell.timeLb.hidden=NO;
                //数据大于99时显示99
                if (self.dataArr1.count>99) {
                    cell.msgCountLb.text=@"99";
                }else{
                    cell.msgCountLb.text=[NSString stringWithFormat:@"%ld",self.dataCountArr1.count];
                }
                //有数据时才显示时间
                cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%@",self.dataArr1[0][@"createTim"]]];
            }
        }
        //擂台赛
        if (indexPath.row==2){
            //没有数据时隐藏小红点和时间
            if (self.dataCountArr2.count==0) {
                cell.msgCountLb.hidden=YES;
                cell.timeLb.hidden=YES;
            }else{
                cell.msgCountLb.hidden=NO;
                cell.timeLb.hidden=NO;
                //数据大于99时显示99
                if (self.dataArr2.count>99) {
                    cell.msgCountLb.text=@"99";
                }else{
                    cell.msgCountLb.text=[NSString stringWithFormat:@"%ld",self.dataCountArr2.count];
                }
                //有数据时才显示时间
                cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%@",self.dataArr2[0][@"createTim"]]];
            }
        }
        //好友申请
        if (indexPath.row==3){
            //没有数据时隐藏小红点和时间
            if (self.dataCountArr3.count==0) {
                cell.msgCountLb.hidden=YES;
                cell.timeLb.hidden=YES;
            }else{
                cell.msgCountLb.hidden=NO;
                cell.timeLb.hidden=NO;
                //数据大于99时显示99
                if (self.dataArr3.count>99) {
                    cell.msgCountLb.text=@"99";
                }else{
                    cell.msgCountLb.text=[NSString stringWithFormat:@"%ld",self.dataCountArr3.count];
                }
                //有数据时才显示时间
                cell.timeLb.text=[Utils getDateStrByTimeStamp:[NSString stringWithFormat:@"%@",self.dataArr3[0][@"createTim"]]];
            }
        }
        return cell;
    }else{
        static NSString *cellID=@"yourcell";
        MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        NSDictionary * friendInfo = self.addressContentArr[indexPath.section][indexPath.row];
        if ([LGDUtils isValidStr:friendInfo[@"addFamily"]]) {
            UIImage *placeholderImage=[UIImage imageNamed:@"icon_addFamily"];
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:placeholderImage];
            cell.nameLb.text=@"添加陪伴号";
            cell.contentLb.text = @"邀请QQ/微信好友陪伴";
            cell.msgCountLb.hidden=YES;
        }else{
            //头像icon
            NSURL *iconImgUrl=[NSURL URLWithString:self.addressContentArr[indexPath.section][indexPath.row][@"signPhoto"]];
            UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
            [cell.iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
            //start
#pragma mark gd_只显示姓名,不显示备注  <#时间#>-<#编号#>
            //非同学关系显示备注    isFriend 是否是朋友（0:同学关系，1朋友关系）
            //        NSInteger isFriend=[self.addressContentArr[indexPath.section][indexPath.row][@"isFriend"] integerValue];
            //        if (isFriend==0) {
            cell.nameLb.text=self.addressContentArr[indexPath.section][indexPath.row][@"name"];
            //        }else if(isFriend==1){
            //            //如果有备注显示备注，无备注显示真名
            //            NSString *remarkName=self.addressContentArr[indexPath.section][indexPath.row][@"remarkName"];
            //            if ([remarkName isEqualToString:@""]) {
            //                cell.nameLb.text=self.addressContentArr[indexPath.section][indexPath.row][@"name"];
            //            }else{
            //                cell.nameLb.text=remarkName;
            //            }
            //        }
            //end
            //昨天的练习时间
            //start
#pragma mark gd_修改学习不对,秒转分钟  2017-03-27 16:49:55-3
            NSInteger day1 = [LGDUtils changeSecondsToMinute:self.addressContentArr[indexPath.section][indexPath.row][@"st1day"]];
            //        NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%@分钟",self.addressContentArr[indexPath.section][indexPath.row][@"st1day"]];
            NSString *timeStr=[NSString stringWithFormat:@"昨天练习了%zd分钟",day1];
            //end
            
            cell.contentLb.text=timeStr;
            cell.msgCountLb.hidden=YES;
        }
        return cell;
    }
}
#pragma mark---cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消息界面
    if (tableView.tag==111) {
        if (indexPath.row<3) {
            MessageMoreInfoVC *more=[[MessageMoreInfoVC alloc]init];
            more.iconImg=[UIImage imageNamed:self.titleImgArr[indexPath.row]];
            if (indexPath.row==0) {
                more.dataArr=self.dataArr;
                more.titleStr=@"系统通知";
            }else if (indexPath.row==1){
                more.dataArr=self.dataArr1;
                more.titleStr=@"每日战报";
            }else if (indexPath.row==2){
                more.dataArr=self.dataArr2;
                more.titleStr=@"擂台赛";
            }
            more.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:more animated:YES];
        }else{
            NewFriendsVC *newFriendVC=[[NewFriendsVC alloc]init];
            newFriendVC.dataArr=self.dataArr3;
            newFriendVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:newFriendVC animated:YES];
        }
        //通讯录界面
    }else{
        
        /*
         _sectionNum=indexPath.section;
         _rowNum=indexPath.row;
         EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:self.addressContentArr[indexPath.section][indexPath.row][@"hxAccount"] conversationType:EMConversationTypeChat];
         chatController.hidesBottomBarWhenPushed = YES;
         chatController.delegate=self;
         chatController.dataSource=self;
         NSString *remarkNameStr=self.addressContentArr[indexPath.section][indexPath.row][@"remarkName"];
         if ([remarkNameStr isEqualToString:@""]) {
         chatController.title=self.addressContentArr[indexPath.section][indexPath.row][@"name"];
         }else{
         chatController.title=remarkNameStr;
         }
         [self.navigationController pushViewController:chatController animated:YES];
         */
        
        NSDictionary * friendInfo = self.addressContentArr[indexPath.section][indexPath.row];
        if ([LGDUtils isValidStr:friendInfo[@"addFamily"]]) {
//            点击了添加陪伴号
            [self addFriend];
        }else{
            NSInteger group=indexPath.section;
            NSInteger number=indexPath.row;
            NSDictionary *tempDic=@{@"group":@(group),@"number":@(number)};
            
            NewFriendsInfoVC *newFriendsInfo=[[NewFriendsInfoVC alloc]init];
            newFriendsInfo.userName=self.addressContentArr[indexPath.section][indexPath.row][@"friAccount"];
            newFriendsInfo.viewTag=200;
            newFriendsInfo.noteStr=self.addressContentArr[indexPath.section][indexPath.row][@"remarkName"];
            if (indexPath.section==0) {
                newFriendsInfo.groupStr=@"陪伴号";
            }else if(indexPath.section==1){
                newFriendsInfo.groupStr=@"朋友";
            }
            newFriendsInfo.tempDic=tempDic;
            newFriendsInfo.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:newFriendsInfo animated:YES];

        }
        
        
      
        
        
    }
}

- (void)addFriend{
    //    AddNewFriendVC *vc = [[AddNewFriendVC alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    //#import "AddFriendsTypeVC.h"
    AddFriendsTypeVC *vc = [[AddFriendsTypeVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = AddFriendTypeFamily;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark---EaseMessageViewControllerDataSource
//具体样例：
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    //用户可以根据自己的用户体系，根据message设置用户昵称和头像
    //    id<IMessageModel> model = nil;
    EaseMessageModel *model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"message_icon_default"];//默认头像
    model.nickname = @"";//用户昵称
    //发送方
    if (model.isSender) {
    //接收方
    }else{
    }
    return model;
}
#pragma mark---EaseMessageViewControllerDelegate
//获取用户点击头像回调的样例：
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    //点击接收方的头像
    if (!messageModel.isSender) {
        NSDictionary *tempDic=@{@"group":@(_sectionNum),@"number":@(_rowNum)};
        NewFriendsInfoVC *newFriendsInfo=[[NewFriendsInfoVC alloc]init];
        newFriendsInfo.userName=self.addressContentArr[_sectionNum][_rowNum][@"friAccount"];
        newFriendsInfo.viewTag=200;
        newFriendsInfo.noteStr=self.addressContentArr[_sectionNum][_rowNum][@"remarkName"];
        if (_sectionNum==0) {
            newFriendsInfo.groupStr=@"陪伴号";
        }else if(_sectionNum==1){
            newFriendsInfo.groupStr=@"朋友";
        }
        newFriendsInfo.tempDic=tempDic;
        [self.navigationController pushViewController:newFriendsInfo animated:YES];
    }

}
#pragma mark--cell允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //朋友跟家人可以删除，同学不可以删除
    if (tableView.tag==222&&(indexPath.section==0||indexPath.section==1)) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==222) {
        
        // 添加一个删除按钮
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction*action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            // 1. 删除网络数据数据
            NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":self.addressContentArr[indexPath.section][indexPath.row][@"friAccount"]};
            [NetWorkingUtils postWithUrlWithoutHUD:DeleteFriend params:paraDic successResult:^(id response) {
                if ([response[@"status"] integerValue]==1) {
                    //2.删除本地缓存数据
                    //获取本地缓存
                    NSArray  *localArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
                    NSMutableArray *localMutableArr=[NSMutableArray array];
                    [localMutableArr addObjectsFromArray:localArr];
                    //获取本地朋友或者家人的数组
                    NSArray *friendArr=localMutableArr[indexPath.section];
                    NSMutableArray *friendMutableArr=[NSMutableArray array];
                    [friendMutableArr addObjectsFromArray:friendArr];
                    //获取同学的数组
                    NSArray *classArr=localMutableArr[2];
                    NSMutableArray *classMutableArr=[NSMutableArray array];
                    [classMutableArr addObjectsFromArray:classArr];
                    //将删除的数据添加到同学数组中
                    [classMutableArr insertObject:friendMutableArr[indexPath.row] atIndex:0];
                    //删除家人或者朋友选中行的数据
                    [friendMutableArr removeObjectAtIndex:indexPath.row];
                    //替代朋友或者家人数据
                    [localMutableArr replaceObjectAtIndex:indexPath.section withObject:friendMutableArr];
                    //替代同学数据
                    [localMutableArr replaceObjectAtIndex:2 withObject:classMutableArr];
                    //修改的数据再次写入缓存
                    [[NSUserDefaults standardUserDefaults]setObject:localMutableArr forKey:@"address"];
                    //再次获取缓存
                    NSArray *newLocalArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
                    //移除原来数据
                    [self.addressContentArr removeAllObjects];
                    [self.addressContentArr addObjectsFromArray:newLocalArr];
                    //3.刷新列表
                    [tableView reloadData];
                }
            } errorResult:^(NSError *error) {
            }];
        }];
        return @[deleteRowAction];
    }else{
        return nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    _tittleView.hidden=NO;
    self.title=@"";
    self.tabBarItem.title=@"消息";
    
//    _segmentBt.selectedSegmentIndex=0;
//    [_myScrollView setContentOffset:CGPointMake(0, 0)];
    
    //start
#pragma mark gd_切换账号好友列表未更新  2017-03-21 19:34:05-2
    if (_segmentBt.selectedSegmentIndex==0) {
        [_myScrollView setContentOffset:CGPointMake(0, 0)];
    }else if(_segmentBt.selectedSegmentIndex==1){
        [_myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        
        [self addAddressNetData];
    }
    //end
}
-(void)viewWillDisappear:(BOOL)animated
{
    _tittleView.hidden=YES;
    if (_segmentBt.selectedSegmentIndex==0) {
        [_myScrollView setContentOffset:CGPointMake(0, 0)];
        self.title=@"消息";
    }else if(_segmentBt.selectedSegmentIndex==1){
        self.title=@"通讯录";
        self.tabBarItem.title=@"消息";
        [_myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        
    }
}


@end
