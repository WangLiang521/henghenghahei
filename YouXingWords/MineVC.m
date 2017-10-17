//
//  MineVC.m
//  YouXingWords
//
//  Created by sunzhaokai on 16/8/2.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "MineVC.h"
#import "myHeadCell.h"
#import "MyCell.h"
#import "PreferenceVC.h"
#import "NewNoteBookVC.h"
//#import "ReferralVC.h"
#import "ChooseResVC.h"
#import "StudyReportVC.h"
#import "IntegralTaskVC.h"
#import "AwardSignInVC.h"
#import "LoginVC.h"
#import "LuckyDrawViewController.h"
#import "SZKImagePickerVC.h"
#import "UserInfoVC.h"
//#import "PrePlayVC.h"
#import "GDTextViewVC.h"
#import "GDHidenPassWordView.h"
//#import "AliVcMoiveViewController.h"
#import "AboutUsVC.h"
//#import "BuyUCoinsVC.h"

#import "WordSeaTestVC.h"
#import "PassList.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate,LuckyDrawDelegate,SZKImagePickerVCDelegate,UIActionSheetDelegate>

@property(nonatomic,retain)UITableView *myTableView;//tableView
@property(nonatomic,retain)UILabel *mainTitleLb;//页面标题
@property(nonatomic,retain)UIView *titleView;//页面导航栏
@property(nonatomic,retain)NSArray *imageArray;
@property(nonatomic,retain)NSArray *contentArray;
@property(nonatomic,copy)NSDictionary *userInfoDic;//个人信息字典
@property (nonatomic,retain)UIImage *iconImage;

@property (assign, nonatomic)  BOOL isNotFirstRefresh;

@end

@implementation MineVC

//@synthesize videolists,datasource;


- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //获取个人信息
    [self getUserInfo];
//    [_myTableView reloadData];
    
    self.navigationController.navigationBarHidden =YES;
    self.tabBarController.tabBar.hidden=NO;
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
//       _imageArray=@[@[@"icon_choosebook",@"icon_studyreport",@"icon_wrongbook",@"icon_recommend",@"icon_work",@"icon_vovabulary",@"icon_share",@"icon_preference"],@[@"icon_newcomer",@"icon_suggestion",@"icon_about"]];
//        if (![TestUserName isEqualToString:[Utils getCurrentUserName]]) {
//            _imageArray=@[@[@"icon_choosebook",@"icon_studyreport",@"icon_wrongbook",@"icon_gold",@"icon_recommend",@"icon_work",@"icon_vovabulary",@"icon_preference"],@[@"icon_newcomer",@"icon_suggestion",@"icon_about"]];
//        }else{
//            _imageArray=@[@[@"icon_choosebook",@"icon_studyreport",@"icon_wrongbook",@"icon_recommend",@"icon_work",@"icon_vovabulary",@"icon_preference"],@[@"icon_newcomer",@"icon_suggestion",@"icon_about"]];
            _imageArray=@[@[@"icon_choosebook",@"icon_studyreport",@"icon_wrongbook",@"icon_work",@"icon_vovabulary",@"icon_preference"],@[@"icon_newcomer",@"icon_suggestion",@"icon_about"]];
