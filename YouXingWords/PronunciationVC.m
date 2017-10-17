//
//  PronunciationVC.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//


#import "PronunciationVC.h"
#import "ISEParams.h"
#import "IFlyMSC/IFlyMSC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <SVProgressHUD.h>
#import "PronunciationCell.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#import "BarrierDetailVC.h"
#import "PassList.h"
#import "WaveContentView.h"
#import "AFWaveView.h"
#import <AVFoundation/AVFoundation.h>

@interface PronunciationVC ()<IFlySpeechEvaluatorDelegate,ISEResultXmlParserDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    SystemSoundID _soundID;
    SystemSoundID _wordSoundID;
    UIButton *lastBTN;
//    AVAudioPlayer *audioPlayer;
//    AVAudioRecorder *audioRecorder;
//    int recordEncoding;
//    enum
//    {
//        ENC_AAC = 1,
//        ENC_ALAC = 2,
//        ENC_IMA4 = 3,
//        ENC_ILBC = 4,
//        ENC_ULAW = 5,
//        ENC_PCM = 6,
//    } encodingTypes;
//    
//    NSURL *recordSaveFile;
//    NSTimer *timerForPitch;

}
@property (nonatomic,retain)UIImageView *wordImgV;
@property (nonatomic,retain)UIImageView *rotateImage;

@property (nonatomic,retain)WaveContentView *lineImage;
@property (nonatomic,retain)AFWaveView *waveView;
@property (nonatomic,retain)UIImageView *notUnderstand;
//@property (nonatomic,retain)UIImageView *rotateImage;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder; //音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;     //音频播放器
@property (nonatomic,copy)NSString *resultString;

@property (nonatomic,retain)UILabel *EnLabel;
@property (nonatomic,retain)UILabel *ChLabel;
@property (nonatomic,retain)UICollectionView *collectionView;
@property (retain, nonatomic ) UICollectionViewFlowLayout *collectFlowLayout;
@property (nonatomic,retain)NSMutableArray *listArray;

@property (nonatomic,assign)NSInteger currentWord;

/**
 *  语音评测
 */
@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, assign) BOOL isSessionResultAppear;
@property (nonatomic, assign) BOOL isSessionEnd;
@property (nonatomic, assign) BOOL isValidInput;

@property (nonatomic, strong) NSString* resultText;

@property (nonatomic,assign)BOOL shouldGoNext;
@property (nonatomic,assign)int continuousThree90;

@property (assign, nonatomic)  BreakthroughType type;


@end

@implementation PronunciationVC

static int a = 0;
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

-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    _iFlySpeechEvaluator.delegate = self;
    
    //清空参数
    [_iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    _isSessionResultAppear=YES;
    _isSessionEnd=YES;
    _isValidInput=YES;
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
//    [self addImgV];
//    [self addInfo];
//    [self addTextView];
    [self addColloctionView];
    [self addVoiceButton];
    [self addNextButton];
    if (!self.iFlySpeechEvaluator) {
        self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    }
    self.iFlySpeechEvaluator.delegate = self;
    //清空参数，目的是评测和听写的参数采用相同数据
    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    self.iseParams=[ISEParams fromUserDefaults];
    [self reloadCategoryText];
//    _currentWord=-1;
    [self goNext];
    NSLog(@"6");

//    [self]
    
    
    [self.KVOController observe:self keyPath:@"currentWord" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"currentWord = %@",change);
    }];

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
    titleLabel.text = @"发音练习";
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
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:YXFrame(746-15-34-90, 67, 130, 34)];
//    [rightButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [rightButton setTitle:@"直接闯关" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [rightButton addTarget:self action:@selector(startBarrier:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rightButton];

    
}
-(void)addColloctionView{
    _collectFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectFlowLayout.minimumLineSpacing =0;
    _collectFlowLayout.minimumInteritemSpacing=0;
    _collectFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemSizeWidth = SCREEN_WIDTH;
    _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth, AutoTrans(900));
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_collectFlowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[PronunciationCell class] forCellWithReuseIdentifier:@"PronunciationCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.left.mas_equalTo(@(0));
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(@(AutoTrans(900)));
    }];
}

-(void)addImgV{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(20);
    [self.view addSubview:whiteView];
    
    _wordImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _wordImgV.layer.masksToBounds = YES;
    _wordImgV.layer.cornerRadius = AutoTrans(20);
    QsModel *model = self.wordslist[_currentWord];
    if (model.qImage) {
//        NSString *str7z = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//
//        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],model.qImage];
        NSString *path = [Utils getImageFolderWithQImage:model.qImage];
        self.wordImgV.image = [UIImage imageWithContentsOfFile:path];
        
    }else{
//        NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//
//        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
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
//                NSString *str7z = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//
//                NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],[tempArr[i]valueForKey:@"image"]];
                NSString *path = [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"image"]];
                self.wordImgV.image = [UIImage imageWithContentsOfFile:path];
                
             
                break;
            }
            
        }
    }

//    _wordImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_wordImgV];
    [_wordImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.left.mas_equalTo(@(AutoTrans(40)));
        make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
        make.height.mas_equalTo(@(AutoTrans(500)));
    }];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.view viewWithTag:233].mas_bottom).offset((AutoTrans(30)));
        make.left.mas_equalTo(@(AutoTrans(40)));
        make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
        make.height.mas_equalTo(@(AutoTrans(500)));
    }];
    
}

