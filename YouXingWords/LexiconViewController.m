//
//  LexiconViewController.m
//  YouXingWords
//
//  Created by tih on 16/8/10.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "LexiconViewController.h"
#import "PassCell.h"
#import "MyPageControl.h"
#import "BarrierDetailVC.h"
#import "BeforeLearnVC.h"
#import "BrowerWordsVC.h"
#import "SARUnArchiveANY.h"
#import "LZMAExtractor.h"
#import "PassList.h"
#import "CustomLayout.h"
#import "ChooseResVC.h"
#import <SVProgressHUD.h>

#import "FuxiModel.h"

#import "DDCollectionViewHorizontalLayout.h"

#import "XMGLineLayout.h"

#import "PassList.h"

typedef void(^DownQSBlock)(NSDictionary * dictJSON);

#define BEFORE_TEST @"beforeTest"//学前测试分数
@interface LexiconViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,ChooseResProtocal>
{   //学前分数
    UILabel *scoreLabel;
    //钻石数
    UILabel * diamondLabel;
    //ABC数
    UILabel * ABCLabel;
    //touch
    BOOL isOnTouch;
    
}
@property (nonatomic,retain)UIButton *beforeStartTest;
@property (nonatomic,retain)UIButton *beforeRestartTest;
@property (nonatomic,retain)PassModel *testModel;

@property (nonatomic,retain)UIButton *preBarrierVBtn;
@property (nonatomic,retain)UIButton *nextBarrierVBtn;
@property (nonatomic,retain)UICollectionView *collectionView;
//@property (retain, nonatomic ) CustomLayout *collectFlowLayout;
@property (strong, nonatomic ) DDCollectionViewHorizontalLayout *collectFlowLayout;

//@property (retain, nonatomic ) XMGLineLayout *collectFlowLayout;
@property (nonatomic,retain)NSMutableArray *listArray;
@property (nonatomic,assign)NSInteger realModelNum;
@property (nonatomic,retain)NSMutableArray *ifLockArray;

@property (nonatomic,retain)MyPageControl *pageControl;
@property (nonatomic,retain)UILabel *currentBook;




@property (strong, nonatomic)  NSNumber *currentBookId;

@property (assign, nonatomic)  BreakthroughType type;

@end

@implementation LexiconViewController

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

#pragma mark - 视图变化 消失出现
-(void)viewWillAppear:(BOOL)animated{

    //start
#pragma mark gd_屏蔽,解决加载时间过长  2017-03-28 12:08:24-7
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    [df setObject:@0 forKey:@"timer"];
//    if (_collectionView) {
//        //        _ifLockArray = nil;
//        [_collectionView reloadData];
//        [self updateButtonStatus];
//        
//    }
//    
//    NSString *path = [PassList getIfLockArrayPath];
//    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
//    if (arr && _isNotFirst) {
//        [self calculateNumbers:arr];
//    }else{
//        _isNotFirst = YES;
//    }
    //end
    
    
    
    [self checkAndRequest];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initNaviBarAndBackImg];
    [self addBeforeLearn];
    [self addGoodsNumView];
    
    
    
    
    
//    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
//        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alterView show];
//    }else{
//      
//        [self startRequset];
//    }
    
}


- (void)setup{
    self.title = @"闯关";
//    NSNumber * currentBookId = nil;
//    switch (self.type) {
//        case BreakthroughTypeWord:
//            currentBookId = [AnswerTools getBookID];
//            break;
//            
//        case BreakthroughTypeGrammer:
//            currentBookId = [AnswerTools getBookID];
//            break;
//            
//        case BreakthroughTypeCourse:
//            currentBookId = [AnswerTools getBookID];
//            break;
//            
//        default:
//            break;
//    }
//    
//    self.currentBookId = currentBookId;

}

- (void)checkAndRequest{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *strzip = [NSString stringWithFormat:@"Documents/%@/%@.zip",[Utils getResFolder],[AnswerTools getBookID]];
//    NSString *filePathzip = [NSHomeDirectory() stringByAppendingPathComponent:strzip];
//    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getBookID]];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    NSString *strzip = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getBookIDWith:_type],ArchiveType];
    NSString *filePathzip = [NSHomeDirectory() stringByAppendingPathComponent:strzip];
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getBookIDWith:_type]];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    
    //end


    
    
    
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && ![[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }else{
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:filePath] && [[NSFileManager defaultManager]fileExistsAtPath:filePathzip]) {
            
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
            [Utils unArchive:filePathzip andPassword:nil destinationPath:nil completionBlock:^{
                
            } failureBlock:^{
                
            }];
            
            __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES afterDelay:0.5];
                
                hud.completionBlock = ^{
                    [self startRequset];
                };
                
            });
        }else{
            [self startRequset];
        }
        
        
        
    }

}

