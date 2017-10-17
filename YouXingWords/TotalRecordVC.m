//
//  TotalRecordVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/9/5.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "TotalRecordVC.h"
#import "TotalRecordView.h"

@interface TotalRecordVC ()
//自定义导航栏
@property(nonatomic,retain)CustomTitleView *customTitleView;

//弧形view
@property(nonatomic,retain)TotalRecordView *totalRecordView;
@property(nonatomic,retain)UIImageView *iconImg;//头像img
@property(nonatomic,retain)UILabel *mainNameLb;//名称
@property(nonatomic,retain)UILabel *recordLb;//战绩的label

@property(nonatomic,retain)UIScrollView *recordInfoScr;//战绩详情的滑动视图
@property(nonatomic,retain)UIView *recordInfoView;//战绩详情每个的view

@end

@implementation TotalRecordVC

-(NSArray *)colorArr
{
    NSArray *arr=@[@"#db4213",@"#78b9f9",@"#ffba00"];
    return arr;
}
-(NSArray *)recordArr
{
    NSArray *arr=@[@"胜",@"平",@"负"];
    return  arr;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#3eb9e4"];
    
    //添加导航栏
    [self addCustomTitleView];
    //添加总战绩弧形view
    [self addTotalRecordView];
    //添加战绩详情
    [self addRecordInfoScr];
}
#pragma mark---自定义导航栏
-(void)addCustomTitleView
{
    _customTitleView=[CustomTitleView customTitleView:@"总战绩" rightTitle:@"" leftBtAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        //
    }];
    [self.view addSubview:_customTitleView];
}
#pragma mark---添加总战绩弧形view
-(void)addTotalRecordView
{
    //弧形view
    _totalRecordView=[[TotalRecordView alloc]initWithFrame:CGRectMake(0, AutoTrans(280), SCREEN_WIDTH, SCREEN_HEIGHT-(AutoTrans(320)))];
    _totalRecordView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_totalRecordView];
    //头像背景view
    UIView *iconBgView=[[UIView alloc]initWithFrame:CGRectMake(_totalRecordView.center.x-(AutoTrans(80)),-(AutoTrans(80)), AutoTrans(160), AutoTrans(160))];
    iconBgView.layer.cornerRadius=CGRectGetWidth(iconBgView.frame)/2;
    iconBgView.layer.masksToBounds=YES;
    iconBgView.backgroundColor=[UIColor colorWithRed:0.107 green:0.593 blue:0.808 alpha:1.000];
    [_totalRecordView addSubview:iconBgView];
    //头像img
    _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, CGRectGetWidth(iconBgView.frame)-6, CGRectGetWidth(iconBgView.frame)-6)];
    _iconImg.image=[UIImage imageNamed:@"icon_me"];
    _iconImg.layer.cornerRadius=CGRectGetWidth(_iconImg.frame)/2;
    _iconImg.layer.masksToBounds=YES;
    [iconBgView addSubview:_iconImg];
    //名称
    _mainNameLb=[[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-100, CGRectGetMaxY(iconBgView.frame)+(AutoTrans(15)), 200, AutoTrans(40))];
    _mainNameLb.text=@"王一涵";
    _mainNameLb.textAlignment=NSTextAlignmentCenter;
    _mainNameLb.font=[UIFont systemFontOfSize:AutoTrans(30)];
    [_totalRecordView addSubview:_mainNameLb];
    //战绩label
    CGFloat recordLbWidth=(SCREEN_WIDTH-(AutoTrans(60))*2-(AutoTrans(20))*2)/3;
    for (int i=0; i<3; i++) {
        _recordLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(60)+(recordLbWidth+(AutoTrans(20)))*i, CGRectGetMaxY(_mainNameLb.frame)+(AutoTrans(15)), recordLbWidth, AutoTrans(84))];
        _recordLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[i]];
        _recordLb.layer.cornerRadius=CGRectGetHeight(_recordLb.frame)/2;
        _recordLb.layer.masksToBounds=YES;
        _recordLb.textAlignment=NSTextAlignmentCenter;
        _recordLb.textColor=[UIColor whiteColor];
        _recordLb.font=[UIFont systemFontOfSize:AutoTrans(35)];
        _recordLb.text=[NSString stringWithFormat:@"1 %@",self.recordArr[i]];
        [_totalRecordView addSubview:_recordLb];
        //大字体
        NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:_recordLb.text];
        NSRange stringRange = NSMakeRange(0, 1); //该字符串的位置
        [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(48)] range:stringRange];
        [_recordLb setAttributedText: noteString];
    }
}
#pragma mark---添加战绩详情滑动视图
-(void)addRecordInfoScr
{
    _recordInfoScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recordLb.frame)+(AutoTrans(30)), SCREEN_WIDTH, CGRectGetHeight(_totalRecordView.frame)-CGRectGetMaxY(_recordLb.frame)-(AutoTrans(30)))];
    _recordInfoScr.backgroundColor=[UIColor whiteColor];
    [_totalRecordView addSubview:_recordInfoScr];
    for (int i=0;i<3;i++) {
        //战绩详情的view
        CGFloat recordInfoViewWidth=SCREEN_WIDTH-(AutoTrans(20)*2);
        CGFloat recordInfoViewHeight=120;
        _recordInfoView=[[UIView alloc]initWithFrame:CGRectMake(AutoTrans(20), (recordInfoViewHeight+(AutoTrans(20)))*i, recordInfoViewWidth, recordInfoViewHeight)];
        _recordInfoView.backgroundColor=[UIColor colorWithHexString:@"#fbfbfb"];
        _recordInfoView.layer.cornerRadius=recordInfoViewHeight/2;
        _recordInfoView.layer.masksToBounds=YES;
        _recordInfoView.layer.borderColor=[UIColor colorWithWhite:0.677 alpha:1.000].CGColor;
        _recordInfoView.layer.borderWidth=0.5;
        [_recordInfoScr addSubview:_recordInfoView];
        //日期
        UILabel *dateLb=[[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(120),AutoTrans(20), AutoTrans(160), AutoTrans(40))];
        dateLb.text=@"7月1号";
        dateLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        dateLb.textColor=[UIColor colorWithHexString:@"#666666"];
        [_recordInfoView addSubview:dateLb];
        //小头像
        UIImageView *smallIconImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLb.frame), CGRectGetMaxY(dateLb.frame)+(AutoTrans(10)), AutoTrans(80), AutoTrans(80))];
        smallIconImg.layer.cornerRadius=CGRectGetWidth(smallIconImg.frame)/2;
        smallIconImg.layer.masksToBounds=YES;
        smallIconImg.image=[UIImage imageNamed:@"icon_me"];
        [_recordInfoView addSubview:smallIconImg];
        //胜利的皇冠图片