//-(void)addInfo{
//    _EnLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    _EnLabel.textAlignment =1;
//    _EnLabel.textColor = [UIColor whiteColor];
//    _EnLabel.font = [UIFont systemFontOfSize:AutoTrans(56)];
//    [self.view addSubview:_EnLabel];
//    [_EnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_wordImgV.mas_bottom).offset((AutoTrans(30)));
//        make.left.mas_equalTo(@(AutoTrans(40)));
//        make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
//        make.height.mas_equalTo(@(AutoTrans(120)));
//    }];
//    _EnLabel.lineBreakMode = NSLineBreakByClipping;
//    _EnLabel.numberOfLines = 2;
//    
//    _ChLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    _ChLabel.textAlignment =1;
//    _ChLabel.textColor = [UIColor whiteColor];
//    _ChLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
//    [self.view addSubview:_ChLabel];
//    [_ChLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_EnLabel.mas_bottom).offset((AutoTrans(30)));
//        make.left.mas_equalTo(@(AutoTrans(40)));
//        make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
//        make.height.mas_equalTo(@(AutoTrans(100)));
//    }];
//    
//    QsModel *model = self.wordslist[0];
//    self.EnLabel.text = model.qWord;
//    self.ChLabel.text = model.qExplain;
//
//}
-(void)addVoiceButton{
    
    
    
    UIButton *voiceBTN = [[UIButton alloc]initWithFrame:YXFrame(293, 1155, 160, 160)];
    
    [voiceBTN addTarget:self action:@selector(voiceButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [voiceBTN setImage:[UIImage imageNamed:@"barrier_icon_speak"] forState:UIControlStateNormal];
    
    
    _waveView = [[AFWaveView alloc]initWithPoint:voiceBTN.center];
    
    _waveView.maxR=100;
    _waveView.duration=2;
    _waveView.waveDelta=20;
    _waveView.waveCount=10000;
    _waveView.maxAlpha=1;
    _waveView.minAlpha=0;
    _waveView.waveStyle = Circle;
    _waveView.mainColor = [UIColor colorWithRed:0 green:0.7 blue:1 alpha:1];
    [self.view addSubview:_waveView];
    
    
    
    [self.view addSubview:voiceBTN];
    
    _rotateImage = [[UIImageView alloc]initWithFrame:YXFrame(318, 1155, 160, 160)];
    _rotateImage.center = voiceBTN.center;
    _rotateImage.image = [UIImage imageNamed:@"barrier_icon_speak_around"];
    [self.view addSubview:_rotateImage];
    
}
-(void)addNextButton{
    UIButton *nextBTN = [[UIButton alloc]initWithFrame:YXFrame(580, 1200, 180, 90)];
    [nextBTN setImage:[UIImage imageNamed:@"icon_right"] forState:UIControlStateNormal];
    
    [nextBTN addTarget:self action:@selector(nextButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBTN];


    lastBTN = [[UIButton alloc]initWithFrame:YXFrame(0, 1200, 180, 90)];
    [lastBTN setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    lastBTN.hidden = YES;
    [lastBTN addTarget:self action:@selector(lastButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastBTN];

}
-(void)addDidNotUnderstand{
    if (!_notUnderstand) {
        _notUnderstand = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, AutoTrans(980), AutoTrans(200), AutoTrans(200))];
        _notUnderstand.image = [UIImage imageNamed:@"icon_message"];
        [self.view addSubview:_notUnderstand];
        UILabel *label = [[UILabel alloc]initWithFrame:_notUnderstand.bounds];
        label.text = @"没听懂Orz...\n在读准一点吧";
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:AutoTrans(25)];
        [_notUnderstand addSubview:label];
        _notUnderstand.hidden = YES;
    }
    _notUnderstand.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _notUnderstand.hidden = YES;
    });
    
    
}

-(WaveContentView *)lineImage{
    if (!_lineImage) {
        _lineImage = [[WaveContentView alloc]initWithFrame:CGRectMake(20, AutoTrans(1000), SCREEN_WIDTH-40, AutoTrans(120))];
//        _lineImage.contentMode = UIViewContentModeScaleAspectFill;
//        _lineImage.image = [UIImage imageNamed:@"line"];
        [self.view addSubview:_lineImage];
    }
    return _lineImage;
}

/**
 *  设置音频会话
 */
- (void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  录音文件设置
 *
 *  @return 返回录音设置
 */
- (NSDictionary *)getAudioSetting
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];  //设置录音格式
    [dic setObject:@(44100.0) forKey:AVSampleRateKey];                 //设置采样率
    [dic setObject:@(1) forKey:AVNumberOfChannelsKey];              //设置通道，这里采用单声道
    [dic setObject:@(32) forKey:AVLinearPCMBitDepthKey];             //每个采样点位数，分为8，16，24，32
    [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];            //是否使用浮点数采样
    [dic setObject:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];
    return dic;
}
/**
 *  录音存储路径
 *
 *  @return 返回存储路径
 */
- (NSURL *)getSavePath
{
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"voice1.pcm"]];
    NSLog(@"url: %@",url);
    return url;
}

- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath] settings:[self getAudioSetting] error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES; //是否启用录音测量，如果启用录音测量可以获得录音分贝等数据信息
        if (error) {
            NSLog(@"创建录音机对象发生错误:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getSavePath] error:&error];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
        if (error) {
            NSLog(@"创建音频播放器对象发生错误:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

#pragma mark - AVAudioRecorderDelegate
//录音成功
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"录音成功!");
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完毕");
//    self.timer.fireDate = [NSDate distantFuture];
    self.audioPlayer = nil;
    [self showPoint];
}

#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return 100;
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PronunciationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PronunciationCell" forIndexPath:indexPath];
    cell.item = self.listArray[indexPath.row];
    WS(weakSelf);
    cell.block=^(){
        //start
#pragma mark gd_点击例句或者图片或者单词直接再次发音  2017-03-22 21:49:42
//                AudioServicesPlaySystemSound(_wordSoundID);
//        AudioServicesPlaySystemSound(_soundID);
        
        PronunciationModel * model = weakSelf.listArray[indexPath.row];
        if (_soundID) {
            AudioServicesDisposeSystemSoundID(_soundID);
        }
        NSURL *soundURL = [NSURL URLWithString:model.audioPath];
        if (!soundURL) {
            soundURL = [NSURL URLWithString:[model.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
        AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)weakSelf);
        AudioServicesPlaySystemSound(_soundID);
        
        if (_wordSoundID) {
            AudioServicesDisposeSystemSoundID(_wordSoundID);
        }
        NSURL *wordSoundURL = [NSURL URLWithString:model.wordAudioPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(wordSoundURL), &_wordSoundID);
        //end
        
        
    };

//    if (indexPath.row == 0) {
//        lastBTN.hidden = YES;
//    }else{
//        lastBTN.hidden = NO;
//    }

    return cell;
}
#pragma mark - collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}
#pragma mark - scroll代理

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    _pageControl.currentPage = scrollView.contentOffset.x/320;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
//    if (self.currentWord!=page) {
//
//        self.currentWord = page;
//        [self goNext];
//    }


//    if (_currentWord == 0) {
//        lastBTN.hidden = YES;
//    }else{
//        lastBTN.hidden = NO;
//    }

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"1");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
//    if (_currentWord!=page) {
        _currentWord = page;
        [self goNext];
    if (!self.isSessionEnd) {
        [self onBtnCancel:nil];
        
    }
        NSLog(@"2");
//    }
    if (page == 0) {
        lastBTN.hidden = YES;
    }else{
        lastBTN.hidden = NO;
    }

}

