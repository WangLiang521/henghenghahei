//
//  PKVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PKVC.h"
#import "RankVC.h"//排行榜和团队排行榜
#import "TotalRecordVC.h"//总战绩
#import "ContestVC.h"//竞技场
#import "ChooseRewardVC.h"//选择奖惩
#import "GetUserPKListModel.h"

#import "ContestReportVC.h"

#import "TotalRecordController.h"

#import "RankContentVC.h"
#import "FriendRankVC.h"

@interface PKVC ()<UIAlertViewDelegate>

//数据源
@property(nonatomic,copy)NSMutableArray *dataArr;
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;

@property(nonatomic,retain)UIScrollView *myScrollView;//滑动视图
@property(nonatomic,retain)UILabel *mainTitleLb;//页面标题
@property(nonatomic,retain)UIView *rankView;//排行榜view
@property(nonatomic,retain)UIView *tomorrowPKView;//明日PKview
//id
@property(nonatomic,copy)NSString *idStr;
//challenger
@property(nonatomic,copy)NSString *challengerStr;
@end

@implementation PKVC



- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

#pragma mark---数据源
-(NSMutableArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark---排行榜icon数组
-(NSArray *)rankIconImgArr
{
    NSArray *arr=@[@"icon_charts",@"icon_team",@"icon_PK",@"icon_athletic"];
    return arr;
}
#pragma mark---排行榜name数组
-(NSArray *)rankNameArr
{
    NSArray *arr=@[@"排行榜",@"团队PK",@"PK好友",@"竞技场"];
    return arr;
}
#pragma mark---排行榜content数组
-(NSArray *)rankContentArr
{
    NSArray *arr=@[@"知道自己的位置很重要",@"你不是一个人在战斗",@"学的多就是牛",@"你敢进来挑战一下吗？"];
    return arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:PKFriendList object:nil];
    
    
    //解决导航栏坐标问题
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加背景图片
    [self addBackgroundView];
    //添加页面主标题
    [self addMainTitleLb];
    //添加滑动视图
    [self addMyScrollView];
    if ([Utils getCurrentToken]!=nil) {
        //添加网络数据
        [self addPKNetData];
        //没有登陆或者没有网络
    }else{
        [NetWorkingUtils networkReachable:^{
            [Utils showAlter:@"用户未登陆，有些功能需要登陆后才能使用！" WithTime:2];
        } AndUnreachable:^{
            [Utils showAlter:@"手机未连接网络，有些功能需连接网络后才能使用！" WithTime:2];
        }];
    }

}
-(void)notification:(NSNotification *)notification
{
    //添加网络数据
    [self addPKNetData];
}
#pragma mark---添加网络数据
-(void)addPKNetData
{
    for (int i=0; i<self.dataArr.count; i++) {
        UIView *view=(UIView *)[self.view viewWithTag:1000+i];
        [view removeFromSuperview];
    }
    [self.dataArr removeAllObjects];
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"page":@"1",@"size":@"20"};
    
    [NetWorkingUtils postWithUrl:GetUserPKList  params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        for (NSDictionary *dicc in response[@"data"]) {
//            GetUserPKListModel *model=[GetUserPKListModel getUserListModelWith:dicc];
            #pragma mark gd_崩溃 0111
            
            GetUserPKListModel *model=[GetUserPKListModel mj_objectWithKeyValues:dicc];
            [self.dataArr addObject:model];
        }
        //添加明日PK排行榜view
        [self addTomorrowPKView];
        
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark---添加滑动视图
-(void)addMyScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_titleView.frame) - 49)];
    _myScrollView.bounces=NO;
    _myScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_myScrollView];
    

    //添加排行榜
    [self addRankView];

}
#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
}
#pragma mark---页面标题
-(void)addMainTitleLb
{
    _titleView=[CustomTitleView customTitleView:@"PK" rightTitle:@"总战绩" leftBtAction:^{
        
    } rightBtAction:^{
//        TotalRecordVC *totalRecordVC=[[TotalRecordVC alloc]init];

        TotalRecordController *totalRecordVC = [[TotalRecordController alloc] init];
        totalRecordVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:totalRecordVC animated:YES];
    }];
    _titleView.leftBt.hidden=YES;
    [self.view addSubview:_titleView];
}
#pragma mark---添加排行榜view
-(void)addRankView
{
    _rankView=[[UIView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_mainTitleLb.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(60)), AutoTrans(500))];
    _rankView.backgroundColor=[UIColor whiteColor];
    _rankView.clipsToBounds=YES;
    _rankView.layer.cornerRadius=(CGRectGetWidth(_rankView.frame))/25;
    [_myScrollView addSubview:_rankView];
    //水平分割线
    UILabel *horizontalLine=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(60), CGRectGetHeight(_rankView.frame)/2, CGRectGetWidth(_rankView.frame)-(AutoTrans(120)), 1)];
    horizontalLine.backgroundColor=[UIColor colorWithHexString:@"#eeeeee"];
    [_rankView addSubview:horizontalLine];
    //垂直分割线
    UILabel *verticaLine=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_rankView.frame)/2, AutoTrans(30), 1, CGRectGetHeight(_rankView.frame)-(AutoTrans(60)))];
    verticaLine.backgroundColor=[UIColor colorWithHexString:@"#eeeeee"];
    [_rankView addSubview:verticaLine];
    //排行榜的选项view
    for (int i=0; i<2; i++) {
        for (int j=0; j<2; j++) {
            //contentViewWidth
            CGFloat contentViewWidth=CGRectGetWidth(_rankView.frame)/2-CGRectGetHeight(horizontalLine.frame)/2;
            //contentViewHeight
            CGFloat contentViewHeight=CGRectGetHeight(_rankView.frame)/2-CGRectGetHeight(horizontalLine.frame)/2;
            //contentView
            UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake((contentViewWidth+1)*j, (contentViewHeight+1)*i, contentViewWidth, contentViewHeight)];
            contentView.backgroundColor=[UIColor whiteColor];
            contentView.tag=888+i*2+j;
            [_rankView addSubview:contentView];
            //图标
            UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentView.frame)/2-(AutoTrans(40)), AutoTrans(40), AutoTrans(80), AutoTrans(80))];
            iconImg.image=[UIImage imageNamed:self.rankIconImgArr[i*2+j]];
            [contentView addSubview:iconImg];
            //name
            UILabel *nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentView.frame)/2-(AutoTrans(60)), CGRectGetMaxY(iconImg.frame), AutoTrans(120), AutoTrans(50))];
            nameLb.text=self.rankNameArr[i*2+j];
            nameLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
            nameLb.textAlignment=NSTextAlignmentCenter;
            [contentView addSubview:nameLb];
            //content
            UILabel *contentLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLb.frame), CGRectGetWidth(contentView.frame), AutoTrans(50))];
            contentLb.text=self.rankContentArr[i*2+j];
            contentLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
            contentLb.textAlignment=NSTextAlignmentCenter;
            contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
            [contentView addSubview:contentLb];
            //contentView添加点击手势
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [contentView addGestureRecognizer:tap];
        }
    }
}
#pragma mark---添加点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 888:{
            //排行榜
