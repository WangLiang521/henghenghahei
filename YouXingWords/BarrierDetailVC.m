//
//  BarrierDetailVC.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BarrierDetailVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YXProgressBar.h"
#import "YXTimeProgress.h"

#import "ChoiceCell.h"
#import "ChoiceLong.h"

#import "AnswerTools.h"
#import "TimerTools.h"

#import "BarrierSuccessVC.h"
#import "WrongWordVC.h"

#import "AlreadyWordNum.h"

#import "LexiconViewController.h"

@interface BarrierDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,YXAnswerWrong,YXTimeProgressDelegate,RestartOrNextDelegate>{
    NSTimer *timer;
    SystemSoundID _soundID;
    SystemSoundID _rightID;
    SystemSoundID _wrongID;
}
@property (nonatomic,assign)BOOL shouldGoNext;//正确选项
@property (nonatomic,assign)BOOL wrongGoNext;//错误选择

@property (nonatomic,assign)NSInteger currentQs;    //当前第几题
@property (nonatomic,copy)NSString *rightAnswer;    //当前正确答案
@property (nonatomic,copy)NSString * currentType;   //1 拼写 2图片 other文字 4
@property (nonatomic,strong)NSMutableArray *list;          //所有题目
@property (nonatomic,retain)UILabel *needReview;
@property (nonatomic,retain)UILabel *lastWord;
@property (nonatomic,retain)UILabel *heartNumLabel;

@property (nonatomic,retain)YXProgressBar *wordsProgress;

@property (nonatomic,retain)YXTimeProgress *timerProgress;
@property (nonatomic,retain)UILabel *wordLabel;
@property (nonatomic,retain)UILabel *sentenceLabel;

@property (nonatomic,retain)NSMutableArray *answerArray;
@property (nonatomic,retain)UICollectionView *collectionView;
@property (retain, nonatomic ) UICollectionViewFlowLayout *collectFlowLayout;
@property (nonatomic,retain)UIButton *iDontKnow;


@property (nonatomic,retain) UIView          *typeSpellView; //拼写题目
@property (nonatomic,retain) UILabel         *spellLabel;
@property (nonatomic,retain) UITextField     *virtualField;
@property (nonatomic,copy  ) NSMutableString *knownStr;
@property (nonatomic,copy  ) NSString        *OriginalStr;

@property (nonatomic,retain)UIButton * listenButton;//听力题  耳机形button
@property (nonatomic,retain)UIButton * readButton;//其他选择题 小型button

@property(nonatomic,assign)BOOL ifSpell;
@property(nonatomic,assign)BOOL ifPronunciation;

@property(nonatomic,assign)BOOL ifAlertPlay;
@property(nonatomic,assign)BOOL ifWordPlay;

@property (nonatomic,assign)NSInteger time_second;

/**
 *  记录单词连续作对的次数,每当做错一次,将单词连续作对次数置0
 */
@property (strong, nonatomic)  NSMutableDictionary *WordDict;


@property (assign, nonatomic)  BreakthroughType type;



/**
 *  当前要播放的mp3的路径
 */
@property (copy, nonatomic)  NSString * currentSoundPath;

@end

@implementation BarrierDetailVC

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
    [self initNavi];
    [self addLastWordLabel];
    [self addProgressBar];
    [self addWordView];
    [self addChoices];
    [self addIDontKnow];
    [self addTypeSpellView];
    self.currentQs =0;
    [AnswerTools setDelegate:self];
    [AnswerTools beginRecorder];
    [self initAlert];
    
    [Utils saveStartTime];
    
}

- (NSMutableDictionary *)WordDict{
    if (!_WordDict) {
        _WordDict = [NSMutableDictionary dictionary];
    }
    return _WordDict;
}

