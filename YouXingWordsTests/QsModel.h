//
//  QsModel.h
//  YouXingWords
//
//  Created by LDJ on 16/8/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QsModel : NSObject
@property (nonatomic,retain) NSNumber *qID;
@property (nonatomic,retain) NSNumber *qType;
@property (nonatomic,copy) NSString *qWord;
@property (nonatomic,retain) NSNumber *qWordID;


@property (nonatomic,copy) NSString *random;

@property (nonatomic,copy) NSString *qAudio;
@property (nonatomic,copy) NSString *qAnswer;
@property (nonatomic,copy) NSString *qImage;

@property (nonatomic,copy) NSString *qOptionA;
@property (nonatomic,copy) NSString *qOptionB;
@property (nonatomic,copy) NSString *qOptionC;
@property (nonatomic,copy) NSString *qOptionD;

@property (nonatomic,copy) NSString *qExplainA;
@property (nonatomic,copy) NSString *qExplainB;
@property (nonatomic,copy) NSString *qExplainC;
@property (nonatomic,copy) NSString *qExplainD;

@property (nonatomic,copy) NSString *qEgSpell;
@property (nonatomic,copy) NSString *qEgCN;

@property (nonatomic,copy) NSString *qExplain;

@property (nonatomic,copy) NSString *qName;

@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,assign)BOOL isNOTShow;

@property (strong, nonatomic)  NSNumber *wordId;

@property (nonatomic,retain)NSDictionary *dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