-(void)goNext{
    //[self onBtnCancel:nil];
    [_rotateImage.layer removeAnimationForKey:@"rotationAnimation"];
//    [_lineImage.layer removeAnimationForKey:@"lineAnimation"];
//    [_lineImage clearPoints];
//    _lineImage.hidden =YES;

    [self stopRecording];

    if (_currentWord>=self.wordslist.count*2) {
        //        [PassList gotUdiamondNum:@1];
        [self startBarrier:nil];
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentWord inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    PronunciationModel *model = [self.listArray objectAtIndex:_currentWord];
    
    if (_soundID) {
        AudioServicesDisposeSystemSoundID(_soundID);
    }
    NSURL *soundURL = [NSURL URLWithString:model.audioPath];
    if (!soundURL) {
        soundURL = [NSURL URLWithString:[model.audioPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
    AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
    AudioServicesPlaySystemSound(_soundID);
    
    if (_wordSoundID) {
        AudioServicesDisposeSystemSoundID(_wordSoundID);
    }
    NSURL *wordSoundURL = [NSURL URLWithString:model.wordAudioPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(wordSoundURL), &_wordSoundID);
    
    _currentWord++;

}

//-(void)setCurrentWord:(NSInteger)currentWord{
//    _currentWord = currentWord;
//    if (currentWord>self.4listArray.count) {
//        NSAssert(0, @"越界");
//        return;
//    }
//    PronunciationModel *model = [self.listArray objectAtIndex:currentWord];
//    
//    if (_soundID) {
//        AudioServicesDisposeSystemSoundID(_soundID);
//    }
//    NSURL *soundURL = [NSURL URLWithString:model.audioPath];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
//    AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
//    AudioServicesPlaySystemSound(_soundID);
//    
//}

#pragma mark 从上一页中传入题目
-(void)setItem:(PassModel *)item{
    _item = item;
//    self.list = _item.list;
    _currentWord = 0;
    
}
-(void)setWordslist:(NSMutableArray *)wordslist{
    _wordslist = wordslist;
    for (int i=0; i<wordslist.count; i++) {
        QsModel *model = self.wordslist[i];

        PronunciationModel *itemWord = [[PronunciationModel alloc]init];
        itemWord.word = model.qWord;
        itemWord.explain = model.qExplain;
        itemWord.ENString = model.qWord;
        itemWord.CHString = model.qExplain;
        
        PronunciationModel *item = [[PronunciationModel alloc]init];
        item.word = model.qWord;
        item.explain = model.qExplain;

        NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
        NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:_type],@"txt/wordInfos.json"];
        //end

#pragma mark gd_修改获取资源包方式
        NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
        NSError *error;


        if (!firstDic) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"解析媒体资料出错"];
        }
        NSArray *tempArr=[firstDic valueForKey:@"data"];
        for (int i=0; i<tempArr.count; i++) {
            
            if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {
                NSString *path;
                path = [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"image"]];
                NSString * pathNOJpg = [path stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                NSString * pathNOPng = [path stringByReplacingOccurrencesOfString:@".png" withString:@""];
                if (clearProImageSpace && ![[NSFileManager defaultManager] fileExistsAtPath:path] && ![[NSFileManager defaultManager] fileExistsAtPath:pathNOJpg] && ![[NSFileManager defaultManager] fileExistsAtPath:pathNOPng] ) {
                    NSString * strPath = [tempArr[i]valueForKey:@"image"];
                    strPath  = [strPath stringByReplacingOccurrencesOfString:@" " withString:@""];
                    strPath  = [strPath stringByReplacingOccurrencesOfString:@"　" withString:@""];
                    path = [Utils getImageFolderWithQImage:strPath];
                }
                
                itemWord.imgPath = path;
                item.imgPath = path;
                
                NSString *wordAudioPath ;
//                 wordAudioPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[tempArr[i]valueForKey:@"audio"]];
                wordAudioPath = [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"audioUrl"]];

                
                if (clearAudioSpace && ![[NSFileManager defaultManager] fileExistsAtPath:wordAudioPath]) {
                    NSString * qAudio = [tempArr[i]valueForKey:@"audioUrl"];
                    qAudio  = [qAudio stringByReplacingOccurrencesOfString:@" " withString:@""];
                    qAudio  = [qAudio stringByReplacingOccurrencesOfString:@"　" withString:@""];
                    wordAudioPath = [Utils getImageFolderWithQImage:qAudio];
                }
//                else{
//                    wordAudioPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[tempArr[i]valueForKey:@"audio"]];
//                }
                
                
                itemWord.wordAudioPath = wordAudioPath;
                item.wordAudioPath = wordAudioPath;
                
                
//                  ```````````````````NSString *audioPath  = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[tempArr[i]valueForKey:@"eg"]];
                 NSString *audioPath  = [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"eg"]];
                
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
                    if (clearAudioSpace) {
                        NSString * qAudio = [tempArr[i]valueForKey:@"eg"];
                        
                        qAudio  = [qAudio stringByReplacingOccurrencesOfString:@" " withString:@""];
                        qAudio  = [qAudio stringByReplacingOccurrencesOfString:@"　" withString:@""];
                        audioPath =   [Utils getImageFolderWithQImage:qAudio];
                    }
                    
                    
                }
//                else{
////                    audioPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str1],[tempArr[i]valueForKey:@"eg"]];
//                    audioPath =   [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"eg"]];
//                    
//                }
                
                
                itemWord.audioPath = wordAudioPath;
                item.audioPath = audioPath;
                
                NSString *egEN = [tempArr[i]valueForKey:@"egEN"];
                item.ENString = egEN;
                
                
                NSString *egCN = [tempArr[i]valueForKey:@"egCN"];
                item.CHString = egCN;
                
                
                //                NSString *egEN = [tempArr[i]valueForKey:@"egEN"];
                //                itemWord.ENString = egEN;
                //
                //
                //                NSString *egCN = [tempArr[i]valueForKey:@"egCN"];
                //                itemWord.CHString = egCN;
                break;
            }
            
        }
        [self.listArray addObject:itemWord];
        [self.listArray addObject:item];
        
//        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //解压
//        
//        NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
//        NSString *unarchiveBase = [pathArr objectAtIndex:0];
//        if ([unarchiveBase isEqualToString:@".DS_Store"]) {
//            if (pathArr.count>1) {
//                unarchiveBase = [pathArr objectAtIndex:1];
//            }
//        }
//        //解析wordInfos.txt
//        NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
//        NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];
//        
//        NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSError *error;
//        NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        if (!firstDic) {
//            NSLog(@"%@",error);
//        }
//        NSArray *tempArr=[firstDic valueForKey:@"data"];
//        for (int i=0; i<tempArr.count; i++) {
//            
//            if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {
//                NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7z"],[tempArr[i]valueForKey:@"image"]];
//                item.imgPath = path;
//                
//
//                NSString *audioPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7z"],[tempArr[i]valueForKey:@"eg"]];
//                item.audioPath = audioPath;
//                
//                
//                NSString *wordAudioPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7z"],[tempArr[i]valueForKey:@"audio"]];
//                item.wordAudioPath = wordAudioPath;
//                
//                
//                NSString *egEN = [tempArr[i]valueForKey:@"egEN"];
//                item.ENString = egEN;
//                
//                
//                NSString *egCN = [tempArr[i]valueForKey:@"egCN"];
//                item.CHString = egCN;
//                break;
//            }
//            
//        }

    }
}
//暂时不用
-(void)getNextWord{
    [_rotateImage.layer removeAnimationForKey:@"rotationAnimation"];
//    [_lineImage.layer removeAnimationForKey:@"lineAnimation"];
//    [_lineImage clearPoints];
//    _lineImage.hidden =YES;

    [self stopRecording];

    if (_currentWord>=self.wordslist.count) {
//        [PassList gotUdiamondNum:@1];
        [self startBarrier:nil];
        return;
    }
    QsModel *model = self.wordslist[_currentWord];
    self.EnLabel.text = model.qWord;
    self.ChLabel.text = model.qExplain;
        NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
        //解压
        
        NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
        NSString *unarchiveBase = [pathArr objectAtIndex:0];
    if ([unarchiveBase isEqualToString:@".DS_Store"]) {
        if (pathArr.count>1) {
            unarchiveBase = [pathArr objectAtIndex:1];
        }
    }
        //解析wordInfos.txt
        NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
    NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];


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
//                NSString *str7z = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

