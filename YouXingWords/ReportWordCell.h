//
//  ReportWordCell.h
//  YouXingWords
//
//  Created by LDJ on 16/11/9.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReportCellBlock)();
@interface ReportWordCell : UITableViewCell
@property (nonatomic,copy)ReportCellBlock block;
@property (nonatomic,assign)BOOL isEven;
@property (nonatomic,assign)BOOL isRight;
@property (nonatomic,copy)NSString *word;
@property (nonatomic,copy)NSString *explain;
@end
