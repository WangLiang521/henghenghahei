//
//  ChooseRewardVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseRewardVC.h"
#import "ChooseFriendsPKVC.h"

@interface ChooseRewardVC ()
//表头视图
@property(nonatomic,retain)CustomTitleView *titleView;
//优钻数量label
@property(nonatomic,retain)UILabel *diamondNumLb;
//钻石数量
@property(nonatomic,assign)NSInteger diamondNum;
//底部图片
@property(nonatomic,retain)UIImageView *bottomImg;
//PK类型
@property(nonatomic,assign)NSInteger PKType;
@end

@implementation ChooseRewardVC


- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}
-(NSArray *)typeArr
{
    NSArray *arr=@[@"学习时长",@"准确率"];
    return arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加中间圆形图片
    [self addDiamondView];
    //添加底部view
    [self addBottomImg];
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
    _titleView=[CustomTitleView customTitleView:@"选择奖惩" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加优钻数量的label
-(void)addDiamondView
{
    //左边➖号距离左边框的距离
    CGFloat leftSpace=(AutoTrans(60));
    //左边➖号距离中间圆形的距离
    CGFloat midSpace=(AutoTrans(120));
    //减号按钮的宽度
    CGFloat delBtWidth=(AutoTrans(80));
    //中间圆形label的宽度
    CGFloat cirLbWidth=SCREEN_WIDTH-leftSpace*2-midSpace*2-delBtWidth*2;
    //圆形label
    _diamondNumLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-cirLbWidth/2, CGRectGetMaxY(_titleView.frame)+(AutoTrans(50)), cirLbWidth, cirLbWidth)];
    _diamondNumLb.backgroundColor=[UIColor whiteColor];
    _diamondNumLb.textColor=[UIColor colorWithHexString:@"#00d1a2"];
    //改变字体
    [self changeDiamondLbFont];

    _diamondNumLb.layer.cornerRadius=CGRectGetWidth(_diamondNumLb.frame)/2;
    _diamondNumLb.layer.masksToBounds=YES;
    _diamondNumLb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_diamondNumLb];
    //减号按钮
    UIButton *delBt=[[UIButton alloc]initWithFrame:CGRectMake(leftSpace, _diamondNumLb.center.y-delBtWidth/2, delBtWidth, delBtWidth)];
    delBt.layer.cornerRadius=CGRectGetWidth(delBt.frame)/2;
    delBt.layer.masksToBounds=YES;
    [delBt setBackgroundImage:[UIImage imageNamed:@"icon_jian_yuan"] forState:UIControlStateNormal];
    [delBt addTarget:self action:@selector(delBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBt];
    //加号按钮
    UIButton *addBt=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondNumLb.frame)+midSpace, CGRectGetMinY(delBt.frame), delBtWidth, delBtWidth)];
    addBt.layer.cornerRadius=CGRectGetWidth(addBt.frame)/2;
    addBt.layer.masksToBounds=YES;
    [addBt setBackgroundImage:[UIImage imageNamed:@"icon_jia_yuan"] forState:UIControlStateNormal];
    [addBt addTarget:self action:@selector(addBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBt];
    //双方各出以上优钻，赢家可以获得全部优钻
    UILabel *warnLb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_diamondNumLb.frame)+(AutoTrans(50)), SCREEN_WIDTH, AutoTrans(30))];
    warnLb.textAlignment=NSTextAlignmentCenter;
    warnLb.text=@"双方各出以上优钻，赢家可以获得全部优钻";
    warnLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    warnLb.textColor=[UIColor whiteColor];
    [self.view addSubview:warnLb];
}
#pragma mark---删除按钮点击事件
-(void)delBtClick
{
    _diamondNum--;
    if (_diamondNum<0) {
        _diamondNum=0;
    }
    //改变字体
    [self changeDiamondLbFont];
}
#pragma mark---添加按钮点击事件
-(void)addBtClick
{
    _diamondNum++;
    if (_diamondNum>99) {
        _diamondNum=99;
        [Utils showAlter:@"最多添加99个优钻"];
    }
    //改变字体
    [self changeDiamondLbFont];
}
#pragma mark---改变优钻数量label的字体
-(void)changeDiamondLbFont
{
    _diamondNumLb.text=[NSString stringWithFormat:@"%ld优钻",_diamondNum];
    //改变字体
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:_diamondNumLb.text];
    NSRange stringRange;
    if (_diamondNumLb.text.length==3) {
        stringRange = NSMakeRange(0, 1); //该字符串的位置
    }else{
        stringRange = NSMakeRange(0, 2); //该字符串的位置
    }
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(100)] range:stringRange];
    [_diamondNumLb setAttributedText: noteString];
}
#pragma mark---添加底部view
-(void)addBottomImg
{
    _bottomImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_diamondNumLb.frame)+(AutoTrans(120)), SCREEN_WIDTH,SCREEN_HEIGHT-(CGRectGetMaxY(_diamondNumLb.frame)+(AutoTrans(120))))];
    _bottomImg.image=[UIImage imageNamed:@"bg_bolang"];
    _bottomImg.userInteractionEnabled=YES;
    [self.view addSubview:_bottomImg];
    //选择PK项目
    UILabel *chooseItemLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(40), AutoTrans(100), SCREEN_WIDTH/2, AutoTrans(40))];
    chooseItemLb.text=@"选择PK项目";
    chooseItemLb.textColor=[UIColor colorWithHexString:@"#666666"];
    chooseItemLb.font=[UIFont systemFontOfSize:AutoTrans(36)];
    [_bottomImg addSubview:chooseItemLb];
    //学习时长，准确率
    UILabel *typeLb;
    //PK类型默认为1；
    _PKType=1;
    for (int i=0; i<2; i++) {
        typeLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, CGRectGetMaxY(chooseItemLb.frame)+(AutoTrans(60))+(AutoTrans(100))*i, SCREEN_WIDTH/2, AutoTrans(50))];
        typeLb.text=self.typeArr[i];
        typeLb.textAlignment=NSTextAlignmentCenter;
        typeLb.font=[UIFont systemFontOfSize:AutoTrans(40)];
        typeLb.textColor=[UIColor colorWithHexString:@"#333333"];
        typeLb.userInteractionEnabled=YES;
        typeLb.tag=1000+i;
        [_bottomImg addSubview:typeLb];
        //勾选的图片
        UIImageView *chooseImg=[[UIImageView alloc]initWithFrame:CGRectMake(AutoTrans(40), 0, AutoTrans(40), AutoTrans(40))];
        if (i==0) {
            chooseImg.image=[UIImage imageNamed:@"barrier_ck_checked"];
        }else{
            chooseImg.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
        }
        chooseImg.tag=2000+i;
        [typeLb addSubview:chooseImg];
        //添加点击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [typeLb addGestureRecognizer:tap];
    }
    //邀请好友PK按钮
    UIButton *inviteBt=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(100), CGRectGetMaxY(typeLb.frame)+(AutoTrans(80)), SCREEN_WIDTH-(AutoTrans(200)), AutoTrans(90))];
    inviteBt.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    inviteBt.layer.cornerRadius=CGRectGetHeight(inviteBt.frame)/2;
    inviteBt.layer.masksToBounds=YES;
    [inviteBt setTitle:@"邀请好友PK" forState:UIControlStateNormal];
    inviteBt.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(35)];
    [inviteBt addTarget:self action:@selector(inviteBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomImg addSubview:inviteBt];
}
#pragma mark---点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    UIImageView *image1=(UIImageView *)[self.view viewWithTag:2000];
    UIImageView *image2=(UIImageView *)[self.view viewWithTag:2001];

    if (tap.view.tag==1000) {
        _PKType=1;
        image1.image=[UIImage imageNamed:@"barrier_ck_checked"];
        image2.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
    }else{
        _PKType=2;
        image2.image=[UIImage imageNamed:@"barrier_ck_checked"];
        image1.image=[UIImage imageNamed:@"barrier_ck_unchecked"];
    }
}
#pragma mark---邀请好友按钮点击
-(void)inviteBtClick
{
    NSNumber * selfCoins = [Utils getCoinsCount];
    
    if ([selfCoins integerValue] < self.diamondNum) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"您的优钻数不足,最多可选 %@ 个优钻",selfCoins]];
        return;
    }
    
    
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
    //跳转到选择好友界面
    
    if (_friendAccount) {
        NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"chanType":[NSString stringWithFormat:@"%ld",self.PKType],@"beChallenger":_friendAccount,@"coins":[NSString stringWithFormat:@"%ld",self.diamondNum]};
        NSLog(@"%@",paraDic);
        [NetWorkingUtils postWithUrl:ChooseFriendChange params:paraDic successResult:^(id response) {
            if ([response[@"status"] integerValue]==0) {
                [Utils showAlter:response[@"error"]];
            }else if ([response[@"status"] integerValue]==1){
                [Utils showAlter:@"PK请求已发送"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:PKFriendList object:nil];
                    //返回根目录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        } errorResult:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        ChooseFriendsPKVC *chooseFriends=[[ChooseFriendsPKVC alloc]init];
        chooseFriends.diamondNum=_diamondNum;
        chooseFriends.PKType=_PKType;
        [self.navigationController pushViewController:chooseFriends animated:YES];
    }
    
    
    
    //end

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}


@end
