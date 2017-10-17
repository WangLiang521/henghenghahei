//
//  ChooseResVC.m
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseResVC.h"
#import "ChooseResCell.h"
#import "SARUnArchiveANY.h"
#import "NetworkHelper.h"
#import "GDSessionManager.h"
@interface ChooseResVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UIView *littleWhiteV;
    UIButton *word;
    UIButton *grammar;
    UIButton *course;
    UILabel *orangeLabel;
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)NSMutableArray *wordList;
@property (nonatomic,retain)NSMutableArray *grammarList;
@property (nonatomic,retain)NSMutableArray *courseList;
@property (nonatomic,copy)NSString *bookUrl;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)NSInteger selectRow;
@property (nonatomic,assign)BOOL needDownload;

@property (strong, nonatomic)  NSURLSessionDataTask  *task;
@property (assign, nonatomic)  BOOL shouldNotShowError;


@property (strong, nonatomic)  GDSessionManager * manager;



@end

@implementation ChooseResVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
-(NSMutableArray *)grammarList{
    if (!_grammarList) {
        _grammarList = [NSMutableArray array];
    }
    return _grammarList;
}
-(NSMutableArray *)courseList{
    if (!_courseList) {
        _courseList = [NSMutableArray array];
    }
    return _courseList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    [self initNavi];
    [self addResCategory];
    [self addTableView];
    [self requestBooks];
}

