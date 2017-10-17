//
//  PKResultCell.h
//  YouXingWords
//
//  Created by wangliang on 16/11/22.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PKResultModel.h"

@interface PKResultCell : UITableViewCell

- (void)setDataWithModel:(PKResultModel *)model indexPath:(NSIndexPath *)indexPath;


@end