-(NSMutableArray *)answerArray{
    if (!_answerArray) {
        _answerArray = [NSMutableArray array];
    }
    return _answerArray;
}
-(NSMutableString *)knownStr{
    if (!_knownStr) {
        _knownStr = [NSMutableString string];
    }
    return _knownStr;
}
-(void)initAlert{
    NSString *pathError = [[NSBundle mainBundle]pathForResource:@"error" ofType:@"wav"];
    NSURL *soundURLError = [NSURL URLWithString:pathError];
    if (_wrongID) {
        AudioServicesDisposeSystemSoundID(_wrongID);
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURLError), &_wrongID);
    
    NSString *pathRight = [[NSBundle mainBundle]pathForResource:@"right" ofType:@"wav"];
    NSURL *soundURLRight = [NSURL URLWithString:pathRight];
    if (_rightID) {
        AudioServicesDisposeSystemSoundID(_rightID);
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURLRight), &_rightID);
    
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
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(42)];
    titleLabel.text = _item.passName;
    titleLabel.userInteractionEnabled = YES;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset((AutoTrans(30))+20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(42)));
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 90, 34)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
}
-(void)addLastWordLabel{
    _needReview = [[UILabel alloc]initWithFrame:CGRectZero];
    _needReview.textColor = [UIColor whiteColor];
    _needReview.text = @"需复习 2";
    _needReview.hidden = YES;
    _needReview.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [self.view addSubview:_needReview];
    [_needReview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.left.mas_equalTo(@(AutoTrans(44)));
        make.height.mas_equalTo(@(AutoTrans(28)));
    }];
    
    _lastWord = [[UILabel alloc]initWithFrame:CGRectZero];
    _lastWord.textColor = [UIColor whiteColor];
    _lastWord.tag = 234;
    _lastWord.hidden = NO;
    _lastWord.text = @"上个单词：producter 制片人";
    _lastWord.font = [UIFont systemFontOfSize:AutoTrans(28)];
    _lastWord.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_lastWord];
    [_lastWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(28)));
        
        #pragma mark gd_答题页提示上一题单词 0115
        make.left.mas_equalTo(self.view).offset((AutoTrans(40)));
    }];

}
-(void)addProgressBar{
    _wordsProgress = [[YXProgressBar alloc]initWithFrame:CGRectZero];

    [self.view addSubview:_wordsProgress];
    [_wordsProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:234].mas_bottom).offset((AutoTrans(14)));
        make.left.mas_equalTo(@(AutoTrans(40)));
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(150)));
    }];
    _wordsProgress.sum = 50;
    _wordsProgress.current = 6;
    
    
    UIView *littleWhtie = [[UIView alloc]initWithFrame:CGRectZero];
    littleWhtie.backgroundColor = [UIColor whiteColor];
    littleWhtie.layer.masksToBounds = YES;
    littleWhtie.layer.cornerRadius =(AutoTrans(30))/2;
    [self.view addSubview:littleWhtie];
    [littleWhtie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_wordsProgress.mas_top);
        make.left.mas_equalTo(_wordsProgress.mas_right).offset(AutoTrans(9));
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(60)));
    }];
    
    _heartNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _heartNumLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
    _heartNumLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _heartNumLabel.textAlignment =1;
    _heartNumLabel.text = @"6";
    _heartNumLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_heartNumLabel];
    [_heartNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_wordsProgress.mas_top);
        make.left.mas_equalTo(_wordsProgress.mas_right).offset(AutoTrans(29));
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.right.mas_equalTo(littleWhtie.mas_right).offset(-(AutoTrans(20)));
    }];
    
    UIImageView *heart = [[UIImageView alloc]initWithFrame:CGRectZero];
    heart.image = [UIImage imageNamed:@"barrier_icon_heart_selected"];
    [self.view addSubview:heart];
    [heart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_wordsProgress.mas_centerY);
        make.width.mas_equalTo(@(AutoTrans(40)));
        make.height.mas_equalTo(@(AutoTrans(40)));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(40)));
    }];

}
-(void)addWordView{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(36);
    whiteView.tag = 235;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(AutoTrans(41)));
        make.top.mas_equalTo(_wordsProgress.mas_bottom).offset(AutoTrans(32));
        make.width.mas_equalTo(@(SCREEN_WIDTH-((AutoTrans(41))*2)));
        make.height.mas_equalTo(@(AutoTrans(294)));
    }];

    _timerProgress = [[YXTimeProgress alloc]initWithFrame:CGRectZero];
    _timerProgress.delegate =self;
    [self.view addSubview:_timerProgress];
    [_timerProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(whiteView.mas_top).offset(AutoTrans(35));
        make.width.mas_equalTo(whiteView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(@(AutoTrans(12)));
    }];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df valueForKey:@"waitingTime"]) {
        _timerProgress.sum = [[df valueForKey:@"waitingTime"]integerValue];
    }else{
        [df setValue:@10 forKey:@"waitingTime"];
        _timerProgress.sum =10;
    }
    _timerProgress.current = 0;
    
    _wordLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _wordLabel.textAlignment =1;
    _wordLabel.text = @"n.制片人";
    _wordLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _wordLabel.font = [UIFont systemFontOfSize:AutoTrans(60)];
    _wordLabel.adjustsFontSizeToFitWidth = YES;
//    _wordLabel.numberOfLines = 2;
    [self.view addSubview:_wordLabel];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_timerProgress.mas_bottom).offset(AutoTrans(30));
        make.height.mas_equalTo(@(AutoTrans(60)));
        //start
