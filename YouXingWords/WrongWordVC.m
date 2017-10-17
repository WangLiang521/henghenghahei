//
//  WrongWordVC.m
//  YouXingWords
//
//  Created by LDJ on 16/8/14.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "WrongWordVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BrowerWordsVC.h"
#import "PassList.h"
#import "TimerTools.h"
#import <SVProgressHUD.h>
#import "DakaView.h"

#import "LexiconViewController.h"
@interface WrongWordVC (){
    SystemSoundID _soundID;
    SystemSoundID _sentenceID;

}
@property (nonatomic,retain)NSDictionary *infoDic;

@property (nonatomic,retain)UILabel *wordLabel;
@property (nonatomic,retain)UILabel *pronunciationLabel;
@property (nonatomic,retain)UILabel *translateLabel;

@property (nonatomic,retain)UIImageView *infoImageView;
@property (nonatomic,retain)UILabel *imgSentenceEnLabel;
@property (nonatomic,retain)UILabel *imgSentenceChLabel;

@property (nonatomic,copy)NSString *mp3Path;
@property (nonatomic,copy)NSString *sentencePath;

@property (nonatomic,retain)UIImageView *centerDiamond;
@property (nonatomic,retain)UIImageView *leftDiamond;
@property (nonatomic,retain)UIImageView *rightDiamond;
@property (nonatomic,retain)UILabel     *BarrierInfoLabel;


@property (assign, nonatomic)  BreakthroughType type;


@end

@implementation WrongWordVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}


- (instancetype)initWith:(BreakthroughType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //start
//#pragma mark gd_转存学习时间,方便上传  2017-03-15 21:11:32
//    [TimerTools reSaveTimeNew];
//    //end
    
    [self initNavi];
    [self addWordView];
    [self addWordImageInfo];
    [self addContinueButton];
    if (_needShowFailView ) {
//        //start
//#pragma mark gd_分用户储存  0115
//        //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/answer.txt"];
//        NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@answer.txt",dict[@"username"]]];
//        //end
//        
//        NSArray *jsonArr =[NSArray arrayWithContentsOfFile:path];
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"passId":self.passId,@"passTime":self.time_second,@"wordsInfo":jsonStr};
//        [NetWorkingUtils postWithUrl:SubmitInfo params:paramsDic successResult:^(id response) {
//            if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
//                NSLog(@"%@",[response valueForKey:@"lastPassTime"]);
//            }
//            else{
//                NSLog(@"%@",response);
//            }
//        } errorResult:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
        //start
    #pragma mark gd_转存学习时间,方便上传  2017-03-15 21:11:32
        [TimerTools reSaveTimeNew];
        //end
#pragma mark gd_更改提交用户的闯关信息方式  0115
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        [NetWorkingUtils uploadBarrierInfoPassfail:YES passId:self.passId passTime:self.time_second currentVC:self];
        [NetWorkingUtils uploadBarrierInfoPassfail:YES passId:self.passId passTime:self.time_second currentVC:self With:_type];
        //end
        
    }
    

    
}
-(void)initNavi{
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImg.userInteractionEnabled = YES;
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    [self.view addSubview:backImg];

    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.tag = 233;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"做错了";
    titleLabel.userInteractionEnabled = YES;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset((AutoTrans(30))+20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(38)));
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 90, 34)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    [self.view addSubview:backButton];
    

}
-(void)addWordView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(36);
    whiteView.tag = 234;
    whiteView.layer.borderWidth = AutoTrans(4);
    whiteView.layer.borderColor = [[UIColor colorWithHexString:@"#ff697a"] CGColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(AutoTrans(36)));
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset(AutoTrans(50));
        make.width.mas_equalTo(@(SCREEN_WIDTH-((AutoTrans(36))*2)));
        make.height.mas_equalTo(@(AutoTrans(287)));
    }];
    
    _wordLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _wordLabel.textAlignment =1;
    _wordLabel.text = [_infoDic valueForKey:@"word"];;
//    _wordLabel.adjustsFontSizeToFitWidth = YES;
    _wordLabel.textColor = [UIColor colorWithHexString:@"#32b5e7"];
    _wordLabel.font = [UIFont systemFontOfSize:AutoTrans(52)];
    [self.view addSubview:_wordLabel];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(whiteView.mas_top).offset(AutoTrans(35));
        make.width.mas_equalTo(whiteView.mas_width);
        make.height.mas_equalTo(@(AutoTrans(52)));
    }];
    
    _pronunciationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _pronunciationLabel.textAlignment =1;