- (void)requestBooks{
    [NetWorkingUtils postWithUrl:BookListUrl params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
        if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
            [self.list removeAllObjects];
            self.wordList = [NSMutableArray array];
            self.grammarList = [NSMutableArray array];
            self.courseList = [NSMutableArray array];
            NSArray *arr = [response valueForKey:@"data"];
            
            

            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:KeyBookInfoList];
            
            for ( int i=0; i<arr.count; i++) {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary: arr[i]];
                

                
                //start
#pragma mark gd_修改当前选择的 Book 的方式  <#时间#>-<#编号#>
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                //                NSInteger currentBookId = [[AnswerTools getBookID] integerValue];
                NSInteger currentWordsBookId = [[AnswerTools getBookIDWith:BreakthroughTypeWord] integerValue];
                
                NSInteger currentCourseBookId = [[AnswerTools getBookIDWith:BreakthroughTypeCourse] integerValue];
                //end
                
                
                if (([[dic valueForKey:@"bookId"] integerValue] - currentWordsBookId == 0) || ([[dic valueForKey:@"bookId"] integerValue] - currentCourseBookId == 0)) {
//                    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],[dic valueForKey:@"bookId"],ArchiveType];
//                    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
//                    NSFileManager *fm = [NSFileManager defaultManager];
//                    if ( [fm fileExistsAtPath:filePathBase]) {
                        [dic setValue:@1 forKey:@"isUsed"];
//                    }else{
//                        [dic setValue:@0 forKey:@"isUsed"];
//                    }
                    
                    [AnswerTools setBookName:dic[@"name"] With:[dic[@"bookStyle"] integerValue]];
                }else{
                    [dic setValue:@0 forKey:@"isUsed"];
                }
                
                
                
                if (!dic[@"bookUrl"]) {
                    dic[@"bookUrl"] = [NSString stringWithFormat:@"http://word.jinyouapp.com/youcan/resources/book/%@.%@",dic[@"bookId"],ArchiveType];
                }
                
                NSString * fileName = [NSString stringWithFormat:@"%@.%@",dic[@"bookId"],ArchiveType];
                dic[@"fileName"] = fileName;
                
                
                dic[@"status"] = [[GDSessionManager share] getDownStatusWith:dic[@"bookId"] url:dic[@"bookUrl"] fileName:fileName fileType:@""];
                
                //                if ([[dic valueForKey:@"isUsed"]isEqualToNumber:@1]) {
                //                    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.zip",[Utils getResFolder],[dic valueForKey:@"bookId"]];
                //                    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
                //                    NSFileManager *fm = [NSFileManager defaultManager];
                //                    if ( [fm fileExistsAtPath:filePathBase]) {
                //                    }else{
                //                        [dic setValue:@0 forKey:@"isUsed"];
                //                    }
                //                }
                //end
                ChooseResModel *model = [ChooseResModel chooseResModelWithDic:dic];
                switch ([model.bookStyle integerValue]) {
                    case 1:
                        //                        词汇
                        [self.wordList addObject:model];
                        break;
                    case 2:
                        //                        语法
                        [self.grammarList addObject:model];
                        break;
                    case 3:
                        //                        课程
                        [self.courseList addObject:model];
                        break;
                        
                    default:
                        break;
                }
                
                
                //                [self.list addObject:model];
            }
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:[response valueForKey:@"error"]];
        }
        
        switch (self.index) {
            case 0:
                self.list = [NSMutableArray arrayWithArray:self.wordList];
                break;
                
            case 1:
                self.list = [NSMutableArray arrayWithArray:self.grammarList];
                break;
                
            case 2:
                self.list = [NSMutableArray arrayWithArray:self.courseList];
                break;
                
            default:
                break;
        }
        
        
        [_tableView reloadData];
        
    } errorResult:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)initNavi{
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImg setImage:[UIImage imageNamed:@"barrier_bg@2x (2)"]];
    backImg.userInteractionEnabled = YES;
    
    [self.view addSubview:backImg];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment =1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:AutoTrans(38)];
    titleLabel.text = @"选择教材";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset((AutoTrans(30))+20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(AutoTrans(38)));
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 120, 60)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
    
    //    UIButton *backButton2 = [[UIButton alloc]initWithFrame:CGRectMake(15, 67, 100, 40)];
    //
    //    [backButton2 addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.view addSubview:backButton2];
    
}
-(void)addResCategory{
    littleWhiteV = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(30), AutoTrans(140), SCREEN_WIDTH-(AutoTrans(30))*2, AutoTrans(80))];
    littleWhiteV.tag = 0x1234;
    littleWhiteV.layer.masksToBounds = YES;
    littleWhiteV.layer.cornerRadius = AutoTrans(30);
    littleWhiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:littleWhiteV];
    
    
    
    word = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), 0, AutoTrans(120), AutoTrans(80))];
    word.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    [word setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [word setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [word setTitle:@"词汇" forState:UIControlStateNormal];
    [word addTarget:self action:@selector(wordOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [littleWhiteV addSubview:word];
    
    grammar = [[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(80), 0, AutoTrans(120), AutoTrans(80))];
    grammar.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    grammar.center =CGPointMake(littleWhiteV.frame.size.width/2, AutoTrans(40));
    [grammar setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [grammar setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [grammar setTitle:@"语法" forState:UIControlStateNormal];
    [grammar addTarget:self action:@selector(grammarOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleWhiteV addSubview:grammar];
    
    course = [[UIButton alloc]initWithFrame:CGRectMake(littleWhiteV.frame.size.width-(AutoTrans(80))-(AutoTrans(120)), 0, AutoTrans(120), AutoTrans(80))];
    course.titleLabel.font =[UIFont systemFontOfSize:AutoTrans(30)];
    [course setTitleColor:[UIColor colorWithHexString:@"#ffa200"] forState:UIControlStateSelected];
    [course setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [course setTitle:@"同步" forState:UIControlStateNormal];
    [course addTarget:self action:@selector(courseOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleWhiteV addSubview:course];
    
    orangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(120), AutoTrans(5))];
    orangeLabel.center = CGPointMake(word.center.x, littleWhiteV.frame.size.height-(AutoTrans(5))/2);
    orangeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffa200"];
    [littleWhiteV addSubview:orangeLabel];
}
-(void)addTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(littleWhiteV.frame)+(AutoTrans(20)), CGRectGetWidth(littleWhiteV.frame), SCREEN_HEIGHT-CGRectGetMaxY(littleWhiteV.frame)-(AutoTrans(50))-(AutoTrans(20)))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = AutoTrans(153);
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = AutoTrans(40);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID2 = @"cell2";
    ChooseResCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (!cell) {
        cell = [[ChooseResCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChooseResModel * model = self.list[indexPath.row];
    cell.item = model;
    
    
    cell.tapFileBlock = ^(NSString * statusName){
        
        _manager = [GDSessionManager share];
        
        
//        1.下载了压缩包,但是没有解压
        if ([statusName containsString:@"解压"]) {
            NSNumber * bookId = [self.list[self.selectRow]valueForKey:@"bookID"];
            NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],bookId,ArchiveType];
            NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
            NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
            NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
            
            
            
            //        1.解压
            
            
            
#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
            [Utils unArchive:filePathBase andPassword:nil destinationPath:filePathDest completionBlock:^{
                
            } failureBlock:^{
                
            }];
            
            NSString *strFile = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],bookId];
            NSString *filePathBaseFile = [NSHomeDirectory() stringByAppendingPathComponent:strFile];
            
            if ( [[NSFileManager defaultManager] fileExistsAtPath:filePathBaseFile]) {
                NSString * progress = @"可用";
                [[NSNotificationCenter  defaultCenter] postNotificationName:model.fileName object:nil userInfo:@{@"text":progress}];
                 model.status = progress;
                [MBProgressHUD showSuccess:@"解压成功"];
                
            }else{
                [MBProgressHUD showSuccess:@"解压失败"];
                
                NSString * progress = @"解压失败";
                [[NSNotificationCenter  defaultCenter] postNotificationName:model.fileName object:nil userInfo:@{@"text":progress}];
            }
        }else if ([statusName containsString:@"正在下载"]){
//            2.正在下载 停止当前并开始下一个
//            NSString * progress = @"下载";
//            [[NSNotificationCenter  defaultCenter] postNotificationName:model.fileName object:nil userInfo:@{@"text":progress}];
//            model.status = progress;
            
            [_manager stopDownWithUrl:model.bookUrl];
            
            
            
        }else if ([statusName containsString:@"等待下载"]){
            
//            3.在下载队列中,从下载队列中移除
            NSString * progress = @"下载";
            [[NSNotificationCenter  defaultCenter] postNotificationName:model.fileName object:nil userInfo:@{@"text":progress}];
            model.status = progress;
            
            [_manager stopDownWithUrl:model.bookUrl];
        }else if ([statusName isEqualToString:@"下载"] || [statusName containsString:@"暂停"]){
//            4.没有下载,也没有等待下载,如果当前有 url 正在下载,则添加到下载队列,否则直接开始下载
            
            if (![[self.list[indexPath.row] valueForKey:@"isLocked"]isEqualToNumber:@0]) {

                [self checkWifiToDownload:model];
            }else{
                [self changeBook:indexPath];
            }

            
        }else if ([statusName containsString:@"解压失败"]){
            //            4.没有下载,也没有等待下载,如果当前有 url 正在下载,则添加到下载队列,否则直接开始下载
            
//            [self checkWifiToDownload:model];
            
            [MBProgressHUD showError:@"请左滑删除后,重新下载"];
            
        }
    };
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.index) {
        case 0:
        {
            return self.list.count;
            break;
        }
        case 1:
        {
            return self.grammarList.count;
            break;
        }
        case 2:
        {
            return self.courseList.count;
            break;
        }
            
        default:
            return self.list.count;
            break;
            
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
#pragma mark 删除
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

//    非 FRC 模式下删除单元格的方法
    //删除 cell
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ChooseResModel * model  = self.list[indexPath.row];
        _manager = [GDSessionManager share];
        [_manager deleteFileWithUrl:model.bookUrl FileName:model.fileName ChaosFileType:@"" bookId:model.bookID];
        
        
        model.status = [[GDSessionManager share] getDownStatusWith:model.bookID url:model.bookUrl fileName:model.fileName fileType:@""];
        [self.tableView reloadData];
    }
    
    
    
}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮（或者添加按钮，或者没有按钮），这个方法就是修改这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleInsert;    //插入
        return UITableViewCellEditingStyleDelete;   //删除
    //    return UITableViewCellEditingStyleNone;     //无
}





#pragma mark---提示框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }
    if (buttonIndex==1) {
        
        
        
        
        NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"bookId":[self.list[self.selectRow]valueForKey:@"bookID"]};
        
        [NetWorkingUtils postWithUrl:ChooseBook params:paramsDic successResult:^(id response) {
            if ([[response valueForKey:@"status"]isEqualToNumber:@1]) {
                
                ChooseResModel * model = self.list[self.selectRow];
                [CommonShare share].currentBookName = model.title;
                
                //                 [AnswerTools setBookID:model.bookID];
                
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                //                [NetWorkingUtils requestNoteBook];
                switch (self.index) {
                    case 0:
                        [NetWorkingUtils requestNoteBookWith:BreakthroughTypeWord];
                        break;
                    case 1:
                        
                        break;
                    case 2:
                        [NetWorkingUtils requestNoteBookWith:BreakthroughTypeCourse];
                        break;
                        
                    default:
                        break;
                }
                //end
                
                
                
                
                //start
#pragma mark gd_不再使用newBookId  2017-04-27 11:13:53
                //保存当前bookid
                //                [[NSUserDefaults standardUserDefaults]setObject:[self.list[self.selectRow]valueForKey:@"bookID" ] forKey:@"newBookId"];
                //end
                
                
                
                NSFileManager *fm = [NSFileManager defaultManager];
                if ( 1) {
                    //if have to download
                    
                    
                    
                    NSNumber *bookid = [self.list[self.selectRow]valueForKey:@"bookID" ];
                    
                    switch (self.index) {
                        case 0:
                            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                            //                            [AnswerTools setBookID:bookid];
                            [AnswerTools setBookID:bookid With:BreakthroughTypeWord];
                            [AnswerTools setBookName:[self.list[self.selectRow]valueForKey:@"title" ] With:BreakthroughTypeWord];
                            //end
                            
                            break;
                            
                        case 1:
                            
                            break;
                            
                        case 2:
                            //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
                            //                            [AnswerTools setCourseBookID:bookid];
                            [AnswerTools setBookID:bookid With:BreakthroughTypeCourse];
                            [AnswerTools setBookName:[self.list[self.selectRow]valueForKey:@"title" ] With:BreakthroughTypeCourse];
                            //end
                            
                            break;
                        default:
                            break;
                    }
                    
                    
                    
                    
                    for (int i=0; i<self.list.count; i++) {
                        ( (ChooseResModel*)self.list[i]).isUsed = @0;
                        
                        if (i==self.selectRow) {
                            ( (ChooseResModel*)self.list[i]).isUsed = @1;
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                    
                }

            }
            else{
                [Utils showAlter:response[@"error"]];
//                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"优钻不足" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction * action =[UIAlertAction actionWithTitle:@"购买优钻" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                [alertVC addAction:action];
//                [alertVC addAction:cancelAction];
                
            }
        } errorResult:^(NSError *error) {
            [Utils showAlter:@"网络连接失败！"];
            
        }];
        
        
        
    }
}

- (void)checkWifiToDownload:(ChooseResModel *)model{
    


    WS(weakSelf);
    if ([NetworkHelper share].currentNetWorkStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您现在使用的是流量,继续下载吗?" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction * actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {



            [weakSelf downResWithRes:model];



        }];

        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];

        [alert addAction:actionSure];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self downResWithRes:model];
    }
}

