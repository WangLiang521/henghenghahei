
//
//  PayChooseVC.m
//  LuoKeLock
//
//  Created by Apple on 2017/3/24.
//  Copyright © 2017年 com.jinyouapp. All rights reserved.
//

#import "PayChooseVC.h"
#import "InfoModel.h"
#import "PayTypeCell.h"

#ifdef DefineAliPay
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#endif

#ifdef DefineWeiXinPay
#import "WXApi.h"
#endif

#import "GDWXApiManager.h"

#import "CreatPayCodeVC.h"

@interface PayChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  InfoModel *selectedModel;


@property (strong, nonatomic)  NSMutableDictionary *parameters;

@end

@implementation PayChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    // Do any additional setup after loading the view.
    [self loadShuju];
    [self setUpTableView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallBack) name:@"aliPayComplete" object:nil];
    WS(weakSelf);
    [[NSNotificationCenter defaultCenter] addObserverForName:@"aliPayComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary * dict = note.object;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([dict[@"resultStatus"] integerValue] == 9000) {
                [MBProgressHUD showSuccess:@"支付成功"];
            }else{
                [MBProgressHUD showError:@"支付失败"];
            }
        }
        [weakSelf payCallBack];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"weixinPayComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        PayResp *resp = note.object;
        if ([resp isKindOfClass:[PayResp class]]) {
            PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
            switch (response.errCode) {
                case WXSuccess:
                {// 支付成功，向后台发送消息
                    NSLog(@"支付成功");
                    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
                    [MBProgressHUD showError:@"支付成功"];
                }
                    break;
                case WXErrCodeCommon:
                { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                    [MBProgressHUD showError:@"支付失败"];
                    NSLog(@"支付失败");
                }
                    break;
                case WXErrCodeUserCancel:
                { //用户点击取消并返回
                    NSLog(@"取消支付");
                    [MBProgressHUD showError:@"取消支付"];
                }
                    break;
                case WXErrCodeSentFail:
                { //发送失败
                    NSLog(@"发送失败");
                    [MBProgressHUD showError:@"发送失败"];
                }
                    break;
                case WXErrCodeUnsupport:
                { //微信不支持
                    NSLog(@"微信不支持");
                    [MBProgressHUD showError:@"微信不支持"];
                }
                    break;
                case WXErrCodeAuthDeny:
                { //授权失败
                    NSLog(@"授权失败");
                    [MBProgressHUD showError:@"授权失败"];
                }
                    break;
                default:
                    break;
            }
        }

        [weakSelf payCallBack];
    }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallBack) name:@"weixinPayComplete" object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setUpNav{
    self.title = @"订单支付";
    
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)loadShuju{
    InfoModel * model1 = [InfoModel new];
    model1.titleBase = @"微信支付";
    model1.leftImageName = @"weixin";
    InfoModel * model2 = [InfoModel new];
    model2.titleBase = @"支付宝支付";
    model2.leftImageName = @"zhifubao1";
//    InfoModel * model3 = [InfoModel new];
//    model3.titleBase = @"微信二维码支付";
//    model3.leftImageName = @"fukuanma";
//    InfoModel * model4 = [InfoModel new];
//    model4.titleBase = @"支付宝二维码支付";
//    [self.dataArray addObjectsFromArray:@[model1,model2,model3,model4]];
     [self.dataArray addObjectsFromArray:@[model1,model2]];
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PayTypeCell" bundle:nil] forCellReuseIdentifier:@"PayTypeCell"];
    
    
    NSInteger fontSize = 16;
    UILabel * tableHeader = [UILabel new];
    tableHeader.font = [UIFont systemFontOfSize:fontSize];
    tableHeader.textAlignment = NSTextAlignmentCenter;
    
    NSString * price =[NSString stringWithFormat:@"总价:¥%0.2f",[_money doubleValue]];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:price];
    [attStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:fontSize + 4]} range:NSMakeRange(3, price.length - 3)];
    tableHeader.attributedText = attStr;
    tableHeader.frame = CGRectMake(0, 0, MainScreenWidth, 70);

    self.tableView.tableHeaderView = tableHeader;
    
    UILabel * lblFooter = [UILabel new];
    lblFooter.textColor = [UIColor whiteColor];
    lblFooter.backgroundColor = ColorNavBG;
    lblFooter.font = [UIFont systemFontOfSize:fontSize];
    lblFooter.textAlignment = NSTextAlignmentCenter;
    lblFooter.layer.cornerRadius = 5;
    lblFooter.layer.masksToBounds = YES;
    NSString * btnTitle = [NSString stringWithFormat:@"确认支付 ¥%0.2f",[_money doubleValue]];
    NSMutableAttributedString * attStrFooter = [[NSMutableAttributedString alloc] initWithString:btnTitle];
    [attStrFooter setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize + 4]} range:NSMakeRange(5, btnTitle.length - 5)];
    lblFooter.attributedText = attStrFooter;
    
    UIView * footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, MainScreenWidth, 70);
    [footerView addSubview:lblFooter];
    
    [lblFooter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footerView);
        make.width.mas_equalTo(MainScreenWidth - 40);
        make.height.mas_equalTo(40);
    }];
    
    
    self.tableView.tableFooterView = footerView;
    
    
    