#pragma mark gd_解决汉译比较长的单词出格  2017-03-22 22:14:50-12
        make.width.mas_equalTo(whiteView.mas_width).mas_offset(-10);
        //end
    }];
    
    _sentenceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _sentenceLabel.textAlignment =1;
    _sentenceLabel.text = @"我想吃苹果\ni want to eat ____";
    _sentenceLabel.numberOfLines = 0;
    _sentenceLabel.adjustsFontSizeToFitWidth = YES;
    _sentenceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _sentenceLabel.font = [UIFont systemFontOfSize:AutoTrans(60)];
    [self.view addSubview:_sentenceLabel];
    self.sentenceLabel.hidden = YES;
    [_sentenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_timerProgress.mas_bottom).offset(AutoTrans(30));
                make.width.mas_equalTo(whiteView.mas_width);
        make.height.mas_equalTo(@(AutoTrans(100)));
    }];
    

    
    _readButton = [[UIButton alloc]initWithFrame:CGRectZero];
    _readButton.layer.masksToBounds = YES;
    _readButton.layer.cornerRadius = (AutoTrans(32))/1;
    _readButton.layer.borderColor = [[UIColor colorWithHexString:@"#dbdbdb"] CGColor];
    _readButton.layer.borderWidth = 1;
    [_readButton setTitle:@"朗读" forState:UIControlStateNormal];
    _readButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(29) ];
    [_readButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_readButton setImage:[UIImage imageNamed:@"barrier_icon_sound"] forState:UIControlStateNormal];
    
    [_readButton setImageEdgeInsets:UIEdgeInsetsMake(0, AutoTrans(70), 0, -(AutoTrans(70)))];
    [_readButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-( AutoTrans(40)), 0, AutoTrans(40))];
    [_readButton addTarget:self action:@selector(listenButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_readButton];
    [_readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_wordLabel.mas_bottom).offset(AutoTrans(40));
        make.width.mas_equalTo(@(AutoTrans(168)));
        make.height.mas_equalTo(@(AutoTrans(64)));
    }];
    
    _listenButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_listenButton setImage:[UIImage imageNamed:@"barrier_icon_listen"] forState:UIControlStateNormal];
    _listenButton.hidden = YES;
    [self.view addSubview:_listenButton];
    [_listenButton addTarget:self action:@selector(listenButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_listenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.centerY.mas_equalTo(whiteView.mas_centerY);
        make.width.mas_equalTo(@(AutoTrans(170)));
        make.height.mas_equalTo(@(AutoTrans(170)));
    }];
    
}
-(void)addChoices{
    _collectFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectFlowLayout.minimumLineSpacing =AutoTrans(20);
    _collectFlowLayout.minimumInteritemSpacing=0;
    //_collectFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemSizeWidth = AutoTrans(329);
    CGFloat itemSizeHeight = (AutoTrans(224))+20;
    _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth-(AutoTrans(10)), itemSizeHeight);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(AutoTrans(34),CGRectGetMaxY([self.view viewWithTag:235].frame)+(AutoTrans(42)), itemSizeWidth*2, itemSizeHeight*2+20) collectionViewLayout:_collectFlowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[ChoiceCell class] forCellWithReuseIdentifier:@"ChoiceCell"];
    [self.collectionView registerClass:[ChoiceLong class] forCellWithReuseIdentifier:@"ChoiceLong"];
    [self.view addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo([self.view viewWithTag:235].mas_bottom).offset(AutoTrans(42));
        make.width.mas_equalTo(@(itemSizeWidth*2));
        make.height.mas_equalTo(@(itemSizeHeight*2+20));
    }];

    
}
-(void)addIDontKnow{
    _iDontKnow = [[UIButton alloc]initWithFrame:CGRectZero];
    [_iDontKnow setBackgroundColor:[UIColor colorWithHexString:@"#64bfff"]];
    _iDontKnow.layer.masksToBounds = YES;
    _iDontKnow.layer.cornerRadius = (AutoTrans(12))/2;
    [_iDontKnow setTitle:@"我不会" forState:UIControlStateNormal];
    [_iDontKnow addTarget:self action:@selector(iDontKnowOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iDontKnow];
    [_iDontKnow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(AutoTrans(44));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(44)));
        make.top.mas_equalTo(_collectionView.mas_bottom).offset(AutoTrans(30));
        make.height.mas_equalTo(@(AutoTrans(80)));
    }];
}
-(void)addTypeSpellView{
    _typeSpellView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_typeSpellView];
    [self.typeSpellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionView.mas_left);
        make.top.mas_equalTo(self.collectionView.mas_top);
        make.right.mas_equalTo(self.collectionView.mas_right);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom);
    }];
    
    _spellLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _spellLabel.font = [UIFont systemFontOfSize:AutoTrans(72)];
    _spellLabel.textColor = [UIColor whiteColor];
    _spellLabel.textAlignment =1;
    _spellLabel.numberOfLines = 2;
    _spellLabel.adjustsFontSizeToFitWidth = YES;
    _spellLabel.text = [self strWithKnownStr:@"P" AndOriginalStr:@"Panda"];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(virtualFieldToFirst)];
    _spellLabel.userInteractionEnabled = YES;
    [_spellLabel addGestureRecognizer:tap];
    [_typeSpellView addSubview:_spellLabel];
    WS(weakSelf);
    [self.spellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.collectionView.mas_left);
        make.top.mas_equalTo(weakSelf.collectionView.mas_top).offset(AutoTrans(50));
