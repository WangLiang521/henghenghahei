//
//  UserInfoVC.m
//  YouXingWords
//
//  Created by tih on 16/11/1.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoFirstCell.h"
#import "MyCell.h"
#import "ModifyVC.h"
#import "ChangePasswordVC.h"
@interface UserInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)CustomTitleView *titleView;//导航栏
@property(nonatomic,retain)UITableView *myTableView;//tableView
@property(nonatomic,copy)NSDictionary *userInfoDic;//个人信息字典
@property(nonatomic,retain)NSArray *imageArray;
@property(nonatomic,retain)NSArray *contentArray;
@property(nonatomic,retain)NSMutableArray *detailArray;
@property(nonatomic,retain)NSArray *keyArray;
@end

@implementation UserInfoVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = YES;
    //获取个人信息
    [self getUserInfo];
    [_myTableView reloadData];
    
    
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=@[@[@"icon_name_me",@"icon_passsward_me",@"icon_zhanghao_me",@"icon_meng_me"],@[@"icon_area_me",@"icon_school_me",@"icon_grade_me",@"icon_phone_me",@"icon_other_me"]];
    }
    
    return _imageArray;
}
-(NSArray *)contentArray
{
    if (!_contentArray) {
        _contentArray=@[@[@"姓名",@"修改密码",@"优行账号",@"加盟校"],@[@"地区",@"学校",@"年级",@"手机号",@"其他联系方式"]];
    }
    return _contentArray;
}
-(NSMutableArray *)detailArray{
    if (!_detailArray) {
        NSString * name = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"name"]]?[_userInfoDic valueForKey:@"name"]:@"";
        NSString * username = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"username"]]?[_userInfoDic valueForKey:@"username"]:@"";
        NSString * jmSchName = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"jmSchName"]]?[_userInfoDic valueForKey:@"jmSchName"]:@"";
        NSString * address = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"address"]]?[_userInfoDic valueForKey:@"address"]:@"";
        NSString * schName = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"schName"]]?[_userInfoDic valueForKey:@"schName"]:@"";
        NSString * className = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"className"]]?[_userInfoDic valueForKey:@"className"]:@"";
        NSString * telphone = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"telphone"]]?[_userInfoDic valueForKey:@"telphone"]:@"";
        NSString * phone2 = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"phone2"]]?[_userInfoDic valueForKey:@"phone2"]:@"";
        NSArray * array0 = [NSMutableArray arrayWithArray:@[name,@" ",username,jmSchName]];
        NSArray * array1 = [NSMutableArray arrayWithArray:@[address,schName,className,telphone,phone2]];
        NSArray * array = @[array0,array1];
        _detailArray = [NSMutableArray arrayWithArray:array];
    }
    return _detailArray;
}
-(NSArray*)keyArray{
    if (!_keyArray) {
        _keyArray = @[@[@"name",@" ",@"username",@"jmSchName"],@[@"address",@"schName",@"className",@"telphone",@"phone2"]];
    }
    return _keyArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //解决导航栏坐标问题
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackgroundView];
    [self addTitleView];
    [self addMyTableView];
    // Do any additional setup after loading the view.
}
#pragma mark---获取个人信息
-(void)getUserInfo
{
    _userInfoDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
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
    _titleView=[CustomTitleView customTitleView:@"我的资料" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
        
    }];
    [self.view addSubview:_titleView];
}
#pragma mark---添加tableView
-(void)addMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH-(AutoTrans(60)), SCREEN_HEIGHT-CGRectGetMaxY(_titleView.frame)-(AutoTrans(10))) style:UITableViewStyleGrouped];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    _myTableView.bounces=NO;
    _myTableView.backgroundColor=[UIColor clearColor];
    _myTableView.showsVerticalScrollIndicator=NO;
   
    
    [self.view addSubview:_myTableView];
    
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
        return 4;
    }
    else
    {
        return 5;
    }
}
#pragma mark --返回每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID=@"UserInfoFirstCell";
        UserInfoFirstCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UserInfoFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
      
            //头像
            NSURL *iconImgUrl=[NSURL URLWithString:_userInfoDic[@"signPhoto"]];
            UIImage *placeholderImage=[UIImage imageNamed:@"message_icon_default"];
            [cell.headerImg sd_setImageWithURL:iconImgUrl placeholderImage:placeholderImage];
            
        
        //头像添加点击手势
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        [cell.headerImg addGestureRecognizer:tap];
        
        
        NSString * name = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"name"]]?[_userInfoDic valueForKey:@"name"]:@"";
        NSString * username = [LGDUtils isValidStr:[_userInfoDic valueForKey:@"username"]]?[_userInfoDic valueForKey:@"username"]:@"";
        //名称
        cell.nameLab.text=[NSString stringWithFormat:@"%@",name];
        //手机号
        cell.phoneLab.text=[NSString stringWithFormat:@"%@",username];
        [cell.phoneLab sizeToFit];
        
        return cell;
    }
    else
    {
        if ((indexPath.section==1&&(indexPath.row==0||indexPath.row==1))||(indexPath.section==2&&(indexPath.row==0||indexPath.row==1||indexPath.row==4))) {
            static NSString *cellID2=@"cellID";
            MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
            if (cell==nil) {
                cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentLable.text=self.contentArray[indexPath.section-1][indexPath.row];
            cell.detailLable.text = self.detailArray[indexPath.section-1][indexPath.row];
            cell.leftImage.image=[UIImage imageNamed:self.imageArray[indexPath.section-1][indexPath.row]];
            NSLog(@"%ld------%ld",indexPath.section,indexPath.row);
            cell.rightImage.hidden = NO;
            return cell;
        }
        else
        {
            static NSString *cellID=@"cellID";
            MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentLable.text=self.contentArray[indexPath.section-1][indexPath.row];
            cell.leftImage.image=[UIImage imageNamed:self.imageArray[indexPath.section-1][indexPath.row]];
            cell.detailLable.text = self.detailArray[indexPath.section-1][indexPath.row];

            cell.rightImage.hidden = YES;
            return cell;
        }
        
    }
    
}
#pragma mark---每组表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return AutoTrans(20);
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
    if (indexPath.section==0) {
        return;
    }
    if (indexPath.section==1&&(indexPath.row==1)) {
        ChangePasswordVC * vc = [[ChangePasswordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section==1&&(indexPath.row==2 || indexPath.row==3 )) {
        return;
    }
    if (indexPath.section==2&&indexPath.row==2) {
        return;
    }
    ModifyVC *modify = [[ModifyVC alloc]init];
    modify.titleString = [NSString stringWithFormat:@"修改%@",self.contentArray[indexPath.section-1][indexPath.row]];
    modify.contentKey = self.keyArray[indexPath.section-1][indexPath.row];
    modify.contentStr = self.detailArray[indexPath.section-1][indexPath.row];
    WS(weakSelf);
    modify.completeBlock = ^(NSString * content){
        weakSelf.detailArray[indexPath.section - 1][indexPath.row] = content;
        [weakSelf.myTableView reloadData];
    };
    [self.navigationController pushViewController:modify animated:YES];
    
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
