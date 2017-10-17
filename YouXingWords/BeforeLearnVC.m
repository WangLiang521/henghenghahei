//
//  BarrierDetailVC.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BeforeLearnVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YXProgressBar.h"
#import "YXTimeProgress.h"

#import "ChoiceCell.h"
#import "ChoiceLong.h"

//#import "AnswerTools.h"
#import "TimerTools.h"

#import "TestResultViewController.h"
#import "BarrierSuccessVC.h"
#import "WrongWordVC.h"
#import "LexiconViewController.h"
#import "AlreadyWordNum.h"
@interface BeforeLearnVC()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,YXAnswerWrong,YXTimeProgressDelegate,RestartOrNextDelegate>{
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
@property (nonatomic,retain)NSArray *list;          //所有题目
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

@property (nonatomic,retain)UIButton * listenButton;//听力题
@property (nonatomic,retain)UIButton * readButton;//其他选择题

@property(nonatomic,assign)BOOL ifSpell;
@property(nonatomic,assign)BOOL ifPronunciation;

@property(nonatomic,assign)BOOL ifAlertPlay;
@property(nonatomic,assign)BOOL ifWordPlay;

@property(nonatomic,assign)NSInteger rightNum;
@property(nonatomic,assign)NSInteger wrongNum;

@property (assign, nonatomic)  BreakthroughType type;

@end

@implementation BeforeLearnVC

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
    self.wrongNum=0;
    self.rightNum=0;
//    [AnswerTools setDelegate:self];
//    [AnswerTools beginRecorder];
    [self initAlert];
    
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
    _lastWord.hidden = YES;
    _lastWord.text = @"上个单词：producter 制片人";
    _lastWord.font = [UIFont systemFontOfSize:AutoTrans(28)];
    _lastWord.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_lastWord];
    [_lastWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(28)));
    }];
    
}
-(void)addProgressBar{
    _wordsProgress = [[YXProgressBar alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_wordsProgress];
    [_wordsProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:234].mas_bottom).offset((AutoTrans(14)));
        make.left.mas_equalTo(@(AutoTrans(40)));
        make.height.mas_equalTo(@(AutoTrans(30)));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(40)));
    }];
    _wordsProgress.sum = 50;
    _wordsProgress.current = 6;
    
    
//    UIView *littleWhtie = [[UIView alloc]initWithFrame:CGRectZero];
//    littleWhtie.backgroundColor = [UIColor whiteColor];
//    littleWhtie.layer.masksToBounds = YES;
//    littleWhtie.layer.cornerRadius =(AutoTrans(30))/2;
//    [self.view addSubview:littleWhtie];
//    [littleWhtie mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_wordsProgress.mas_top);
//        make.left.mas_equalTo(_wordsProgress.mas_right).offset(AutoTrans(9));
//        make.height.mas_equalTo(@(AutoTrans(30)));
//        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(9)));
//    }];
    
//    _heartNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    _heartNumLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//    _heartNumLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    _heartNumLabel.textAlignment =1;
//    _heartNumLabel.text = @"6";
//    _heartNumLabel.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:_heartNumLabel];
//    [_heartNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_wordsProgress.mas_top);
//        make.left.mas_equalTo(_wordsProgress.mas_right).offset(AutoTrans(29));
//        make.height.mas_equalTo(@(AutoTrans(30)));
//        make.right.mas_equalTo(littleWhtie.mas_right).offset(-(AutoTrans(20)));
//    }];
//    
//    UIImageView *heart = [[UIImageView alloc]initWithFrame:CGRectZero];
//    heart.image = [UIImage imageNamed:@"barrier_icon_heart_selected"];
//    [self.view addSubview:heart];
//    [heart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_wordsProgress.mas_centerY);
//        make.width.mas_equalTo(@(AutoTrans(40)));
//        make.height.mas_equalTo(@(AutoTrans(40)));
//        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(40)));
//    }];
    
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
//    
    _timerProgress = [[YXTimeProgress alloc]initWithFrame:CGRectZero];
    _timerProgress.delegate =self;
    _timerProgress.hidden = YES;
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
    _wordLabel.adjustsFontSizeToFitWidth = YES;
    _wordLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _wordLabel.font = [UIFont systemFontOfSize:AutoTrans(60)];
    _wordLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_wordLabel];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(_timerProgress.mas_bottom).offset(AutoTrans(30));
        //        make.width.mas_equalTo(whiteView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(@(AutoTrans(60)));
        
        //start
