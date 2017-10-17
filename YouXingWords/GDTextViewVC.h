//
//  GDTextViewVC.h
//  BaiLifeShop
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CompleteBlock)(NSString * text);

#import "GDTextView.h"

@interface GDTextViewVC : BaseViewController

/**
 *  提交内容是否可以为空,默认 no
 */
@property (assign, nonatomic)  BOOL canEmpty;

@property (weak, nonatomic) IBOutlet UIButton *btnComplete;

@property (copy, nonatomic)  CompleteBlock completeBlock;

@property (strong, nonatomic) IBOutlet GDTextView *gdTextV;

+(instancetype)VCWithTittle:(NSString *)title placeHolder:(NSString *)placeHolder completeBlock:(CompleteBlock )completeBlock;

@property (copy, nonatomic)  NSString * text;

@property (copy, nonatomic)  NSString * saveUrl;
/**
 *   上传 key
 */
@property (copy, nonatomic)  NSString * key;


/**
 *  除了反馈内容之外的参数
 */
@property (strong, nonatomic)  NSMutableDictionary *otherParameters;

@end