#pragma mark gd_startRequset
-(void)startRequset{
    
    NSLog(@"----------startRequset---------");
    
    [self addBarrierView];
    
    __block MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:HUD];
    
    HUD.labelText =@"正在加载";
    HUD.dimBackground = YES;
    HUD.mode=MBProgressHUDModeText;
    [HUD show:YES ];//                    });
    
   
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//     NSNumber * bookId = [AnswerTools getBookID];
     NSNumber * bookId = [AnswerTools getBookIDWith:_type];
    //end
    
    [NetWorkingUtils postWithUrlWithoutHUD:LockListUrl params:@{@"token":[Utils getCurrentToken],@"bookId":bookId} successResult:^(id response) {
        
        
        NSLog(@"*******************iflock下载成功");
        
        //        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
        NSString *path = [PassList getIfLockArrayPathWith:_type];
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //        本来存在的lockArray
//        NSArray *lockArrayExisted = nil;
//        if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
//            lockArrayExisted = [NSArray arrayWithContentsOfFile:path];
//        }
        NSMutableArray * OldPassInfoArr = [FileManagerHelper getPassInfo];
        
        @try {
            if ([response valueForKey:@"data"]!=nil) {
                
                //不要抹掉
                if ([fm fileExistsAtPath:path]) {
                    [fm removeItemAtPath:path error:nil];
                }
                
                //解析qs.txt
                //start
#pragma mark gd_修改获取 firstDic 的方法  2017-03-28 12:17:00-编号
//                NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//                NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//                NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
 
//#pragma mark gd_修改获取资源包方式
//                NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
                
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                NSDictionary *firstDic = [Utils getCurrentQsTxtDict];
                NSDictionary *firstDic = [Utils getCurrentQsTxtDictWith:_type];
                //end
                
                
                //end
                
                

                NSError *error;
                
                if (!firstDic) {
                    NSLog(@"%@",error);
                }
                NSArray *listArr = [firstDic valueForKey:@"datas"];
                
                NSMutableArray *passIdArr = [NSMutableArray array];

            
                _testModel = [PassModel modelWithDic:listArr[0]];
                
                //start
#pragma mark xl_关卡顺序不对  7.25-20：53
                NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"passId" ascending:YES]];
                NSArray *sortListArr = [listArr sortedArrayUsingDescriptors:sortArr];
                
// 记录过关的单词数量,使用 dict 避免重复
                NSMutableDictionary * dictNumber  = [NSMutableDictionary dictionary];
                for (int i = 0; i < sortListArr.count; i ++) {
                    NSDictionary *dic = sortListArr[i];
                    [passIdArr addObject:[dic valueForKey:@"passId"]];


                    PassModel *model = [PassModel modelWithDic:dic];

                    
////                    取关卡的时候顺便给 listArray 赋值
//                    PassModel *model = [PassModel modelWithDic:dic];
//                    model.passName = [NSString stringWithFormat:@"第%zd关",i + 1];
                    
                    //end
                    [self.listArray addObject:model];
                    
//                    NSDictionary *dic = listArr[i];
                    //        当前关卡中的题目
//                    NSArray *qsArr =[dic valueForKey:@"data"];
//                    
//                    for (int j=0; j<qsArr.count; j++) {
//                        
//                        NSNumber *wordID = [qsArr[j] valueForKey:@"wordId"];
//                        [dictNumber setObject:wordID forKey:wordID];
//                    }
                    
                }
                
                NSInteger fuxiGuanIndex = -1; //在下面的循环中检测出如果有复习关应该插入到何处
                
//                计算已获取优钻数量
                NSInteger gotCoins = 0;
                
                
                //                返回数据中的关卡信息
                NSMutableArray *arr = [NSMutableArray arrayWithArray:[response valueForKey:@"data"]];
                NSArray *arrs = [NSArray arrayWithArray:arr];
                
#//start
#pragma mark xl_有未上传的关卡记录先覆盖网络上的  8-25-1
                if (OldPassInfoArr.count>0) {
                    NSDictionary *liziOne = arrs[0];
                    for (NSDictionary *passDict in OldPassInfoArr) {
                        if ([passDict[@"bookId"] isEqualToString:liziOne[@"bookId"]]) {
                            int i = 0;
                            for (NSDictionary *passNew in arrs) {
                                if ([passNew[@"passId"] isEqualToString:passDict[@"passId"]] && [passDict[@"isExit"] integerValue] == 0) {
                                    NSDictionary *newPass = @{@"isPass":@(1),@"coins":@(1),@"bookId":passNew[@"bookId"],@"passId":passNew[@"passId"],@"passTime":passNew[@"passTime"],@"ranking":passNew[@"ranking"],@"updateTime":passNew[@"updateTime"],@"username":passNew[@"username"],@"voiceCoins":passNew[@"voiceCoins"],};
                                    
                                    [arr replaceObjectAtIndex:i withObject:newPass];
                                }
                                
                                i++;
                            }
                        }
                    }
                }
                
                
                //end
                
                
#pragma mark gd_保存是否解锁关卡
                //                下面这个嵌套循环逻辑:将下载下来的关卡信息,录入到 arrM ,passIdArr的作用仅仅是方便排序
                NSMutableArray *arrM = [NSMutableArray array];
                BOOL isFirst=NO;
                //#pragma mark gd_如果最后一个解锁关卡是第五关(及倍数),这一关是复习关,解锁下一关.
                //                NSInteger shouldOpenNext = -1;
                

                for (int j =0; j<passIdArr.count; j++) {
                    
                    if (j == 99) {
                        NSLog(@"");
                    }
                    
                    for (int i=0; i<arr.count; i++) {
                        if (![[arr[i]valueForKey:@"passId"]isEqualToNumber:passIdArr[j]]) {
                            continue;
                        }else{
                           
                            NSLog(@"关卡 = %d,passInfo = %@",j,arr[i]);
                            
                            NSNumber *isUnlock =[arr[i] valueForKey:@"isPass"];
                            
                            if ([isUnlock integerValue] == 1) {
                                NSDictionary *QSdic = listArr[j];
                                NSArray *qsArr =[QSdic valueForKey:@"data"];
                                
                                for (int k=0; k<qsArr.count; k++) {
                                    
                                    NSNumber *wordID = [qsArr[k] valueForKey:@"wordId"];
                                    [dictNumber setObject:wordID forKey:wordID];
                                }
                            }
                            
                            if ([isUnlock isEqualToNumber:@1]) {
                                fuxiGuanIndex = j;
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",j] forKey:@"LastPassIndex"];
                                //                                [[NSUserDefaults standardUserDefaults] setObject:@"7" forKey:@"LastPassIndex"];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"alreadyPass"];
                            }
                            
                            
                            if ([isUnlock isEqualToNumber:@0]&&!isFirst) {
                                
                                //start
#pragma mark gd_更改解锁条件,如果存在复习关,不解锁下一关  2017-04-05 10:21:49-7
//                                isFirst = YES;
//                                isUnlock = @1;
                                if (ShouleUnLockNextIfHasFuxiguan) {
//                                    isFirst = YES;
                                    isUnlock = @1;
                                }else{
                                    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                                    if (![PassList shouldSetUpFuxiguan]) {
//                                        //                                        isFirst = YES;
//                                        isUnlock = @1;
//                                    }
                                    if (![PassList shouldSetUpFuxiguanWith:_type]) {
                                        //                                        isFirst = YES;
                                        isUnlock = @1;
                                    }
                                    //end
                                
                                }
                                
                               
                                if ([isUnlock integerValue] == 1) {
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",j] forKey:@"LastPassIndex"];
                                    //                                [[NSUserDefaults standardUserDefaults] setObject:@"7" forKey:@"LastPassIndex"];
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"alreadyPass"];
                                }
                                
                                
                                //end
                                
                                
                                
                                

                                //                                if ((j + 1) % 5 == 0) {
                                //                                    shouldOpenNext = j+1;
                                //                                }
                                fuxiGuanIndex = j;
                                isFirst = YES;
                            }else if ((j == passIdArr.count - 1)&& !isFirst){
                                fuxiGuanIndex = j+1;
                            }
//                            isUnlock = @1;
                            
                            NSDictionary *dic = @{@"ifLock":isUnlock,@"Udiamond":[arr[i] valueForKey:@"coins"]};
                            [arrM addObject:dic];
                            
                            NSNumber *coins = [dic valueForKey:@"Udiamond"];
                            gotCoins= gotCoins + [coins integerValue];
                            
                            
                            
                            
                            break;
                        }
                        
                    }
                }
                
                NSString *diamondLabelText =  [NSString stringWithFormat:@"%zd/%zd",gotCoins,arr.count*3];
                diamondLabel.text = diamondLabelText;
                
                NSString *ABCLabelText = [NSString stringWithFormat:@"%zd/%@",dictNumber.count,[firstDic valueForKey:@"counts"]];
                ABCLabel.text = [Utils isValidStr:ABCLabelText]?ABCLabelText:@"0/0";
                
                
                
                
                //start
#pragma mark gd_修改添加复习关的方式，改为判断本地错题本  2017-03-30 20:34:18
                
                //#pragma mark    gd_检查之前有没有存复习关卡,如果存了,要取出存到最新的里面
                //                for (int k = 0; k <lockArrayExisted.count; k++) {
                //                    NSDictionary * dict = lockArrayExisted[k];
                //                    if (dict[@"isFuxiguan"] && [dict[@"isFuxiguan"] integerValue] ==1) {
                //                        //                                        [arrM insertObject:dict atIndex:k];
                //                        //                        [arrM addObject:dict];
                //                        [arrM insertObject:dict atIndex:k];
                //
                //
                //                        PassModel *model = [PassList getFuxiti];
                //                        [self.listArray insertObject:model atIndex:k];
                //                        
                //                        
                //                    }
                //                }
                
                
//                NSString * userCuotiCount = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserCuotiCount];
                
//                if ([userCuotiCount integerValue] > CountWrongWordsCallFuxi) {
                if ([PassList shouldSetUpFuxiguanWith:_type]) {
                    PassModel *model = [PassList getFuxitiWith:_type];
//                    if (fuxiGuanIndex > 0) {
//                        fuxiGuanIndex --;
//                    }
                    [self.listArray insertObject:model atIndex:fuxiGuanIndex];
                    
                }else{
                    fuxiGuanIndex = -1;
                }
                [PassList defaultManager].indexFuxiguan = fuxiGuanIndex;
                

                
                //end



                //                将闯关信息保存到本地
                [arrM writeToFile:path atomically:NO];
                
                self.ifLockArray = [NSMutableArray arrayWithArray:arrM];
                
                for (int i = 0; i < arrM.count; i++) {
                    
                    if (i >= 1) {
                        NSDictionary *previousdict = arrM[i-1];
                        NSDictionary *nowdict = arrM[i];
                        if (([previousdict[@"Udiamond"] intValue]>0 && [previousdict[@"ifLock"] intValue] ==1) && [nowdict[@"ifLock"] intValue] == 0) {
                            NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                            
                            [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                        }
                    }
                    
                }
                int psId = 0;
                for (int i = (short)arr.count- 1; i > 0; i--) {
                    NSDictionary *nowdict = arr[i];
                    if ([nowdict[@"ifLock"] intValue] == 1) {
                        if(psId == 0){
                            psId = 1;
                        }else{
                            NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                            [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                        }
                        
                    }
                }
                //start
#pragma mark gd_在临时ifLockArray中插入复习关  <#时间#>-<#编号#>
                if (fuxiGuanIndex != -1) {
                    NSDictionary * fuxi = @{@"ifLock":@(1),@"Udiamond":@(0)};
                    [self.ifLockArray insertObject:fuxi atIndex:fuxiGuanIndex];
                }
                //end
                
                //start
#pragma mark gd_上面已经计算过-减少时间  2017-03-28 15:16:52
                //                //                计算钻石数量
                //                [self calculateNumbers:arrM];
                //end
                
                //start
#pragma mark gd_修改添加关卡 view 的位置  2017-03-21 21:10:32-4
                //                [self addBarrierView];
                //end
                
                
                //                更新ABC信息 和 给关卡题目数据赋值
                [self downloadRes];
//                [self reloadDataSource];
                [self reloadDataSourceWithOutFuxiguan];
                //                更改CollectionView两侧箭头按钮是否可交互
                [self updateButtonStatus];
                
            }
        }
        @catch (NSException *exception) {
            [Utils showAlter:@"网络连接失败！"];
            //            self.view.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        @finally {
            [self.collectionView reloadData];
        }
//
        
        [HUD hide:YES afterDelay:0];
    } errorResult:^(NSError *error) {
        

        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *path = [PassList getIfLockArrayPath];
        NSString *path = [PassList getIfLockArrayPathWith:_type];
        //end
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSLog(@"*******************iflock下载失败");
        
        if ([fm fileExistsAtPath:path]) {
            NSLog(@"*******************iflock存在");
            //start
#pragma mark gd_修改无网络状况下的获取方式  2017-04-05 19:12:48
            //            NSArray *arr = [NSArray arrayWithContentsOfFile:path];
            //            //start
            //#pragma mark gd_没网情况下,解决关卡全部没解锁  2017-03-<#时间#>-<#编号#>
            //            self.ifLockArray = [NSMutableArray arrayWithArray:arr];
            //            //end
            //            [self calculateNumbers:arr];
            //            //start
            //#pragma mark gd_修改添加关卡 view 的位置  2017-03-21 21:10:32-5
            //            //                [self addBarrierView];
            //            //end
            //
            //
            //
            //
            //
            //            NSDictionary *firstDic = [Utils getCurrentQsTxtDict];
            //            //        qs.txt中的全部关卡信息
            //            NSArray *listArr = [firstDic valueForKey:@"datas"];
            //            for (int i=0; i<listArr.count; i++) {
            //                PassModel *model = [PassModel modelWithDic:listArr[i]];
            //                model.passName = [NSString stringWithFormat:@"第%zd关",i + 1];
            //                [self.listArray addObject:model];
            //            }
            //
            //
            //
            //
            //            //        本来存在的lockArray
            //            NSArray *lockArrayExisted = nil;
            //            if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
            //                lockArrayExisted = [NSArray arrayWithContentsOfFile:path];
            //            }
            //
            //            for (int j =0; j<lockArrayExisted.count; j++) {
            //
            //                NSString * fuxiti = [lockArrayExisted[j]valueForKey:@""];
            //
            ////                for (int i=0; i<arr.count; i++) {
            ////                    if (![[arr[i]valueForKey:@"passId"]isEqualToNumber:passIdArr[j]]) {}
            ////                }
            //            }
            //            
            //            
            //            
            //            
            //            
            //            
            //            [self downloadRes];
            //            [self reloadDataSource];
            //            [self updateButtonStatus];
            //            [self.collectionView reloadData];
//                        [HUD hide:YES afterDelay:0];
            //
            
            
            
            
            
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            NSDictionary *firstDic = [Utils getCurrentQsTxtDict];
            NSDictionary *firstDic = [Utils getCurrentQsTxtDictWith:_type];
            //end

            
            
            //end
            
            
            
            NSError *error;
            
            if (!firstDic) {
                NSLog(@"%@",error);
            }
            NSArray *listArr = [firstDic valueForKey:@"datas"];
            
            
            _testModel = [PassModel modelWithDic:listArr[0]];
            
            
            //                记录过关的单词数量,使用 dict 避免重复
            NSMutableDictionary * dictNumber  = [NSMutableDictionary dictionary];
            for (int i = 0; i < listArr.count; i ++) {
                NSDictionary *dic = listArr[i];
//                [passIdArr addObject:[dic valueForKey:@"passId"]];
                
                //                    取关卡的时候顺便给 listArray 赋值
                PassModel *model = [PassModel modelWithDic:dic];
                model.passName = [NSString stringWithFormat:@"第%zd关",i + 1];
                [self.listArray addObject:model];
                
                
                //                    NSDictionary *dic = listArr[i];
                //        当前关卡中的题目
                //                    NSArray *qsArr =[dic valueForKey:@"data"];
                //
                //                    for (int j=0; j<qsArr.count; j++) {
                //
                //                        NSNumber *wordID = [qsArr[j] valueForKey:@"wordId"];
                //                        [dictNumber setObject:wordID forKey:wordID];
                //                    }
                
            }
            
            
            NSInteger fuxiGuanIndex = -1; //在下面的循环中检测出如果有复习关应该插入到何处
            
            //                计算已获取优钻数量
            NSInteger gotCoins = 0;
            
            
            NSArray *arr = [NSArray arrayWithContentsOfFile:path];

           
            
            self.ifLockArray = [NSMutableArray arrayWithArray:arr];
            
            for (int i = 0; i < arr.count; i++) {
                
                if (i >= 1) {
                    NSDictionary *previousdict = arr[i-1];
                    NSDictionary *nowdict = arr[i];
                    if (([previousdict[@"Udiamond"] intValue]>0 && [previousdict[@"ifLock"] intValue] ==1) && [nowdict[@"ifLock"] intValue] == 0) {
                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                        
                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                    }
                }
            }
//            int psId = 0;
//            for (int i = (short)arr.count- 1; i > 0; i--) {
//                NSDictionary *nowdict = arr[i];
//                if ([nowdict[@"ifLock"] intValue] == 1) {
//                    if(psId == 0){
//                        psId = 1;
//                    }else{
//                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
//                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
//                    }
//                    
//                }
//            }
#pragma mark gd_保存是否解锁关卡
            //                下面这个嵌套循环逻辑:将下载下来的关卡信息,录入到 arrM ,passIdArr的作用仅仅是方便排序
            NSMutableArray *arrM = [NSMutableArray array];
            BOOL isFirst=NO;
            //#pragma mark gd_如果最后一个解锁关卡是第五关(及倍数),这一关是复习关,解锁下一关.
            //                NSInteger shouldOpenNext = -1;
            
            NSDictionary * passIdsDic = [PassList getBookAllPassedPassIdsWithBookId:[AnswerTools getBookIDWith:self.type]];
            
            for (int j =0; j<arr.count; j++) {
                
  
                
//                for (int i=0; i<arr.count; i++) {
//                    if (![[arr[i]valueForKey:@"passId"]isEqualToNumber:passIdArr[j]]) {
//                        continue;
//                    }else{
                
                        
                        
                        NSNumber *isUnlock =[arr[j] valueForKey:@"ifLock"];
                        
                        if ([isUnlock integerValue] == 1) {
                            NSDictionary *QSdic = listArr[j];
                            NSArray *qsArr =[QSdic valueForKey:@"data"];
                            
                            for (int k=0; k<qsArr.count; k++) {
                                
                                NSNumber *wordID = [qsArr[k] valueForKey:@"wordId"];
                                [dictNumber setObject:wordID forKey:wordID];
                            }
                        }
                        
                        if ([isUnlock isEqualToNumber:@1]) {
                            fuxiGuanIndex = j;
                        }
                        
                        
                        if ([isUnlock isEqualToNumber:@0]&&!isFirst) {
                            
                            if (j == 0) {
//                                如果是第一关,直接解锁
                                isUnlock = @1;
                            }else{
//                                上一个关卡的关卡 Id
                                NSNumber * lastPassId = [arr[j - 1] valueForKey:@"passId"];
                                
//                                查看本地存储的已通关的 passId 中是否有上一关的 id
                                NSString * lastIfPass = [passIdsDic objectForKey:lastPassId];
//                                 判断上一关是不是真的通关了(有可能是没有通关,只是解锁了)
                                BOOL lastIfPassB = [LGDUtils isValidStr:lastIfPass]?YES:NO;
//                                如果上一关是真的通关了,而不只是解锁了,那么,解锁下一关
                                if (lastIfPassB) {
                                    //start
#pragma mark gd_更改解锁条件,如果存在复习关,不解锁下一关  2017-04-05 10:21:49-7
                                    //                                isFirst = YES;
                                    //                                isUnlock = @1;
                                    if (ShouleUnLockNextIfHasFuxiguan) {
                                        //                                    isFirst = YES;
                                        isUnlock = @1;
                                    }else{
                                        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                                        //                                if (![PassList shouldSetUpFuxiguan]) {
                                        //                                    //                                        isFirst = YES;
                                        //                                    isUnlock = @1;
                                        //                                }
                                        if (![PassList shouldSetUpFuxiguanWith:_type]) {
                                            //                                        isFirst = YES;
                                            isUnlock = @1;
                                        }
                                        //end
                                        
                                    }
                                }
                            }
                            
                            
                            
                            
                            //end
                            
                            
                            
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",j] forKey:@"LastPassIndex"];
                            //                                [[NSUserDefaults standardUserDefaults] setObject:@"7" forKey:@"LastPassIndex"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",j] forKey:@"alreadyPass"];
                            //                                if ((j + 1) % 5 == 0) {
                            //                                    shouldOpenNext = j+1;
                            //                                }
                            fuxiGuanIndex = j;
                            isFirst = YES;
                        }
                        //                            isUnlock = @1;
                        
                        NSDictionary *dic = @{@"ifLock":isUnlock,@"Udiamond":[arr[j] valueForKey:@"Udiamond"]};
                        [arrM addObject:dic];
                
                        NSNumber *coins = [dic valueForKey:@"Udiamond"];
                        gotCoins= gotCoins + [coins integerValue];
                        
                        
                        
//                        break;
//                    }
                    
//                }
            }
            
            NSString *diamondLabelText =  [NSString stringWithFormat:@"%zd/%zd",gotCoins,arr.count*3];
            diamondLabel.text = diamondLabelText;
            
            NSString *ABCLabelText = [NSString stringWithFormat:@"%zd/%@",dictNumber.count,[firstDic valueForKey:@"counts"]];
            ABCLabel.text = [Utils isValidStr:ABCLabelText]?ABCLabelText:@"0/0";

            
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                if ([PassList shouldSetUpFuxiguan]) {
//            PassModel *model = [PassList getFuxiti];
            if ([PassList shouldSetUpFuxiguanWith:_type]) {
                PassModel *model = [PassList getFuxitiWith:_type];
                //end

                

                [self.listArray insertObject:model atIndex:fuxiGuanIndex];
                
            }else{
                fuxiGuanIndex = -1;
            }
            [PassList defaultManager].indexFuxiguan = fuxiGuanIndex;
            
            
            
            
            //                将闯关信息保存到本地
            [arrM writeToFile:path atomically:NO];
            
            self.ifLockArray = [NSMutableArray arrayWithArray:arrM];
            
            for (int i = 0; i < arrM.count; i++) {
                
                if (i >= 1) {
                    NSDictionary *previousdict = arrM[i-1];
                    NSDictionary *nowdict = arrM[i];
                    if (([previousdict[@"Udiamond"] intValue]>0 && [previousdict[@"ifLock"] intValue] ==1) && [nowdict[@"ifLock"] intValue] == 0) {
                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                        
                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                    }
                }
                
            }
            
            int psId = 0;
            for (int i = (short)arr.count- 1; i > 0; i--) {
                NSDictionary *nowdict = arr[i];
                if ([nowdict[@"ifLock"] intValue] == 1) {
                    if(psId == 0){
                        psId = 1;
                    }else{
                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                    }
                    
                }
            }
            
            //start
#pragma mark gd_在临时ifLockArray中插入复习关  <#时间#>-<#编号#>
            if (fuxiGuanIndex != -1) {
                NSDictionary * fuxi = @{@"ifLock":@(1),@"Udiamond":@(0)};
                [self.ifLockArray insertObject:fuxi atIndex:fuxiGuanIndex];
            }
            //end

            //                更新ABC信息 和 给关卡题目数据赋值
            [self downloadRes];
            //                [self reloadDataSource];
            [self reloadDataSourceWithOutFuxiguan];
            //                更改CollectionView两侧箭头按钮是否可交互
            [self updateButtonStatus];
            
            [HUD hide:YES afterDelay:0];
            
            //end
        }else{
            [HUD hide:YES afterDelay:0];
            
            [Utils showAlter:@"网络连接失败！"];
            self.view.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        NSLog(@"%@",error);
    }];
    
}

//只需要 [response valueForKey:@"data"] 即可
- (void)afterRequest:(NSDictionary *)response{
    NSLog(@"*******************iflock下载成功");
    
    //        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
    NSString *path = [PassList getIfLockArrayPathWith:_type];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //        本来存在的lockArray
    //        NSArray *lockArrayExisted = nil;
    //        if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
    //            lockArrayExisted = [NSArray arrayWithContentsOfFile:path];
    //        }
    
    
    @try {
        if ([response valueForKey:@"data"]!=nil) {
            if ([fm fileExistsAtPath:path]) {
                [fm removeItemAtPath:path error:nil];
            }
            
            //解析qs.txt
            //start
#pragma mark gd_修改获取 firstDic 的方法  2017-03-28 12:17:00-<#编号#>
            //                NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
            //                NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
            //                NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
            
            //#pragma mark gd_修改获取资源包方式
            //                NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
            
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
            //                NSDictionary *firstDic = [Utils getCurrentQsTxtDict];
            NSDictionary *firstDic = [Utils getCurrentQsTxtDictWith:_type];
            //end
            
            
            //end
            
            
            
            NSError *error;
            
            if (!firstDic) {
                NSLog(@"%@",error);
            }
            NSArray *listArr = [firstDic valueForKey:@"datas"];
            
            NSMutableArray *passIdArr = [NSMutableArray array];
            
            
            
            
            
            _testModel = [PassModel modelWithDic:listArr[0]];
            
            
            
            
            //                记录过关的单词数量,使用 dict 避免重复
            NSMutableDictionary * dictNumber  = [NSMutableDictionary dictionary];
            for (int i = 0; i < listArr.count; i ++) {
                NSDictionary *dic = listArr[i];
                [passIdArr addObject:[dic valueForKey:@"passId"]];
                
                //                    取关卡的时候顺便给 listArray 赋值
                PassModel *model = [PassModel modelWithDic:dic];
                model.passName = [NSString stringWithFormat:@"第%zd关",i + 1];
                [self.listArray addObject:model];
                
                
                //                    NSDictionary *dic = listArr[i];
                //        当前关卡中的题目
                //                    NSArray *qsArr =[dic valueForKey:@"data"];
                //
                //                    for (int j=0; j<qsArr.count; j++) {
                //
                //                        NSNumber *wordID = [qsArr[j] valueForKey:@"wordId"];
                //                        [dictNumber setObject:wordID forKey:wordID];
                //                    }
                
            }
            
            
            
            
            NSInteger fuxiGuanIndex = -1; //在下面的循环中检测出如果有复习关应该插入到何处
            
            //                计算已获取优钻数量
            NSInteger gotCoins = 0;
            
            //                返回数据中的关卡信息
            NSArray *arr = [response valueForKey:@"data"];
#pragma mark gd_保存是否解锁关卡
            //                下面这个嵌套循环逻辑:将下载下来的关卡信息,录入到 arrM ,passIdArr的作用仅仅是方便排序
            NSMutableArray *arrM = [NSMutableArray array];
            BOOL isFirst=NO;
            //#pragma mark gd_如果最后一个解锁关卡是第五关(及倍数),这一关是复习关,解锁下一关.
            //                NSInteger shouldOpenNext = -1;
            
            
            for (int j =0; j<passIdArr.count; j++) {
                
                if (j == 99) {
                    NSLog(@"");
                }
                
                for (int i=0; i<arr.count; i++) {
                    if (![[arr[i]valueForKey:@"passId"]isEqualToNumber:passIdArr[j]]) {
                        continue;
                    }else{
                        
                        
                        
                        NSNumber *isUnlock =[arr[i] valueForKey:@"isPass"];
                        
                        if ([isUnlock integerValue] == 1) {
                            NSDictionary *QSdic = listArr[j];
                            NSArray *qsArr =[QSdic valueForKey:@"data"];
                            
                            for (int k=0; k<qsArr.count; k++) {
                                
                                NSNumber *wordID = [qsArr[k] valueForKey:@"wordId"];
                                [dictNumber setObject:wordID forKey:wordID];
                            }
                        }
                        
                        if ([isUnlock isEqualToNumber:@1]) {
                            fuxiGuanIndex = j;
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",j] forKey:@"LastPassIndex"];
                            //                                [[NSUserDefaults standardUserDefaults] setObject:@"7" forKey:@"LastPassIndex"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"alreadyPass"];
                        }
                        
                        
                        if ([isUnlock isEqualToNumber:@0]&&!isFirst) {
                            
                            //start
#pragma mark gd_更改解锁条件,如果存在复习关,不解锁下一关  2017-04-05 10:21:49-7
                            //                                isFirst = YES;
                            //                                isUnlock = @1;
                            if (ShouleUnLockNextIfHasFuxiguan) {
                                //                                    isFirst = YES;
                                isUnlock = @1;
                            }else{
                                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                                //                                    if (![PassList shouldSetUpFuxiguan]) {
                                //                                        //                                        isFirst = YES;
                                //                                        isUnlock = @1;
                                //                                    }
                                if (![PassList shouldSetUpFuxiguanWith:_type]) {
                                    //                                        isFirst = YES;
                                    isUnlock = @1;
                                }
                                //end
                                
                            }
                            
                            
                            if ([isUnlock integerValue] == 1) {
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",j] forKey:@"LastPassIndex"];
                                //                                [[NSUserDefaults standardUserDefaults] setObject:@"7" forKey:@"LastPassIndex"];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"alreadyPass"];
                            }
                            
                            
                            //end
                            
                            
                            
                            
                            
                            //                                if ((j + 1) % 5 == 0) {
                            //                                    shouldOpenNext = j+1;
                            //                                }
                            fuxiGuanIndex = j;
                            isFirst = YES;
                        }else if ((j == passIdArr.count - 1)&& !isFirst){
                            fuxiGuanIndex = j+1;
                        }
                        //                            isUnlock = @1;
                        
                        NSDictionary *dic = @{@"ifLock":isUnlock,@"Udiamond":[arr[i] valueForKey:@"coins"]};
                        [arrM addObject:dic];
                        
                        NSNumber *coins = [dic valueForKey:@"Udiamond"];
                        gotCoins= gotCoins + [coins integerValue];
                        
                        
                        
                        
                        break;
                    }
                    
                }
            }
            
            NSString *diamondLabelText =  [NSString stringWithFormat:@"%zd/%zd",gotCoins,arr.count*3];
            diamondLabel.text = diamondLabelText;
            
            NSString *ABCLabelText = [NSString stringWithFormat:@"%zd/%@",dictNumber.count,[firstDic valueForKey:@"counts"]];
            ABCLabel.text = [Utils isValidStr:ABCLabelText]?ABCLabelText:@"0/0";
            
            
            
            
            //start
#pragma mark gd_修改添加复习关的方式，改为判断本地错题本  2017-03-30 20:34:18
            
            //#pragma mark    gd_检查之前有没有存复习关卡,如果存了,要取出存到最新的里面
            //                for (int k = 0; k <lockArrayExisted.count; k++) {
            //                    NSDictionary * dict = lockArrayExisted[k];
            //                    if (dict[@"isFuxiguan"] && [dict[@"isFuxiguan"] integerValue] ==1) {
            //                        //                                        [arrM insertObject:dict atIndex:k];
            //                        //                        [arrM addObject:dict];
            //                        [arrM insertObject:dict atIndex:k];
            //
            //
            //                        PassModel *model = [PassList getFuxiti];
            //                        [self.listArray insertObject:model atIndex:k];
            //
            //
            //                    }
            //                }
            
            
            //                NSString * userCuotiCount = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserCuotiCount];
            
            //                if ([userCuotiCount integerValue] > CountWrongWordsCallFuxi) {
            if ([PassList shouldSetUpFuxiguanWith:_type]) {
                PassModel *model = [PassList getFuxitiWith:_type];
                //                    if (fuxiGuanIndex > 0) {
                //                        fuxiGuanIndex --;
                //                    }
                [self.listArray insertObject:model atIndex:fuxiGuanIndex];
                
            }else{
                fuxiGuanIndex = -1;
            }
            [PassList defaultManager].indexFuxiguan = fuxiGuanIndex;
            
            
            //end
            
            //                将闯关信息保存到本地
            [arrM writeToFile:path atomically:NO];
            
            self.ifLockArray = [NSMutableArray arrayWithArray:arrM];
            
            for (int i = 0; i < arrM.count; i++) {
                
                if (i >= 1) {
                    NSDictionary *previousdict = arrM[i-1];
                    NSDictionary *nowdict = arrM[i];
                    if (([previousdict[@"Udiamond"] intValue]>0 && [previousdict[@"ifLock"] intValue] ==1) && [nowdict[@"ifLock"] intValue] == 0) {
                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                        
                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                    }
                }
                
            }
            
            int psId = 0;
            for (int i = (short)arr.count- 1; i > 0; i--) {
                NSDictionary *nowdict = arr[i];
                if ([nowdict[@"ifLock"] intValue] == 1) {
                    if(psId == 0){
                        psId = 1;
                    }else{
                        NSDictionary *dict = @{@"Udiamond":nowdict[@"Udiamond"],@"ifLock":@1};
                        [self.ifLockArray replaceObjectAtIndex:i withObject:dict];
                    }
                    
                }
            }
            
            //start
#pragma mark gd_在临时ifLockArray中插入复习关  <#时间#>-<#编号#>
            if (fuxiGuanIndex != -1) {
                NSDictionary * fuxi = @{@"ifLock":@(1),@"Udiamond":@(0)};
                [self.ifLockArray insertObject:fuxi atIndex:fuxiGuanIndex];
            }
            //end
            
            //start
#pragma mark gd_上面已经计算过-减少时间  2017-03-28 15:16:52
            //                //                计算钻石数量
            //                [self calculateNumbers:arrM];
            //end
            
            //start
#pragma mark gd_修改添加关卡 view 的位置  2017-03-21 21:10:32-4
            //                [self addBarrierView];
            //end
            
            
            //                更新ABC信息 和 给关卡题目数据赋值
            [self downloadRes];
            //                [self reloadDataSource];
            [self reloadDataSourceWithOutFuxiguan];
            //                更改CollectionView两侧箭头按钮是否可交互
            [self updateButtonStatus];
            
        }
    }
    @catch (NSException *exception) {
        [Utils showAlter:@"网络连接失败！"];
        //            self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [self.navigationController popViewControllerAnimated:YES];
        });
    }
    @finally {
        [self.collectionView reloadData];
    }
    
    
    

}