//    _pronunciationLabel.adjustsFontSizeToFitWidth = YES;
    _pronunciationLabel.text = [_infoDic valueForKey:@"phonetic"];
    _pronunciationLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _pronunciationLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
    [self.view addSubview:_pronunciationLabel];
    [_pronunciationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_wordLabel.mas_bottom).offset(AutoTrans(16));
        make.width.mas_equalTo(whiteView.mas_width);
        make.height.mas_equalTo(@(AutoTrans(30)));
    }];
    
    _translateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _translateLabel.textAlignment =1;
    _translateLabel.text = [_infoDic valueForKey:@"explain"];
//    _translateLabel.adjustsFontSizeToFitWidth = YES;
    _translateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _translateLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [self.view addSubview:_translateLabel];
    [_translateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_pronunciationLabel.mas_bottom).offset(AutoTrans(14));
        make.width.mas_equalTo(whiteView.mas_width);
        make.height.mas_equalTo(@(AutoTrans(28)));
    }];
    
    UIButton *readButton = [[UIButton alloc]initWithFrame:CGRectZero];
    readButton.layer.masksToBounds = YES;
    readButton.layer.cornerRadius = (AutoTrans(32))/1;
    readButton.layer.borderColor = [[UIColor colorWithHexString:@"#dbdbdb"] CGColor];
    readButton.layer.borderWidth = 1;
    [readButton setTitle:@"朗读" forState:UIControlStateNormal];
    readButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(29) ];
    [readButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [readButton setImage:[UIImage imageNamed:@"barrier_icon_sound"] forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(readButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [readButton setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(70), 0, -(AutoTrans(70)))];
    [readButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [self.view addSubview:readButton];
    [readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_translateLabel.mas_bottom).offset(AutoTrans(24));
        make.width.mas_equalTo(@(AutoTrans(168)));
        make.height.mas_equalTo(@(AutoTrans(64)));
    }];
    
}
-(void)addWordImageInfo{
    CGFloat imageH = AutoTrans(650);
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(36);
    whiteView.tag = 235;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(AutoTrans(40)));
        make.top.mas_equalTo([self.view viewWithTag:234].mas_bottom).offset(AutoTrans(25));
        make.width.mas_equalTo(@(SCREEN_WIDTH-((AutoTrans(40))*2)));
        make.height.mas_equalTo(@(AutoTrans(imageH+28+34+14+30+26+6)));
    }];
    
    _infoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _infoImageView.contentMode = UIViewContentModeScaleAspectFit;
   // [_infoImageView setImage:[UIImage imageNamed:@"barrier_icon_pic2"]];
//    NSString *str = [NSString stringWithFormat:@"Documents/%@/7z",[Utils getCurrentUserName]];
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[_infoDic valueForKey:@"image"]];
    _infoImageView.image = [UIImage imageWithContentsOfFile:imgPath];
    _infoImageView.layer.masksToBounds = YES;
    _infoImageView.layer.cornerRadius = AutoTrans(30);
    [self.view addSubview:_infoImageView];
    [_infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
//        make.top.mas_equalTo(whiteView.mas_top).offset(AutoTrans(6));
//        make.width.mas_equalTo(whiteView.mas_width).offset(-(AutoTrans(12)));
        make.top.mas_equalTo(whiteView.mas_top).offset(2);
        make.width.mas_equalTo(whiteView.mas_width).offset(-4);
        make.height.mas_equalTo(@(AutoTrans(imageH)));
    }];
    
    _imgSentenceEnLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _imgSentenceEnLabel.text = [_infoDic valueForKey:@"egEN"];
    _imgSentenceEnLabel.adjustsFontSizeToFitWidth = YES;
    _imgSentenceEnLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _imgSentenceEnLabel.font = [UIFont systemFontOfSize:AutoTrans(36)];
    _imgSentenceEnLabel.numberOfLines = 0;
    _imgSentenceEnLabel.textAlignment = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sentenceReadOnClick:)];
    _imgSentenceEnLabel.userInteractionEnabled = YES;
    [_imgSentenceEnLabel addGestureRecognizer:tap];
    
    [self.view addSubview:_imgSentenceEnLabel];
    [_imgSentenceEnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX).offset(-(AutoTrans(8)));
        make.top.mas_equalTo(_infoImageView.mas_bottom).offset(AutoTrans(28));
        make.width.mas_equalTo(whiteView.mas_width).offset(-(AutoTrans(38*2)));
        make.height.mas_equalTo(@(AutoTrans(36)));
    }];
    