- (void)downResWithRes:(ChooseResModel * )model{
    
    self.bookUrl = [NSString stringWithFormat:@"http://%@.%@",model.bookUrl,ArchiveType];
    
    
    NSString *Dir = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]]];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:Dir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
//#pragma mark 下载进度
//    
//    
//    
//    __block MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //    __block MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
//    
//    //    [self.view addSubview:HUD];
//    
//    HUD.dimBackground = YES;
//    HUD.mode=MBProgressHUDModeDeterminate;
//    
    
//    
//#pragma mark 取消下载按钮
//    __block UIButton * btnCancelDownload = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btnCancelDownload setTitle:@"取消" forState:UIControlStateNormal];
//    [btnCancelDownload setTintColor:[UIColor whiteColor]];
//    [self.view addSubview:btnCancelDownload];
//    
//    btnCancelDownload.frame = CGRectMake(SCREEN_WIDTH  - 120, SCREEN_HEIGHT - 70, 100, 30);
//    //                    btnCancelDownload.backgroundColor =
//    [btnCancelDownload addTarget:self action:@selector(cancelDownload:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSNumber * bookId = [self.list[self.selectRow]valueForKey:@"bookID"];
    NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],model.bookID,ArchiveType];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
//    NSString *strDest = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
//    NSString *filePathDest = [NSHomeDirectory() stringByAppendingPathComponent:strDest];
    
