
//
//  PNCModel.h
//  YouXingWords
//
//  Created by tih on 16/9/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PronunciationModel : NSObject
@property (nonatomic,copy) NSString * CHString;
@property (nonatomic,copy) NSString * ENString;

@property (nonatomic,copy) NSString * explain;
@property (nonatomic,copy) NSString * word;

@property (nonatomic,copy) NSString * audioPath;
@property (nonatomic,copy) NSString * wordAudioPath;
@property (nonatomic,copy) NSString * imgPath;


@end