- (void)reloadData{
    self.ifLockArray = nil;
    [self.listArray removeAllObjects];
    [self startRequset];

    
}

-(void)calculateNumbers:(NSArray *)arr{
    NSLog(@"----------calculateNumbers---------");
//    NSArray *arr = [response valueForKey:@"data"];
    NSInteger gotCoins= 0;
    NSInteger unLockNumber=0;
    for (int i=0; i<arr.count; i++) {
        NSNumber *isBlock =[arr[i] valueForKey:@"ifLock"];
      
        if ([isBlock isEqualToNumber:@1]) {
//            计算已通过的关卡数
            unLockNumber+=1;
        }

//        计算优钻数 -- 显示在页面左下角的数量
        NSNumber *coins = [arr[i] valueForKey:@"Udiamond"];
        gotCoins= gotCoins + [coins integerValue];
    }

    #pragma mark gd_如果最后一个解锁关卡是第五关(及倍数),这一关是复习关,解锁下一关.
    if (unLockNumber % 5 == 0) {
        unLockNumber ++;
    }

    NSString *diamondLabelText =  [NSString stringWithFormat:@"%zd/%zd",gotCoins,arr.count*3];
    diamondLabel.text = diamondLabelText;
    
    
    
    //start
#pragma mark gd_使用统一封装好的获取qs.txt的方法  2017-03-28 15:40:56-<#编号#>
//    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//    
//    
//    
//    NSString *finalPath2=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
//    
//    
//    NSString *dataStr2 = [[NSString alloc]initWithContentsOfFile:finalPath2 encoding:NSUTF8StringEncoding error:nil];
//    
//    dataStr2 = [dataStr2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    
//    dataStr2 = [dataStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    dataStr2 = [dataStr2 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//    
//    NSData *data2 = [dataStr2 dataUsingEncoding:NSUTF8StringEncoding];
//    if (!data2) {
//        return;
//    }
//    NSError *error2;
//    NSDictionary *firstDic2 =  [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&error2];
//    if (!firstDic2) {
//        NSLog(@"%@",error2);
//    }
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSDictionary *firstDic2 = [Utils getCurrentQsTxtDict];
    NSDictionary *firstDic2 = [Utils getCurrentQsTxtDictWith:_type];
    //end
    
    //end
//    qs.txt中的关卡数组
    NSArray *listArr2 = [firstDic2 valueForKey:@"datas"];
    if (listArr2.count<unLockNumber-1) {
        return;
    }
    
    NSMutableArray *numberArr = [NSMutableArray array];
    for (int i=0; i<unLockNumber-1; i++) {
        NSDictionary *dic = listArr2[i];
//        当前关卡中的题目
        NSArray *qsArr =[dic valueForKey:@"data"];
        
        for (int j=0; j<qsArr.count; j++) {
            
            NSNumber *wordID = [qsArr[j] valueForKey:@"wordId"];
            BOOL isHas = NO;
            for (int j=0; j<numberArr.count; j++) {
                if ([numberArr[j] isEqualToNumber:wordID]) {
                    isHas = YES;
                    break;
                }
            }
            if (!isHas) {
                [numberArr addObject:wordID];
            }
            
            
        }
        
    }
    
    
    NSString *ABCLabelText = [NSString stringWithFormat:@"%zd/%@",numberArr.count,[firstDic2 valueForKey:@"counts"]];
    ABCLabel.text = [Utils isValidStr:ABCLabelText]?ABCLabelText:@"0/0";
}