//    _manager  = [[GDSessionManager alloc] initWithUrl:self.bookUrl FileName:[NSString stringWithFormat:@"%@.zip",bookId] ChaosFileType:@"" successPath:filePathBase];
    _manager = [GDSessionManager share];
    [_manager addToDownloadQueueWithUrl:model.bookUrl FileName:[NSString stringWithFormat:@"%@.%@",model.bookID,ArchiveType] ChaosFileType:@"" successPath:filePathBase];
    
//    [_manager downResWithBookUrl:_bookUrl bookId:bookId];
    return;
//    [_manager startWithProgressblock:^(long long totalLength, long long downloadLength) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            HUD.progress = 1.0 * downloadLength / totalLength;
//            //                            NSLog(@"%f",[response fractionCompleted]);
//            NSString *str = [NSString stringWithFormat:@"%@/%@",[CountBytes countBytesBy:downloadLength],[CountBytes countBytesBy:totalLength]];
//            HUD.labelText = str;
//        });
//    } CompletionBlock:^{
//        NSLog(@"CompletionBlock");
//        //        return ;
//        NSLog(@"filePathBase = %@",filePathBase);
//        
//        btnCancelDownload.hidden = YES;
//        //                                [HUD hide:YES];
//        
//        
//        //        [HUD hide:YES afterDelay:0];
//        
//        
//        //        [(NSData*)response writeToFile:filePath atomically:NO];
//        
//        
//        //解压
//        //        HUD.mode = MBProgressHUDModeText;
//        
//        
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //
//        //        });
//        //                        NSString *str2 = [NSString stringWithFormat:@"Documents/%@/%@",[Utils getResFolder],[AnswerTools getBookID]];
//        //                        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str2];
//        
//        //        __block MBProgressHUD * hudss = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //
//        dispatch_main_async_safe(^{
//            HUD.progress = 1.0;
//            HUD.labelText = @"解压中...";
//            [HUD hide:YES afterDelay:2.0];
//            HUD.completionBlock = ^{
//                //                NSNumber *bookid = [self.list[self.selectRow]valueForKey:@"bookID" ];
//                //                [AnswerTools setBookID:bookid];
//                
//                //start
//                //#pragma mark gd_修改设置当前 bookId 的方式  2017-04-27 12:01:02
//                NSNumber *bookid = [self.list[self.selectRow]valueForKey:@"bookID" ];
//                
//                switch (self.index) {
//                    case 0:
//                        //start
//                        //#pragma mark gd_修改 type  2017-05-02 21:58:41
//                        //                        [AnswerTools setBookID:bookid];
//                        [AnswerTools setBookID:bookid With:BreakthroughTypeWord];
//                        //end
//                        
//                        break;
//                        
//                    case 1:
//                        
//                        break;
//                        
//                    case 2:
//                        //start
//                        //#pragma mark gd_修改 type  2017-05-02 21:58:41
//                        //                        [AnswerTools setCourseBookID:bookid];
//                        [AnswerTools setBookID:bookid With:BreakthroughTypeCourse];
//                        //end
//                        
//                        break;
//                    default:
//                        break;
//                }
//                
//                //end
//                
//                //start
//                //#pragma mark gd_修改下载教材后不自动切换教材的 bug  <#时间#>-<#编号#>
//                //                                [self naviPop:nil];
//                //                [self change];
//                //end
//            };
//        });
//        
//        
//        ChooseResModel * model = self.list[self.selectRow];
//        [CommonShare share].currentBookName = model.title;
//        //        [AnswerTools setBookID:model.bookID];
//        
//        
//        
//#pragma mark gd_修改不解压  直接改了 Utils中的 unArchive 方法,添加了 completionBlock failureBlock
//        [Utils unArchive:filePathBase andPassword:nil destinationPath:filePathDest completionBlock:^{
//            
//        } failureBlock:^{
//            
//        }];
//        
//        
//        for (int i=0; i<self.list.count; i++) {
//            ( (ChooseResModel*)self.list[i]).isUsed = @0;
//            
//            if (i==self.selectRow) {
//                ( (ChooseResModel*)self.list[i]).isUsed = @1;
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView reloadData];
//        });
//        
//    } failBlock:^(NSError *error) {
//        NSLog(@"failBlock");
//        
//        dispatch_main_async_safe(^{
//            btnCancelDownload.hidden = YES;
//            [HUD hide:YES];
//            if (error.code == -1000 && !_shouldNotShowError) {
//                //            [Utils showAlter:@"已取消"];
//                [SVProgressHUD showInfoWithStatus:@"已取消"];
//            }else if (!_shouldNotShowError) {
//                [SVProgressHUD showInfoWithStatus:@"网络连接失败！"];
//                //            [Utils showAlter:@"网络连接失败！"];
//            }
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//        });
//    }];
//    
//    _shouldNotShowError = NO;
    
    
}