//            RankVC *rank=[[RankVC alloc]init];
//            rank.titleStr=@"排行榜";
//            rank.hidesBottomBarWhenPushed=YES;
//            rank.urlStr=FriendRank;
//            [self.navigationController pushViewController:rank animated:YES];
            RankContentVC * rankContent = [[RankContentVC alloc] init];
            rankContent.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:rankContent animated:YES];
        }
            break;
        case 889:{
            //团队排行榜
            FriendRankVC *rank=[[FriendRankVC alloc]init];
//            rank.titleStr=@"团队排行榜";
            rank.title = @"团队排行榜";
            rank.type = @"3";
            rank.hidesBottomBarWhenPushed=YES;
//            rank.urlStr=SchoolRank;
            [self.navigationController pushViewController:rank animated:YES];
        }
            break;
        case 890:{
            //选择奖惩
            ChooseRewardVC *choose=[[ChooseRewardVC alloc]init];
            choose.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:choose animated:YES];
        }
            break;
        case 891:{
            //竞技场
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            ContestVC *contest=[[ContestVC alloc]init];
            ContestVC *contest=[[ContestVC alloc]initWith:BreakthroughTypeWord];
            //end
            
            contest.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:contest animated:YES];
            
            
            
            
//            ContestReportVC *contestReport=[[ContestReportVC alloc]init];
//            contestReport.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:contestReport animated:YES];


        }
            break;
        default:
            break;
    }
}
#pragma mark----添加明日PKview
-(void)addTomorrowPKView
{
    CGFloat tomorrowPKViewHeight=AutoTrans(220);
    CGFloat margin = AutoTrans(20);
    for (int i=0; i<self.dataArr.count; i++) {
        GetUserPKListModel *model=self.dataArr[i];
        _tomorrowPKView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_rankView.frame), CGRectGetMaxY(_rankView.frame)+(AutoTrans(20))+(tomorrowPKViewHeight+(AutoTrans(20)))*i, CGRectGetWidth(_rankView.frame), tomorrowPKViewHeight)];
        _tomorrowPKView.backgroundColor=[UIColor whiteColor];
        _tomorrowPKView.layer.cornerRadius=(CGRectGetWidth(_rankView.frame))/25;
        _tomorrowPKView.tag=1000+i;
        [_myScrollView addSubview:_tomorrowPKView];
        //添加点击手势
        UITapGestureRecognizer *PKViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PKViewTap:)];
        [_tomorrowPKView addGestureRecognizer:PKViewTap];
        //明日PK
        UILabel *tomorrowPKLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(25), AutoTrans(120), AutoTrans(40))];