//    UIButton *sentenceRead = [[UIButton alloc]initWithFrame:CGRectZero];
//    [sentenceRead setImage:[UIImage imageNamed:@"barrier_icon_sound"] forState:UIControlStateNormal];
//    [sentenceRead addTarget:self action:@selector(sentenceReadOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sentenceRead];
//    [sentenceRead mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_imgSentenceEnLabel.mas_right);
//        make.top.mas_equalTo(_infoImageView.mas_bottom).offset(AutoTrans(28));
//        make.width.mas_equalTo(@(AutoTrans(36)));
//        make.height.mas_equalTo(@(AutoTrans(36)));
//    }];
    
    
    _imgSentenceChLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _imgSentenceChLabel.text = [_infoDic valueForKey:@"egCN"];
    _imgSentenceChLabel.adjustsFontSizeToFitWidth = YES;
    _imgSentenceChLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _imgSentenceChLabel.font = [UIFont systemFontOfSize:AutoTrans(34)];
    _imgSentenceChLabel.textAlignment = 1;
    [self.view addSubview:_imgSentenceChLabel];
    
    [_imgSentenceChLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_imgSentenceEnLabel.mas_bottom).offset(AutoTrans(14));
        make.width.mas_equalTo(whiteView.mas_width).offset(-(AutoTrans(38*2)));
        make.height.mas_equalTo(@(AutoTrans(34)));
    }];

    

}
-(void)addContinueButton{
    UIButton *continueBTN = [[UIButton alloc]initWithFrame:CGRectZero];
    [continueBTN setBackgroundColor:[UIColor colorWithHexString:@"#64bfff"]];
    continueBTN.layer.masksToBounds = YES;
    continueBTN.layer.cornerRadius = (AutoTrans(90))/2;
    [continueBTN setTitle:@"继续" forState:UIControlStateNormal];
    [continueBTN addTarget:self action:@selector(continueBarrier:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBTN];
    [continueBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(AutoTrans(96)));
        make.top.mas_equalTo([self.view viewWithTag:235].mas_bottom).offset(AutoTrans(30));
        make.width.mas_equalTo(@(SCREEN_WIDTH-((AutoTrans(96))*2)));
        make.height.mas_equalTo(@(AutoTrans(90)));
    }];

}
-(void)addFailView{
    UIView *blackView = [[UIView alloc]initWithFrame:self.view.frame];
    blackView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
    [self.view addSubview:blackView];
    
    UIView *backView = [[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    UIImageView *infoBackImg = [[UIImageView alloc]initWithFrame:YXFrame(43, 247, 660, 486)];
    [infoBackImg setImage:[UIImage imageNamed:@"icon_base_fail"]];
    [backView addSubview:infoBackImg];
    
    UIImageView *successImg = [[UIImageView alloc]initWithFrame:YXFrame(137, 196, 476, 124)];
    [successImg setImage:[UIImage imageNamed:@"barrier_icon_fail_title"]];
    [backView addSubview:successImg];
    
    UIButton *button = [[UIButton alloc]initWithFrame:YXFrame(642, 247, 74, 74)];
    [button setImage:[UIImage imageNamed:@"barrier_icon_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToLexicon:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    _centerDiamond = [[UIImageView alloc]initWithFrame:YXFrame(301, 353, 162, 128)];
    [_centerDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal_center"]];
    [backView addSubview:_centerDiamond];
    //151 是算出来的
    _leftDiamond = [[UIImageView alloc]initWithFrame:YXFrame(151, 371, 128, 108)];
    [_leftDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamond_normal_left"]];
    [backView addSubview:_leftDiamond];
    
    _rightDiamond = [[UIImageView alloc]initWithFrame:YXFrame(485, 371, 128, 108)];
    [_rightDiamond setImage:[UIImage imageNamed:@"barrier_icon_diamondl_normal_right"]];
    [backView addSubview:_rightDiamond];
    
    UIButton *restartButton=[[UIButton alloc]initWithFrame:YXFrame(209, 639, 132, 136)];
    [restartButton addTarget:self action:@selector(restartOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [restartButton setImage:[UIImage imageNamed:@"barrier_icon_again"] forState:UIControlStateNormal];
    [backView addSubview:restartButton];
    
    UIButton *nextButton=[[UIButton alloc]initWithFrame:YXFrame(32+373, 639, 132, 136)];
    [nextButton addTarget:self action:@selector(nextOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"barrier_icon_nextbarrier"] forState:UIControlStateNormal];
    [backView addSubview:nextButton];
    
    _BarrierInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerDiamond.frame), SCREEN_WIDTH, CGRectGetMinY(restartButton.frame)-CGRectGetMaxY(_centerDiamond.frame))];
    _BarrierInfoLabel.textAlignment =1;
    _BarrierInfoLabel.font = [UIFont fontWithName:HYCHAOCU size:AutoTrans(33)];
    _BarrierInfoLabel.numberOfLines = 3;
    _BarrierInfoLabel.textColor = [UIColor whiteColor];
    _BarrierInfoLabel.shadowColor = [UIColor colorWithHexString:@"#3a230a"];
    _BarrierInfoLabel.shadowOffset =CGSizeMake(-1, 1);
    

    
    _BarrierInfoLabel.text = self.failInfo;
    [backView addSubview:_BarrierInfoLabel];
    
    
    DakaView * dkView = [DakaView shareWithCurrentVC:self];
    [dkView setFailPic];
    [self.view addSubview:dkView];
    [self.view bringSubviewToFront:dkView];
    self.view.userInteractionEnabled = YES;
    DEFINE_WEAK(dkView);
    [dkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GDAutoTrans(56));
        make.right.mas_equalTo(-GDAutoTrans(56));
        make.bottom.mas_equalTo(-GDAutoTrans(200));
        make.height.mas_equalTo(wdkView.mas_width).multipliedBy(312.0/644);
    }];
    
}

-(void)restartOnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate needRestart];
}
-(void)nextOnClick:(UIButton *)button{
    if (self.navigationController.viewControllers[2]) {
        BrowerWordsVC *vc =self.navigationController.viewControllers[2];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        if ([PassList canGetNext]) {
        if ([PassList canGetNextWith:_type]) {
        //end

        
            vc.item = [PassList getNext];
            [self.navigationController popToViewController:vc animated:YES];

        }else{
            
            [SVProgressHUD showErrorWithStatus:@"没有下一关或下一关没有解锁"];
            //start
#pragma mark gd_修改返回方式,解决复习关问题  2017-03-28 09:57:55
            UIViewController * firstVC = [self.navigationController.viewControllers objectAtIndex:0];
            [self.navigationController popToViewController:firstVC animated:NO];
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
            //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
            LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:_type];
            //end
            lexiconVC.hidesBottomBarWhenPushed = YES;
            
            [firstVC.navigationController pushViewController:lexiconVC animated:NO];
            //            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            //end
        }
    }
    
}

-(void)setWordID:(NSNumber *)wordID{
    _wordID =wordID;
//    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]];
//
//    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
//    //解压
//    
//    NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
//    NSString *unarchiveBase = [pathArr objectAtIndex:0];
//    if ([unarchiveBase isEqualToString:@".DS_Store"]) {
//        if (pathArr.count>1) {
//            unarchiveBase = [pathArr objectAtIndex:1];
//        }
//    }
    //解析wordInfos.txt
//    NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:_type],@"txt/wordInfos.json"];
    //end
    


#pragma mark gd_修改获取资源包方式
    NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
    NSError *error;
//    NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSError *error;
//    NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!firstDic) {
        NSLog(@"%@",error);
    }
    NSArray *tempArr=[firstDic valueForKey:@"data"];
    for (int i=0; i<tempArr.count; i++) {
        
        if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[_wordID integerValue]) {
            _infoDic =tempArr[i];
//            _wordLabel.text = [_infoDic valueForKey:@"word"];
//            _translateLabel.text = [_infoDic valueForKey:@"explain"];
//            _pronunciationLabel.text = [_infoDic valueForKey:@"phonetic"];
//            _imgSentenceChLabel.text = [_infoDic valueForKey:@"egCN"];
//            _imgSentenceEnLabel.text = [_infoDic valueForKey:@"egEN"];
//            NSString *str7z = [NSString stringWithFormat:@"Documents/%@/7z",[Utils getCurrentUserName]];
            NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//            NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//            NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
            _mp3Path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[_infoDic valueForKey:@"audio"]];
            _sentencePath =[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[_infoDic valueForKey:@"eg"]];
            
//            NSString *imgPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7z"],[_infoDic valueForKey:@"image"]];
//            _infoImageView.image = [UIImage imageWithContentsOfFile:imgPath];
            break;
        }
       
    }
    if (_mp3Path) {
        NSURL *soundURL = [NSURL URLWithString:[_mp3Path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
    }
    if (_sentencePath) {
        NSURL *soundURL = [NSURL URLWithString:[_sentencePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_sentenceID);
    }

}

#pragma mark - 界面跳转
-(void)naviPop:(UITapGestureRecognizer *)tap{
    if (_needShowFailView ) {
        [self addFailView];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block();
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    if (_soundID) {
        AudioServicesDisposeSystemSoundID(_soundID);
    }
    if (_sentenceID) {
        AudioServicesDisposeSystemSoundID(_sentenceID);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(_sentenceID);

    });
}
#pragma mark - 点击事件
-(void)readButtonOnClick:(UIButton *)button{
    AudioServicesPlaySystemSound(_soundID);
}
-(void)continueBarrier:(UIButton *)button{
    if (_needShowFailView ) {
        [self addFailView];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block();
        }
    }


}
-(void)sentenceReadOnClick:(UIButton *)button{
    AudioServicesPlaySystemSound(_sentenceID);
}
-(void)backToLexicon:(UIButton *)button{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
