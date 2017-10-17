//
//  GDConfig.h
//  YouXingWords
//
//  Created by Apple on 2017/3/11.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#ifndef GDConfig_h
#define GDConfig_h

#import "GDEasySetting.h"

//#define TestWord @"o'clock"
#define TestWord @""
#define TestType @""

//支付
//#define DefineAliPay
#define DefineWeiXinPay

#define KeyWeiXinPay @"wx306fdb5e0b6400c7"
//本地 key 用户连续签到天数
#define KeySeriesSignDays [NSString stringWithFormat:@"%@KeySeriesSignDays",[Utils getCurrentUserName]]

/**
 *  是否启用 bugly
 */
#define Define_BUGLY
//#undef Define_BUGLY

//宽度高度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

#define KeyBookInfoList @"KeyBookInfoList"













/**
 *  压缩包类型
 */
//#define ArchiveType @"zip"
#define ArchiveType @"7z"

#define ColorNav @"#36b6e6"
#define ColorNavBG [UIColor colorWithHexString:@"36b6e6"]
#define ColorRegisterVC [UIColor colorWithHexString:@"36b6e6"]
#define ColorBaseBGGray [UIColor colorWithHexString:@"eeeeee"]

#ifdef DEBUG

#define TestUserName @"00000000000"

// Debug 模式的代码...
// Debug 模式的代码...
// Debug 模式的代码...
// Debug 模式的代码...

//选词后每一关最少单词数
#define lestWordsCount 1

/**
 *  答对4道题,不在出现  答对次数可配置
 */
#define notShowRightCount 4//4
/**
 *  答对4道题,不在出现  是否可以在复习关执行  默认复习关不删词  //0
 */
#define notShowRightCountIfFuxiguan  0

/**
 *  是否清除 txt/wordInfos.json 中的 audio 路径中的空格 发音联系中,audio 路径的空格   默认清除
 */
#define clearAudioSpace  1  //1

/**
 *  是否清除 txt/wordInfos.json 中的 image 路径中的空格  发音联系中,图片路径的空格  默认清除
 */
#define clearProImageSpace  1  //1

/**
 *  是否清除 txt/wordInfos.json 中的 image 路径中的空格  发音联系中,图片的空格  默认清除
 */
#define clearBreakthroughImageSpace  1  //1

/**
 *  过关z数 : 做对几个题会跳到答题成功页面 默认为极大值 // MAXFLOAT 不得小于1 1//
 */
#define PassSuccessAfterQsIndex [GDEasySetting share].PassSuccessCount// MAXFLOAT

///**
// *  做错1题直接失败 默认不直接失败 0
// */
//#define PassFailAfterOneQs 0//0

/**
 *  存在复习关的情况下,是否解锁下一关,当前默认不解锁 0
 */
#define  ShouleUnLockNextIfHasFuxiguan 0//0



/**
 *  复习关 : 错题超过8个将会出复习关,最小1 ,当前要求为9个
 */
#define CountWrongWordsCallFuxi 8//8

/**
 *  复习关 : 是否题目随机 默认1
 */
#define  SuijiFuxiguanQS 0//1


/**
 *  秒转分钟的计算方法,大于此数 进1 最小为0 默认：0
 */
#define MinuteJin1 0 // 0
#define MinuteJia1IfMoreThan(x) ((x) > MinuteJin1 ? 1:0)


/**
 *  复习关 passId
 */
#define FuxiPassId 0

/**
 *  循环上传学习时间的间隔(单位s)
 */
#define LoopTime (5*60)//(5*60)


/**
 *  答案字体大小
 */
#define FontSizeAnswerText 19


#else

#define TestUserName @"18560126362"
// Release 模式的代码...
// Release 模式的代码...
// Release 模式的代码...
// Release 模式的代码...

//选词后每一关最少单词数
#define lestWordsCount 5

/**
 *  答对4道题,不在出现  答对次数可配置
 */
#define notShowRightCount 4//4
/**
 *  答对4道题,不在出现  是否可以在复习关执行  默认复习关不删词  //0
 */
#define notShowRightCountIfFuxiguan  0

/**
 *  是否清除 txt/wordInfos.json 中的 audio 路径中的空格 发音联系中,audio 路径的空格   默认清除
 */
#define clearAudioSpace  1  //1

/**
 *  是否清除 txt/wordInfos.json 中的 image 路径中的空格  发音联系中,图片路径的空格  默认清除
 */
#define clearProImageSpace  1  //1

/**
 *  是否清除 txt/wordInfos.json 中的 image 路径中的空格  发音联系中,图片的空格  默认清除
 */
#define clearBreakthroughImageSpace  1  //1

/**
 *  过关z数 : 做对几个题会跳到答题成功页面 默认为极大值 // MAXFLOAT 不得小于1 1//
 */
#define PassSuccessAfterQsIndex [GDEasySetting share].PassSuccessCount// [GDEasySetting share].PassSuccessCount

///**
// *  做错1题直接失败 默认不直接失败 0
// */
//#define PassFailAfterOneQs 0//0

/**
 *  存在复习关的情况下,是否解锁下一关,当前默认不解锁 0
 */
#define  ShouleUnLockNextIfHasFuxiguan 0//0



/**
 *  复习关 : 错题超过8个将会出复习关,最小1 ,当前要求为9个
 */
#define CountWrongWordsCallFuxi 8//8

/**
 *  复习关 : 是否题目随机 默认1
 */
#define  SuijiFuxiguanQS 1//1


/**
 *  秒转分钟的计算方法,大于此数 进1 最小为0 默认：0
 */
#define MinuteJin1 0 // 0
#define MinuteJia1IfMoreThan(x) ((x) > MinuteJin1 ? 1:0)


/**
 *  复习关 passId
 */
#define FuxiPassId 0

/**
 *  循环上传学习时间的间隔(单位s)
 */
#define LoopTime (5*60)//(5*60)


/**
 *  答案字体大小
 */
#define FontSizeAnswerText 19



#endif




#define GDAutoTrans(x) (([UIScreen mainScreen].bounds.size.width * 1.0 / 750) * (x))



#define UMSocial_UmSocial_Appkey @"587ee483ae1bf87faa000a7a"

#define UMSocial_Sina_appkey @"1764719427"
#define UMSocial_Sina_appSecret @"b7649e5e4bc49102e92db90555f727dc"
#define UMSocial_Sina_redirectURL @"sns.whalecloud.com"

#define UMSocial_Wx_appkey @"wx306fdb5e0b6400c7"
#define UMSocial_Wx_appSecret @"8796a15c2687747723f08fb3b21e47e0"
#define UMSocial_Wx_redirectURL @"http://mobile.umeng.com/social1"

#define UMSocial_QQ_appkey @"1105971581"
#define UMSocial_QQ_appSecret @"o5uIRHHgeZ3j9wqo"
#define UMSocial_QQ_redirectURL @"sns.whalecloud.com"

#define BUGLY_APP_ID @"60bd957c9b"

#endif /* GDConfig_h */