//        make.right.mas_equalTo(self.collectionView.mas_right);
        make.height.mas_equalTo(@((AutoTrans(80)) * 2));
        make.width.mas_equalTo((AutoTrans(329))*2);
        make.centerX.mas_equalTo(weakSelf.collectionView.mas_centerX);
    }];
    
    _virtualField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _virtualField.hidden = YES;
    _virtualField.delegate = self;
    _virtualField.keyboardType = UIKeyboardTypeAlphabet;
    _virtualField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_typeSpellView addSubview:_virtualField];

}
#pragma mark - textField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    NSLog(@"range = %@",NSStringFromRange(range));
//    if ([string isEqualToString:@""]) {
//        if (_knownStr.length>0) {
//            [_knownStr deleteCharactersInRange:NSMakeRange(_knownStr.length-1, 1)];
//            //        _knownStr = [NSMutableString stringWithString:@""];
//            _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
//        }
//
//        return YES;
//
//    }
//    [_knownStr appendString:[string lowercaseString]];
//    _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
//
//    if (_knownStr.length >=_OriginalStr.length) {
//        [textField resignFirstResponder];
//        if ([[_knownStr lowercaseString] isEqualToString:[_OriginalStr lowercaseString] ]) {
//            if (self.ifWordPlay) {
//                self.shouldGoNext = YES;
//            }
//            [self answerRight];
//            [self getNextQs];
//
//        }
//        else{
//            if (self.ifWordPlay) {
//                self.wrongGoNext = YES;
//            }
//            [self answerWrong];
//        }
//    }
//    return YES;
    /**
     *  自动添加空格,学生答题不必再写空格,相应的在答案出加上空格
     */
    NSLog(@"range = %@",NSStringFromRange(range));
    if ([string isEqualToString:@""]) {
        if (_knownStr.length>0) {
            [_knownStr deleteCharactersInRange:NSMakeRange(_knownStr.length-1, 1)];
            //        _knownStr = [NSMutableString stringWithString:@""];
            _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
        }
        return YES;
    }
    [_knownStr appendString:[string lowercaseString]];
    _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
    
    NSString * answerStr = [_OriginalStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_knownStr.length >=answerStr.length) {
        [textField resignFirstResponder];
        NSString * tempKnownStr = [LGDUtils cleanChinaChar:_knownStr];
        NSString * tempAnswer = [LGDUtils cleanChinaChar:answerStr];
//
//        
//        
        if ([[tempKnownStr lowercaseString] isEqualToString:[tempAnswer lowercaseString] ]) {
//        if ([[_knownStr lowercaseString] isEqualToString:[answerStr lowercaseString] ]) {
            if (self.ifWordPlay) {
                self.shouldGoNext = YES;
            }
            [self answerRight];
            //            [self getNextQs];
            
        }
        else{
            if (self.ifWordPlay) {
                self.wrongGoNext = YES;
            }
            [self answerWrong];
        }
    }

    return YES;
}
-(NSString *)strWithKnownStr:(NSString *)knownStr AndOriginalStr:(NSString *)originalStr{
//    NSMutableString *finalStr = [NSMutableString string];
//    
//    for (int i=0; i<knownStr.length; i++) {
//        [finalStr appendFormat:@"%@ ",[knownStr substringWithRange:NSMakeRange(i, 1)]];
//    }
//    for (int i=0; i<originalStr.length-knownStr.length; i++) {
//        [finalStr appendString:@"_ "];
//
//    }
//    
//    return  finalStr;
    
    NSMutableString *finalStr = [NSMutableString stringWithString:knownStr];
//
//    NSRange rangeStr = [originalStr rangeOfString:@" "];
//    for (int i=0; i<knownStr.length; i++) {
//        [finalStr appendFormat:@"%@ ",[knownStr substringWithRange:NSMakeRange(i, 1)]];
//    }
//    for (int i=0; i<originalStr.length-knownStr.length - rangeStr.length; i++) {
//        [finalStr appendString:@"_ "];
//        
//    }
//    
//    if (rangeStr.location != NSNotFound) {
////        [finalStr insertString:@"  " atIndex:rangeStr.location+2];
//        [finalStr insertString:@"  " atIndex:rangeStr.location*2];
//    }
    
    for (int i = 0; i < finalStr.length; i++) {
        
        NSString * curStr = [originalStr substringWithRange:NSMakeRange(i, 1)];
        if ([curStr isEqualToString:@" "] || [curStr isEqualToString:@" "]) {
            [finalStr insertString:@" " atIndex:i];
        }
    }
    
    
    for (int i = (int)finalStr.length ; i < originalStr.length; i ++) {
        NSString * curStr = [originalStr substringWithRange:NSMakeRange(i, 1)];
        if ([curStr isEqualToString:@" "] || [curStr isEqualToString:@" "]) {
            [finalStr appendFormat:@" "];
        }else{
            [finalStr appendFormat:@"_"];
        }
    }
    
    for (int i = (int)finalStr.length; i > 0; i --) {
        [finalStr insertString:@" " atIndex:i];
    }
    
    
    
    return  finalStr;
}
#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return 4;
    return self.answerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceFatherCell *cell;
    if ([_currentType isEqualToString:@"3"]||[_currentType isEqualToString:@"6"]) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChoiceCell" forIndexPath:indexPath];
        [cell resetGreen];


    }
    else if ([_currentType isEqualToString:@"2"]){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChoiceLong" forIndexPath:indexPath];
        [cell resetGreen];
    }
    else{
        cell = nil;
    }
    cell.item = self.answerArray[indexPath.row];
    return cell;
}
#pragma mark - collectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceFatherCell *cell = ( ChoiceFatherCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setWrong];

    for (int i=0; i<self.answerArray.count; i++) {
        if ([_rightAnswer isEqualToString:[self.answerArray[i] option]]) {
            ChoiceFatherCell *cell = (ChoiceFatherCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell didSelected];
        }
    }
    collectionView.userInteractionEnabled =NO;
    [_timerProgress stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_rightAnswer isEqualToString:[self.answerArray[indexPath.row] option]]) {
            QsModel *model  =[self.list objectAtIndex:_currentQs-1];
            _rightAnswer = model.qAnswer;
            _timerProgress.current=0;
            //    [_timerProgress beginMove];
            if (model.qAudio) {
                NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],model.qAudio];
                NSURL *soundURL = [NSURL URLWithString:path];
                if (_soundID) {
                    AudioServicesDisposeSystemSoundID(_soundID);
                }
                AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
                AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback2, (__bridge void *)self);
                
            }
            if (self.ifWordPlay) {
                self.shouldGoNext = YES;
            }
            [self answerRight];
//            [self getNextQs];

        } else{
            if (self.ifWordPlay) {
                self.wrongGoNext = YES;
            }
            [self answerWrong];
        }


    });
}

void BarrierCompletionCallback2(SystemSoundID soundID,void *clientData){
    //[SVProgressHUD showInfoWithStatus:@"请跟读"];
//    AudioServicesDisposeSystemSoundID(soundID);
    
    //start
#pragma mark gd_新加的,之前这一步是在 BarrierCompletionCallback2 中,下一题发音后回调的,因为有的题目找不到 mp3 所以修改了这种方式  2017-05-23 17:29:52
    if (((__bridge BarrierDetailVC *)clientData).shouldGoNext) {
        ((__bridge BarrierDetailVC *)clientData).shouldGoNext=NO;
        [((__bridge BarrierDetailVC *)clientData) getNextQs];
    }
    if (((__bridge BarrierDetailVC *)clientData).wrongGoNext) {
        ((__bridge BarrierDetailVC *)clientData).wrongGoNext=NO;
        [(__bridge BarrierDetailVC *)clientData afterReadAnswerWrong];
    }
    //end
    
   
    //    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //
    //    if (!mgr.isReachable) {
    //        [SVProgressHUD showErrorWithStatus:@"没有网络"];
    //    }
    //    [(__bridge PronunciationVC *)clientData onBtnStart:nil];
    
}


/**
 *  新加的,之前这一步是在 BarrierCompletionCallback2 中,下一题发音后回调的,因为有的题目找不到 mp3 所以修改了这种方式
 */
- (void)checkToGetNext{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.currentSoundPath]) {
            if (self.shouldGoNext) {
                self.shouldGoNext=NO;
                [self getNextQs];
            }
            if (self.wrongGoNext) {
                self.wrongGoNext=NO;
                [self afterReadAnswerWrong];
            }
        }
        
    });
}

-(BOOL)ifAlertPlay{
    if (!_ifAlertPlay) {
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
      
        _ifAlertPlay = [[df objectForKey:@"AlertNotPlay"]isEqualToNumber:@1]?NO:YES;
    }
    return _ifAlertPlay;
}