#pragma mark gd_解决汉译比较长的单词出格  2017-03-27 16:10:16-12
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
    CGFloat itemSizeWidth = AutoTrans(329  );
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
    _spellLabel.text = [self strWithKnownStr:@"P" AndOriginalStr:@"Panda"];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(virtualFieldToFirst)];
    _spellLabel.userInteractionEnabled = YES;
    [_spellLabel addGestureRecognizer:tap];
    [_typeSpellView addSubview:_spellLabel];
    [self.spellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionView.mas_left);
        make.top.mas_equalTo(self.collectionView.mas_top).offset(AutoTrans(50));
        make.right.mas_equalTo(self.collectionView.mas_right);
        make.height.mas_equalTo(@(AutoTrans(80)));
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
    
    NSLog(@"bool");
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
    
    if (_knownStr.length >=_OriginalStr.length) {
        [textField resignFirstResponder];
        if ([[_knownStr lowercaseString] isEqualToString:[_OriginalStr lowercaseString] ]) {
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
    NSMutableString *finalStr = [NSMutableString string];
    for (int i=0; i<knownStr.length; i++) {
        [finalStr appendFormat:@"%@ ",[knownStr substringWithRange:NSMakeRange(i, 1)]];
    }
    for (int i=0; i<originalStr.length-knownStr.length; i++) {
        [finalStr appendString:@"_ "];
        
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
    ChoiceFatherCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setWrong];
    
    for (int i=0; i<self.answerArray.count; i++) {
        if ([_rightAnswer isEqualToString:[self.answerArray[i] option]]) {
            ChoiceFatherCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
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
                AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback, (__bridge void *)self);
                
            }
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
        
        
    });
}

void BarrierCompletionCallback(SystemSoundID soundID,void *clientData){
    //[SVProgressHUD showInfoWithStatus:@"请跟读"];
    //    AudioServicesDisposeSystemSoundID(soundID);
    if (((__bridge BeforeLearnVC *)clientData).shouldGoNext) {
        ((__bridge BeforeLearnVC *)clientData).shouldGoNext=NO;
        [((__bridge BeforeLearnVC *)clientData) getNextQs];
    }
    if (((__bridge BeforeLearnVC *)clientData).wrongGoNext) {
        ((__bridge BeforeLearnVC *)clientData).wrongGoNext=NO;
        [(__bridge BeforeLearnVC *)clientData afterReadAnswerWrong];
    }
    //    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //
    //    if (!mgr.isReachable) {
    //        [SVProgressHUD showErrorWithStatus:@"没有网络"];
    //    }
    //    [(__bridge PronunciationVC *)clientData onBtnStart:nil];
    
}
-(BOOL)ifAlertPlay{
    if (!_ifAlertPlay) {
        _ifAlertPlay = NO;
    }
    return _ifAlertPlay;
}
-(BOOL)ifWordPlay{
    if (!_ifWordPlay) {
        _ifWordPlay = NO;
    }
    return _ifWordPlay;
}
-(void)getNextQs{
    _collectionView.userInteractionEnabled = YES;
//    [_timerProgress start];
    
    if (self.list.count<=_currentQs) {
        //start
#pragma mark gd_加上 type  2017-05-02 21:57:07
//        TestResultViewController *successVC = [[TestResultViewController alloc]init];
        TestResultViewController *successVC = [[TestResultViewController alloc]initWith:_type];
        //end
        successVC.rightNum = self.rightNum;
        successVC.wrongNum = self.wrongNum;
//        successVC.delegate = self;
//        successVC.successInfo = [self getInfo];
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [df valueForKey:@"timer"];
//        successVC.time_second =num;
//        successVC.passId = self.item.passID;
        [self.navigationController pushViewController:successVC animated:YES];
        if (_soundID) {
            AudioServicesDisposeSystemSoundID(_soundID);
        }
        return;
    }
    QsModel *model  =[self.list objectAtIndex:_currentQs];
    [AlreadyWordNum handleWithNumber:model.qWordID];
    _rightAnswer = model.qAnswer;
    _timerProgress.current=0;
    
    if (model.qAudio) {
        NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],model.qAudio];
        NSURL *soundURL = [NSURL URLWithString:path];
        if (_soundID) {
            AudioServicesDisposeSystemSoundID(_soundID);
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
        AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback, (__bridge void *)self);
        
    }else{
        //        NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]];
        //
        //        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
        //        //解压
        //
        //        NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
        //        NSString *unarchiveBase = [pathArr objectAtIndex:0];
        //        if ([unarchiveBase isEqualToString:@".DS_Store"]) {
        //            if (pathArr.count>1) {
        //                unarchiveBase = [pathArr objectAtIndex:1];
        //            }
        //        }
        //解析wordInfos.txt
        NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
        NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:_type],@"txt/wordInfos.json"];
        //end
        
        //        NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
        //        NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];


