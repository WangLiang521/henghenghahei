//
//  DakaView.m
//  YouXingWords
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "DakaView.h"

#import <UMSocialCore/UMSocialCore.h>
#import "TimerTools.h"

@interface DakaView ()


@property (weak, nonatomic) IBOutlet UIImageView *imageText;


@property (strong, nonatomic)  UIButton *btnFriends;
@property (strong, nonatomic)  UIButton *btnWeixin;
@property (strong, nonatomic)  UIButton *btnKongjian;
@property (strong, nonatomic)  UIButton *btnWeibo;

@property (strong, nonatomic)  UIViewController *CurrentVC;

@property (weak, nonatomic) IBOutlet UIImageView *imageDaka;

@property (weak, nonatomic) IBOutlet UIImageView *imageBack;

@end


@implementation DakaView

+(instancetype)shareWithCurrentVC:(UIViewController *)CurrentVC{
    DakaView * da = [[[NSBundle mainBundle] loadNibNamed:@"DakaView" owner:nil options:nil] lastObject];
    da.userInteractionEnabled = YES;
    da.CurrentVC = CurrentVC;
    return da;
}

- (void)setFailPic{
    self.imageDaka.image = [UIImage imageNamed:@"icon_error_head"];
    self.imageBack.image = [UIImage imageNamed:@"icon_error_base"];
}

- (void)otherInit{
    WS(weakSelf);
    
    
    UIView * contentView = [UIView new];
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageText.mas_bottom).mas_offset(GDAutoTrans(20));
        make.left.mas_equalTo(GDAutoTrans(27));
        make.right.mas_equalTo(GDAutoTrans(27));
    }];
    
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 888 + i;
        [contentView addSubview:button];
        CGFloat left = GDAutoTrans(45) * (i + 1) + GDAutoTrans(90) * i;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView);
            make.left.mas_equalTo(left);
            make.width.mas_equalTo(GDAutoTrans(90));
            make.height.mas_equalTo(GDAutoTrans(90));
        }];
        
        
        UILabel * label = [UILabel new];
        label.tag = 999 + i;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button);
            make.top.mas_equalTo(button.mas_bottom).mas_offset(GDAutoTrans(12));
            make.bottom.mas_equalTo(contentView);
        }];
        label.font = [UIFont systemFontOfSize:12 weight:1];
        label.textColor = [UIColor colorWithHexString:@"aab081"];
        label.textAlignment = NSTextAlignmentCenter;
        
        NSString * imageName = nil;
        NSString * labelText = nil;
        switch (i) {
            case 0:
            {
                imageName = @"barrier_icon_friend";
                labelText = @"朋友圈";
            }
                break;
                
            case 1:
            {
                imageName = @"barrier_icon_wx";
                labelText = @"微信";
            }
                break;
                
            case 2:
            {
                imageName = @"barrier_icon_zone";
                labelText = @"QQ";
            }
                break;
                
            case 3:
            {
                imageName = @"barrier_icon_weobo";
                labelText = @"新浪微博";
            }
                break;
                
            default:
                break;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapShare:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        label. text = labelText;
        [label sizeToFit];
    }
    
    
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan -- tapShare  tag =%zd",[touches anyObject].view.tag);
//    
//}

- (void)tapShare:(id)btn{
    

    UIButton *btnShare = (UIButton *)btn;
    
    UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
    NSInteger tag = btnShare.tag - 888;
    switch (tag) {
        case 0:
        {
             platformType = UMSocialPlatformType_WechatTimeLine;
        }
            break;
            
        case 1:
        {
             platformType = UMSocialPlatformType_WechatSession;
        }
            break;
            
        case 2:
        {
             platformType = UMSocialPlatformType_QQ;
        }
            break;
            
        case 3:
        {
             platformType = UMSocialPlatformType_Sina;
        }
            break;
            
        default:
            break;
    }
    
    
    if ([[UMSocialManager defaultManager] isSupport:platformType]) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage* thumbURL =  [UIImage imageNamed:@"icon_youxing"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"优行英语" descr:@"欢迎使用优行英语,学英语,so easy!" thumImage:thumbURL];
        //start
#pragma mark gd_修改计算学习时间的方式  2017-06-08 20:32:53
        //        NSString * todayTotalStudyTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"todayTotalStudyTime"];
        
        //                    计算学习时间
        NSString *timeStr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"studyTimeToday"];
        
        timeStr = [Utils isValidStr:timeStr]?timeStr:@"0";
        
        NSString *strBendi= [TimerTools getStudyTimeNew];
        
        NSInteger timeAll = [strBendi integerValue] + [timeStr integerValue];
        timeStr = [NSString stringWithFormat:@"%zd",timeAll];
        //end
        
        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//        NSNumber * createTim = @([userInfo[@"createTim"] integerValue]);
        NSNumber * creatTim = [[NSUserDefaults standardUserDefaults] objectForKey:KeySeriesSignDays];
        if (!creatTim) {
            creatTim = @(0);
        }
        NSString * currentTim = [LGDUtils getCurrentTimeString13];
        creatTim = @(currentTim.longLongValue - creatTim.longLongValue * 24*3600*1000);
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://jinyouapp.com/html5/ycanclock/index.html?createTim=%@&passNum=%@",timeStr,creatTim];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.CurrentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
//            [self alertWithError:error];
        }];
    }else{
//        未安装
        [MBProgressHUD showError:@"未安装"];
    }
    NSLog(@"tag = %zd",tag);

}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self otherInit];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self otherInit];
    }
    return self;
}





@end
