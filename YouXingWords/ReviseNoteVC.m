//
//  ReviseNoteVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/25.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ReviseNoteVC.h"

@interface ReviseNoteVC ()

//修改备注
@property(nonatomic,retain)UITextField *myTextField;//修改备注输入框
//修改分组
@property(nonatomic,retain)UILabel *groupLb;//分组输入框
//对号✔️
@property(nonatomic,retain)UILabel *sureLb;//对号label

@end

@implementation ReviseNoteVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.titleStr;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#e8edf1"];
    //添加完成按钮
    [self addRightButton];
    if ([self.titleStr isEqualToString:@"修改备注"]) {
        //添加备注修改框
        [self addMyTextField];
    }else if([self.titleStr isEqualToString:@"修改分组"]){
        //添加分组label
        [self addGroupLb];
    }
}
#pragma mark---添加右上角按钮
-(void)addRightButton
{
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(buttonItemAction)];
    self.navigationItem.rightBarButtonItem=buttonItem;
}
#pragma mark---完成按钮点击
-(void)buttonItemAction
{
    //修改备注
    if ([self.titleStr isEqualToString:@"修改备注"]) {
        if ([_myTextField.text isEqualToString:@""]) {
            [Utils showAlter:@"请输入备注名称"];
        }else{
            //参数字典（修改备注）
            NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":self.username,@"remarkName":_myTextField.text};
            [NetWorkingUtils postWithUrl:ReviseFriendInfo params:paraDic successResult:^(id response) {
                if ([response[@"status"] integerValue]==1) {
//                    //修改本地缓存数据
//                    [self reviseLocalNoteData:_myTextField.text];
                    //返回根目录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //
                    self.block(_myTextField.text);
                }else{
                    [Utils showAlter:@"修改失败，请重新修改"];
                }
            } errorResult:^(NSError *error) {
                
            }];
        }
    //修改分组
    }else if([self.titleStr isEqualToString:@"修改分组"]){
        
        NSString *groupStr;
    
        UILabel *familyLb=(UILabel *)[self.view viewWithTag:600];
        UILabel *friendLb=(UILabel *)[self.view viewWithTag:601];
        if (familyLb.hidden==YES&&friendLb.hidden==YES) {
            [Utils showAlter:@"请选择分组"];
        }else{
            //选择家人分组
            if(familyLb.hidden==NO){
                groupStr=@"1";
                //选择朋友分组
            }else if(friendLb.hidden==NO){
                groupStr=@"2";
            }
            //参数字典（修改备注）
            NSDictionary *paraDic=@{@"token":[Utils getCurrentToken],@"friAccount":self.username,@"group":groupStr};
            [NetWorkingUtils postWithUrl:ReviseFriendInfo params:paraDic successResult:^(id response) {
                NSLog(@"+++++%@",response);
                if ([response[@"status"] integerValue]==1) {
                    //修改成功
                    //返回根目录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //传值回调
                    if ([groupStr isEqualToString:@"1"]) {
                        self.block(@"家人");
                    }else if ([groupStr isEqualToString:@"2"]){
                        self.block(@"朋友");
                    }
//                    //修改本地缓存中的分组
//                    [self reviseLocalGroupData:groupStr];
                }else{
                    [Utils showAlter:@"修改失败，请重新修改"];
                }
            } errorResult:^(NSError *error) {
                    
            }];
        }
    }
}
#pragma mark---添加备注修改框
-(void)addMyTextField
{
    _myTextField=[[UITextField alloc]initWithFrame:CGRectMake(AutoTrans(40), 64+(AutoTrans(40)), SCREEN_WIDTH-(AutoTrans(80)), AutoTrans(90))];
    _myTextField.backgroundColor=[UIColor whiteColor];
    _myTextField.borderStyle=UITextBorderStyleRoundedRect;
    _myTextField.text=self.noteStr;
    _myTextField.clearButtonMode=UITextFieldViewModeAlways;
    [self.view addSubview:_myTextField];
}
#pragma mark---添加修改分组
-(void)addGroupLb
{
    NSArray *array=@[@"家人",@"朋友"];
    
    for (int i= 0; i<2; i++) {
        _groupLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 64+((AutoTrans(100))+1)*i, SCREEN_WIDTH, AutoTrans(100))];
        _groupLb.backgroundColor=[UIColor whiteColor];
        _groupLb.text=[NSString stringWithFormat:@"    %@",array[i]];
        _groupLb.userInteractionEnabled=YES;
        _groupLb.tag=500+i;
        [self.view addSubview:_groupLb];
        //添加手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_groupLb addGestureRecognizer:tap];
        //对号 ✔️
        _sureLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(AutoTrans(100)), 64+((AutoTrans(100))+1)*i, AutoTrans(100), AutoTrans(100))];
        _sureLb.text=@"✔️";
        _sureLb.hidden=YES;
        _sureLb.tag=600+i;
        [self.view addSubview:_sureLb];
    }
}
#pragma mark---手势点击
-(void)tap:(UITapGestureRecognizer *)tap
{
    UILabel *familyLb=(UILabel *)[self.view viewWithTag:600];
    UILabel *friendLb=(UILabel *)[self.view viewWithTag:601];
    
    if (tap.view.tag==500) {
        familyLb.hidden=NO;
        friendLb.hidden=YES;
    }else if(tap.view.tag==501){
        familyLb.hidden=YES;
        friendLb.hidden=NO;
    }
}
#pragma mark---修改本地缓存中备注数据
-(void)reviseLocalNoteData:(NSString *)noteStr
{
    //获取本地缓存数据
    NSMutableArray *localAddressArr=[NSMutableArray array];
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    [localAddressArr addObjectsFromArray:arr];
    //组数
    NSInteger group=[self.tempDic[@"group"] integerValue];
    //行数
    NSInteger number=[self.tempDic[@"number"] integerValue];
    //更改行数对应的字典的值
    NSDictionary *rowDic=localAddressArr[group][number];
    NSMutableDictionary *rowMutableDic=[NSMutableDictionary dictionary];
    [rowMutableDic setDictionary:rowDic];
    [rowMutableDic setObject:noteStr forKey:@"remarkName"];
    //修改组数对应的数组的值
    NSMutableArray *sectionMutableArr=[NSMutableArray array];
    [sectionMutableArr addObjectsFromArray:localAddressArr[group]];
    [sectionMutableArr replaceObjectAtIndex:number withObject:rowMutableDic];
    //替换修改之后的值
    [localAddressArr replaceObjectAtIndex:group withObject:sectionMutableArr];
    //再次添加到本地缓存中
    [[NSUserDefaults standardUserDefaults]setObject:localAddressArr forKey:@"address"];
}
#pragma mark----修改本地缓存中分组的数据
-(void)reviseLocalGroupData:(NSString *)groupStr
{
    //获取本地缓存数据
    NSMutableArray *localAddressArr=[NSMutableArray array];
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    [localAddressArr addObjectsFromArray:arr];
    //组数
    NSInteger group=[self.tempDic[@"group"] integerValue];
    //行数
    NSInteger number=[self.tempDic[@"number"] integerValue];
    //表示当前数据为家人分组
    if (group==0) {
        //点击家人按钮不用修改
        if ([groupStr integerValue]==1) {
            
        //点击朋友按钮将数据修改为朋友分组
        }else if([groupStr integerValue]==2){
            //获取家人数组中的全部字典
            NSMutableArray *familyMutableArr=[NSMutableArray array];
            [familyMutableArr addObjectsFromArray:localAddressArr[0]];
            //获取朋友数组中的全部字典
            NSMutableArray *friendMutableArr=[NSMutableArray array];
            [friendMutableArr addObjectsFromArray:localAddressArr[1]];
            //获取当前数据所在字典
            NSDictionary *curDataDic=localAddressArr[group][number];
            //朋友数组添加当前数据
            [friendMutableArr addObject:curDataDic];
            //家人数组删除当前数据
            [familyMutableArr removeObjectAtIndex:number];
            //更新本地缓存
            [localAddressArr replaceObjectAtIndex:0 withObject:familyMutableArr];
            [localAddressArr replaceObjectAtIndex:1 withObject:friendMutableArr];
            [[NSUserDefaults standardUserDefaults]setObject:localAddressArr forKey:@"address"];
        }
    //表示当前数据为朋友分组
    }else if (group==1){
        //点击家人按钮将当前数据修改为家人分组
        if ([groupStr integerValue]==1) {
            //获取家人数组中的全部字典
            NSMutableArray *familyMutableArr=[NSMutableArray array];
            [familyMutableArr addObjectsFromArray:localAddressArr[0]];
            //获取朋友数组中的全部字典
            NSMutableArray *friendMutableArr=[NSMutableArray array];
            [friendMutableArr addObjectsFromArray:localAddressArr[1]];
            //获取当前数据所在字典
            NSDictionary *curDataDic=localAddressArr[group][number];
            //家人数组添加当前数据
            [familyMutableArr addObject:curDataDic];
            //朋友数组删除当前数据
            [friendMutableArr removeObjectAtIndex:number];
            //更新本地缓存
            [localAddressArr replaceObjectAtIndex:0 withObject:familyMutableArr];
            [localAddressArr replaceObjectAtIndex:1 withObject:friendMutableArr];
            [[NSUserDefaults standardUserDefaults]setObject:localAddressArr forKey:@"address"];
            //点击朋友按钮不用修改
        }else if([groupStr integerValue]==2){

        }
    }
}

@end
