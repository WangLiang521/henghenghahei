//
//  NewNoteBookCell.h
//  YouXingWords
//
//  Created by sunzhaokai on 16/11/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@interface NewNoteBookCell : UITableViewCell


@property(nonatomic,retain)UILabel *nameLb;

@property (strong, nonatomic)  NoteModel *model;

@end
