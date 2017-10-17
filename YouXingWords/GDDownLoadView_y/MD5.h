//
//  MD5.h
//  EasyWedding
//
//  Created by wangliang on 16/8/23.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5 : NSObject

/**
 *  MD5加密
 *
 *  @param inPutText 需要加密的字符串
 *
 *  @return 经过加密的字符串
 */
+(NSString *) md5: (NSString *) inPutText;

/**
 *  MD5加密
 *
 *  @param inPutText 需要加密的字符串
 *
 *  @return 经过加密的字符串(返回的字符串为小写)
 */
+(NSString *) md5lowercaseString: (NSString *) inPutText;

@end