//                NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],[tempArr[i]valueForKey:@"image"]];
                NSString *path = [Utils getImageFolderWithQImage:[tempArr[i]valueForKey:@"image"]];
                self.wordImgV.image = [UIImage imageWithContentsOfFile:path];

                break;
            }
            
        }

    if (model.qAudio) {
        NSString *str7z = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],model.qAudio];
        NSURL *soundURL = [NSURL URLWithString:path];
        if (_soundID) {
            AudioServicesDisposeSystemSoundID(_soundID);
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
        AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
        AudioServicesPlaySystemSound(_soundID);
    }else {
        
#warning 解压没改
        NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];

            NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
            //解压
            
            NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
            NSString *unarchiveBase = [pathArr objectAtIndex:0];
        if ([unarchiveBase isEqualToString:@".DS_Store"]) {
            if (pathArr.count>1) {
                unarchiveBase = [pathArr objectAtIndex:1];
            }
        }
            //解析wordInfos.txt
            NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
        NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];



#pragma mark gd_修改获取资源包方式
        NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
        NSError *error;

//            NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//            NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//            
//            NSError *error;
//            NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!firstDic) {
                NSLog(@"%@",error);
            }
            NSArray *tempArr=[firstDic valueForKey:@"data"];
            for (int i=0; i<tempArr.count; i++) {
                
                if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {
                    NSString *str7z = [NSString stringWithFormat:@"Documents/%@/7z",[Utils getCurrentUserName]];

                    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str7z],[tempArr[i]valueForKey:@"audio"]];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if ([fm fileExistsAtPath:path]) {
                        NSURL *soundURL = [NSURL URLWithString:path];
                        if (_soundID) {
                            AudioServicesDisposeSystemSoundID(_soundID);
                        }
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
                        AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
                        AudioServicesPlaySystemSound(_soundID);
                    }
                    
                    break;
                }
                
            
        }

    }
    
    _currentWord++;
}

void completionCallback2(SystemSoundID soundID,void *clientData){
    //[SVProgressHUD showInfoWithStatus:@"请跟读"];
    AudioServicesDisposeSystemSoundID(soundID);
    if (((__bridge PronunciationVC *)clientData).shouldGoNext) {
        ((__bridge PronunciationVC *)clientData).shouldGoNext=NO;
        [((__bridge PronunciationVC *)clientData) goNext];
        NSLog(@"3");

    }
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//
//    if (!mgr.isReachable) {
//        [SVProgressHUD showErrorWithStatus:@"没有网络"];
//    }
//    [(__bridge PronunciationVC *)clientData onBtnStart:nil];
  
}