#pragma mark 点击了取消下载
- (void)cancelDownload:(UIButton *)sender{
    
    dispatch_main_async_safe(^{
        [_manager stop];
        _shouldNotShowError = YES;
    });
    
    
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self changeBook:indexPath];
}

/**
 *  返回是否需要解锁 YES, 需要
 */
- (BOOL)changeBook:(NSIndexPath *)indexPath{
    BOOL needUzuan = YES;
    if (self.index==0 || self.index == 2) {
        ChooseResCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.item.isUsed isEqualToNumber:@1]) {
            return  NO;
        }
        self.selectRow = indexPath.row;
        
        NSString *alertStr = [NSString stringWithFormat:@"解锁此教材需要花费%@优钻。确定解锁并切换教材？",[self.list[indexPath.row] valueForKey:@"coins"]];
        
        
        
        NSNumber *bookid = [self.list[self.selectRow]valueForKey:@"bookID" ];
        
        NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",[Utils getResFolder],bookid,ArchiveType];
        NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ( [fm fileExistsAtPath:filePathBase]) {
            _needDownload = NO;
        }else{
            _needDownload = YES;
        }
        if (![[self.list[indexPath.row] valueForKey:@"isLocked"]isEqualToNumber:@0]) {
            //            if (_needDownload) {
            //                alertStr = @"是否切换并下载教材？";
            //
            //            }else{
            alertStr = @"是否切换教材？";
            //
            //            }
            needUzuan = NO;
        }
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
        
        
        
    }
    return needUzuan;
}