//        + (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval WithFormatterString:(NSString*)fromatterString;4
        #pragma mark gd_PK页未取数据 0114
        NSString * strDate = [LGDUtils stringFromTimeInterval:[model.createTim longLongValue] WithFormatterString:@"MM月dd日"];
        tomorrowPKLb.text=strDate;
        NSLog(@"creat = %@",strDate);
        tomorrowPKLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        [tomorrowPKLb sizeToFit];
        [_tomorrowPKView addSubview:tomorrowPKLb];
        //钟表icon
        UIImageView *alarmIcon=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tomorrowPKView.frame)/2+(AutoTrans(20)), CGRectGetMinY(tomorrowPKLb.frame), AutoTrans(40), AutoTrans(40))];
        alarmIcon.image=[UIImage imageNamed:@"icon_time"];
        [_tomorrowPKView addSubview:alarmIcon];
        //时间
        UILabel *timeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alarmIcon.frame), CGRectGetMinY(tomorrowPKLb.frame), CGRectGetWidth(_tomorrowPKView.frame)/2-(AutoTrans(20)), AutoTrans(40))];
        #pragma mark gd_PK页未取数据 0114
//        timeLb.text=[Utils changeByTimeStamp:model.deadline];
        timeLb.text = [LGDUtils getDateToDayFromTimeInt:[model.deadline longLongValue]];
        timeLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        timeLb.textColor=[UIColor colorWithHexString:@"#999999"];
        timeLb.textAlignment = NSTextAlignmentRight;
        [timeLb sizeToFit];
        [_tomorrowPKView addSubview:timeLb];
        //水平label
        UILabel *horizontalLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(tomorrowPKLb.frame)+(AutoTrans(15)), CGRectGetWidth(_tomorrowPKView.frame)-(AutoTrans(80)), AutoTrans(80))];
        horizontalLb.backgroundColor=[UIColor colorWithWhite:0.953 alpha:1.000];
        horizontalLb.layer.cornerRadius=CGRectGetHeight(horizontalLb.frame)/2;
        horizontalLb.layer.masksToBounds=YES;
        if ([model.status integerValue]==1) {
            horizontalLb.text=@"创建";
        }else if([model.status integerValue]==3){
            horizontalLb.text=@"同意";
        }else if([model.status integerValue]==9){
            horizontalLb.text=@"完成";
        }else if ([model.status integerValue]==-1){
            horizontalLb.text=@"已拒绝";
        }else if ([model.status integerValue]==-0){
            horizontalLb.text=@"已取消";
        }
        horizontalLb.font=[UIFont systemFontOfSize:AutoTrans(26)];
        horizontalLb.textAlignment=NSTextAlignmentCenter;
        horizontalLb.textColor=[UIColor colorWithHexString:@"#999999"];
        [_tomorrowPKView addSubview:horizontalLb];
        //我的头像
        UIImageView *myIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetHeight(horizontalLb.frame), CGRectGetHeight(horizontalLb.frame))];
        //头像icon
        NSURL *iconImgUrl=[NSURL URLWithString:model.challengerImageUrl];
        UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
        [myIcon sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
        myIcon.layer.cornerRadius=CGRectGetHeight(myIcon.frame)/2;
        myIcon.layer.masksToBounds=YES;
        [horizontalLb addSubview:myIcon];
        //我的名称
        UILabel *myNameLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(horizontalLb.frame)+(AutoTrans(10)), AutoTrans(80)+CGRectGetHeight(horizontalLb.frame), AutoTrans(30))];
        myNameLb.textColor=[UIColor colorWithHexString:@"#999999"];
        myNameLb.textAlignment=NSTextAlignmentCenter;
        if ([model.challenger isEqualToString:[Utils getCurrentUserInfo][@"username"]]) {
            myNameLb.text=@"我 发起";
        }else{
            myNameLb.text=[NSString stringWithFormat:@"%@ 发起",model.challengerName];
        }
        myNameLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        [myNameLb sizeToFit];
        [_tomorrowPKView addSubview:myNameLb];
        //我的个数
        UILabel *myCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myIcon.frame), 0, CGRectGetHeight(horizontalLb.frame), CGRectGetHeight(horizontalLb.frame))];
        myCountLb.text=[NSString stringWithFormat:@"%@",model.challengerValue];
        myCountLb.textAlignment=NSTextAlignmentCenter;
        myCountLb.textColor=[UIColor colorWithHexString:@"#999999"];
        [horizontalLb addSubview:myCountLb];
        //其他人头像
        UIImageView *otherIcon=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(horizontalLb.frame)-CGRectGetHeight(horizontalLb.frame), 0, CGRectGetHeight(horizontalLb.frame), CGRectGetHeight(horizontalLb.frame))];
        //头像icon
        NSURL *iconImgUrl1=[NSURL URLWithString:model.beChallengerImageUrl];
        UIImage *placeholderImage1=[UIImage imageNamed:@"message_icon_default"];
        [otherIcon sd_setImageWithURL:iconImgUrl1 placeholderImage:placeholderImage1];
        otherIcon.layer.cornerRadius=CGRectGetHeight(otherIcon.frame)/2;
        otherIcon.layer.masksToBounds=YES;
        [horizontalLb addSubview:otherIcon];
        //其他人的名称
        UILabel *otherNameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLb.frame)-CGRectGetHeight(horizontalLb.frame)-(AutoTrans(40)), CGRectGetMaxY(horizontalLb.frame)+(AutoTrans(10)), CGRectGetHeight(horizontalLb.frame)+(AutoTrans(80)), AutoTrans(30))];
        otherNameLb.textColor=[UIColor colorWithHexString:@"#999999"];
        otherNameLb.textAlignment=NSTextAlignmentCenter;
        if ([model.beChallenger isEqualToString:[Utils getCurrentUserInfo][@"username"]]) {
            otherNameLb.text=@"我";
        }else{
            otherNameLb.text=[NSString stringWithFormat:@" %@",model.beChallengerName];
        }
        otherNameLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
        [_tomorrowPKView addSubview:otherNameLb];
        //其他人个数
        UILabel *otherCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(otherIcon.frame)-CGRectGetWidth(otherIcon.frame), 0, CGRectGetHeight(horizontalLb.frame), CGRectGetHeight(horizontalLb.frame))];
        otherCountLb.text=[NSString stringWithFormat:@"%@",model.beChallengerValue];
        otherCountLb.textAlignment=NSTextAlignmentCenter;
        otherCountLb.textColor=[UIColor colorWithHexString:@"#999999"];
        [horizontalLb addSubview:otherCountLb];
        //钻石图片
        UIImageView *diamondIcon=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tomorrowPKView.frame)/2-(AutoTrans(30)), CGRectGetMaxY(horizontalLb.frame)+(AutoTrans(10)), AutoTrans(30), AutoTrans(30))];
        diamondIcon.image=[UIImage imageNamed:@"icon_gold"];
        [_tomorrowPKView addSubview:diamondIcon];
        //钻石数量
        UILabel *diamondCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondIcon.frame), CGRectGetMinY(diamondIcon.frame), AutoTrans(80), AutoTrans(30))];
        diamondCountLb.text=[NSString stringWithFormat:@"x%@",model.coins];
        diamondCountLb.textColor=[UIColor colorWithHexString:@"#999999"];
        diamondCountLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
        [_tomorrowPKView addSubview:diamondCountLb];
    }