//        }
    }
    
    return _imageArray;
}
-(NSArray *)contentArray
{
    if (!_contentArray) {

        
//        联系客服18853147859
//        if (![TestUserName isEqualToString:[Utils getCurrentUserName]]) {
//            _contentArray=@[@[@"选择教材",@"学习报告",@"错题本",@"优钻购买",@"推荐码",@"积分任务",@"词汇量测试",@"偏好设置"],@[@"意见反馈",@"关于优行"]];
//        }else{
//            _contentArray=@[@[@"选择教材",@"学习报告",@"错题本",@"推荐码",@"积分任务",@"词汇量测试",@"偏好设置"],@[@"意见反馈",@"关于优行"]];
            _contentArray=@[@[@"选择教材",@"学习报告",@"错题本",@"积分任务",@"词汇量测试",@"偏好设置"],@[@"意见反馈",@"关于优行"]];
//        }
        

        
    }
    return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //解决导航栏坐标问题
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加tableView
//    [NetWorkingUtils networkReachable:^{
//        [NetWorkingUtils postWithUrl:GetUserInfo params:@{@"token":[Utils getCurrentToken]} successResult:^(id response) {
//            
//            [[NSUserDefaults standardUserDefaults]setObject:response[@"info"] forKey:@"userInfo"];
//            [self getUserInfo];
//            [CommonShare share].currentBookName = response[@"info"][@"bookName"];
//            [AnswerTools setBookID:[response[@"info"] valueForKey:@"bookId"]];
//            _myTableView? [_myTableView reloadData]:    [self addMyTableView];
//        } errorResult:^(NSError *error) {
//            NSLog(@"%@",error);
//            _myTableView? [_myTableView reloadData]:    [self addMyTableView];
//
//        }];
//
//    } AndUnreachable:^{
//        [self getUserInfo];
//        _myTableView? [_myTableView reloadData]:    [self addMyTableView];
//
//    }];
} 
#pragma mark---获取个人信息
-(void)getUserInfo
{
    
    [NetWorkingUtils networkReachable:^{

        
        __block MBProgressHUD * hud =nil;
        if (!_isNotFirstRefresh) {
           hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        }
        
        
        
        [LGDHttpTool POST:GetUserInfo parameters:@{@"token":[Utils getCurrentToken]} success:^(NSDictionary * response) {
            
            if (!_isNotFirstRefresh) {
               
//                hud.labelText = response[@"error"];
                [hud hide:YES afterDelay:0];
                hud.completionBlock = ^{
                };
               
            }
            
            if ([response[@"status"] integerValue] == 0) {
                [MBProgressHUD showError:response[@"error"]];
                if ([response[@"type"] isEqualToString:@"notLogin"]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                            EMError *error = [[EMClient sharedClient] logout:YES];
                            if (!error) {
                                
                                LoginVC *login=[[LoginVC alloc]init];
                                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
                                nav.navigationBar.shadowImage = [UIImage new];
                                login.returnBlock=^{
                                    self.tabBarController.selectedIndex=0;
                                    _myTableView.contentOffset=CGPointMake(0, 0);
                                };
                                [Utils  clearToken];
                                [self presentViewController:nav animated:YES completion:nil];
                                
                            }
                        
                    });
                }
            }else{
                [PassList saveSysInfo:response[@"sysInfo"]];
            }
            
            
            _isNotFirstRefresh = YES;
            NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:response[@"info"]];
            
            [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"userInfo"];

            _userInfoDic=[NSDictionary dictionaryWithDictionary:userInfo];
            _myTableView? [_myTableView reloadData]:    [self addMyTableView];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            if (!_isNotFirstRefresh) {
                
                [hud hide:YES afterDelay:0.5];
                hud.completionBlock = ^{};
            }
            _myTableView? [_myTableView reloadData]:    [self addMyTableView];
        }];
        
        
    } AndUnreachable:^{

        _myTableView? [_myTableView reloadData]:    [self addMyTableView];
        
    }];

}

#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
    
}

#pragma mark---添加表头
-(void)addTitleView
{
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, AutoTrans(80))];
    UILabel* titleLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(AutoTrans(100)), 0, AutoTrans(200), _titleView.frame.size.height)];
    titleLb.textAlignment=NSTextAlignmentCenter;
    titleLb.textColor=[UIColor whiteColor];
    titleLb.font=[UIFont systemFontOfSize:AutoTrans(40)];
    titleLb.text=@"我的";
    [_titleView addSubview:titleLb];
    
    [self.view addSubview:_titleView];
}

#pragma mark---添加tableView
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH-(AutoTrans(60)), SCREEN_HEIGHT-CGRectGetMaxY(_titleView.frame)-(AutoTrans(150))) style:UITableViewStyleGrouped];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    _myTableView.bounces=NO;
    _myTableView.backgroundColor=[UIColor clearColor];
    _myTableView.showsVerticalScrollIndicator=NO;
    //添加footView
    [self addFootView];
    
    [self.view addSubview:_myTableView];
    
}