#pragma mark gd_修改获取资源包方式
        NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
        NSError *error;
//        NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSError *error;
//        NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!firstDic) {
            NSLog(@"%@",error);
        }
        NSArray *tempArr=[firstDic valueForKey:@"data"];
        for (int i=0; i<tempArr.count; i++) {
            
            if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {
                NSDictionary * _infoDic =tempArr[i];
                NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

                NSString* _mp3Path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[_infoDic valueForKey:@"audio"]];
                NSURL *soundURL = [NSURL URLWithString:_mp3Path];
                if (_soundID) {
                    AudioServicesDisposeSystemSoundID(_soundID);
                }
                AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
                AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, BarrierCompletionCallback, (__bridge void *)self);
                break;
            }
            
        }
        
    }
    if ([model.qType integerValue]==1) {//拼写题 有听力  1拼写 2听力 3看图 4句子翻译 5单词翻译 6英译汉
        [self.answerArray removeAllObjects];
        self.typeSpellView.hidden = NO;
        self.collectionView.hidden = YES;
        self.iDontKnow.hidden = YES;
        self.sentenceLabel.hidden  = YES;
        self.wordLabel.hidden      = YES;//词语处
        self.timerProgress.hidden  = YES;
        self.readButton.hidden     = YES;
        self.listenButton.hidden   = NO;
        
        [self.virtualField becomeFirstResponder];
        self.OriginalStr = model.qWord ;
        [self.knownStr deleteCharactersInRange:NSMakeRange(0, self.knownStr.length)];
        [self.knownStr appendString:[self.OriginalStr substringToIndex:0]];
        _spellLabel.text = [self strWithKnownStr:_knownStr AndOriginalStr:_OriginalStr];
        
        _currentType = @"1";
    }
    else if([model.qType integerValue]==3||[model.qType integerValue]==6){
        if ([model.qType integerValue]==3) {
            self.listenButton.hidden   = NO;
            self.wordLabel.hidden      = YES;//词语处
            _currentType = @"3";
        }else{
            self.listenButton.hidden   = YES;
            self.wordLabel.hidden      = NO;
            _currentType = @"6";
            self.wordLabel.text        = model.qName;
            
        }
        self.typeSpellView.hidden  = YES;//选项处
        self.collectionView.hidden = NO;
        self.iDontKnow.hidden = YES;
        self.sentenceLabel.hidden  = YES;
        self.timerProgress.hidden  = YES;
        self.readButton.hidden     = YES;
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
//            self.timerProgress.hidden  = NO;
            self.readButton.hidden     = NO;
            self.listenButton.hidden   = YES;
            self.sentenceLabel.text    = [NSString stringWithFormat:@"%@\n%@",model.qEgCN,model.qEgSpell];
        }
        if ([model.qType integerValue]==5) {
            self.sentenceLabel.hidden  = YES;
            self.wordLabel.hidden      = NO;//词语处
//            self.timerProgress.hidden  = NO;
            self.readButton.hidden     = NO;
            self.listenButton.hidden   = YES;
            self.wordLabel.text        = model.qExplain;
            
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
    if ([model.qType integerValue]==1||[model.qType integerValue]==2||[model.qType integerValue]==3) {
        [self listenButtonOnClick:nil];
    }
    _wordsProgress.current ++;
    _currentQs ++;
}
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
        self.list = [NSArray arrayWithArray:temArr];
        
    }else{
        self.list = _item.list;
    }
    _wordsProgress.sum = self.list.count;
    _wordsProgress.current = 0;
    [self getNextQs];
    
    
}
#pragma mark - 答案是否正确
-(void)answerRight{
    self.rightNum+=1;
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    [self getNextQs];

//    [AnswerTools answerRightWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
//    if (self.ifAlertPlay) {
//        AudioServicesPlaySystemSound(_rightID);
//    }
//    if (self.ifWordPlay) {
//        AudioServicesPlaySystemSound(_soundID);
//    }else{
//    }
    
    
}
-(void)answerWrong{
    self.wrongNum+=1;
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    [self getNextQs];

//    if (self.ifAlertPlay) {
//        AudioServicesPlaySystemSound(_wrongID);
//        
//    }
//    if (self.ifWordPlay) {
//        AudioServicesPlaySystemSound(_soundID);
//        
//    }else{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [self showWrongVC];
////            [AnswerTools answerWrongWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
//            
//            
//        });
//    }
    
    
}
-(void)afterReadAnswerWrong{//错误选择也要发音 发音结束调用这个
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
//    [self showWrongVC];
    [self getNextQs];
//    [AnswerTools answerWrongWithQId:model.qID AndWordId:model.qWordID AndWord:model.qWord];
    
}
-(void)showWrongVC{
//    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];
    
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
    [self.navigationController pushViewController:wrongVC animated:YES];
}
-(void)showfailView{
//    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];
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
//    wrongVC.failInfo = [self getInfo];
    QsModel *model  =[self.list objectAtIndex:_currentQs-1];
    wrongVC.wordID = model.qWordID;
    [self.navigationController pushViewController:wrongVC animated:YES];
}
#pragma mark - 界面跳转
-(void)naviPop:(UIButton *)tap{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出测试？" message:@"返回将丢失测试数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
#pragma mark gd_先返回到首页,在push过来  2017-01-19
        
        //    UIViewController * vc = self.navigationController.viewControllers[0];
        //    [self.navigationController popToViewController:vc animated:NO];
        ////    vc.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
        //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
        //    lexiconVC.hidesBottomBarWhenPushed = YES;
        //
        //    [vc.navigationController pushViewController:lexiconVC animated:NO];
        
        UIViewController * firstVC = [self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToViewController:firstVC animated:NO];
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
        //    LexiconViewController *lexiconVC = [[LexiconViewController alloc]init];
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
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [df valueForKey:@"timer"];
    if (!num) {
        num=@0;
    }
    num=@([num intValue]+1);
    [df setObject:num forKey:@"timer"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
    
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
//    [AnswerTools beginRecorder];
//    
//    self.heartNumLabel.text = [NSString stringWithFormat:@"%lu",[AnswerTools getLives]];
    
    [self getNextQs];
    
    
    
    
}
//-(NSString *)getInfo{
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    NSNumber *num = [df valueForKey:@"timer"];
//    if (!num) {
//        num=@0;
//    }
//    NSInteger time = [num intValue];
//    NSString *useTime;
//    
//    if (time>=60) {
//        int a = time/60;
//        int b =time%60;
//        useTime = [NSString stringWithFormat:@"%d分钟%d秒",a,b];
//    }else{
//        useTime = [NSString stringWithFormat:@"%d秒",time];
//    }
//    [df setObject:@0 forKey:@"timer"];
//    
//    float rate =[AnswerTools getRate];
//    int l = rate*100;
//    NSString *rateStr = [NSString stringWithFormat:@"%d%%",l];
//    NSString *finalStr  = [NSString stringWithFormat:@"本关学习：%d个单词\n用时：%@\n准确率：%@",self.wordList.count,useTime,rateStr];
//    
//    return finalStr;
//}
-(void)viewWillDisappear:(BOOL)animated{
    //[AnswerTools beginRecorder];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
