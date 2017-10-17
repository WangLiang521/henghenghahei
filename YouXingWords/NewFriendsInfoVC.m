//
//  NewFriendsInfoVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/24.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "NewFriendsInfoVC.h"
#import "MoreInfoVC.h"
#import "ChooseRewardVC.h"


@interface NewFriendsInfoVC ()

@property(nonatomic,retain)UIScrollView *myScrollView;
//数据源
@property(nonatomic,copy)NSDictionary *dataDic;
//titleview
@property(nonatomic,retain)UIView *titleView;//titleview
@property(nonatomic,retain)UIImageView *iconImg;//头像按钮
@property(nonatomic,retain)UILabel *nameLb;//名称
@property(nonatomic,retain)UILabel *subNameLb;//副名称
@property(nonatomic,retain)UILabel *accountLb;//账号
@property(nonatomic,retain)UIImageView *diamondImg;//钻石图片
@property(nonatomic,retain)UILabel *diamondCountLb;//钻石数量
//contentView
@property(nonatomic,retain)UIView *contentView;//contentView
//拒绝按钮
@property(nonatomic,retain)UIButton *refuseBt;//拒绝按钮
//同意按钮
@property(nonatomic,retain)UIButton *agreeBt;//同意按钮

//PK按钮
@property(nonatomic,retain)UIButton *PKBt;//发起PK按钮
//发起聊天按钮
@property(nonatomic,retain)UIButton *chatBt;//发起聊天按钮

@property(nonatomic,retain)UIButton *applyFriendBt;//申请好友按钮


@end

@implementation NewFriendsInfoVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决导航栏坐标问题
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //背景颜色
    self.view.backgroundColor=[UIColor colorWithHexString:@"#e8edf1"];
    //添加网络数据
    [self addNetData];
}
#pragma mark---更多按钮点击
-(void)barButtonAction
{
    MoreInfoVC *more=[[MoreInfoVC alloc]init];
    more.dataDic=_dataDic;
    more.groupStr=self.groupStr;
    more.noteStr=self.noteStr;
    more.tempDic=self.tempDic;
    [self.navigationController pushViewController:more animated:YES];
}
#pragma mark---加载网络数据
-(void)addNetData
{
    //参数字典
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"username":self.userName};
    //请求数据
    [NetWorkingUtils postWithUrl:UserInfo params:paraDic successResult:^(id response) {
        //返回数据字典
        _dataDic=response[@"info"];
        NSLog(@"++++++%@",_dataDic);
        //标题
        if (self.addtype == AddFriendTypeFamily) {
            self.title = @"添加陪伴号";
        }else if ([self.dataDic[@"isFriend"] integerValue]==0&&_viewTag==300) {
            self.title=@"新朋友";
        }else {
            self.title=@"好友信息";
        }
        //添加滑动视图
        [self addMyScrollView];
        
    } errorResult:^(NSError *error) {
    }];
}
#pragma mark---添加滑动视图
-(void)addMyScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _myScrollView.backgroundColor=[UIColor colorWithHexString:@"#e8edf1"];
    _myScrollView.bounces=NO;
    [self.view addSubview:_myScrollView];
    //添加表头view
    [self addTitleView];
    //添加contentView
    [self addContentView];
    
    
    
    
    //不是好友，添加好友
    if ([self.dataDic[@"isFriend"] integerValue]==0&&self.isFriend!=-1) {
        if (_viewTag==100) {
            //添加拒绝或者同意按钮
            [self addButtonView];
        }else if (_viewTag==300){
            //添加申请添加好友按钮
            [self addApplyFriendBt];
        }else if(_viewTag==200){
            //添加PK按钮
            [self addPKBt];
        }
        //是好友,发起PK
    }else if([self.dataDic[@"isFriend"] integerValue]==1){
        //添加PK按钮
        [self addPKBt];
        //添加聊天按钮
        //        [self addChatBt];
        //从通讯录进来才有更多按钮
        if (_viewTag==200) {
            //更多按钮
            UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonAction)];
            self.navigationItem.rightBarButtonItem=barButton;
        }
    }

    
   



}
#pragma mark---添加表头view
-(void)addTitleView
{
    //添加titleView
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(190))];
    _titleView.backgroundColor=[UIColor whiteColor];
    [_myScrollView addSubview:_titleView];
    //头像按钮
    _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(30), AutoTrans(130), AutoTrans(130))];
    _iconImg.layer.cornerRadius=(AutoTrans(130))/2;
    _iconImg.layer.masksToBounds=YES;
    NSURL *iconImgUrl=nil;
    if ([LGDUtils isValidStr:_dataDic[@"signPhoto"]]) {
        iconImgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"signPhoto"]]];
    }
    UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
    [_iconImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
    [_titleView addSubview:_iconImg];
    //名称
    _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame)+(AutoTrans(26)), AutoTrans(54), AutoTrans(100), AutoTrans(60))];
    _nameLb.text=_dataDic[@"name"];
    _nameLb.font=[UIFont systemFontOfSize:AutoTrans(38)];
    [_nameLb sizeToFit];
    [_titleView addSubview:_nameLb];