#pragma mark -- 添加tableViewFootView
-(void)addFootView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoTrans(90))];
    view.backgroundColor=[UIColor clearColor];
    
    UIButton *footBtn=[[UIButton alloc]initWithFrame:CGRectMake(AutoTrans(67), 0, SCREEN_WIDTH-(AutoTrans(194)), AutoTrans(90))];
    footBtn.backgroundColor=[UIColor colorWithHexString:@"#64bfff"];
    footBtn.layer.cornerRadius=20;
    footBtn.layer.masksToBounds=YES;
    
    [footBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    
    footBtn.titleLabel.font=[UIFont systemFontOfSize:AutoTrans(28.81)];
    footBtn.titleLabel.textColor=[UIColor whiteColor];
    [footBtn addTarget:self action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footBtn];
    _myTableView.tableFooterView=view;
}
#pragma mark - dataSource
#pragma mark --返回组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
#pragma mark --返回每组cell数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {

        return ((NSArray *) self.contentArray[0]).count;
    }
    else
    {
        return ((NSArray *) self.contentArray[1]).count;
    }
}

#pragma mark --返回每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID=@"myHeadCell";
        myHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[myHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        if (self.iconImage) {
            cell.headerImg.image = self.iconImage;
        }else{
            //头像
            NSURL *iconImgUrl=[NSURL URLWithString:_userInfoDic[@"signPhoto"]];
            UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
            [cell.headerImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];

        }
//        cell.numberLab.text = _userInfoDic[@"coins"];
                //头像添加点击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [cell.headerImg addGestureRecognizer:tap];
        //名称
        cell.nameLab.text=[NSString stringWithFormat:@"%@",[Utils isValidStr:_userInfoDic[@"name"]]?_userInfoDic[@"name"]:@""];
        //手机号
        cell.phoneLab.text=[NSString stringWithFormat:@"%@",[Utils isValidStr:_userInfoDic[@"username"]]?_userInfoDic[@"username"]:@""];
        NSString * strCoins = [NSString stringWithFormat:@"%@",_userInfoDic[@"coins"]];
        //钻石数量
        cell.numberLab.text=[NSString stringWithFormat:@"%@",[LGDUtils isValidStr:strCoins]?strCoins:@"0"];
        [cell.numberLab sizeToFit];
        return cell;
    }
    else
    {
        if (indexPath.section==1&&indexPath.row==0) {
            static NSString *cellID=@"cellID";
            MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }

        
                //start
#pragma mark gd_修改 type  2017-05-02 21:58:41
//            if ([CommonShare share].currentBookName) {
//                cell.detailLable.text = [CommonShare share].currentBookName;
//            }else{
//                cell.detailLable.text = [_userInfoDic valueForKey:@"bookName"];
//                
//            }
            cell.detailLable.text = [AnswerTools getBookNameWith:BreakthroughTypeWord];
                //end
                
            
            

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.contentLable.text=self.contentArray[indexPath.section-1][indexPath.row];
            cell.leftImage.image=[UIImage imageNamed:self.imageArray[indexPath.section-1][indexPath.row]];
            return cell;
        }
        else
        {
            static NSString *cellID=@"cellID1";
            MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentLable.text=self.contentArray[indexPath.section-1][indexPath.row];
            cell.leftImage.image=[UIImage imageNamed:self.imageArray[indexPath.section-1][indexPath.row]];
            return cell;
        }
    
    }
    
}
#pragma mark---每组表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return AutoTrans(44);
    }
    else if (section==1||section==2)
    {
        return AutoTrans(20);
    }
    else
    {
        return AutoTrans(30);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 30;
    }
    return 0.1;
}
#pragma mark---cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return AutoTrans(212);
    }
    else
    {
        return AutoTrans(90);
    }
    
}
#pragma mark --选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row==0) {
            UserInfoVC *userInfoVC = [[UserInfoVC alloc]init];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
//    @[@"选择教材",@"学习报告",@"错题本",@"优钻购买",@"推荐码",@"积分任务",@"词汇量测试",@"偏好设置"]
    
    if (indexPath.section==1) {
        NSString * str = _contentArray[0][indexPath.row];
        
        NSLog(@"str = %@",str);
        //选择教材
        if (indexPath.row==0) {
            ChooseResVC *chooseRes = [[ChooseResVC alloc]init];
            chooseRes.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chooseRes animated:YES];
        }
        //学习报告
        if (indexPath.row==1) {
            
            StudyReportVC *studyVC = [[StudyReportVC alloc]init];
            studyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:studyVC animated:YES];
            
        }
        //错题本
        if (indexPath.row==2) {
            NewNoteBookVC *notebookVC = [[NewNoteBookVC alloc]init];
            notebookVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:notebookVC animated:YES];
        }