-(BOOL)ifWordPlay{
    if (!_ifWordPlay) {
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        _ifWordPlay = [[df objectForKey:@"WordNotPlay"]isEqualToNumber:@1]?NO:YES;
    }
    return _ifWordPlay;
}
#pragma mark  下一题
-(void)getNextQs{
    _collectionView.userInteractionEnabled = YES;
    [_timerProgress start];
    
    if (self.list.count<=_currentQs || _currentQs >= PassSuccessAfterQsIndex) {
#pragma mark gd_答完所有题目
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        BarrierSuccessVC *successVC = [[BarrierSuccessVC alloc]init];
        BarrierSuccessVC *successVC = [[BarrierSuccessVC alloc]initWith:_type];
        //end
        
        successVC.delegate = self;
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"timer"];
        successVC.time_second =num;
        successVC.successInfo = [self getInfo];
        successVC.passId = self.item.passID;
        [self.navigationController pushViewController:successVC animated:YES];
        if (_soundID) {
            AudioServicesDisposeSystemSoundID(_soundID);
        }
        return;
    }
    
    QsModel *model  =[self.list objectAtIndex:_currentQs];

#ifdef DEBUG
    for (NSInteger i = _currentQs ; i < self.list.count ; i ++) {
        QsModel *models = [self.list objectAtIndex:i];
        if ([models.qType integerValue] == 1 && [models.qWord isEqualToString:TestWord]) {
            model = models;
            _currentQs = i;
            break;
        }
        if ([models.qType integerValue] == [TestType integerValue] && [TestWord isEqualToString:@""]) {
            model = models;
            _currentQs = i;
            break;
        }
        
    }
#endif
    
    [AlreadyWordNum handleWithNumber:model.qWordID];
    _rightAnswer = model.qAnswer;
    _timerProgress.current=0;
    
    //start
#pragma mark gd_答题页提示上一题单词  0115
    if (_currentQs > 0) {
        QsModel *model  =[self.list objectAtIndex:_currentQs - 1];
        _lastWord.text = [NSString stringWithFormat:@"上一单词:%@ %@",model.qWord,model.qExplain];
    }else{
        _lastWord.text = [NSString stringWithFormat:@""];
    }
    
    //end
    
//    题型1 不播放声音
//    if ([model.qType integerValue] != 1) {
        if (model.qAudio) {
            NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
            
            NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],model.qAudio];
            self.currentSoundPath = [NSString stringWithFormat:@"%@",path];
            NSURL *soundURL = [NSURL URLWithString:path];
            if (!soundURL) {
                soundURL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            if (_soundID) {
                AudioServicesDisposeSystemSoundID(_soundID);
            }
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
            AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback2, (__bridge void *)self);
            
        }else{
            
            //解析wordInfos.txt
            NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
            NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
           
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//             NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
             NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:_type],@"txt/wordInfos.json"];
            //end
#pragma mark gd_修改获取资源包方式
            NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
            NSError *error;
            if (!firstDic) {
                NSLog(@"%@",error);
            }
            NSArray *tempArr=[firstDic valueForKey:@"data"];
            for (int i=0; i<tempArr.count; i++) {
                
                if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {
                    NSDictionary * _infoDic =tempArr[i];
                    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                    NSString* _mp3Path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[_infoDic valueForKey:@"audio"]];
                    self.currentSoundPath = [NSString stringWithFormat:@"%@",_mp3Path];
                    NSURL *soundURL = [NSURL URLWithString:_mp3Path];
                    if (!soundURL) {
                        soundURL = [NSURL URLWithString:[_mp3Path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    if (_soundID) {
                        AudioServicesDisposeSystemSoundID(_soundID);
                    }
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
                    AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback2, (__bridge void *)self);
                    break;
                }
                
            }
            
        }