-(void)downloadRes{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookID]};
    NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":[AnswerTools getBookIDWith:_type]};
    //end
    
    [NetWorkingUtils postWithUrlWithoutHUD:BeforeTest params:paramsDic successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            NSDictionary *dic  =[response valueForKey:@"info"];
            if (![dic isKindOfClass:[NSNull class]]) {
                NSInteger rightNumber = [[dic valueForKey:@"rightCounts"] integerValue];
                NSInteger wrongNumber = [[dic valueForKey:@"wrongCounts"] integerValue];
                float a = rightNumber*1.00/(rightNumber+wrongNumber);
                NSInteger b = a*100;
                NSString *str = [NSString stringWithFormat:@"%ld",(long)b];
                if (rightNumber>0) {
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    [df setValue:str forKey:BEFORE_TEST];
                    scoreLabel.hidden = NO;
                    _beforeRestartTest.hidden =NO;
                    _beforeStartTest.hidden = YES;
                    scoreLabel.text = [NSString stringWithFormat:@"得分：%@",str];
                }
            }
            
        }
    } errorResult:^(NSError *error) {
        
    }];
    
   
    

}

#pragma mark 初始化 listArray
- (void)reloadDataSourceWithOutFuxiguan{
    self.realModelNum = self.listArray.count;
    //        每页显示8个关卡,如果最后一页不足8个,填充空模型 --不知道为啥要这样
    if ((self.listArray.count)%8!=0) {
        NSInteger j =((self.listArray.count)/8+1)*8-self.listArray.count;
        for (int i=0; i<j; i++) {
            PassModel *model = [[PassModel alloc]init];
            model.isNULL = YES;
            [self.listArray addObject:model];
        }
    }
#pragma mark gd_初始化全局数组,方法过关
    [PassList setList:self.listArray];
    
    //start
    //#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
    ////    _testModel = [PassModel modelWithDic:listArr[0]];
    //    PassModel * firstModel = self.listArray.firstObject;
    //
    //    _testModel = [PassModel modelWithDic:firstModel.dic];
    //
    //     [self randomTestModel];
    //end
    
    
    
    
//    
//    float pages= (self.listArray.count)/8.00;
//    int a = (int)(pages+0.5);
//    if (a!=pages) {
//        pages++;
//    }
    NSInteger a = (self.listArray.count)/8;
    
    NSInteger yu = (self.listArray.count)%8;
    if (yu > 0) {
        a++;
    }
    
    _pageControl.numberOfPages = a;
    if (a<=1) {
        _pageControl.hidden = YES;
    }

    
    [self.collectionView reloadData];
    
    //    滑动到最后一个所学关卡
    NSInteger lastPassIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"LastPassIndex"] integerValue];
    NSInteger shouldShowPage = lastPassIndex / 8;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:shouldShowPage * 8 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    
    [self updateButtonStatus];
    
    
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSDictionary *_userInfoDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"userInfo"];
//    [self addCurrentBookLabel:[_userInfoDic valueForKey:@"bookName"]];
    [self addCurrentBookLabel:[AnswerTools getBookNameWith:_type]];
    //end

}