#pragma mark - 点击事件
-(void)voiceButtonOnClick:(UIButton *)button{

    [self onBtnStart:nil];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    
    [_rotateImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
//    [self.view addSubview:_waveView];
    _waveView.hidden = NO;
    
//    if (![self.audioRecorder isRecording]) {    //不是正在录制
//        NSLog(@"录制");
//        [self.audioRecorder record];
//
//    }
//    CABasicAnimation* lineAnimation;
//    lineAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    lineAnimation.duration = 2;
//    lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    lineAnimation.repeatCount = 110;
//    lineAnimation.removedOnCompletion = NO;
//
//    lineAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, AutoTrans(1000))];
//    lineAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-0,AutoTrans(1000))];
//    self.lineImage.hidden = NO;
//    [self.lineImage.layer addAnimation:lineAnimation forKey:@"lineAnimation"];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(refreshWaveView:) userInfo:nil repeats:YES];
//    
//    audioRecorder = nil;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
//    
//    
//    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
//    if(recordEncoding == ENC_PCM)
//    {
//        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
//        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
//        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    }
//    else
//    {
//        NSNumber *formatObject;
//        
//        switch (recordEncoding) {
//            case (ENC_AAC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
//                break;
//            case (ENC_ALAC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
//                break;
//            case (ENC_IMA4):
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
//                break;
//            case (ENC_ILBC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
//                break;
//            case (ENC_ULAW):
//                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
//                break;
//            default:
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
//        }
//        
//        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
//        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
//        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
//        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
//    }
//
//    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
//                                                            NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [dirPaths objectAtIndex:0];
//    NSString *soundFilePath = [docsDir
//                               stringByAppendingPathComponent:@"recordTest.caf"];
//    
//    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
//    NSError *error = nil;
//    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
//    audioRecorder.meteringEnabled = YES;
//    if ([audioRecorder prepareToRecord] == YES){
//        audioRecorder.meteringEnabled = YES;
//        [audioRecorder record];
//        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(refreshWaveView:) userInfo: nil repeats: YES];
//    }else {
//        int errorCode = CFSwapInt32HostToBig ([error code]);
//        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
//        
//    }

    

    
//    [UIView animateWithDuration:2 animations:^{
//        CGRect tempFrame = self.lineImage.frame;
//        tempFrame.origin.x = -SCREEN_WIDTH;
//        self.lineImage.frame =tempFrame;
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(void)nextButtonOnClick:(UIButton *)button{
//    [self getNextWord];

    DEFINE_WEAK(self);
    CGFloat pageX = _collectionView.contentOffset.x;
    CGFloat pageY = _collectionView.contentOffset.y;
    if (pageX<_collectionView.contentSize.width-_collectionView.frame.size.width) {
        pageX+=_collectionView.frame.size.width;
    }
    [_collectionView setContentOffset:CGPointMake(pageX, pageY) animated:YES];
    
    
    CGFloat pageWidth = _collectionView.frame.size.width;
    int page = floor((pageX - pageWidth / 2) / pageWidth)+1;


    if (_listArray.count -1 == page) {
        a += 1;
        if (a == 2) {

            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"发音练习已结束，是否直接开始闯关" message:nil preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];

            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去闯关" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [wself startBarrier:nil];
            }];

            [alertVC addAction:action1];
            [alertVC addAction:action2];

            [self presentViewController:alertVC animated:YES completion:nil];

            a = 1;
        }
    }else{
        a = 0;
    }

    _currentWord = page;
    [self goNext];
    NSLog(@"4");
    if (!self.isSessionEnd) {
        [self onBtnCancel:nil];
        
    }
    lastBTN.hidden = NO;



}
-(void)lastButtonOnClick:(UIButton *)button{


    CGFloat pageX = _collectionView.contentOffset.x;
    CGFloat pageY = _collectionView.contentOffset.y;
    if (pageX>0) {
        pageX-=_collectionView.frame.size.width;
        if (pageX<0) {
            pageX=0;
        }
    }
    [_collectionView setContentOffset:CGPointMake(pageX, pageY) animated:YES];
    CGFloat pageWidth = _collectionView.frame.size.width;
    int page = floor((pageX - pageWidth / 2) / pageWidth)+1;
    _currentWord = page;
    [self goNext];
    NSLog(@"5");
    if (!self.isSessionEnd) {
        [self onBtnCancel:nil];
    }

    if (page == 0) {
        lastBTN.hidden = YES;
    }

    if (_listArray.count -2 == page) {
        a = 0;
    }



}
#pragma mark - 界面跳转
-(void)naviPop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)startBarrier:(UIButton *)button{
    
    AudioServicesDisposeSystemSoundID(_soundID);
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]init];
    BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]initWith:_type];
    //end
  
    detailVC.item = self.item;
    detailVC.wordList = self.list;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self onBtnStop:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#define XMAX	20.0f
//- (void) refreshWaveView:(id) arg{
//    [audioRecorder updateMeters];
//    NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
//    
//    float linear = pow (10, [audioRecorder peakPowerForChannel:0] / 20);
//    //    NSLog(@"linear===%f",linear);
//    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0] / 20);
//
//    [_lineImage addAveragePoint:linear1 andPeakPoint:linear];
//    NSLog(@"%f-----%f",linear1,linear);
//}
#pragma mark --- 停止录音
-(void) stopRecording
{
//    NSLog(@"stopRecording");
//    // kSeconds = 0.0;
//    self.lineImage.hidden = YES;
//    [self.lineImage clearPoints];
//    [audioRecorder stop];
//    NSLog(@"stopped");
//    [timerForPitch invalidate];
//    timerForPitch = nil;
    _waveView.hidden = YES;
//     [self.audioRecorder stop];
//    if (self.audioPlayer) {
//        [self.audioPlayer play];
//    }else{
//        [self showPoint];
//    }
//    [self showPoint];
//    [_waveView removeFromSuperview];

}
/*!
 *  开始录音
 *
 *  @param sender startBtn
 */