//    }
//    else{
//        if (self.shouldGoNext) {
//            self.shouldGoNext=NO;
//            [self getNextQs];
//        }
//        if (self.wrongGoNext) {
//            self.wrongGoNext=NO;
//            [self afterReadAnswerWrong];
//        }
//    }
    
    
    
    
#pragma mark 拼写题 有听力  1拼写 2听力 3看图 4句子翻译 5单词翻译 6英译汉
    
    if ([model.qType integerValue]==1) {//拼写题 有听力  1拼写 2听力 3看图 4句子翻译 5单词翻译 6英译汉
        [self.answerArray removeAllObjects];
        self.typeSpellView.hidden = NO;
        self.collectionView.hidden = YES;
        self.iDontKnow.hidden = YES;
        self.sentenceLabel.hidden  = YES;
        self.wordLabel.hidden      = YES;//词语处
#pragma mark 改动
        self.timerProgress.hidden  = YES;


//        self.timerProgress.hidden  = YES;

#pragma mark  gd_拼写题显示汉语
//        self.readButton.hidden     = YES;
//        self.listenButton.hidden   = NO;
        self.wordLabel.hidden = NO;
        self.readButton.hidden = NO;
        self.listenButton.hidden = YES;
        self.wordLabel.text        = model.qExplain;
        
        

        [self.virtualField becomeFirstResponder];
        self.OriginalStr = model.qWord ;
        [self.knownStr deleteCharactersInRange:NSMakeRange(0, self.knownStr.length)];
        [self.knownStr appendString:[self.OriginalStr substringToIndex:0]];
        _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
        
        _currentType = @"1";
    }
    else if([model.qType integerValue]==3||[model.qType integerValue]==6){
        
        if ([model.qType integerValue]==3) {
            
#pragma mark gd_题型6和题型3互换
            self.listenButton.hidden   = YES;
            //            self.listenButton.hidden   = NO;
            self.wordLabel.hidden      = YES;//词语处

//            self.wordLabel.hidden      = NO;//词语处
//            self.wordLabel.text        = model.qExplain;
           self.wordLabel.text        = model.qWord;
        _currentType = [NSString stringWithFormat:@"%@",model.qType];

        }else{
#pragma mark gd_题型6和题型3互换
            //            self.listenButton.hidden   = NO;
            self.listenButton.hidden   = YES;
            self.wordLabel.hidden      = NO;

//            self.wordLabel.text        = model.qWord;
//                    _currentType = @"6";

            _currentType = [NSString stringWithFormat:@"%@",model.qType];

            self.wordLabel.text        = model.qWord;


        }
        
        self.typeSpellView.hidden  = YES;//选项处
        self.collectionView.hidden = NO;
        self.iDontKnow.hidden = YES;
        self.sentenceLabel.hidden  = YES;
#pragma mark 改动
        self.timerProgress.hidden  = NO;
        //        self.timerProgress.hidden  = YES;
#pragma mark gd_展示单词或汉语
        self.wordLabel.hidden      = NO;//词语处
#pragma mark gd_展示朗读button
        self.readButton.hidden     = NO;
        //        self.readButton.hidden     = YES;
        [self.virtualField resignFirstResponder];
        
        [self.answerArray removeAllObjects];
        ChioceModel *modelA = [[ChioceModel alloc]init];
        modelA.imgPath      = model.qOptionA;
        modelA.title        = model.qExplainA;
        modelA.option       = @"A";
        
        ChioceModel *modelB = [[ChioceModel alloc]init];
        modelB.imgPath      = model.qOptionB;
        modelB.title        = model.qExplainB;
        modelB.option       = @"B";
        
        ChioceModel *modelC = [[ChioceModel alloc]init];
        modelC.imgPath      = model.qOptionC;
        modelC.title        = model.qExplainC;
        modelC.option       = @"C";
        
        
        ChioceModel *modelD = [[ChioceModel alloc]init];
        modelD.imgPath      = model.qOptionD;
        modelD.title        = model.qExplainD;
        modelD.option       = @"D";
        
        
        [self.answerArray addObject:modelA];
        [self.answerArray addObject:modelB];
        [self.answerArray addObject:modelC];
        [self.answerArray addObject:modelD];
        CGFloat itemSizeWidth = AutoTrans(329  );
        CGFloat itemSizeHeight = (AutoTrans(224))+20;
        _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth-(AutoTrans(10)), itemSizeHeight);
        
    }
    else{//long
        self.typeSpellView.hidden = YES;
        self.collectionView.hidden = NO;
        self.iDontKnow.hidden = NO;
        if ([model.qType integerValue]==4) {
            self.wordLabel.hidden      = YES;//词语处
            self.sentenceLabel.hidden  = NO;
            self.timerProgress.hidden  = NO;
            self.readButton.hidden     = NO;
            self.listenButton.hidden   = YES;
            self.sentenceLabel.text    = [NSString stringWithFormat:@"%@\n%@",model.qEgCN,model.qEgSpell];
        }
        if ([model.qType integerValue]==5) {
            self.sentenceLabel.hidden  = YES;
            self.wordLabel.hidden      = NO;//词语处
            self.timerProgress.hidden  = NO;
            self.readButton.hidden     = NO;
            self.listenButton.hidden   = YES;
            self.wordLabel.text        = model.qExplain;
            
//            self.wordLabel.text        = @"现下一关莫名其妙解锁了。 25关还有了钻石。过了一会，27关又莫名妙解锁了，这肯定是个bug。我碰到好几次了";
//            [self.wordLabel setAdjustsFontSizeToFitWidth:YES];
//            self.wordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        }
        if ([model.qType integerValue]==2) {
            self.timerProgress.hidden  = NO;
#pragma mark gd_修改隐藏
            self.sentenceLabel.hidden  = YES;
            self.wordLabel.hidden      = YES;//词语处
            
            self.readButton.hidden     = YES;
            self.listenButton.hidden   = NO;
            //            self.wordLabel.text        = model.qExplain;
            self.wordLabel.hidden      = YES;
        }
        
        //        if ([model.qType integerValue]==6) {
        //            self.sentenceLabel.hidden  = YES;
        //            self.wordLabel.hidden      = NO;//词语处
        //            self.timerProgress.hidden  = NO;
        //            self.readButton.hidden     = NO;
        //            self.listenButton.hidden   = YES;
        //            self.wordLabel.text        = model.qName;
        //
        //        }
        
        [self.virtualField resignFirstResponder];
        _currentType = @"2";
        [self.answerArray removeAllObjects];
        ChioceModel *modelA = [[ChioceModel alloc]init];
        modelA.title = model.qOptionA;
        modelA.option = @"A";
        
        ChioceModel *modelB = [[ChioceModel alloc]init];
        modelB.title = model.qOptionB;
        modelB.option =@"B";
        
        ChioceModel *modelC = [[ChioceModel alloc]init];
        modelC.title = model.qOptionC;
        modelC.option =@"C";
        
        ChioceModel *modelD = [[ChioceModel alloc]init];
        modelD.title = model.qOptionD;
        modelD.option =@"D";
        
        [self.answerArray addObject:modelA];
        [self.answerArray addObject:modelB];
        [self.answerArray addObject:modelC];
        [self.answerArray addObject:modelD];
        
        CGFloat itemSizeWidth = _collectionView.frame.size.width;
        CGFloat itemSizeHeight = (AutoTrans(124));
        _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth, itemSizeHeight);
        
    }
    [_collectionView reloadData];
    //start
#pragma mark gd_题型1 不在自动发音  2017-03-23 22:02:37-8
//    if ([model.qType integerValue]==1||[model.qType integerValue]==2||[model.qType integerValue]==3) {
//        [self listenButtonOnClick:nil];
//    }
    if ([model.qType integerValue]==2||[model.qType integerValue]==3) {
        [self listenButtonOnClick:nil];
    }
    //end
    
    
    //start