- (void)reloadDataSource{
    NSLog(@"-------reloadDataSource----------");
    //start
#pragma mark gd_之前已经判断过是否解压了,不需要再次判断  2017-03-28 13:55:07
//    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.zip",[Utils getResFolder],[AnswerTools getBookID]];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
//    //解析qs.txt
//    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//    NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
//    if (![[NSFileManager defaultManager]fileExistsAtPath:finalPath]) {
//        [self unArchive:filePath andPassword:nil destinationPath:filePathBase];
//        
//    }
    //end
//    
    //start
//#pragma mark gd_使用封装好的  2017-03-28 13:55:26-<#编号#>
////    NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
//    NSDictionary *firstDic = [Utils getCurrentQsTxtDict];
//    //end
//    
//#pragma mark gd_修改获取资源包方式
//    
//    NSError *error;
//    if (!firstDic) {
//        NSLog(@"%@",error);
//    }
//    //        qs.txt中的全部关卡信息
//    NSArray *listArr = [firstDic valueForKey:@"datas"];
//    for (int i=0; i<listArr.count; i++) {
//        PassModel *model = [PassModel modelWithDic:listArr[i]];
//        model.passName = [NSString stringWithFormat:@"第%zd关",i + 1];
//        [self.listArray addObject:model];
//    }
    
    
#pragma mark   *************gd 添加复习关*********
    //*************gd 添加复习关*********\\
    //        本来存在的lockArray
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSString *path = [PassList getIfLockArrayPath];
    NSString *path = [PassList getIfLockArrayPathWith:_type];
    //end
    
    NSArray *lockArrayExisted = nil;
    if ([[FileManagerHelper share].fileManager fileExistsAtPath:path]) {
        lockArrayExisted = [NSArray arrayWithContentsOfFile:path];
        
        for (int i = 0; i < lockArrayExisted.count; i++) {
            NSDictionary * dict = lockArrayExisted[i];
            if ([dict[@"isFuxiguan"] integerValue] ==1) {
                
                //                    PassModel *model = [PassModel modelWithDic:listArr[i]];
                //                    [self.listArray addObject:model];
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                PassModel *model = [PassList getFuxiti];
                PassModel *model = [PassList getFuxitiWith:_type];
                //end
                
                [self.listArray insertObject:model atIndex:i];
            }
        }
    }

    //*************gd 添加复习关*********//
    
    
    
    self.realModelNum = self.listArray.count;
    //        每页显示8个关卡,如果最后一页不足8个,填充空模型 --不知道为啥要这样
    if ((self.listArray.count)%8!=0) {
        NSInteger j =((self.listArray.count)/8+1)*8-self.listArray.count;
        for (int i=0; i<j; i++) {
            PassModel *model = [[PassModel alloc]init];
            model.isNULL = YES;
            [self.listArray addObject:model];
        }
    }
#pragma mark gd_初始化全局数组,方法过关
    [PassList setList:self.listArray];
    
    //start
//#pragma mark gd_<#tips#>  <#时间#>-<#编号#>
////    _testModel = [PassModel modelWithDic:listArr[0]];
//    PassModel * firstModel = self.listArray.firstObject;
//    
//    _testModel = [PassModel modelWithDic:firstModel.dic];
//    
//     [self randomTestModel];
    //end

   
    
    
    
    float pages= (self.listArray.count)/8.00;
    int a = (int)(pages+0.5);
    if (a!=pages) {
        pages++;
    }
    _pageControl.numberOfPages = a;
    if (a<=1) {
        _pageControl.hidden = YES;
    }
    
    
    
    
    [self.collectionView reloadData];
    
//    滑动到最后一个所学关卡
    NSInteger lastPassIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"LastPassIndex"] integerValue];
    NSInteger shouldShowPage = lastPassIndex / 8;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:shouldShowPage * 8 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    
    [self updateButtonStatus];
    
    NSDictionary *_userInfoDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"userInfo"];
    [self addCurrentBookLabel:[_userInfoDic valueForKey:@"bookName"]];

}