//    //副名称
//    _subNameLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLb.frame), CGRectGetMinY(_nameLb.frame), CGRectGetWidth(_nameLb.frame), CGRectGetHeight(_nameLb.frame))];
//    _subNameLb.text=[NSString stringWithFormat:@"(%@)",_dataDic[@"nickName"]];
//    _subNameLb.textColor=[UIColor colorWithHexString:@"#999999"];
//    _subNameLb.font=[UIFont systemFontOfSize:AutoTrans(26)];
//    [_titleView addSubview:_subNameLb];
    //账号
    _accountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLb.frame), CGRectGetMaxY(_nameLb.frame)+(AutoTrans(14)), AutoTrans(200), CGRectGetHeight(_nameLb.frame))];
    _accountLb.text=[NSString stringWithFormat:@"优行账号:%@",[self phoneNumStr:_dataDic[@"username"]]];
    _accountLb.font=[UIFont systemFontOfSize:AutoTrans(26)];
    [_accountLb sizeToFit];
    [_titleView addSubview:_accountLb];
    //钻石图片
    _diamondImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(600), (AutoTrans(181))-64, AutoTrans(40), AutoTrans(40))];
    _diamondImg.image=[UIImage imageNamed:@"barrier_icon_diamond"];
    [_titleView addSubview:_diamondImg];
    //钻石数量
    _diamondCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondImg.frame), CGRectGetMinY(_diamondImg.frame), AutoTrans(150), CGRectGetHeight(_diamondImg.frame))];
    _diamondCountLb.text=[NSString stringWithFormat:@"%@",_dataDic[@"coins"]];
    _diamondCountLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [_diamondCountLb sizeToFit];
    [_titleView addSubview:_diamondCountLb];
}
#pragma mark----添加contentView
-(void)addContentView
{
    
    
   
    
    NSArray *titleArr=@[@"地区",@"学校",@"最近1天",@"最近7天",@"最近30天"];
    
    //start
#pragma mark gd_通讯录里面联系时间显示不准确  2017-03-21 19:51:42-3
    
    
    
    NSInteger day1 = [_dataDic[@"st1day"] integerValue] / 60 + ([_dataDic[@"st1day"] integerValue] % 60) > 0 ?1:0;
    NSInteger day7 = [_dataDic[@"st7day"] integerValue] / 60 + ([_dataDic[@"st7day"] integerValue] % 60) > 0 ?1:0;
    NSInteger day30 = [_dataDic[@"st30day"] integerValue] / 60 + ([_dataDic[@"st30day"] integerValue] % 60) > 0 ?1:0;
    NSString *st1day = [NSString stringWithFormat:@"%zd",day1];
    NSString *st7day = [NSString stringWithFormat:@"%zd",day7];
    NSString *st30day = [NSString stringWithFormat:@"%zd",day30];
    NSArray *contentArr=@[_dataDic[@"address"],
                          _dataDic[@"schName"],
                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",st1day,_dataDic[@"so1day"],_dataDic[@"sr1day"]],
                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",st7day,_dataDic[@"so7day"],_dataDic[@"sr7day"]],
                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",st30day,_dataDic[@"so30day"],_dataDic[@"sr30day"]]];
//    NSArray *contentArr=@[_dataDic[@"address"],
//                          _dataDic[@"schName"],
//                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",_dataDic[@"st1day"],_dataDic[@"so1day"],_dataDic[@"sr1day"]],
//                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",_dataDic[@"st7day"],_dataDic[@"so7day"],_dataDic[@"sr7day"]],
//                          [NSString stringWithFormat:@"练习了%@分钟，战绩排名%@，打败了全国%@人",_dataDic[@"st30day"],_dataDic[@"so30day"],_dataDic[@"sr30day"]]];
    
    //end
    
    
    NSInteger lineCount=titleArr.count;
    //start
#pragma mark gd_通讯录朋友或者陪伴号处点击还是重影混乱状态  2017-03-21 18:15:02-1
    _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+(GDAutoTrans(20)), SCREEN_WIDTH, (GDAutoTrans(130))*lineCount)];
    _contentView.backgroundColor=[UIColor whiteColor];
    [_myScrollView addSubview:_contentView];
    //分割线
    UILabel *leftLineLb=[[UILabel alloc]initWithFrame:CGRectMake(GDAutoTrans(34)+(GDAutoTrans(30))/2-1, GDAutoTrans(40), 2,(GDAutoTrans(130)*(lineCount-1)))];
    leftLineLb.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
    [_contentView addSubview:leftLineLb];
    
    for (NSInteger i=0; i<lineCount; i++) {
        //小圆球
        UILabel *cirLb=[[UILabel alloc]initWithFrame:CGRectMake(GDAutoTrans(34), GDAutoTrans(40)+(GDAutoTrans(130))*i, GDAutoTrans(30), GDAutoTrans(30))];
        cirLb.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
        cirLb.layer.cornerRadius=(GDAutoTrans(30))/2;
        cirLb.layer.masksToBounds=YES;
        [_contentView addSubview:cirLb];
        //title
        UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cirLb.frame)+(GDAutoTrans(26)), GDAutoTrans(32)+(GDAutoTrans(130))*i, GDAutoTrans(200), AutoTrans(50))];
        titleLb.text=titleArr[i];
        titleLb.font=[UIFont systemFontOfSize:GDAutoTrans(34)];
        [titleLb sizeToFit];
        [_contentView addSubview:titleLb];
        //content
        UILabel *contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(titleLb.frame), GDAutoTrans(300), CGRectGetHeight(titleLb.frame))];
        contentLb.text=contentArr[i];
        contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
        contentLb.font=[UIFont systemFontOfSize:GDAutoTrans(28)];
        [contentLb sizeToFit];
        [_contentView addSubview:contentLb];
        if (i!=lineCount-1) {
            //底部分割线
            UILabel *bottomLineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(contentLb.frame)+(GDAutoTrans(20)), SCREEN_WIDTH-(GDAutoTrans(34+26+30)), 0.8)];
            bottomLineLb.backgroundColor=[UIColor colorWithHexString:@"#999999"];
            [_contentView addSubview:bottomLineLb];
        }
    }

