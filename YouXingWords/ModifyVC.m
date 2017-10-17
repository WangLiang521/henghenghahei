//
//  ModifyVC.m
//  YouXingWords
//
//  Created by tih on 16/11/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ModifyVC.h"

@interface ModifyVC ()<UITextFieldDelegate>
@property(nonatomic,retain)CustomTitleView *titleView;//导航栏
@property(nonatomic,retain)UITextField *textField;
@end

@implementation ModifyVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackgroundView];
    [self addTitleView];
    [self addTextField];
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
    
    WS(weakSelf);
    _titleView=[CustomTitleView customTitleView:_titleString rightTitle:@"完成" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        NSDictionary *paramsDic = @{@"token":[Utils getCurrentToken],@"username":[Utils getCurrentUserName],_contentKey:_textField.text};
        
        [NetWorkingUtils postWithUrl:UserModify params:paramsDic successResult:^(id response) {
           
            if ([response[@"status"] integerValue] == 1) {
                [Utils showAlter:@"修改成功！"];
                NSDictionary * userInfoDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
                [dic setValue:_textField.text forKey:_contentKey];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
                if (self.completeBlock) {
                    self.completeBlock(weakSelf.textField.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showError:response[@"error"]];
            }
        } errorResult:^(NSError *error) {
            [Utils showAlter:@"修改失败！"];

        }];
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加tableView
-(void)addTextField
{
    //40 40 70
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(AutoTrans(40), CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH-(AutoTrans(80)), AutoTrans(70))];
    whiteView.backgroundColor =  [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = AutoTrans(35);
    [self.view addSubview:whiteView];
    
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(AutoTrans(60), CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH-(AutoTrans(120)), AutoTrans(70)) ];
    _textField.delegate=self;
    _textField.backgroundColor=[UIColor clearColor];
//    _textField.layer.masksToBounds = YES;
//    _textField.layer.cornerRadius = AutoTrans(35);
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.text = _contentStr;
    [self.view addSubview:_textField];
    
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