//        UIImageView *winImg=[[UIImageView     alloc]initWithFrame:CGRectMake(CGRectGetMinX(smallIconImg.frame)-(AutoTrans(40)), CGRectGetMinY(smallIconImg.frame)-(AutoTrans(40)), AutoTrans(80), AutoTrans(80))];
//        winImg.backgroundColor=[UIColor yellowColor];
//        winImg.image=[UIImage imageNamed:@"icon_goldcrown"];
//        winImg.transform=CGAffineTransformMakeRotation(M_PI*1.5);
//        [_recordInfoView addSubview:winImg];
        //名称+时间
        UILabel *nameAndTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(smallIconImg.center.x-80, CGRectGetMaxY(smallIconImg.frame)+(AutoTrans(10)), 160, AutoTrans(40))];
        if (i==0) {
            nameAndTimeLb.text=@"我 3分钟";
        }else{
            nameAndTimeLb.text=@"我 第3名";
        }
        nameAndTimeLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        nameAndTimeLb.textColor=[UIColor colorWithHexString:@"#333333"];
        nameAndTimeLb.textAlignment=NSTextAlignmentCenter;
        [_recordInfoView addSubview:nameAndTimeLb];
        //改变字体颜色
        NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:nameAndTimeLb.text];
        NSRange stringRange =NSMakeRange(1, 4); //该字符串的位置
        [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange];
        [nameAndTimeLb setAttributedText: noteString];
        //正确单词数量
        if (i!=0) {
            UILabel *wordsCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameAndTimeLb.frame), CGRectGetMaxY(nameAndTimeLb.frame), CGRectGetWidth(nameAndTimeLb.frame), CGRectGetHeight(nameAndTimeLb.frame))];
            wordsCountLb.textColor=[UIColor colorWithHexString:@"#999999"];
            wordsCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
            wordsCountLb.text=@"正确30词/90秒";
            wordsCountLb.textAlignment=NSTextAlignmentCenter;
            [_recordInfoView addSubview:wordsCountLb];
        }
        //PK类型
        UILabel *PKTypeLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_recordInfoView.frame)/2-30, CGRectGetMinY(smallIconImg.frame), 60, CGRectGetHeight(smallIconImg.frame))];
        PKTypeLb.textColor=[UIColor colorWithHexString:@"#fd7900"];
        PKTypeLb.font=[UIFont boldSystemFontOfSize:AutoTrans(30)];
        PKTypeLb.textAlignment=NSTextAlignmentCenter;
        PKTypeLb.numberOfLines=0;
        if (i==0) {
            PKTypeLb.text=@"好友PK";
        }else{
            PKTypeLb.text=@"竞技场\n山师附小";
            //改变字体颜色和大小
            NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:PKTypeLb.text];
            NSRange stringRange =NSMakeRange(3, 5); //该字符串的位置
            [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:stringRange];
            [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AutoTrans(24)] range:stringRange];
            [PKTypeLb setAttributedText: noteString];
        }
        [_recordInfoView addSubview:PKTypeLb];
        //比赛结果
        UILabel *resultLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(PKTypeLb.frame), CGRectGetMaxY(PKTypeLb.frame)+(AutoTrans(10)), CGRectGetWidth(PKTypeLb.frame), AutoTrans(40))];
        resultLb.textAlignment=NSTextAlignmentCenter;
        resultLb.textColor=[UIColor whiteColor];
        resultLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        resultLb.layer.cornerRadius=CGRectGetHeight(resultLb.frame)/2;
        resultLb.layer.masksToBounds=YES;
        if (i==0) {
            resultLb.text=@"输了";
            resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[1]];
        }else if(i==1){
            resultLb.text=@"平局";
            resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[2]];
        }else if(i==2){
            resultLb.text=@"胜利";
            resultLb.backgroundColor=[UIColor colorWithHexString:self.colorArr[0]];
        }
        [_recordInfoView addSubview:resultLb];
        //其他人的小头像
        UIImageView *otherImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_recordInfoView.frame)-(AutoTrans(120))-(AutoTrans(80)), CGRectGetMinY(smallIconImg.frame), CGRectGetWidth(smallIconImg.frame), CGRectGetWidth(smallIconImg.frame))];
        otherImg.layer.cornerRadius=CGRectGetWidth(otherImg.frame)/2;
        otherImg.layer.masksToBounds=YES;
        otherImg.image=[UIImage imageNamed:@"icon_me"];
        [_recordInfoView addSubview:otherImg];
        //名称+时间
        UILabel *otherNameAndTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(otherImg.center.x-80, CGRectGetMaxY(otherImg.frame)+(AutoTrans(10)), 160, AutoTrans(40))];
        if (i==0) {
            otherNameAndTimeLb.text=@"他 5分钟";
        }else{
            otherNameAndTimeLb.text=@"他 第1名";
        }
        otherNameAndTimeLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
        otherNameAndTimeLb.textColor=[UIColor colorWithHexString:@"#333333"];
        otherNameAndTimeLb.textAlignment=NSTextAlignmentCenter;
        [_recordInfoView addSubview:otherNameAndTimeLb];
        //改变字体颜色
        NSMutableAttributedString *otherNoteString = [[NSMutableAttributedString alloc] initWithString:otherNameAndTimeLb.text];
        NSRange stringRange3 =NSMakeRange(1, 4); //该字符串的位置
        [otherNoteString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff8d55"] range:stringRange3];
        [otherNameAndTimeLb setAttributedText: otherNoteString];
        //正确单词数量
        if (i!=0) {
            UILabel *wordsCountLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(otherNameAndTimeLb.frame), CGRectGetMaxY(otherNameAndTimeLb.frame), CGRectGetWidth(otherNameAndTimeLb.frame), CGRectGetHeight(otherNameAndTimeLb.frame))];
            wordsCountLb.textColor=[UIColor colorWithHexString:@"#ff8d55"];
            wordsCountLb.font=[UIFont systemFontOfSize:AutoTrans(24)];
            wordsCountLb.text=@"正确30词/60秒";
            wordsCountLb.textAlignment=NSTextAlignmentCenter;
            [_recordInfoView addSubview:wordsCountLb];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