//    _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+(AutoTrans(20)), SCREEN_WIDTH, (AutoTrans(130))*lineCount)];
//    _contentView.backgroundColor=[UIColor whiteColor];
//    [_myScrollView addSubview:_contentView];
//    //分割线
//    UILabel *leftLineLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(34)+(AutoTrans(30))/2-1, AutoTrans(40), 2,(AutoTrans(130)*(lineCount-1)))];
//    leftLineLb.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
//    [_contentView addSubview:leftLineLb];
//    
//    for (NSInteger i=0; i<lineCount; i++) {
//        //小圆球
//        UILabel *cirLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(34), AutoTrans(40)+(AutoTrans(130))*i, AutoTrans(30), AutoTrans(30))];
//        cirLb.backgroundColor=[UIColor colorWithHexString:@"#36b6e6"];
//        cirLb.layer.cornerRadius=(AutoTrans(30))/2;
//        cirLb.layer.masksToBounds=YES;
//        [_contentView addSubview:cirLb];
//        //title
//        UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cirLb.frame)+(AutoTrans(26)), AutoTrans(32)+(AutoTrans(130))*i, AutoTrans(200), AutoTrans(50))];
//        titleLb.text=titleArr[i];
//        titleLb.font=[UIFont systemFontOfSize:AutoTrans(34)];
//        [titleLb sizeToFit];
//        [_contentView addSubview:titleLb];
//        //content
//        UILabel *contentLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(titleLb.frame), AutoTrans(300), CGRectGetHeight(titleLb.frame))];
//        contentLb.text=contentArr[i];
//        contentLb.textColor=[UIColor colorWithHexString:@"#999999"];
//        contentLb.font=[UIFont systemFontOfSize:AutoTrans(28)];
//        [contentLb sizeToFit];
//        [_contentView addSubview:contentLb];
//        if (i!=lineCount-1) {
//            //底部分割线
//            UILabel *bottomLineLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLb.frame), CGRectGetMaxY(contentLb.frame)+(AutoTrans(20)), SCREEN_WIDTH-(AutoTrans(34+26+30)), 0.8)];
//            bottomLineLb.backgroundColor=[UIColor colorWithHexString:@"#999999"];
//            [_contentView addSubview:bottomLineLb];
//        }
//    }

    //end
    
}
#pragma mark---拒绝or同意按钮
-(void)addButtonView
{
    CGFloat buttonWidth=(SCREEN_WIDTH-(AutoTrans(60+60+20)))/2;
    //拒绝按钮
    _refuseBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(60), CGRectGetMaxY(_contentView.frame)+(AutoTrans(30)), buttonWidth, AutoTrans(90))];
    _refuseBt.backgroundColor=[UIColor colorWithHexString:@"#feb04f"];
    _refuseBt.layer.cornerRadius=(AutoTrans(90))/2;
    _refuseBt.layer.masksToBounds=YES;
    [_refuseBt addTarget:self action:@selector(refuseBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_refuseBt setTitle:@"拒绝" forState:UIControlStateNormal];
    [_myScrollView addSubview:_refuseBt];
    //同意按钮
    _agreeBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_refuseBt.frame)+(AutoTrans(20)), CGRectGetMaxY(_contentView.frame)+(AutoTrans(30)), buttonWidth, AutoTrans(90))];
    _agreeBt.backgroundColor=[UIColor colorWithHexString:@"#00cfb1"];
    _agreeBt.layer.cornerRadius=(AutoTrans(90))/2;
    _agreeBt.layer.masksToBounds=YES;
    [_agreeBt addTarget:self action:@selector(agreeBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBt setTitle:@"同意" forState:UIControlStateNormal];
    [_myScrollView addSubview:_agreeBt];
}
#pragma mark---拒绝按钮点击事件
-(void)refuseBtClick
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":_dataDic[@"username"]};
    [NetWorkingUtils postWithUrl:DisagreeAddFriend params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
            [Utils showAlter:@"已拒绝添加该好友"];
        }else{
        }
    } errorResult:^(NSError *error) {
        
    }];
}
#pragma mark---同意按钮点击事件
-(void)agreeBtClick
{
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":_dataDic[@"username"]};
    [NetWorkingUtils postWithUrl:AgreeAddFriend params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
            [Utils showAlter:@"添加好友成功"];
            //返回根目录
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [Utils showAlter:@"添加好友失败"];
        }
    } errorResult:^(NSError *error) {
        
    }];
}
#pragma mark---发起PK按钮
-(void)addPKBt
{
    _PKBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), CGRectGetMaxY(_contentView.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(160)),  AutoTrans(90))];
    _PKBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    _PKBt.layer.cornerRadius=(AutoTrans(90))/2;
    _PKBt.layer.masksToBounds=YES;
    [_PKBt addTarget:self action:@selector(PKBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_PKBt setTitle:@"发起PK" forState:UIControlStateNormal];
    [_myScrollView addSubview:_PKBt];
}
#pragma mark---PK按钮点击事件
-(void)PKBtClick
{
    ChooseRewardVC *chooseRewardVC=[[ChooseRewardVC alloc]init];
    //start
#pragma mark gd_发起PK  2017-03-27 17:20:14-8
    chooseRewardVC.friendAccount = self.userName;
    //end
    [self.navigationController pushViewController:chooseRewardVC animated:YES];
}
#pragma mark---发起聊天按钮
-(void)addChatBt
{
    _chatBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_PKBt.frame), CGRectGetMaxY(_PKBt.frame)+(AutoTrans(30)), CGRectGetWidth(_PKBt.frame),  CGRectGetHeight(_PKBt.frame))];
    _chatBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    _chatBt.layer.cornerRadius=(AutoTrans(90))/2;
    _chatBt.layer.masksToBounds=YES;
    [_chatBt addTarget:self action:@selector(chatBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_chatBt setTitle:@"发起聊天" forState:UIControlStateNormal];
    //暂时隐藏，展示时需要修改scrollview的contentsize
    _chatBt.hidden=YES;
    [_myScrollView addSubview:_chatBt];
}
#pragma mark---PK按钮点击事件
-(void)chatBtClick
{
    NSLog(@"聊天按钮点击");
}