-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}
-(NSMutableArray *)ifLockArray{
    
    if (!_ifLockArray) {
        _ifLockArray = [NSMutableArray array];
    }
    return _ifLockArray;
    
#pragma mark gd_不要了
    if (!_ifLockArray) {
        //        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *path = [PassList getIfLockArrayPath];
        NSString *path = [PassList getIfLockArrayPathWith:_type];
        //end
        
        _ifLockArray = [NSMutableArray arrayWithContentsOfFile:path];
        //        _ifLockArray = [NSMutableArray array];
        


//        if (!_ifLockArray) {
//            _ifLockArray = [NSMutableArray array];
//            
//            NSDictionary *dic = @{@"ifLock":@1,@"Udiamond":@0};
//            [_ifLockArray addObject:dic];
//            for (int i=0; i<self.listArray.count-1; i++) {
//                NSDictionary *dic = @{@"ifLock":@0,@"Udiamond":@0};
//                
//                [_ifLockArray addObject:dic];
//            }
//            [_ifLockArray writeToFile:path atomically:NO];
//        }
//        if (_ifLockArray.count!=self.realModelNum) {
//            _ifLockArray = [NSMutableArray array];
//            NSDictionary *dic = @{@"ifLock":@1,@"Udiamond":@0};
//            [_ifLockArray addObject:dic];
//            for (int i=0; i<self.realModelNum-1; i++) {
//                NSDictionary *dic = @{@"ifLock":@0,@"Udiamond":@0};
//                
//                [_ifLockArray addObject:dic];
//            }
//            [_ifLockArray writeToFile:path atomically:NO];
//        }
        
    }else{
        //        NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"],@"ifLockArray.plist"];
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        NSString *path = [PassList getIfLockArrayPath];
        NSString *path = [PassList getIfLockArrayPathWith:_type];
        //end

        
        NSMutableArray *tmpArr = [NSMutableArray arrayWithContentsOfFile:path];
        if (![_ifLockArray isEqualToArray:tmpArr]) {
            _ifLockArray = tmpArr;
        }
        if (_ifLockArray.count!=self.realModelNum) {
            _ifLockArray = [NSMutableArray array];
            NSDictionary *dic = @{@"ifLock":@1,@"Udiamond":@0};
            [_ifLockArray addObject:dic];
            for (int i=0; i<self.realModelNum-1; i++) {
                NSDictionary *dic = @{@"ifLock":@0,@"Udiamond":@0};
                
                [_ifLockArray addObject:dic];
            }
            [_ifLockArray writeToFile:path atomically:NO];
        }
    }
    return _ifLockArray;
}

#pragma mark gd_当前教材的所有题目中的 题型5 取出作为学前测试的题目(如果超过30个,随机取30个)
-(void)randomTestModel{

    //start
#pragma mark gd_统一使用封装好的获取 qs.txt 的方法   2017-03-28 15:22:20
//    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
//    NSString *finalPath2=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/qs.txt"];
//    
//#pragma mark gd_修改获取资源包方式
//    NSDictionary *firstDic2 = [Utils getDictWithPath:finalPath2];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    NSDictionary *firstDic2 = [Utils getCurrentQsTxtDict];
    NSDictionary *firstDic2 = [Utils getCurrentQsTxtDictWith:_type];
    //end
    
    //end

    
    //    gd_所有关卡
    NSArray *listArr2 = [firstDic2 valueForKey:@"datas"];
    NSMutableArray *allType5 = [NSMutableArray array];
    for (int i=0; i<listArr2.count; i++) {
        //    gd_当前关卡的所有题目
        NSArray *qsArr = [listArr2[i] valueForKey:@"data"];
        for (int j=0; j<qsArr.count; j++) {
            if ([[qsArr[j]valueForKey:@"type"]isEqualToNumber:@5]) {
                QsModel *model = [QsModel modelWithDic:qsArr[j]];
                [allType5 addObject:model];
            }
        }
    }
    if (allType5.count<=30) {
//        _testModel = [[PassModel alloc]init];
        _testModel.list = allType5;
    }else{
        NSMutableArray *selectArr = [NSMutableArray array];
        BOOL isNeed=YES;
        while (isNeed) {
            NSInteger index = arc4random()%(allType5.count-1);
            [selectArr addObject:allType5[index]];
            [allType5 removeObjectAtIndex:index];
            if (selectArr.count>=30) {
                isNeed=NO;
            }
        }
//        _testModel = [[PassModel alloc]init];
        _testModel.list = selectArr;
    }
}


#pragma mark - UI初始化
-(void)initNaviBarAndBackImg{
    
//    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    /**
     背景图
     */
    UIImageView *backgroundImgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backgroundImgV setImage:[UIImage imageNamed:@"barrier_bg"]];
    [self.view addSubview:backgroundImgV];
    /**
     返回键
     */
    UIButton *backButton=[[UIButton alloc]initWithFrame:YXFrame(44, 19, 116, 117)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    /**
     题目-闯关
     */
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21, 80, 40)];
    titleImage.center = CGPointMake(self.view.center.x, titleImage.bounds.size.height/2);
    [titleImage setImage:[UIImage imageNamed:@"barrier_bg_lexicon"]];
   // [self.view addSubview:titleImage];
    UILabel *titleLabel;
    if (is_3x) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, trans2_3x(142), trans2_3x(76))];
    }
    else{
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, trans2_2x(142), trans2_2x(76))];
    }
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.center = CGPointMake(self.view.center.x, backButton.center.y);
    titleLabel.textAlignment=1;
    titleLabel.font = [UIFont fontWithName:HYTAIJI size:40];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    

}
-(void)addBeforeLearn{
    UIImageView *preschoolBack=[[UIImageView alloc]initWithFrame:YXFrame(40, 214, 670, 166)];;
    [preschoolBack setImage:[UIImage imageNamed:@"barrier_icon_test_bg"]];
    [self.view addSubview:preschoolBack];
    
    UIImageView *preschoolTitle=[[UIImageView alloc]initWithFrame:YXFrame(193, 164, 352, 96)];;
    [preschoolTitle setImage:[UIImage imageNamed:@"barrier_icon_test"]];
    [self.view addSubview:preschoolTitle];
    
    _beforeStartTest = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(264), AutoTrans(78))];
    _beforeStartTest.center = CGPointMake(preschoolBack.center.x, preschoolBack.center.y+(AutoTrans(10)));
    [_beforeStartTest setImage:[UIImage imageNamed:@"btn_Test_start"] forState:UIControlStateNormal];
    [_beforeStartTest addTarget:self action:@selector(beforeTestBegin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beforeStartTest];
    
    scoreLabel = [[UILabel alloc]initWithFrame:preschoolTitle.bounds];
    scoreLabel.center = CGPointMake(preschoolBack.center.x, preschoolBack.center.y-(AutoTrans(20)));
    scoreLabel.textAlignment = 1;
    scoreLabel.textColor = [UIColor colorWithHexString:@"#fb9346"];
    scoreLabel.font = [UIFont systemFontOfSize:14 weight:3];
    [self.view addSubview:scoreLabel];
    _beforeRestartTest = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(222), AutoTrans(66))];
    _beforeRestartTest.center = CGPointMake(preschoolBack.center.x, preschoolBack.center.y+(AutoTrans(35)));
    [_beforeRestartTest setImage:[UIImage imageNamed:@"btn_test_reset"] forState:UIControlStateNormal];
    [_beforeRestartTest addTarget:self action:@selector(beforeTestBegin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_beforeRestartTest];

    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df valueForKey:BEFORE_TEST]) {
        scoreLabel.hidden = YES;
        _beforeStartTest.hidden = NO;
        _beforeRestartTest.hidden = YES;

    }else{
        scoreLabel.hidden = NO;
        _beforeRestartTest.hidden =NO;
        _beforeStartTest.hidden = YES;
        scoreLabel.text = [NSString stringWithFormat:@"得分：%@",[df valueForKey:BEFORE_TEST] ];

    }
  
}