#pragma mark gd_题数会变话,每次都要重新给sum赋值 连续答对4次,take将不再出现”  0115
    _wordsProgress.sum = self.list.count;
    //end
    _wordsProgress.current =_currentQs+1;
    _currentQs ++;
    
#pragma mark 判断题型 如果是第一种题型 关闭计时器,否则开启计时器
//    if ([model.qType integerValue]==1) {
//        [self stopTimer];
//    }else{
        [self startTimer];
//    }
    
}

#pragma mark 从上一页中初始化题目
-(void)setItem:(PassModel *)item{
    _item = item;
    UILabel *label = (UILabel *)[self.view viewWithTag:233];
    label.text = item.passName;
    

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([[df valueForKey:@"NoSpell"]isEqualToNumber:@1]) {
        NSMutableArray *temArr =[NSMutableArray array];
        for (int i=0; i<_item.list.count; i++) {
            QsModel *model  =[_item.list objectAtIndex:i];
            if ([model.qType integerValue]==1) {
                
            }else{
                [temArr addObject:model];
            }

        }
        
        //start
#pragma mark gd_将数据源改成可变数组,- [ ] “连续答对4次,take将不再出现”  0115
//        self.list = [NSArray arrayWithArray:temArr];
        self.list = [NSMutableArray arrayWithArray:temArr];
        //end
        
        
        
    }else{
        //start
#pragma mark gd_将数据源改成可变数组,- [ ] “连续答对4次,take将不再出现”  0115
        //        self.list = _item.list;
        self.list = [NSMutableArray arrayWithArray:_item.list];
        //end
        
    }
    _wordsProgress.sum = self.list.count;
    _wordsProgress.current = 0;
    [self getNextQs];

    
}
#pragma mark - 答案是否正确
-(void)answerRight{
    
    
    
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];

    //start
#pragma mark gd_记录答对的单词的次数. “连续答对4次,take将不再出现”  0115
    NSNumber * rightCount = self.WordDict[model.qWord];
    if (!rightCount) {
        rightCount = [NSNumber numberWithInteger:0];
    }
    NSInteger count = [rightCount integerValue];
    count ++;
#warning lgd_答对4次

    
    if (count >= notShowRightCount && (![self.item.passName isEqualToString:@"复习关"] || notShowRightCountIfFuxiguan)) {
//        for (NSInteger i = _currentQs + 1; i < self.list.count; i ++) {
//            QsModel * qsmodel  = self.list[i];
//            NSLog(@"%zd qs= %@",i,qsmodel);
////            if (([model.qWordID integerValue] - [qsmodel.qWordID integerValue] ==0 ) || ([model.qWord isEqualToString:qsmodel.qWord] )) {
////                [self.list removeObject:qsmodel];
////            }
//        }
        
       __block NSInteger currentQs  = 1;
         [self.list filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(QsModel * qsmodel, NSDictionary *bindings) {
            
             if (currentQs > self.currentQs) {
                 if (([model.qWordID integerValue] - [qsmodel.qWordID integerValue] ==0 ) || ([model.qWord isEqualToString:qsmodel.qWord] )) {
                     return NO;
                 }
             }
             currentQs ++;
            
            return YES;

        }]];
        
        
        UIView * noticeView = [UIView new];
        noticeView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 60);
        [self.view addSubview:noticeView];
        __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:noticeView animated:YES];
        hud.labelText = [NSString stringWithFormat:@"连续答对4次,%@将不再出现",model.qWord];
        hud.mode = MBProgressHUDModeText;
        
        [hud hide:YES afterDelay:1.0];
        hud.completionBlock = ^{
            [noticeView removeFromSuperview];
        };
        
        
    }
    self.WordDict[model.qWord] = @(count);
    //end
    

    
    
    [AnswerTools answerRightWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
    if (self.ifAlertPlay) {
        AudioServicesPlaySystemSound(_rightID);
    }
    if (self.ifWordPlay) {
        AudioServicesPlaySystemSound(_soundID);
        [self checkToGetNext];
//        //start
//#pragma mark gd_题型1 不自动播放提示音,也不自动跳到下一题  2017-03-22 19:47:25
//        if ([model.qType integerValue] == 1) {
//            if (self.shouldGoNext) {
//                self.shouldGoNext=NO;
//                [self getNextQs];
//            }
//            if (self.wrongGoNext) {
//                self.wrongGoNext=NO;
//                [self afterReadAnswerWrong];
//            }
////            [self getNextQs];
//        }
//        //end
    }else{
        [self getNextQs];
    }

    
    
}
-(void)answerWrong{
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    
    //start
#pragma mark gd_记录答对的单词的次数. 答错清空  0115
//    因为做错了这道题,还需要在做一次,直到作对,但是这道题不能记为做对一次,所以直接记为-1,这道题作对了又+1,正好为0.
    self.WordDict[model.qWord] = @(-1);
    //end
    
    if (self.ifAlertPlay) {
        AudioServicesPlaySystemSound(_wrongID);

    }
    if (self.ifWordPlay) {
        AudioServicesPlaySystemSound(_soundID);

        //start
#pragma mark gd_新加的,之前这一步是在 BarrierCompletionCallback2 中,下一题发音后回调的,因为有的题目找不到 mp3 所以修改了这种方式  2017-05-23 17:29:52
        [self checkToGetNext];
        //end
        
        
//        //start
//#pragma mark gd_题型1 不自动播放提示音,也不自动跳到下一题  2017-03-22 19:47:25
//        if ([model.qType integerValue] == 1) {
//            if (self.shouldGoNext) {
//                self.shouldGoNext=NO;
//                [self getNextQs];
//            }
//            if (self.wrongGoNext) {
//                self.wrongGoNext=NO;
//                [self afterReadAnswerWrong];
//            }
//            //            [self getNextQs];
//        }
//        //end
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AnswerTools answerWrongWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
            
            
        });
    }

    

    

}
-(void)afterReadAnswerWrong{//错误选择也要发音 发音结束调用这个
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];

    [AnswerTools answerWrongWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
    
}

