//
//  QsModel.m
//  YouXingWords
//
//  Created by LDJ on 16/8/29.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "QsModel.h"
/*
 @property (nonatomic,copy) NSString *qID;
 @property (nonatomic,copy) NSString *qType;
 @property (nonatomic,copy) NSString *qWord;
 @property (nonatomic,copy) NSString *qWordID;
 @property (nonatomic,copy) NSString *qAudio;
 @property (nonatomic,copy) NSString *qAnswer;
 @property (nonatomic,copy) NSString *qImage;
 
 @property (nonatomic,copy) NSString *qOptionA;
 @property (nonatomic,copy) NSString *qOptionB;
 @property (nonatomic,copy) NSString *qOptionC;
 @property (nonatomic,copy) NSString *qOptionD;
 
 @property (nonatomic,copy) NSString *qEgSpell;
 @property (nonatomic,copy) NSString *qEgCN;
 
 @property (nonatomic,copy) NSString *qExplain;
 
 @property (nonatomic,copy) NSString *qName;

 */
@implementation QsModel
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    QsModel *model = [[QsModel alloc]init];
    model.wordId = dic[@"wordId"];
    model.dic = dic;
    model.qID = [dic valueForKey:@"qId"];

//#pragma mark gd_题型6和题型3互换
    model.qType = [dic valueForKey:@"type"];

//    if ([model.qType integerValue]==3) {
//        model.qType = @(6);
//    }else if ([model.qType integerValue]==6) {
//        model.qType = @(3);
//    }


    model.qWord = [dic valueForKey:@"word"];
    model.qWordID = [dic valueForKey:@"wordId"];
    
    
    
    NSString * qAudio = [dic valueForKey:@"audio"];
    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],qAudio];
    if (clearAudioSpace && ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        qAudio  = [qAudio stringByReplacingOccurrencesOfString:@" " withString:@""];
        qAudio  = [qAudio stringByReplacingOccurrencesOfString:@"　" withString:@""];
        
        model.qAudio = qAudio;
    }else{
        model.qAudio = [dic valueForKey:@"audio"];
    }
    

    model.qImage = [dic valueForKey:@"image"];


    
    model.qEgSpell = [dic valueForKey:@"egSpell"];
    model.qEgCN = [dic valueForKey:@"egCN"];
    model.qExplain = [dic valueForKey:@"explain"];
    model.qName = [dic valueForKey:@"name"];
    #pragma mark gd_增加random字段,值为1时,选项随机
    model.random = [dic valueForKey:@"random"];

//    model.qOptionA = [dic valueForKey:@"A"];
//    model.qOptionB = [dic valueForKey:@"B"];
//    model.qOptionC = [dic valueForKey:@"C"];
//    model.qOptionD = [dic valueForKey:@"D"];
//
//
//    model.qExplainA = [dic valueForKey:@"explainA"];
//    model.qExplainB = [dic valueForKey:@"explainB"];
//    model.qExplainC = [dic valueForKey:@"explainC"];
//    model.qExplainD = [dic valueForKey:@"explainD"];
//
//    model.qAnswer = [dic valueForKey:@"answer"];

    NSNumber * random = [dic valueForKey:@"random"];

    if (random && [random integerValue] == 1) {
//if (0) {
#pragma mark gd_字典是无序的,以此做到随机

//        NSDictionary * dic = @{@"A":@"1",
//                               @"B":@"B",
//                               @"C":@"C",
//                               @"D":@"D",};
        NSMutableDictionary * dictSuiji = [NSMutableDictionary dictionary];
        dictSuiji[@"A"] = @"wrong";
        dictSuiji[@"B"] = @"wrong";
        dictSuiji[@"C"] = @"wrong";
        dictSuiji[@"D"] = @"wrong";

        NSString * keyAnswer = [dic valueForKey:@"answer"];
        dictSuiji[keyAnswer] = keyAnswer;

        NSArray * values = [dictSuiji allKeys];


        model.qOptionA = [dic valueForKey:values[0]];
        model.qOptionB = [dic valueForKey:values[1]];
        model.qOptionC = [dic valueForKey:values[2]];
        model.qOptionD = [dic valueForKey:values[3]];

        model.qExplainA = [dic valueForKey:[NSString stringWithFormat:@"explain%@",values[0]]];
        model.qExplainB = [dic valueForKey:[NSString stringWithFormat:@"explain%@",values[1]]];
        model.qExplainC = [dic valueForKey:[NSString stringWithFormat:@"explain%@",values[2]]];
        model.qExplainD = [dic valueForKey:[NSString stringWithFormat:@"explain%@",values[3]]];

        if (![dictSuiji[values[0]] isEqualToString:@"wrong"]) {
            model.qAnswer = @"A";
        }else if(![dictSuiji[values[1]] isEqualToString:@"wrong"]) {
            model.qAnswer = @"B";
        }else if(![dictSuiji[values[2]] isEqualToString:@"wrong"]) {
            model.qAnswer = @"C";
        }else  {
            model.qAnswer = @"D";
        }

    }else{

        model.qOptionA = [dic valueForKey:@"A"];
        model.qOptionB = [dic valueForKey:@"B"];
        model.qOptionC = [dic valueForKey:@"C"];
        model.qOptionD = [dic valueForKey:@"D"];


        model.qExplainA = [dic valueForKey:@"explainA"];
        model.qExplainB = [dic valueForKey:@"explainB"];
        model.qExplainC = [dic valueForKey:@"explainC"];
        model.qExplainD = [dic valueForKey:@"explainD"];

        model.qAnswer = [dic valueForKey:@"answer"];
    }




    return model;
}



- (NSString *)description{
    return [NSString stringWithFormat:@"%@ = %@",_qWord,_qWordID];
}










@end