- (void)onBtnStart:(id)sender {
    
    [self.iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    
    [self.iFlySpeechEvaluator setParameter:@"eva.pcm" forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
    
    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
    
    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
//    if(needAddTextBom){
//        if(self.textView.text && [self.textView.text length]>0){
//            Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
//            buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
//            [buffer appendData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding]];
//            NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
//        }
//    }else{
    
//    NSString *str = [NSString stringWithFormat:@"[word]\n%@",[self.listArray[_currentWord-1] ENString]];
//        buffer= [NSMutableData dataWithData:[str dataUsingEncoding:encoding]];
//        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
//    }

    

    
    //start
#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
//    NSString *str = [NSString stringWithFormat:@"[word]\n%@",[self.listArray[_currentWord-1] ENString]];
//    buffer= [NSMutableData dataWithData:[str dataUsingEncoding:encoding]];
//    NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);

    NSString * strAnswerPronunciation = [self.listArray[_currentWord-1] ENString];
    
    int notContaion = 50;
    
//    NSString * strAnswerPronunciation = @"I  am ok。 ";
    while (notContaion) {
        NSArray * array = @[@".  ",@" ",@"，",@"。",@"！",@" ，",@" 。",@" ！",@"， ",@"。 ",@"！ ",@" ,",@" .",@" !",@", ",@". ",@"! ",@", ",@"  ",@"  ",@"  ",@"  ",@"\n",@"\t",@" ",@"ˈ"];
        NSArray * replc = @[@".",@" ",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@" ",@" ",@" ",@" ",@"",@"",@" ",@"'"];

        notContaion --;
//        for (NSString * str in array) {
//            if ([strAnswerPronunciation containsString:str]) {
//                notContaion = NO;
//                break;
//            }
//        }
        
        
        
        for (int i = 0; i < array.count; i ++) {
//            if ([array[i] isEqualToString:@", "] ) {
////                NSLog(@"array[i] = \"%@\"",array[i]);
//            }
//            
//            if ([array[i] isEqualToString:@"。"] ) {
////                NSLog(@"array[i] = \"%@\"",array[i]);
//            }
            [NSString stringWithFormat:@"\"%@\"",replc[i]];
//            NSString * str = [NSString stringWithFormat:@"\"%@\"",[strAnswerPronunciation substringWithRange:NSMakeRange(18, 2)]];
            NSString * str = array[i];
            NSRange range = [strAnswerPronunciation rangeOfString:str];
            if (range.location != NSNotFound) {
                
                strAnswerPronunciation = [strAnswerPronunciation stringByReplacingCharactersInRange:range withString:replc[i]];
            }
        }
  
   
    }
    
    
    [strAnswerPronunciation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    NSLog(@"strAnswerPronunciation = \"%@\"",strAnswerPronunciation);
    
    if ([strAnswerPronunciation containsString:@" "] || [strAnswerPronunciation containsString:@" "] || [strAnswerPronunciation containsString:@"."]) {
        //        句子
        [self reloadCategoryText];
        self.iseParams.category = KCCategorySentence;
        self.iseParams.categoryShow = KCCategoryShowSentence;
        buffer= [NSMutableData dataWithData:[strAnswerPronunciation dataUsingEncoding:encoding]];
        [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];

    }else{
        //        单词
        [self reloadCategoryText];
        self.iseParams.category = KCCategoryWord;
        self.iseParams.categoryShow = KCCategoryShowWord;
        NSString *str = [NSString stringWithFormat:@"[word]\n%@",strAnswerPronunciation];
        buffer= [NSMutableData dataWithData:[str dataUsingEncoding:encoding]];
        [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
        
    }
    
    
    //end
    
    self.resultText=@"";
    [self.iFlySpeechEvaluator startListening:buffer params:nil];
    self.isSessionResultAppear=NO;
    self.isSessionEnd=NO;
    //self.startBtn.enabled=NO;
}



/*!
 *  暂停录音
 *
 *  @param sender stopBtn
 */
- (void)onBtnStop:(id)sender {
    
//    if(!self.isSessionResultAppear &&  !self.isSessionEnd){
//      //  self.resultView.text =KCResultNotify3;
//        NSLog(@"结果测评中");
//        self.resultText=@"";
//    }
    
    [self.iFlySpeechEvaluator stopListening];
//    [self.resultView resignFirstResponder];
//    [self.textView resignFirstResponder];
//    self.startBtn.enabled=YES;
}

/*!
 *  取消
 *
 *  @param sender cancelBtn
 */
@class IFlyISERecognizer;
- (void)onBtnCancel:(id)sender {
//        @try {
//            if (_iFlySpeechEvaluator) {
//                id ha =  [_iFlySpeechEvaluator valueForKey:@"iseSession"];
//                NSLog(@"%@",ha);
//                if ([ha isKindOfClass:[IFlyISVRecognizer class]]) {
//                    [self.iFlySpeechEvaluator stopListening];
//                    
//                    [self.iFlySpeechEvaluator cancel];
//                }
//            }
//      
//        } @catch (NSException *exception) {
//            NSLog(@"aaa");
//        } @finally {
//            
//        }
    [self.iFlySpeechEvaluator cancel];
        
    
        //    [self.iFlySpeechEvaluator destroy];
//        [self onBtnParse:nil];
//        [self.iFlySpeechEvaluator stopListening];
//        
//        [self.iFlySpeechEvaluator cancel];
        //    [self.resultView resignFirstResponder];
        //    [self.textView resignFirstResponder];
        //    [self.popupView removeFromSuperview];
        //    self.resultView.text =KCResultNotify1;
        self.resultText=@"";
        //    self.startBtn.enabled=YES;


}


/*!
 *  开始解析
 *
 *  @param sender parseBtn
 */
- (void)onBtnParse:(id)sender {
    
    ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
    parser.delegate=self;
    [parser parserXml:self.resultText];
    
}


#pragma mark - ISESettingDelegate

/*!
 *  设置参数改变
 *
 *  @param params 参数
 */
- (void)onParamsChanged:(ISEParams *)params {
    self.iseParams=params;
    [self performSelectorOnMainThread:@selector(reloadCategoryText) withObject:nil waitUntilDone:NO];
}
static NSString *LocalizedEvaString(NSString *key, NSString *comment) {
    return NSLocalizedStringFromTable(key, @"eva/eva", comment);
}
-(void)reloadCategoryText{
    


    
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    
    
    
    
    
//    if ([self.iseParams.language isEqualToString:KCLanguageZHCN]) {
//        if ([self.iseParams.category isEqualToString:KCCategorySyllable]) {
//            self.textView.text = LocalizedEvaString(KCTextCNSyllable, nil);
//        }
//        else if ([self.iseParams.category isEqualToString:KCCategoryWord]) {
//            self.textView.text = LocalizedEvaString(KCTextCNWord, nil);
//        }
//        else {
//            self.textView.text = @"苹果";
//        }
//    }
//    else {
        if ([self.iseParams.category isEqualToString:KCCategoryWord]) {
//            self.textView.text = LocalizedEvaString(KCTextENWord, nil);
        }
        else {
//            self.textView.text = LocalizedEvaString(KCTextENSentence, nil);
        }
        self.isValidInput=YES;
//        self.EnLabel.text = @"apple";
    
//    }
}
#pragma mark - IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    //    NSLog(@"volume:%d",volume);
//    [self.popupView setText:[NSString stringWithFormat:@"音量：%d",volume]];
    NSLog(@"音量：%d",volume);
//    [self.view addSubview:self.popupView];
}

/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
    
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech {
    NSLog(@"录音结束会掉");
}

/*!
 *  正在取消
 */
- (void)onCancel {
    
}

/*!
 *  评测结果回调
 *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
 *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
 *  数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onError:(IFlySpeechError *)errorCode {
    if(errorCode && errorCode.errorCode!=0){
//        [self.popupView setText:[NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]]];
//        [SVProgressHUD showErrorWithStatus:[errorCode errorDesc]];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//        NSLog(@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]);
//        [self.view addSubview:self.popupView];
#warning 可以加上 请重试
    }
    [_rotateImage.layer removeAnimationForKey:@"rotationAnimation"];
//    [_lineImage.layer removeAnimationForKey:@"lineAnimation"];
//    [_lineImage clearPoints];
//    _lineImage.hidden =YES;
    [self stopRecording];

    [self performSelectorOnMainThread:@selector(resetBtnSatus:) withObject:errorCode waitUntilDone:NO];
    
}

-(void)resetBtnSatus:(IFlySpeechError *)errorCode{
    
    if(errorCode && errorCode.errorCode!=0){
        self.isSessionResultAppear=NO;
        self.isSessionEnd=YES;
//        self.resultView.text =KCResultNotify1;
        self.resultText=@"";
    }else{
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
    }
//    self.startBtn.enabled=YES;
}


/*!
 *  评测结果回调
 *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast{
    if (results) {
        NSString *showText = @"";
        
        const char* chResult=[results bytes];
        
        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }
        
        self.resultText=showText;
//        self.resultView.text = showText;
        [self onBtnParse:nil];
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
        if(isLast){
//            [self.popupView setText:@"评测结束"];
//            [self.view addSubview:self.popupView];
            NSLog(@"测评结束");
        }
        
    }
    else{
        if(isLast){
            NSLog(@"你好像没有说话哦");

//            [self.popupView setText:@"你好像没有说话哦"];
//            [self.view addSubview:self.popupView];
        }
        self.isSessionEnd=YES;
    }
//    self.startBtn.enabled=YES;
}
#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result{
//    self.resultView.text=[result toString];
    self.resultString = [result toString];
    NSLog(@"%@",[result toString]);
    
    [self showPoint];
//    _resultView.text = [result toString];
//    _resultView.hidden = NO;
}
-(void)showPoint{
    NSString *str = self.resultString;
    NSArray *arr =[str componentsSeparatedByString:@"\n"];
    for (int i=0; i<arr.count; i++) {
        
        if ([(NSString *)arr[i] rangeOfString:@"总分："].location!=NSNotFound  ) {
            NSArray *arr2 = [arr[i] componentsSeparatedByString:@"："];
            float a = [arr2[1] floatValue];
            a=a*100/5;
            //            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"标准度:%.0f%%",a]];
            //            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"标准度:%.0f%%",a]];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [SVProgressHUD dismiss];
            //            });
            if (a>60) {
                [Utils showAlter:[NSString stringWithFormat:@"标准度:%.0f%%",a]];
                
                _shouldGoNext = YES;
                AudioServicesPlaySystemSound(_soundID);
                AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
                
                if (a>90) {
                    if (_continuousThree90>=3) {
                        _continuousThree90=0;
                    }
                    _continuousThree90+=1;
                    
                    //start
#pragma mark gd_原本:连续三个Prefect!获得一个U钻! 改为不在获得优钻  2017-03-27 18:11:23:12
//                    if (_continuousThree90>=3) {
//                        _continuousThree90=0;
//                        [Utils showAlter:@"连续三个Prefect!获得一个U钻!"];
//                    }
                    if (_continuousThree90>=3) {
                        _continuousThree90=0;
                        [Utils showAlter:@"连续三个Prefect!"];
                    }
                    //end
                    
                }else{
                    _continuousThree90 = 0;
                }
                //break;
                //                [self getNextWord];
            }else {
                if (a<30) {
                    NSLog(@"没听懂");
                    [self addDidNotUnderstand];
                    
                }else {
                    [Utils showAlter:[NSString stringWithFormat:@"标准度:%.0f%%",a]];
                    
                }
                NSLog(@"bofang");
                PronunciationModel *model = [self.listArray objectAtIndex:_currentWord-1];
                
                //                if (_soundID) {
                //                    AudioServicesDisposeSystemSoundID(_soundID);
                //                }
                NSURL *soundURL = [NSURL URLWithString:model.audioPath];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
                AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, completionCallback2, (__bridge void *)self);
                AudioServicesPlaySystemSound(_soundID);
            }
            break;
        }
    }

}

@end