#pragma mark YXAnswerWrong  答题失败
-(void)showWrongVC{
    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    WrongWordVC *wrongVC = [[WrongWordVC alloc]init];
    WrongWordVC *wrongVC = [[WrongWordVC alloc]initWith:_type];
    //end
    
    __weak __typeof__(self) weakSelf = self;
    wrongVC.block = ^(){
        [weakSelf getNextQs];
    };
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    wrongVC.wordID = model.qWordID;
    _currentQs-=1;

    [self.navigationController pushViewController:wrongVC animated:YES];
}
-(void)showfailView{
    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
    //    WrongWordVC *wrongVC = [[WrongWordVC alloc]init];
    WrongWordVC *wrongVC = [[WrongWordVC alloc]initWith:_type];
    //end
    wrongVC.passId = self.item.passID;
    wrongVC.delegate = self;
    __weak __typeof__(self) weakSelf = self;
    wrongVC.block = ^(){
        [weakSelf getNextQs];
    };
    wrongVC.needShowFailView = YES;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [df valueForKey:@"timer"];
    wrongVC.time_second = num;
    wrongVC.failInfo = [self getInfo];
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    wrongVC.wordID = model.qWordID;
    _currentQs-=1;

    [self.navigationController pushViewController:wrongVC animated:YES];
}
#pragma mark - 界面跳转
-(void)naviPop:(UIButton *)tap{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出闯关？" message:@"返回即视为本次闯关失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        start
#pragma mark gd_更改提交用户的闯关信息方式  0115
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"timer"];
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                [NetWorkingUtils uploadBarrierInfoPassfail:YES passId:self.item.passID passTime:num currentVC:self];
        [NetWorkingUtils uploadBarrierInfoPassfail:YES passId:self.item.passID passTime:num currentVC:self With:_type];
        //end
        
//        end
        //start
#warning 修改跳转方式,因为复习关刷新需要退出到首页,否则总是出错,未解决 0115
#pragma mark gd_修改跳转方式,因为复习关刷新需要退出到首页,否则总是出错,未解决  0115
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        UIViewController * firstVC = [self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToViewController:firstVC animated:NO];
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
        LexiconViewController *lexiconVC = [[LexiconViewController alloc]initWith:_type];
        //end
        
        
        lexiconVC.hidesBottomBarWhenPushed = YES;
        
        [firstVC.navigationController pushViewController:lexiconVC animated:NO];
        
        
        //end


    }];

    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - button 点击
-(void)listenButtonOnClick:(UIButton *)button{
    AudioServicesPlaySystemSound(_soundID);
}
-(void)iDontKnowOnClick:(UIButton *)button{
    for (int i=0; i<self.answerArray.count; i++) {
        if ([_rightAnswer isEqualToString:[self.answerArray[i] option]]) {
            ChoiceFatherCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell didSelected];
        }
    }
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
        if (self.ifWordPlay) {
            self.wrongGoNext = YES;
        }
        [self answerWrong];
//        [self getNextQs];
        
        
    });
}
-(void)virtualFieldToFirst{
    NSLog(@"弹出键盘");
    [_virtualField becomeFirstResponder];
}
#pragma mark - timer
-(void)beginTimer{
    [TimerTools timerAdd];
    _timerProgress.current ++;
    NSInteger curQs = _currentQs - 1;
    QsModel * model = self.list[curQs];
    
    
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [df valueForKey:@"timer"];
    if (!num) {
        num=@0;
    }
    num=@([num intValue]+1);
    [df setObject:num forKey:@"timer"];
    
    if (_timerProgress.current == 9 && [model.qType integerValue] == 1) {
        
        [self stopTimer];
        _timerProgress.current = 0;
        [_timerProgress stop];
    }

}
-(void)viewWillAppear:(BOOL)animated{

    [self startTimer];
}
#pragma mark 开启计时器
- (void)startTimer{

    NSInteger curQs = _currentQs - 1;
    QsModel * model = self.list[curQs];

    if (!timer) {
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
    }
//    if (!timer && [model.qType integerValue] != 1) {
//        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
//    }
}
-(void)viewWillDisappear:(BOOL)animated{
    //[AnswerTools beginRecorder];

    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark 关闭计时器
- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)arriveEnd{
    if ([_currentType isEqualToString:@"1"]) {
        [_virtualField resignFirstResponder];
    }
    [_timerProgress stop];
    _timerProgress.current=0;
    if (self.ifWordPlay) {
        self.wrongGoNext = YES;
    }
    [self answerWrong];
//    [self getNextQs];
}
-(void)needRestart{
    NSLog(@"hello");
    self.currentQs =0;
    _wordsProgress.current = 0;
    [AnswerTools beginRecorder];

    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];

    [self getNextQs];

    
    
    
}
-(NSString *)getInfo{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [df valueForKey:@"timer"];
    if (!num) {
        num=@0;
    }
    NSInteger time = [num intValue];
    NSString *useTime;
    self.time_second =time;

    if (time>=60) {
        int a = time/60;
        int b =time%60;
        useTime = [NSString stringWithFormat:@"%d分钟%d秒",a,b];
    }else{
        useTime = [NSString stringWithFormat:@"%d秒",time];
    }
    [df setObject:@0 forKey:@"timer"];
    float rate =[AnswerTools getRate];
    int l = rate*100;
    NSString *rateStr = [NSString stringWithFormat:@"%d%%",l];
    NSString *finalStr  = [NSString stringWithFormat:@"本关学习：%d个单词\n用时：%@\n准确率：%@",self.wordList.count,useTime,rateStr];
    
    return finalStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
