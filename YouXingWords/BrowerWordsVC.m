//
//  BrowerWordsVC.m
//  YouXingWords
//
//  Created by tih on 16/8/30.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "BrowerWordsVC.h"
#import "BrowerCell.h"
#import "BrowerChooseCell.h"
#import "BarrierDetailVC.h"
#import <SVProgressHUD.h>
#import "PronunciationVC.h"
#import "LexiconViewController.h"
@interface BrowerWordsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel ;
}
@property (nonatomic,retain)UILabel *descLabel;
@property (nonatomic,retain)UITableView *tableView;
//@property (nonatomic,retain)NSMutableArray *list;//9个qsmodel
//@property (nonatomic,retain)NSMutableArray *selectList; //剩下的qsmodel

@property (nonatomic,assign) BOOL canSelected;

@property (nonatomic,assign)BOOL hasShowAlert;//去掉单词后提示 只提示一次

@property (assign, nonatomic)  BreakthroughType type;

@end

@implementation BrowerWordsVC


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
    [self addWordsView];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
        
    }
    return _list;
}
-(NSMutableArray *)removeList{
    if (!_removeList) {
        _removeList = [ NSMutableArray array];
    }
    return _removeList;
}
-(NSMutableArray *)selectList{
    if (!_selectList) {
        _selectList = [NSMutableArray array];
    }
    return _selectList;
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
    titleLabel.text = _item.passName;
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
    [rightButton setTitle:@"选词" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [rightButton addTarget:self action:@selector(chooseWords:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rightButton];
    
    


}
-(void)addWordsView{
    _descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _descLabel.font = [UIFont systemFontOfSize:AutoTrans(40) weight:2];
    _descLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(AutoTrans(60));
        make.left.mas_equalTo(self.view.mas_left).offset(AutoTrans(40));
        make.height.mas_equalTo(@(AutoTrans(38)));
    }];
    _descLabel.text = [NSString stringWithFormat:@"新学单词%lu个",(unsigned long)self.selectList.count];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius= AutoTrans(30);
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_descLabel.mas_bottom).offset(AutoTrans(36));
        make.left.mas_equalTo(self.view.mas_left).offset(AutoTrans(40));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(40)));
        make.height.mas_equalTo(@((AutoTrans(80))*9+10));
    }];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#64bfff"]];
    button.layer.masksToBounds = YES;
    button.tag = 0x1234;
    button.layer.cornerRadius = (AutoTrans(90))/2;
    [button setTitle:@"开始学习" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(practicePronunciation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(AutoTrans(102));
        make.right.mas_equalTo(self.view.mas_right).offset(-(AutoTrans(102)));
        make.top.mas_equalTo(_tableView.mas_bottom).offset(AutoTrans(30));
        make.height.mas_equalTo(@(AutoTrans(90)));
    }];

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_canSelected) {
        static NSString *cellID = @"cell";
        BrowerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[BrowerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.block = ^( ){
//                ((QsModel *)self.selectList[indexPath.row]).isSelected = !((QsModel *)self.selectList[indexPath.row]).isSelected;
                for (int i=0; i<self.list.count; i++) {
                    if ([self.selectList[indexPath.row]isEqual:self.list[i]]) {
                        ((QsModel *)self.list[i]).isSelected = !((QsModel *)self.list[i]).isSelected;

                        break;
                    }
                }
            };
        }
        cell.item = self.selectList[indexPath.row];
        
        
        return cell;

    }else{
        static NSString *cellID2 = @"cell2";
        BrowerChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell = [[BrowerChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.block = ^( ){
                ((QsModel *)self.list[indexPath.row]).isSelected = !((QsModel *)self.list[indexPath.row]).isSelected;
            };
        }
        cell.item = self.list[indexPath.row];
        
        
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_canSelected) {
        return self.selectList.count;
    }
    return self.list.count;
}