-(void)calculateWordsAccount{
    //解析qs.txt
    NSString *str1 = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *filePathBase = [NSHomeDirectory() stringByAppendingPathComponent:str1];
    //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
    //     NSString *finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookID],@"txt/wordInfos.json"];
    NSString *finalPath = nil;
    switch (self.index) {
        case 0:
            finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:BreakthroughTypeWord],@"txt/wordInfos.json"];
            break;
            
        case 1:
            
            break;
            
        case 2:
            finalPath=[NSString stringWithFormat:@"%@/%@/%@",filePathBase,[AnswerTools getBookIDWith:BreakthroughTypeCourse],@"txt/wordInfos.json"];
            break;
            
        default:
            break;
    }
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
    NSArray *listArr = [firstDic valueForKey:@"data"];
    //    NSMutableArray *numberArr = [NSMutableArray array];
    //    for (int i=1; i<listArr.count; i++) {
    //        NSDictionary *dic = listArr[i];
    //        NSNumber *wordID = [dic valueForKey:@"wordId"];
    //        BOOL isHas = NO;
    //        for (int j=0; j<numberArr.count; j++) {
    //            if ([numberArr[j] isEqualToNumber:wordID]) {
    //                isHas = YES;
    //                break;
    //            }
    //        }
    //        if (!isHas) {
    //            [numberArr addObject:wordID];
    //        }
    //    }
    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getCurrentUserName]];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],@"allWords.plist"];
    [listArr writeToFile:path atomically:NO];
    
    
}
-(void)naviPop:(UITapGestureRecognizer *)tap{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(didChooseComplete)]) {
                [self.delegate didChooseComplete];
            }
            
        }];
    }
}
#pragma mark - 解压缩
- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    
    NSLog(@"unArchive  --  解压缩");
    NSLog(@"filePath = %@",filePath);
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil){
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 点击词汇
-(void)wordOnClick:(UIButton *)button{
    self.index = 0;
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    grammar.selected = NO;
    course.selected = NO;
    self.list = [NSMutableArray arrayWithArray:self.wordList];
    [_tableView reloadData];
    
}

#pragma mark 点击语法
-(void)grammarOnClick:(UIButton *)button{
    self.index = 1;
    
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    word.selected = NO;
    course.selected = NO;
    self.list = [NSMutableArray arrayWithArray:self.grammarList];
    [_tableView reloadData];
    
}
#pragma mark 点击课程
-(void)courseOnClick:(UIButton *)button{
    self.index = 2;
    
    button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        orangeLabel.center = CGPointMake(button.center.x, orangeLabel.center.y);
    }];
    word.selected = NO;
    grammar.selected = NO;
    self.list = [NSMutableArray arrayWithArray:self.courseList];
    [_tableView reloadData];
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