#pragma mark 创建collectionView
-(void)addBarrierView{
    UIImageView *barrierBack=[[UIImageView alloc]initWithFrame:YXFrame(41, 454, 662, 524)];
    [barrierBack setImage:[UIImage imageNamed:@"barrier_icon_barrier_bg"]];
    [self.view addSubview:barrierBack];
    
    UIImageView *barrierTitle=[[UIImageView alloc]initWithFrame:YXFrame(138, 413, 476, 118)];;
    [barrierTitle setImage:[UIImage imageNamed:@"barrier_icon_barrier"]];
    [self.view addSubview:barrierTitle];
    
    _preBarrierVBtn = [[UIButton alloc]initWithFrame:YXFrame(34, 698, 50, 40)];
    [_preBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_pre"] forState:UIControlStateNormal];
    [_preBarrierVBtn addTarget:self action:@selector(lastBarrierView:) forControlEvents:UIControlEventTouchUpInside];
    _preBarrierVBtn.userInteractionEnabled = NO;
    [self.view addSubview:_preBarrierVBtn];
    
    _nextBarrierVBtn = [[UIButton alloc]initWithFrame:YXFrame(734-76, 698, 50, 40)];
    [_nextBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_next"] forState:UIControlStateNormal];
    [_nextBarrierVBtn addTarget:self action:@selector(nextBarrierView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBarrierVBtn];

    
    //start
#pragma mark gd_修改最后一页滑动不了  2017-01-20 15:40:52
    //    _collectFlowLayout = [[CustomLayout alloc]init];
    //    _collectFlowLayout.minimumLineSpacing =0;
    //    _collectFlowLayout.minimumInteritemSpacing=0;
    //    _collectFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    CGFloat itemSizeWidth = AutoTrans(144);
    //    _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth, AutoTrans(162));
    //
    //    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(AutoTrans(90), AutoTrans(539), itemSizeWidth*4, AutoTrans((162*2+30))) collectionViewLayout:_collectFlowLayout];
    
//    _collectFlowLayout = [[CustomLayout alloc]init];
    _collectFlowLayout = [[DDCollectionViewHorizontalLayout alloc]init];
    _collectFlowLayout.itemCountPerRow = 4;
    _collectFlowLayout.rowCount = 2;
    _collectFlowLayout.minimumLineSpacing =0;
    _collectFlowLayout.minimumInteritemSpacing=0;
    _collectFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemSizeWidth = AutoTrans(144.0);

    _collectFlowLayout.itemSize =CGSizeMake(itemSizeWidth, AutoTrans(162.0));
    CGRect frameCollectionView = CGRectMake(AutoTrans(90.0), AutoTrans(539.0), itemSizeWidth*4.0, AutoTrans((162.0*2+30)));
    self.collectionView = [[UICollectionView alloc]initWithFrame:frameCollectionView collectionViewLayout:_collectFlowLayout];
    //end
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[PassCell class] forCellWithReuseIdentifier:@"PassCell"];
    [self.view addSubview:_collectionView];
    
    _pageControl = [[MyPageControl alloc]init];
//    [_pageControl setPageControlStyle:PageControlStyleThumb];
//    [_pageControl setThumbImage:[UIImage imageNamed:@"barrier_icon_normal"]];
//    [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"barrier_icon_selected"]];
    _pageControl.center = CGPointMake(self.collectionView.center.x, CGRectGetMaxY(self.collectionView.frame)+10);
    _pageControl.numberOfPages = 0;
    [self.view addSubview:_pageControl];
    

}
-(void)addGoodsNumView{
    /**
     左边的钻石数量
     */
    UIImageView *barrierBack=[[UIImageView alloc]initWithFrame:YXFrame(51, 1048, 318, 70)];;
    [barrierBack setImage:[UIImage imageNamed:@"barrier_icon_score"]];
    [self.view addSubview:barrierBack];
    
    diamondLabel = [[UILabel alloc]initWithFrame:barrierBack.frame];
    diamondLabel.textAlignment =1;
    diamondLabel.font = [UIFont fontWithName:HYTAIJI size:AutoTrans(42)];
    diamondLabel.shadowColor =[UIColor colorWithHexString:@"#3a230a"];
    diamondLabel.textColor = [UIColor whiteColor];
    diamondLabel.text = @"9/75";
    [self.view addSubview:diamondLabel];
    
    UIButton *addDiamonds = [[UIButton alloc]initWithFrame:YXFrame(306, 1061, 46, 46)];
    [addDiamonds setImage:[UIImage imageNamed:@"barrier_icon_plus"] forState:UIControlStateNormal];
    [addDiamonds addTarget:self action:@selector(addDiamonds:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addDiamonds];
    
    UIImageView *diamondsImgV=[[UIImageView alloc]initWithFrame:YXFrame(19, 1025,100, 98)];;
    [diamondsImgV setImage:[UIImage imageNamed:@"barrier_icon_diamond"]];
    [self.view addSubview:diamondsImgV];
    /**
     右边的ABC数量
     */
    UIImageView *ABCBack=[[UIImageView alloc]initWithFrame:YXFrame(746-24-318, 1048, 318, 70)];;

    [ABCBack setImage:[UIImage imageNamed:@"barrier_icon_score"]];
    [self.view addSubview:ABCBack];
    
    ABCLabel = [[UILabel alloc]initWithFrame:ABCBack.frame];
    ABCLabel.textAlignment =1;
    ABCLabel.font = [UIFont fontWithName:HYTAIJI size:AutoTrans(42)];
    ABCLabel.shadowColor =[UIColor colorWithHexString:@"#3a230a"];
    ABCLabel.textColor = [UIColor whiteColor];
    ABCLabel.text = @"9/75";
    [self.view addSubview:ABCLabel];
    
    UIButton *addABC = [[UIButton alloc]initWithFrame:YXFrame(746-24-24-46, 1061, 46, 46)];
    [addABC setImage:[UIImage imageNamed:@"barrier_icon_plus"] forState:UIControlStateNormal];
    [addABC addTarget:self action:@selector(addABC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addABC];
    
    UIImageView *ABCImgV=[[UIImageView alloc]initWithFrame:YXFrame(746-24-318-30, 1025,100, 98)];;
    [ABCImgV setImage:[UIImage imageNamed:@"barrier_icon_money"]];
    [self.view addSubview:ABCImgV];


}
-(void)addCurrentBookLabel:(NSString *)title{
    _currentBook=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20, SCREEN_WIDTH, 20)];
    _currentBook.font = [UIFont systemFontOfSize:10];
    _currentBook.textAlignment =1;
    _currentBook.textColor = [UIColor whiteColor];
    _currentBook.text =[NSString stringWithFormat:@"当前教材:%@",title];
    [self.view addSubview:_currentBook];
}

#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return 100;
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PassCell" forIndexPath:indexPath];
    cell.indexPath = indexPath; 
    cell.item = self.listArray[indexPath.item];
    
    if (self.ifLockArray.count>indexPath.item) {
//        NSInteger num = [[self.ifLockArray[indexPath.item]valueForKey:@"ifLock"] integerValue];
//        NSInteger diamondNumber = [[self.ifLockArray[indexPath.item]valueForKey:@"Udiamond"] integerValue];

        cell.number = [self.ifLockArray[indexPath.item]valueForKey:@"ifLock"];
        cell.diamondNumber =[self.ifLockArray[indexPath.item]valueForKey:@"Udiamond"];
    }
    
    
    
//    cell.numberLabel.text = [NSString stringWithFormat:@"%zd",indexPath.item];
    
    return cell;
}
#pragma mark - collectionView delegate  选择关卡
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    

    if (![[self.ifLockArray[indexPath.row] valueForKey:@"ifLock"]isEqualToNumber:@1]) {
        [SVProgressHUD showErrorWithStatus:@"尚未解锁"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    

    //start
#pragma mark gd_改变获取 model 的方式,不在重新创建,因为关卡名可能不会,在给 DataSource 赋值的时候已经矫正过了,应该从DataSource中取  2017-03-22 17:46:02
//    PassCell *cell = (PassCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    PassModel *model = [PassModel modelWithDic:cell.item.dic];
        PassModel *model = self.listArray[indexPath.item];
    //end

    
    if (model.list.count > 0) {
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        BrowerWordsVC *browerVC = [[BrowerWordsVC alloc]init];
        BrowerWordsVC *browerVC = [[BrowerWordsVC alloc]initWith:_type];
        //end
        
        browerVC.item =model;

        [PassList setCurrent:indexPath.item];
        [[PassList defaultManager] setCurrentModel:model];
        
//        //start
//#pragma mark gd_修改复习关卡进入方式,因为在一开始就给复习关设置题目了  2017-01-20 20:54:10
//#warning 设置当前关卡
//        //    [PassList setCurrent:indexPath.item];
//        if ([model.passName isEqualToString:@"复习关"]) {
//            [PassList setCurrent:FuxiPassIndex];
//        }else{
//            [PassList setCurrent:indexPath.item];
//        }
//        //end
        [self.navigationController pushViewController:browerVC animated:YES];
    }
    else{
//        [self ifTapFuxiWithModel:model indexPath:indexPath];
    }

 
}

-(BOOL)prefersStatusBarHidden{
    
    return  YES;
    
}

-(void)setTestPoint:(NSString *)testPoint{
    _testPoint = testPoint;
    scoreLabel.hidden = NO;
    _beforeRestartTest.hidden =NO;
    _beforeStartTest.hidden = YES;
    scoreLabel.text = [NSString stringWithFormat:@"得分：%@",testPoint];

}
#pragma mark --- ChooseResProtocal
-(void)didChooseComplete{
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//     NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.zip",[Utils getResFolder],[AnswerTools getBookID]];
     NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[AnswerTools getBookIDWith:_type],ArchiveType];
    //end

   
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"使用此功能需先选择教材，您是否进入我的选择教材？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }else{
        [self startRequset];
    }
}
#pragma mark---提示框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex==1) {
        
        ChooseResVC *chooseVC = [[ChooseResVC alloc]init];
        chooseVC.delegate = self;
        [self presentViewController:chooseVC animated:YES completion:^{
            
        }];
    }
}
#pragma mark - 点击事件 学前测试
-(void)beforeTestBegin:(UIButton*)button{
    
    __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PassModel * firstModel = self.listArray.firstObject;
    _testModel = [PassModel modelWithDic:firstModel.dic];
    
    NSMutableArray *allType5 = [NSMutableArray array];
    for (int i=0; i<self.listArray.count; i++) {
        //    gd_当前关卡的所有题目
//        NSArray *qsArr = [listArr2[i] valueForKey:@"data"];
        PassModel * model = self.listArray[i];
        for (int j=0; j<model.list.count; j++) {
            QsModel * qmodel = model.list[j];
            if ([qmodel.qType  isEqualToNumber:@5]) {
//                QsModel *model = [QsModel modelWithDic:qmodel.dic];
                [allType5 addObject:qmodel];
            }
        }
    }
    if (allType5.count<=30) {
        //        _testModel = [[PassModel alloc]init];
        _testModel.list = allType5;
    }else{
        NSMutableArray *selectArr = [NSMutableArray array];
        BOOL isNeed=YES;
        while (isNeed) {
            NSInteger index = arc4random()%(allType5.count-1);
            [selectArr addObject:allType5[index]];
            [allType5 removeObjectAtIndex:index];
            if (selectArr.count>=30) {
                isNeed=NO;
            }
        }
        //        _testModel = [[PassModel alloc]init];
        _testModel.list = selectArr;
    }

    
    
    
    [hud hide:YES afterDelay:0.5];
    hud.completionBlock = ^{};
    
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//    BeforeLearnVC*browerVC = [[BeforeLearnVC alloc]init];
    BeforeLearnVC*browerVC = [[BeforeLearnVC alloc]initWith:_type];
    //end
    
    browerVC.item =_testModel;
    [self.navigationController pushViewController:browerVC animated:YES];
}
-(void)addDiamonds:(UIButton *)button{
    
}
-(void)addABC:(UIButton *)button{
    
}
-(void)lastBarrierView:(UIButton *)button{
    button.userInteractionEnabled = NO;

    self.pageControl.currentPage -=1;
    [self.collectionView setContentOffset:CGPointMake(self.pageControl.currentPage*self.collectionView.bounds.size.width, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
        [self updateButtonStatus];

    });

}
-(void)nextBarrierView:(UIButton *)button{
    button.userInteractionEnabled = NO;
    self.pageControl.currentPage +=1;
    [self.collectionView setContentOffset:CGPointMake(self.pageControl.currentPage*self.collectionView.bounds.size.width, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
        [self updateButtonStatus];

    });
}
-(void)updateButtonStatus{
    NSLog(@"-------updateButtonStatus----------");
    if (_pageControl.numberOfPages<=1) {
        //两个不可交互
        [_preBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_pre"] forState:UIControlStateNormal];
        [_nextBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_pre_noamal"] forState:UIControlStateNormal];
        _preBarrierVBtn.userInteractionEnabled = NO;
        _nextBarrierVBtn.userInteractionEnabled = NO;
    }else {
        if (_pageControl.currentPage<=0) {
            //左边不可以 右边可以
            [_preBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_pre"] forState:UIControlStateNormal];
            [_nextBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_next"] forState:UIControlStateNormal];
            
            _preBarrierVBtn.userInteractionEnabled = NO;
            _nextBarrierVBtn.userInteractionEnabled = YES;
        }
        else if (_pageControl.currentPage>=_pageControl.numberOfPages-1) {
            //左边可以 右边不可以
            [_preBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_next_light"] forState:UIControlStateNormal];
            [_nextBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_pre_noamal"] forState:UIControlStateNormal];
            
            _preBarrierVBtn.userInteractionEnabled = YES;
            _nextBarrierVBtn.userInteractionEnabled = NO;
        }else{
            //左边可以 右边可以
            [_preBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_next_light"] forState:UIControlStateNormal];
            [_nextBarrierVBtn setImage:[UIImage imageNamed:@"barrier_icon_next"] forState:UIControlStateNormal];
            
            _preBarrierVBtn.userInteractionEnabled = YES;
            _nextBarrierVBtn.userInteractionEnabled =YES;
        }
    }
}
#pragma mark - 界面跳转
-(void)naviPop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scroll代理

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    _pageControl.currentPage = scrollView.contentOffset.x/320;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_pageControl.currentPage!=page) {
        _pageControl.currentPage = page;
        [self updateButtonStatus];

    }
}



#pragma mark - 解压缩
- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"US Presidents://"]]) {
            NSLog(@"US Presidents app is installed.");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"US Presidents://"]];
        }
        
        for (NSString *filename in filePaths) {
//            NSLog(@"File: %@", filename);
        }
    };
    unarchive.failureBlock = ^(){
        //        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
}