#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_canSelected) {
        return;
    }
    
    [self.list[indexPath.row] setIsNOTShow:![self.list[indexPath.row]isNOTShow]];
    if (![self.list[indexPath.row] isNOTShow]) {
        if ([self.removeList containsObject:[self.list[indexPath.row] qWordID]]) {
            [self.removeList removeObject:[self.list[indexPath.row] qWordID]];
        }
    }else{
//        [SVProgressHUD showInfoWithStatus:@"去掉该单词后，将不出现该单词的题"];
        if (!_hasShowAlert) {
            [Utils showAlter:@"去掉该单词后，将不出现该单词的题"];
            _hasShowAlert = YES;
        }

        [self.removeList addObject:[self.list[indexPath.row] qWordID]];
    }
    
    [self.selectList removeAllObjects];
    for (int i=0; i<self.list.count; i++) {
        BOOL flag =NO;
        for (int j=0; j<self.removeList.count; j++) {
            if ([[self.list[i] qWordID]isEqualToNumber:self.removeList[j] ]) {
                flag = YES;
            }
        }
        if (!flag) {
            [self.selectList addObject:self.list[i]];
        }
    }

    
    if (self.list.count-self.removeList.count<lestWordsCount) {
        [Utils showAlter:@"请至少选择5个单词"];
//        [SVProgressHUD showInfoWithStatus:@"请至少选择5个单词！"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [self.view viewWithTag:0x1234].backgroundColor =[UIColor colorWithRed:0.636 green:0.652 blue:0.665 alpha:1.000];
        [self.view viewWithTag:0x1234].userInteractionEnabled = NO;
        
    }else{
        [[self.view viewWithTag:0x1234] setBackgroundColor:[UIColor colorWithHexString:@"#64bfff"]];
        [self.view viewWithTag:0x1234].userInteractionEnabled = YES;
    }
    _descLabel.text = [NSString stringWithFormat:@"新学单词%lu个",(unsigned long)self.selectList.count];

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)setItem:(PassModel *)item{
    _item = item;
    titleLabel.text = item.passName;
    //_descLabel.text = [NSString stringWithFormat:@"新学单词%lu个",(unsigned long)item.list.count];
    //[self.list  addObjectsFromArray: _item.list];
    for (int i=0;i<_item.list.count; i++) {
//        if (_item.list[i].qExplain) {
        BOOL flag=NO;
            for (int j=0; j<self.list.count; j++) {
                if ([[self.list[j] qWord]isEqualToString:_item.list[i].qWord]) {
                    flag = YES;
                    break;
                }else{
                }
            }
        if (!flag) {
            QsModel * model = _item.list[i];
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
            }
            [self.list addObject:model];
            [self.selectList addObject:model];
        }
    }
}
#pragma mark - 界面跳转
-(void)practicePronunciation:(UIButton *)button{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tmpList =[NSMutableArray array];
    for (int i=0; i<self.item.list.count; i++) {
        BOOL isEq=NO;
        for (int j=0; j<self.removeList.count; j++) {
            if ([[self.item.list[i] qWordID]isEqualToNumber:self.removeList[j]]) {
                // [self.item.list removeObjectAtIndex:i];
                isEq = YES;
            }else{
            }
        }
        !isEq?[tmpList addObject:self.item.list[i]]:nil;
        
    }
    //    self.item.list = tmpList;
    PassModel *item = [PassModel modelWithDic:self.item.dic];
    item.passName = self.item.passName;
    NSMutableArray *pronVCListtmp = [NSMutableArray array];
    for (int i=0; i<self.list.count; i++) {
        BOOL j = NO;
        for (int k=0; k<self.removeList.count; k++) {
            if ([[self.list[i] qWordID]isEqual:self.removeList[k]]) {
                j=YES;
            }
        }
        if (!j) {
            [pronVCListtmp addObject:self.list[i]];
        }
    }
    item.list = tmpList;
    if ([[df valueForKey:@"NoPronunciation"]integerValue]==1) {
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]init];
        BarrierDetailVC *detailVC = [[BarrierDetailVC alloc]initWith:_type];
        //end
        
        detailVC.item = item;
        detailVC.wordList = self.list;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//        PronunciationVC  *detailVC = [[PronunciationVC alloc]init];
        PronunciationVC  *detailVC = [[PronunciationVC alloc]initWith:_type];
        //end

        detailVC.item =item;
        detailVC.list = pronVCListtmp;
        detailVC.wordslist = self.list;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
-(void)naviPop:(UITapGestureRecognizer *)tap{
//    [self.navigationController popViewControllerAnimated:YES];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    if (_tableView) {
        [_tableView reloadData];
        _descLabel.text = [NSString stringWithFormat:@"新学单词%lu个",(unsigned long)self.selectList.count];

    }
//    if (_removeList) {
//        [_removeList removeAllObjects];;
//    }
//    if (_selectList) {
//        [_selectList removeAllObjects];;
//    }
}
#pragma mark - 点击事件
-(void)chooseWords:(UIButton *)button{
    if (!_canSelected) {
        _canSelected = YES;
        [button setTitle:@"看词" forState:UIControlStateNormal];

        _tableView.layer.cornerRadius = AutoTrans(15);

    }
    else{
        _canSelected = NO;
        [button setTitle:@"选词" forState:UIControlStateNormal];
        _tableView.layer.cornerRadius = AutoTrans(30);
    }
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
