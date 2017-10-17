//
//  PreferenceVC.m
//  YouXingWords
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PreferenceVC.h"
#import "Preference1Cell.h"
@interface PreferenceVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)CustomTitleView *titleView;//导航栏
@property(nonatomic,retain)UITableView *preTableView;//偏好tableView
@property(nonatomic,retain)NSArray *listArray;//偏好list数组
@end

@implementation PreferenceVC

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:self.title];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:self.title];
}

-(NSArray *)listArray
{
    if (!_listArray) {
        _listArray=@[@"是否包含拼写题",@"是否包含发音练习",@"做题提示音是否播放",@"是否播放单词发音",@"英音/美音",@"倒计时时间"];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加背景图片
    [self addBackgroundView];
    //添加表头
    [self addTitleView];
    //添加tableView
    [self addPreTableView];
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
    _titleView=[CustomTitleView customTitleView:@"偏好设置" rightTitle:@"" leftBtAction:^{
        //返回上一个页面
        [self.navigationController popViewControllerAnimated:YES];
    } rightBtAction:^{
       
    }];
    [self.view addSubview:_titleView];
}
#pragma mark ---添加tableView
-(void)addPreTableView
{
    _preTableView=[[UITableView alloc]initWithFrame:CGRectMake(AutoTrans(30), CGRectGetMaxY(_titleView.frame)+(AutoTrans(56)), SCREEN_WIDTH-(AutoTrans(60)), AutoTrans(94*6)) style:UITableViewStylePlain];
    _preTableView.layer.cornerRadius=10.f;
    _preTableView.layer.masksToBounds=YES;
    _preTableView.delegate=self;
    _preTableView.dataSource=self;
//    _preTableView.backgroundColor=[UIColor clearColor];
    _preTableView.bounces=NO;
    [self.view addSubview:_preTableView];
    
}

#pragma mark - dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoTrans(94);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (indexPath.row==0) {
        
        //start
#pragma mark gd_修改 Switch  2017-05-02 21:58:41
//        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)-(AutoTrans(80)), AutoTrans(22), AutoTrans(100), AutoTrans(50))];
        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(0,0, AutoTrans(100), AutoTrans(50))];
        aSwitch.onTintColor=[UIColor colorWithHexString:@"#39b7e5"];
        aSwitch.tag=1000;
        aSwitch.on = YES;
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        if ([df objectForKey:@"NoSpell"]) {
            if ([[df objectForKey:@"NoSpell"]isEqualToNumber:@1]) {
                aSwitch.on = NO;
            }
        }
        [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        [cell addSubview:aSwitch];
        cell.accessoryView = aSwitch;
        //end
        
     
        cell.textLabel.text=self.listArray[0];
    }
    else if (indexPath.row==1)
    {
        //start
#pragma mark gd_修改 Switch  2017-05-02 21:58:41
//        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)-(AutoTrans(80)), AutoTrans(22), AutoTrans(100), AutoTrans(50))];
        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(0,0, AutoTrans(100), AutoTrans(50))];
        aSwitch.onTintColor=[UIColor colorWithHexString:@"#39b7e5"];
        aSwitch.tag=1001;
        aSwitch.on = YES;
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        if ([df objectForKey:@"NoPronunciation"]) {
            if ([[df objectForKey:@"NoPronunciation"]isEqualToNumber:@1]) {
                aSwitch.on = NO;
            }
        }
        [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        [cell addSubview:aSwitch];
        cell.accessoryView = aSwitch;
        //end
        cell.textLabel.text=self.listArray[1];
    }
    else if (indexPath.row==2)
    {
        //start
#pragma mark gd_修改 Switch  2017-05-02 21:58:41
        //        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)-(AutoTrans(80)), AutoTrans(22), AutoTrans(100), AutoTrans(50))];
        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(0,0, AutoTrans(100), AutoTrans(50))];
        aSwitch.onTintColor=[UIColor colorWithHexString:@"#39b7e5"];
        aSwitch.tag=1002;
        aSwitch.on = YES;
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        if ([df objectForKey:@"AlertNotPlay"]) {
            if ([[df objectForKey:@"AlertNotPlay"]isEqualToNumber:@1]) {
                aSwitch.on = NO;
            }
        }
        [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        //        [cell addSubview:aSwitch];
        cell.accessoryView = aSwitch;
        //end
        cell.textLabel.text=self.listArray[2];
    }
    else if (indexPath.row==3)
    {
        //start
#pragma mark gd_修改 Switch  2017-05-02 21:58:41
        //        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)-(AutoTrans(80)), AutoTrans(22), AutoTrans(100), AutoTrans(50))];
        UISwitch  *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(0,0, AutoTrans(100), AutoTrans(50))];
        aSwitch.onTintColor=[UIColor colorWithHexString:@"#39b7e5"];
        aSwitch.tag=1003;
        aSwitch.on = YES;
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        if ([df objectForKey:@"WordNotPlay"]) {
            if ([[df objectForKey:@"WordNotPlay"]isEqualToNumber:@1]) {
                aSwitch.on = NO;
            }
        }
        [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        //        [cell addSubview:aSwitch];
        cell.accessoryView = aSwitch;
        //end
        cell.textLabel.text=self.listArray[3];
    }
    else if (indexPath.row==4)
    {
        cell.textLabel.text=self.listArray[indexPath.row];
        cell.detailTextLabel.text=@"英音";
        cell.detailTextLabel.font=[UIFont systemFontOfSize:AutoTrans(24)];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row==5)
    {
        cell.textLabel.text=self.listArray[indexPath.row];
        cell.detailTextLabel.text=@"10秒";
        cell.detailTextLabel.font=[UIFont systemFontOfSize:AutoTrans(24)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        if ([df valueForKey:@"waitingTime"]) {
            if ([[df valueForKey:@"waitingTime"]isEqualToNumber:@6]) {
                [df setValue:@8 forKey:@"waitingTime"];
            }
            else if ([[df valueForKey:@"waitingTime"]isEqualToNumber:@8]) {
                [df setValue:@10 forKey:@"waitingTime"];
            }
            else if([[df valueForKey:@"waitingTime"]isEqualToNumber:@10]) {
                [df setValue:@6 forKey:@"waitingTime"];
            }
        }else{
            [df setValue:@6 forKey:@"waitingTime"];
        }
        
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];

        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@秒",        [df valueForKey:@"waitingTime"]];
    }
}
#pragma mark - switch 事件
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"kai");
        switch (switchButton.tag) {
            case 1000:{
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setObject:@0 forKey:@"NoSpell"];
                break;
            }
            case 1001:{
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setObject:@0 forKey:@"NoPronunciation"];
                break;
            }
            case 1002:{
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setObject:@0 forKey:@"AlertNotPlay"];
                break;
            }
            case 1003:{
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setObject:@0 forKey:@"WordNotPlay"];
                break;
            }
                
                
            default:
                break;
        }
    }else {
    
            switch (switchButton.tag) {
                case 1000:{
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    [df setObject:@1 forKey:@"NoSpell"];
                    break;
                }
                case 1001:{
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    [df setObject:@1 forKey:@"NoPronunciation"];
                    break;
                }
                case 1002:{
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    [df setObject:@1 forKey:@"AlertNotPlay"];
                    break;
                }
                case 1003:{
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    [df setObject:@1 forKey:@"WordNotPlay"];
                    break;
                }
                    
                    
                default:
                    break;
            }
        NSLog(@"guan");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