//    tomorrowPKViewHeight
//    _myScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_tomorrowPKView.frame)+(AutoTrans(20)));
    CGFloat height = (tomorrowPKViewHeight + margin) * self.dataArr.count + margin + CGRectGetMaxY(_rankView.frame);
    _myScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, height);
}
#pragma mark---PKview点击手势
-(void)PKViewTap:(UITapGestureRecognizer *)tap
{
    GetUserPKListModel *model=self.dataArr[tap.view.tag-1000];
    _idStr=[NSString stringWithFormat:@"%@",model.id];
    _challengerStr=[NSString stringWithFormat:@"%@",model.challenger];
    if ([model.beChallenger isEqualToString:[Utils getCurrentUserInfo][@"username"]]&&[model.status integerValue]==1) {
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否接受好友的PK？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"拒绝",@"接受", nil];
        [alter show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *urlStr;
    switch (buttonIndex) {
        case 0:{
            //拒绝
            urlStr=RefuseUserPKByList;
        }
            break;
        case 1:{
            //接受
            urlStr=AcceptUserPKByList;
        }
            break;
        default:
            break;
    }
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"id":_idStr,@"challenger":_challengerStr};
   
    [NetWorkingUtils postWithUrlWithoutHUD: urlStr params:paraDic successResult:^(id response) {
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue]==1) {
            //发送通知刷新列表
            [[NSNotificationCenter defaultCenter]postNotificationName:PKFriendList object:nil];
        }
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden =YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.hidden=YES;
//    self.tabBarController.tabBar.hidden=NO;
}

@end