//        //优钻购买
//        if ([str isEqualToString:@"优钻购买"]) {
//            BuyUCoinsVC *referVC = [[BuyUCoinsVC alloc]init];
//            referVC.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:referVC animated:YES];
//        }
//        //推荐码
//        if ([str isEqualToString:@"推荐码"]) {
//            ReferralVC *referVC = [[ReferralVC alloc]init];
//            referVC.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:referVC animated:YES];
//        }
        //积分任务
        if ([str isEqualToString:@"积分任务"]) {
            IntegralTaskVC *taskVC = [[IntegralTaskVC alloc]init];
            taskVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:taskVC animated:YES];
//            if (![[Utils getCurrentUserName] isEqualToString:TestUserName]) {
//                IntegralTaskVC *taskVC = [[IntegralTaskVC alloc]init];
//                taskVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:taskVC animated:YES];
//            }
//            [MBProgressHUD showError:@"敬请期待"];
            //            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
            //            IntegralTaskVC *taskVC = [[IntegralTaskVC alloc]init];
            //            taskVC.hidesBottomBarWhenPushed = YES;
            //
            //            [self.navigationController pushViewController:taskVC animated:YES];
            
            
        }
        if ([str isEqualToString:@"词汇量测试"]) {
//            [MBProgressHUD showError:@"敬请期待"];
            WordSeaTestVC * vc = [[WordSeaTestVC alloc] init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            //            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
        }
        if ([str isEqualToString:@"偏好设置"]) {
            PreferenceVC *preVC=[[PreferenceVC alloc]init];
            preVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:preVC animated:YES];
        }
        
        
    }       if (indexPath.section==2) {
        
        if (indexPath.row == 0) {
            GDTextViewVC * vc = [GDTextViewVC VCWithTittle:@"意见反馈" placeHolder:@"请输入意见返回" completeBlock:^(NSString *text) {
                
            }];
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [Utils getCurrentToken];
            dict[@"name"] = @"02";
            dict[@"phone"] = [Utils getCurrentUserName];
            vc.otherParameters = dict;
            vc.saveUrl = SuggestURL;
            vc.key = @"suggest";
            UIView * contentView = [UIView new];
            [vc.view addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(150);
            }];
            [GDHidenPassWordView shareWithView:contentView PassRightBlock:^{
                NSLog(@"GDHidenPassWordView");
                NSNumber * count = [[NSUserDefaults standardUserDefaults] objectForKey:@"PassSuccessAfterQsIndex"];
                NSString * showMessage = nil;
                if ([count integerValue] == 1) {
                    count = @(MAXFLOAT);
                    showMessage = @"正常通关";
                }else{
                    count = @(1);
                    showMessage = @"1题通关";
                }
                [[NSUserDefaults standardUserDefaults] setObject:count forKey:@"PassSuccessAfterQsIndex"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [MBProgressHUD showSuccess:showMessage];
                
                
            }];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            AboutUsVC * vc = [[AboutUsVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
        
//        if (indexPath.row==1) {
////            PrePlayVC * vc = [[PrePlayVC alloc] initWithNibName:@"PrePlayVC" bundle:nil];
////            vc.hidesBottomBarWhenPushed=YES;
////            [self.navigationController pushViewController:vc animated:YES];
//            [AliVcMediaPlayer setAccessKeyDelegate:self];
//            [self loadRemoteVideo];
//            [self loadLocalVideo];
//            [self addVideoToList];
//            datasource = [videolists allKeys];
//            
//            
//            TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
//            NSString* strUrl = @"rtmp://zhibo.jinyouapp.com/AppName/StreamName?auth_key=1488441957-0-0-6a002dc02b451cabde328052eec80770";
//            strUrl = [strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            NSURL* url = [NSURL URLWithString:strUrl];
//            if(url == nil) {
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"输入地址无效" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                
//                [alter show];
//                return;
//            }
//            [currentView SetMoiveSource:url];
//            
//            [self presentViewController:currentView animated:YES completion:nil ];
//        }
    }

}


#pragma mark --分区切圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       if (indexPath.section==0) {
    
    }
    else
    {
        // 圆角弧度半径
        CGFloat cornerRadius = 10.f;
        // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
        cell.backgroundColor = UIColor.clearColor;
        
        // 创建一个shapeLayer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
        // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
        CGMutablePathRef pathRef = CGPathCreateMutable();
        // 获取cell的size
        // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        
        // CGRectGetMinY：返回对象顶点坐标
        // CGRectGetMaxY：返回对象底点坐标
        // CGRectGetMinX：返回对象左边缘坐标
        // CGRectGetMaxX：返回对象右边缘坐标
        // CGRectGetMidX: 返回对象中心点的X坐标
        // CGRectGetMidY: 返回对象中心点的Y坐标
        
        // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
        
        // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);

        if (indexPath.row == 0) {
            // 初始起点为cell的左下角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            // 初始起点为cell的左上角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            // 添加cell的rectangle信息到path中（不包括圆角）
            CGPathAddRect(pathRef, nil, bounds);
        }
        // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
        layer.path = pathRef;
        backgroundLayer.path = pathRef;
        // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
        CFRelease(pathRef);
        // 按照shape layer的path填充颜色，类似于渲染render
        // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        
        // view大小与cell一致
        UIView *roundView = [[UIView alloc] initWithFrame:bounds];
        // 添加自定义圆角后的图层到roundView中
        [roundView.layer insertSublayer:layer atIndex:0];
        roundView.backgroundColor = UIColor.clearColor;
        // cell的背景view
        cell.backgroundView = roundView;
        
        // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
        // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
//        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//        backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
//        [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//        selectedBackgroundView.backgroundColor = UIColor.clearColor;
//        cell.selectedBackgroundView = selectedBackgroundView;
    }
    
}
#pragma mark - 自定义delegate
-(void)pushToLucky{
    LuckyDrawViewController *luckyDrawVC = [[LuckyDrawViewController alloc]init];
    luckyDrawVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:luckyDrawVC animated:YES];
}
#pragma mark---头像添加点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    //判断是否支持相机  模拟器去除相机功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册上传" ,nil];
        [sheet showInView:self.view];
    }else{
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册上传" ,nil];
        [sheet showInView:self.view];
    }
}
#pragma mark-----UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:{
                [self presentViewController:ImagePickerStyleCamera];
            }
                break;
            case 1:{
                [self presentViewController:ImagePickerStylePhotoLibrary];
            }
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:{
                [self presentViewController:ImagePickerStylePhotoLibrary];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark----跳转到SZKImagePickerVC
-(void)presentViewController:(imagePickerStyle)style
{
    SZKImagePickerVC *picker=[[SZKImagePickerVC alloc]initWithImagePickerStyle:style];
    picker.SZKDelegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark----SZKImagePickerVCDelegate
-(void)imageChooseFinish:(UIImage *)image
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    myHeadCell *cell=[_myTableView cellForRowAtIndexPath:indexPath];
    cell.headerImg.image=image;
    self.iconImage = image;
    //上传图片
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSDictionary *dict = @{@"token":[Utils getCurrentToken],@"avator":imageData};
    
//    [NetWorkingUtils postWithUrl:IconUpload params:dict successResult:^(id response) {
//        NSLog(@"%@",response);
//    } errorResult:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    NSDictionary *dic = @{@"token":[Utils getCurrentToken]};

    [manager POST:IconUpload parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"avator" fileName:@"icon.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"status"] integerValue] == 1) {
            
            NSLog(@"请求成功 %@",dict);
            NSMutableDictionary * userInfoDic= [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
            userInfoDic[@"signPhoto"] = dict[@"image"];
            [[NSUserDefaults standardUserDefaults]setObject:userInfoDic forKey:@"userInfo"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}
#pragma mark - 退出登录
-(void)exitApp
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        
        LoginVC *login=[[LoginVC alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
        nav.navigationBar.shadowImage = [UIImage new];
        login.returnBlock=^{
            self.tabBarController.selectedIndex=0;
            _myTableView.contentOffset=CGPointMake(0, 0);
        };
        [Utils  clearToken];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 直播
//
//NSString* accessKeyIDm = @"LTAIJsvkiSzW349g";
//NSString* accessKeySecretm = @"ASnkQdZr74k6wnnTxUFeP9BjyoiE34";
//-(AliVcAccesskey*)getAccessKeyIDSecret
//{
//    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
//    accessKey.accessKeyId = accessKeyIDm;
//    accessKey.accessKeySecret = accessKeySecretm;
//    return accessKey;
//}
//
////添加地址到视频播放列表中
////按照如下格式进行添加
//-(void) addVideoToList
//{
//    [videolists setObject:@"http://YourAddress.m3u8" forKey:@"videoName"];
//}
//- (void)loadRemoteVideo
//{
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [pathArray objectAtIndex:0];
//    NSString *videolistPath = [docDir stringByAppendingFormat:@"/videolist.txt"];
//    FILE *file = fopen([videolistPath UTF8String], "rb");
//    if(file == NULL)
//        return;
//    
//    char VideoPath[200] = {0};
//    fgets(VideoPath, 200, file);
//    
//    do{
//        VideoPath[strlen(VideoPath)] = '\0';
//        NSString *srcFile = [NSString stringWithUTF8String:VideoPath];
//        
//        NSRange range1 = [srcFile rangeOfString:@"["];
//        NSRange range2 = [srcFile rangeOfString:@"]"];
//        if(range1.location == NSNotFound || range2.location == NSNotFound)
//            continue;
//        NSRange rangeName;
//        rangeName.location = range1.location+1;
//        rangeName.length = range2.location-range1.location-1;
//        NSString* filename = [srcFile substringWithRange:rangeName];
//        
//        NSRange range;
//        range = [srcFile rangeOfString:@"http:"];
//        if(range.location == NSNotFound){ //m3u8
//            range = [srcFile rangeOfString:@"rtmp:"];
//            if(range.location == NSNotFound){ //rtmp
//                continue;
//            }
//        }
//        
//        NSString* m3u8file = [srcFile substringFromIndex:range.location];
//        NSRange rangeEnd = [srcFile rangeOfString:@"\n"];
//        if(rangeEnd.location != NSNotFound) {
//            rangeEnd.location = 0;
//            rangeEnd.length = m3u8file.length-1;
//            m3u8file = [m3u8file substringWithRange:rangeEnd];
//        }
//        rangeEnd = [srcFile rangeOfString:@"\r"];
//        if(rangeEnd.location != NSNotFound) {
//            rangeEnd.location = 0;
//            rangeEnd.length = m3u8file.length-1;
//            m3u8file = [m3u8file substringWithRange:rangeEnd];
//        }
//        
//        [videolists setObject:m3u8file forKey:filename];
//        
//        
//    }while (fgets(VideoPath, 200, file));
//    
//    fclose(file);
//}
//
//- (void)loadLocalVideo
//{
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [pathArray objectAtIndex:0];
//    
//    NSMutableArray* video_extension = [[NSMutableArray alloc] init];
//    [video_extension addObject:@"mp4"];
//    [video_extension addObject:@"mkv"];
//    [video_extension addObject:@"rmvb"];
//    [video_extension addObject:@"rm"];
//    [video_extension addObject:@"avs"];
//    [video_extension addObject:@"mpg"];
//    [video_extension addObject:@"3g2"];
//    [video_extension addObject:@"asf"];
//    [video_extension addObject:@"mov"];
//    [video_extension addObject:@"avi"];
//    [video_extension addObject:@"wmv"];
//    [video_extension addObject:@"flv"];
//    [video_extension addObject:@"m4v"];
//    [video_extension addObject:@"swf"];
//    [video_extension addObject:@"webm"];
//    [video_extension addObject:@"3gp"];
//    
//    for(NSString* ext in video_extension) {
//        
//        NSArray *filename = [self getFilenamelistOfType:ext
//                                            fromDirPath:docDir];
//        
//        for (NSString* name in filename) {
//            
//            NSMutableString* fullname = [NSMutableString stringWithString:docDir];
//            [fullname appendString:@"/"];
//            [fullname appendString:name];
//            
//            [videolists setObject:fullname forKey:name];
//        }
//    }
//    
//    datasource = [videolists allKeys];
//}
//
- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}


- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
