//
//  ChoiceCell.m
//  YouXingWords
//
//  Created by tih on 16/8/15.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChoiceCell.h"

@interface ChoiceCell()
@property (nonatomic,retain)UIImageView *choiceImgV;
@property (nonatomic,retain)UIImageView *isRightImgV;
@property (nonatomic,retain)UILabel *choiceLabel;

@end
@implementation ChoiceCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-20)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = AutoTrans(20);
        [self addSubview:whiteView];
        
        _choiceImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-4, self.bounds.size.height-20-4)];
        _choiceImgV.center = whiteView.center;
        _choiceImgV.layer.masksToBounds = YES;
        _choiceImgV.layer.cornerRadius = AutoTrans(15);
        _choiceImgV.contentMode = UIViewContentModeScaleAspectFit;
        [_choiceImgV setImage:[UIImage imageNamed:@"barrier_icon_pic4"]];
        [self addSubview:_choiceImgV];
        
        _choiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_choiceImgV.frame), self.bounds.size.width, 20)];
        _choiceLabel.text = @" ";
        _choiceLabel.textColor = [UIColor colorWithHexString:@"#37777e"];
        _choiceLabel.font = [UIFont systemFontOfSize:FontSizeAnswerText - 2];
        _choiceLabel.textAlignment =1;
        [self addSubview:_choiceLabel];
        
        _isRightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AutoTrans(130), AutoTrans(130))];
        _isRightImgV.center = _choiceImgV.center;
        _isRightImgV.hidden = YES;
        [_isRightImgV setImage:[UIImage imageNamed:@"barrier_icon_right"]];
        [self addSubview:_isRightImgV];
    }
    return self;
}
-(void)setItem:(ChioceModel *)item{
    [super setItem:item];
//    NSString *str = [NSString stringWithFormat:@"Documents/%@",[Utils getResFolder]];
    
//    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:str],item.imgPath];
    NSString *path;
    path = [Utils getImageFolderWithQImage:item.imgPath];
    NSString * pathNOJpg = [path stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    NSString * pathNOPng = [path stringByReplacingOccurrencesOfString:@".png" withString:@""];
    if (clearProImageSpace && ![[NSFileManager defaultManager] fileExistsAtPath:path] && ![[NSFileManager defaultManager] fileExistsAtPath:pathNOJpg] && ![[NSFileManager defaultManager] fileExistsAtPath:pathNOPng] ) {
        NSString * strPath = item.imgPath;
        strPath  = [strPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        strPath  = [strPath stringByReplacingOccurrencesOfString:@"　" withString:@""];
        path = [Utils getImageFolderWithQImage:strPath];
    }
    
    item.imgPath = path;
    [self.choiceImgV setImage:[UIImage imageWithContentsOfFile:path]];
    self.choiceLabel.text = item.title;
}
-(void)didSelected{
    [_isRightImgV setImage:[UIImage imageNamed:@"barrier_icon_right"]];

    _isRightImgV.hidden = NO;
}
-(void)resetGreen{
//    self.backgroundColor = [UIColor whiteColor];

    [_isRightImgV setImage:[UIImage imageNamed:@"barrier_icon_right"]];

    _isRightImgV.hidden = YES;
}
-(void)setWrong{
    _isRightImgV.image = [UIImage imageNamed:@"barrier_icon_wrong"];
    _isRightImgV.hidden = NO;

}
-(void)toGray{
//    self.backgroundColor = [UIColor grayColor];
}
@end