//    点击付款
    [lblFooter tapBlock:^{
        [weakSelf getPayCode];
//        NSString * selectStr = weakSelf.selectedModel.titleBase;
//        if ([selectStr isEqualToString:@"微信支付"]) {
//            [weakSelf chooseWxPay];
//        }else if ([selectStr isEqualToString:@"支付宝支付"]) {
//            [weakSelf chooseAliPay];
//        }
    }];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    _selectedModel = self.dataArray[0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedModel = self.dataArray[indexPath.row];
}

- (void)getPayCode
{
    WS(weakSelf);
    NSString * payType = nil;
    NSString * payUrl = nil;
    NSString * selectStr = self.selectedModel.titleBase;
    if ([selectStr isEqualToString:@"微信支付"]) {
        payType = @"wx";
        payUrl = GDURL_OrderPay;
    }else if ([selectStr isEqualToString:@"支付宝支付"]) {
        payType = @"alipay";
        payUrl = GDURL_OrderPay;
    }else if ([selectStr isEqualToString:@"微信二维码支付"]) {
        payType = @"wx";
        payUrl = GDURL_GetQrCode;
        
    }else{
        payType = @"alipay";
        payUrl = GDURL_GetQrCode;
    }
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    parameters[@"id"] = self.orderNo;
//    parameters[@"phone"] = [LMUserInfo shareInstance].accountInfo.phone;
//    parameters[@"orderNo"] = [NSString stringWithFormat:@"%@",_orderNumber];
    parameters[@"channelType"] = payType;
    _parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    
    [LGDHttpTool POST:payUrl parameters:parameters success:^(NSDictionary *dictJSON) {
        NSLog(@"dictJSON = %@",dictJSON);
        
        if (dictJSON[@"status"] && [dictJSON[@"status"] integerValue] == 0) {
            
            hud.labelText = dictJSON[@"error"];
            
        }else if ([selectStr isEqualToString:@"微信支付"]) {
            NSString * sign = dictJSON[@"info"][@"sign"];
            NSDictionary * signInfo = [self dictionaryWithJsonString:sign];
            self.orderNumber = dictJSON[@"info"][@"orderNo"];
            _parameters[@"orderNo"] = self.orderNumber;
//            NSDictionary * signInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [weakSelf chooseWxPayWith:signInfo];
        }else if ([selectStr isEqualToString:@"支付宝支付"]) {
//            NSString * sign = dictJSON[@"info"][@"sign"];
//            NSDictionary * signInfo = [self dictionaryWithJsonString:sign];
            self.orderNumber = dictJSON[@"info"][@"orderNo"];
            _parameters[@"orderNo"] = self.orderNumber;
            NSDictionary * signInfo = @{@"info":dictJSON[@"info"][@"sign"]};
            [weakSelf chooseAliPayWith:signInfo];
        }else if ([selectStr isEqualToString:@"微信二维码支付"]) {
            [weakSelf chooseWXCodePayWith:dictJSON];
        }else{
            
        }
        
        [hud hide:YES afterDelay:0.5];
        hud.completionBlock = ^{};
    } failure:^(NSError *error) {
        
        [hud hide:YES afterDelay:0.5];
        hud.labelText = @"获取支付信息失败";
        hud.completionBlock = ^{};
        
        NSLog(@"error = %@",error);
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

- (void)chooseWXCodePayWith:(NSDictionary*)info{
//    CreatPayCodeVC * vc = [[CreatPayCodeVC alloc] initWithNibName:@"CreatPayCodeVC" bundle:nil];
//    vc.payUrl = info[@"codeUrl"];
//    vc.payType = @"微信";
//    vc.orderNo = self.orderNo;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseAliPayWith:(NSDictionary*)info{
    //将商品信息赋予AlixPayOrder的成员变量
    [[AlipaySDK defaultService] payOrder:info[@"info"] fromScheme:@"YouCanPayScheme" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (void)chooseWxPayWith:(NSDictionary*)info{
    PayReq *request =  [[PayReq alloc] init] ;
//    request.partnerId = @"10000100";
//    request.prepayId= @"1101000000140415649af9fc314aa427";
//    request.package = info[@""];
//    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
//    request.timeStamp= 1397527777;
//    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    request.partnerId = info[@"partnerid"];
    request.prepayId= info[@"prepayid"];
    request.package = info[@"package"];
    request.nonceStr= info[@"noncestr"];
//    NSString * timeStamp = [[LGDUtils getCurrentTimeString13] substringToIndex:10];
//    request.timeStamp= [timeStamp longLongValue];
    request.timeStamp= [info[@"timestamp"] doubleValue];
    request.sign= info[@"sign"];
    [WXApi sendReq:request];
    
    [[GDWXApiManager share] WXPayBlock:^(int code) {
        switch (code) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功");
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuchenggonghuidiao" object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [MBProgressHUD showError:@"支付失败"];
                NSLog(@"支付失败");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSLog(@"取消支付");
                [MBProgressHUD showError:@"取消支付"];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                [MBProgressHUD showError:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                [MBProgressHUD showError:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                [MBProgressHUD showError:@"授权失败"];
            }
                break;
            default:
                break;
        }

    }];
}

#pragma mark 支付回调
- (void)payCallBack{
    
    [LGDHttpTool POST:GDURL_OrderPayBack parameters:_parameters success:^(NSDictionary *dictJSON) {
        //        NSLog(@"%@",dictJSON);
        //        if ([dictJSON[@"status"]isEqual:@1]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTypeCell * cell = (PayTypeCell *)[tableView dequeueReusableCellWithIdentifier:@"PayTypeCell" forIndexPath:indexPath];
    [cell setDataWithModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}



@end