#pragma mark gd_点击的关卡是复习关卡
- (void)ifTapFuxiWithModel:(PassModel *)model indexPath:(NSIndexPath *)indexPath{

    __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";



    [NetWorkingUtils postWithUrlWithoutHUD:gdReviewListUrl params:@{@"token":[Utils getCurrentToken],@"passId":model.passID} successResult:^(NSDictionary * response) {
        NSLog(@"response = %@",response);


        if ([response[@"status"] integerValue] == 1) {
            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            NSDictionary * dictQstxt = [Utils getCurrentQsTxtDict];
//            NSMutableDictionary * dictAllQs = [NSMutableDictionary dictionaryWithDictionary:[Utils getTxtTimuDict]];
            NSDictionary * dictQstxt = [Utils getCurrentQsTxtDictWith:_type];
            NSMutableDictionary * dictAllQs = [NSMutableDictionary dictionaryWithDictionary:[Utils getTxtTimuDictWith:_type]];
            //end
            
            

            
            /*
             {
             @"关卡id":{
             @"题目id":@"题目",
             @"题目id":@"题目",....},
             @"关卡id":{@"题目id":@"题目",@"题目id":@"题目"},.....

             }

             */

            if (dictAllQs.allKeys.count == 0) {
                NSArray * txtArray = dictQstxt[@"datas"];
                dictAllQs = [NSMutableDictionary dictionary];

                for (NSDictionary * passModel in txtArray) {
                    //         passModel   当前关卡所有题目
                    NSMutableDictionary * dictQses = [NSMutableDictionary dictionary];
                    for (NSDictionary * qsModel in passModel[@"data"]) {
                        NSString * key = [NSString stringWithFormat:@"%@",qsModel[@"qId"]];
                        dictQses[key] = qsModel;
                    }
                    NSString * key = [NSString stringWithFormat:@"%@",passModel[@"passId"]];
                    dictAllQs[key] = dictQses;

                }

                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                [Utils creatTxtTimuDictWith:dictAllQs];
                [Utils creatTxtTimuDictWith:dictAllQs With:_type];
                //end
                
            }

            NSMutableArray * arrayFuxi = [NSMutableArray array];

            for (NSDictionary * dict  in response[@"data"]) {



                NSString * keyPassId = [NSString stringWithFormat:@"%@",dict[@"passId"]];
                NSString * keyQsId = [NSString stringWithFormat:@"%@",dict[@"qId"]];
                NSDictionary * dcitQs = dictAllQs[keyPassId][keyQsId];
                
                if (dcitQs) {
                    QsModel * qsmodel = [QsModel modelWithDic:dcitQs];
                    [arrayFuxi addObject:qsmodel];
                }

            }
            //        @property (nonatomic,retain) NSNumber *qID;
            //        @property (nonatomic,retain) NSNumber *qType;
            //        @property (nonatomic,copy) NSString *qWord;
            //        @property (nonatomic,retain) NSNumber *qWordID;
            

            
            
            model.list = arrayFuxi;
            hud.labelText = @"";
            [hud hide:YES afterDelay:0.5];
            hud.completionBlock = ^{
                [PassList setList:self.listArray];
                [PassList setCurrent:indexPath.item];
//                BrowerWordsVC *browerVC = [[BrowerWordsVC alloc]init];
//                browerVC.item =model;
//
//                [self.navigationController pushViewController:browerVC animated:YES];



                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                //        BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]init];
                BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]initWith:_type];
                //end
                detailVC.item = model;
                detailVC.wordList = [self getBrowerWordsListWithModel:model];
                [self.navigationController pushViewController:detailVC animated:YES];
            };

        }else{
            hud.labelText = @"获取复习关卡信息失败";
            [hud hide:YES afterDelay:0.5];
            hud.completionBlock = ^{};
        }




    } errorResult:^(NSError *error) {

        hud.labelText = @"获取复习关卡信息失败";
        [hud hide:YES afterDelay:0.5];
        hud.completionBlock = ^{};
    }];

}


#pragma mark gd_这个方法是从BrowerWordsVC 中的 setItem 方法改的,用来获取list
-(NSArray *)getBrowerWordsListWithModel:(PassModel *)item{

    NSMutableArray * list = [NSMutableArray array];
    for (int i=0;i<item.list.count; i++) {
        //        if (_item.list[i].qExplain) {
        BOOL flag=NO;
        for (int j=0; j<list.count; j++) {
            if ([[list[j] qWord]isEqualToString:item.list[i].qWord]) {
                flag = YES;
                break;
            }else{
            }
        }
        if (!flag) {
            QsModel * model = item.list[i];
            if (!model.qExplain) {
                //                NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                //                //解压
                //
                //                NSArray *pathArr =[[NSFileManager defaultManager]contentsOfDirectoryAtPath:[filePathBase stringByAppendingPathComponent:@"7z"] error:nil];
                //                NSString *unarchiveBase = [pathArr objectAtIndex:0];

                //解析wordInfos.txt
                //                NSString *wordPath = [unarchiveBase stringByAppendingPathComponent:@"txt/wordInfos.json"];
                //                NSString *finalPath=[NSString stringWithFormat:@"%@/%@",[filePathBase stringByAppendingPathComponent:@"7z"],wordPath];
                NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
                NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//                NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
                NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:_type],@"txt/wordInfos.json"];
                //end
                

#pragma mark gd_修改获取资源包方式
                NSDictionary *firstDic = [Utils getDictWithPath:finalPath];
                NSError *error;
//                NSString *dataStr = [[NSString alloc]initWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
//                NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//
//                NSError *error;
//                NSDictionary *firstDic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (!firstDic) {
                    NSLog(@"%@",error);
                }
                NSArray *tempArr=[firstDic valueForKey:@"data"];
                for (int i=0; i<tempArr.count; i++) {

                    if ( [[tempArr[i] valueForKey:@"wordId"] integerValue]==[model.qWordID integerValue]) {

                        NSDictionary * infoDic =tempArr[i];
                        model.qExplain = [infoDic valueForKey:@"explain"];

                        break;
                    }

                }


//                    passId = 3;
//                    qId = 88;
            }
            [list addObject:model];

        }
    }
    return list;
}



@end