#pragma mark---申请添加好友列表按钮
-(void)addApplyFriendBt
{
    _applyFriendBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), CGRectGetMaxY(_contentView.frame)+(AutoTrans(30)), SCREEN_WIDTH-(AutoTrans(160)),  AutoTrans(90))];
    _applyFriendBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    _applyFriendBt.layer.cornerRadius=(AutoTrans(90))/2;
    _applyFriendBt.layer.masksToBounds=YES;
    [_applyFriendBt addTarget:self action:@selector(applyFriendBtClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.addtype == AddFriendTypeFamily) {
        [_applyFriendBt setTitle:@"添加陪伴号" forState:UIControlStateNormal];
    }else{
        [_applyFriendBt setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    [_myScrollView addSubview:_applyFriendBt];
}
#pragma mark---添加好友
-(void)applyFriendBtClick
{
    int group = 2;
    if (self.addtype == AddFriendTypeFamily) {
        group = 1;
    }
    NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":_dataDic[@"username"],@"group":@(group)};
    [NetWorkingUtils postWithUrl:ApplyAddFriend params:paraDic successResult:^(id response) {
        if ([response[@"status"] integerValue]==1) {
            [Utils showAlter:@"好友请求已发送，等待对方确认"];
            //返回根目录
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            [Utils showAlter:@"添加好友失败"];
        }
    } errorResult:^(NSError *error) {
        
    }];
}

#pragma mark---手机号隐藏中间四位数字
-(NSString *)phoneNumStr:(NSString *)phone
{
    NSString *subStr=[phone substringWithRange:NSMakeRange(3, 4)];
    NSString *str=[phone stringByReplacingOccurrencesOfString:subStr withString:@"****"];
    return str;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
}




@end
