//
//  PronunciationCell.m
//  YouXingWords
//
//  Created by tih on 16/9/23.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "PronunciationCell.h"

@interface PronunciationCell ()
@property (nonatomic,retain)UIImageView *wordImgV;
//@property (nonatomic,retain)UITextView *resultView;
@property (nonatomic,retain)UILabel *EnLabel;
@property (nonatomic,retain)UILabel *ChLabel;
@property (nonatomic,retain)UIButton *isShowButton;

@end
@implementation PronunciationCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectZero];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = AutoTrans(20);
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(@(AutoTrans(40)));
            make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
            make.height.mas_equalTo(@(AutoTrans(500)));
        }];
        
        _wordImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _wordImgV.layer.masksToBounds = YES;
        _wordImgV.layer.cornerRadius = AutoTrans(20);
        _wordImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_wordImgV];
        [_wordImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(@(AutoTrans(40)));
            make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
            make.height.mas_equalTo(@(AutoTrans(500)));
        }];
        
        [_wordImgV tapBlock:^{
            [self isShowOnClick:nil];
        }];
        
        CGRect frameEn = CGRectMake(AutoTrans(40),  AutoTrans(530) , (SCREEN_WIDTH) - (AutoTrans(40)) , 80);
        _EnLabel = [[UILabel alloc]initWithFrame:frameEn];
        _EnLabel.textAlignment =1;
        _EnLabel.numberOfLines = 0;
        _EnLabel.adjustsFontSizeToFitWidth = YES;
        _EnLabel.textColor = [UIColor whiteColor];
        _EnLabel.font = [UIFont systemFontOfSize:AutoTrans(56)];
        [self addSubview:_EnLabel];
        WS(weakSelf);
        [_EnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_wordImgV.mas_bottom).offset((AutoTrans(30)));
            make.left.mas_equalTo(@(AutoTrans(40)));
            make.right.mas_equalTo(AutoTrans(-40));
//            make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
//            make.height.mas_equalTo(@(AutoTrans(120)));
        }];
        _EnLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
//        NSLineBreakByWordWrapping = 0,     	// Wrap at word boundaries, default
//        NSLineBreakByCharWrapping,		// Wrap at character boundaries
//        NSLineBreakByClipping,		// Simply clip
//        NSLineBreakByTruncatingHead,	// Truncate at head of line: "...wxyz"
//        NSLineBreakByTruncatingTail,	// Truncate at tail of line: "abcd..."
//        NSLineBreakByTruncatingMiddle	// Truncate middle of line:  "ab...yz"
        
        [_EnLabel tapBlock:^{
            [self isShowOnClick:nil];
        }];
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
//        _EnLabel.attributedText = [[NSAttributedString alloc]initWithString:_EnLabel.text attributes:attributes];
        
        
        
        
        
        _ChLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _ChLabel.textAlignment =1;
        _ChLabel.textColor = [UIColor whiteColor];
        _ChLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
        [self addSubview:_ChLabel];
        [_ChLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_EnLabel.mas_bottom).offset((AutoTrans(30)));
            make.left.mas_equalTo(@(AutoTrans(40)));
            make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
            make.height.mas_equalTo(@(AutoTrans(100)));
        }];
        
        [_ChLabel tapBlock:^{
            [self isShowOnClick:nil];
        }];
        
        //start
#pragma mark gd_点击例句或者图片或者单词直接再次发音  2017-03-22 21:28:13
//        _isShowButton = [[UIButton alloc]initWithFrame:CGRectZero];
//        [_isShowButton addTarget:self action:@selector(isShowOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_isShowButton setTitle:@"Word" forState:UIControlStateNormal];
//        _isShowButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
//        [_isShowButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        [self addSubview:_isShowButton];
//        [_isShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_ChLabel.mas_bottom).offset((AutoTrans(30)));
//            make.left.mas_equalTo(@(AutoTrans(40)));
//            make.width.mas_equalTo(@(SCREEN_WIDTH-(AutoTrans(40*2))));
//            make.height.mas_equalTo(@(AutoTrans(100)));
//        }];
        //end
        

    }
    return self;
}


-(void)setItem:(PronunciationModel *)item{
    _item = item;
    
    
//    UIImage * image = [UIImage imageWithContentsOfFile:_item.imgPath];
//    if (!image) {
//        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@.jpg",_item.imgPath]];
//    }
//    if (!image) {
//        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@.png",_item.imgPath]];
//    }
    _wordImgV.image = [UIImage imageWithContentsOfFile:_item.imgPath];
//    _wordImgV.image = image;
    NSString * enString = _item.ENString;
//    NSString * enString = @"`";
//    NSString * enString = @"May I speak with your daughter? ";
    
//    NSString * enString = @"May I speak with your daughter?";//复制的 .json
//    NSString * enString = @"May I speak with your daughter? ";//复制的 .json
//    NSString * enString = @"May I speak with your daughter? ";//复制的 .json
    enString = [enString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray * array = @[@".  ",@" ",@"，",@"。",@"！",@" ，",@" 。",@" ！",@"， ",@"。 ",@"！ ",@" ,",@" .",@" !",@", ",@". ",@"! ",@", ",@"  ",@"  ",@"  ",@"  ",@"\n",@"\t",@" ",@"ˈ"];
    NSArray * replc = @[@".",@" ",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@".",@"!",@",",@" ",@" ",@" ",@" ",@"",@"",@" ",@"'"];
    
    int notContaion = 50;
    while (notContaion) {
        
        notContaion --;

        
        for (int i = 0; i < array.count; i ++) {
//            if ([array[i] isEqualToString:@", "] ) {
//                NSLog(@"array[i] = \"%@\"",array[i]);
//            }
//            
//            if ([array[i] isEqualToString:@"。"] ) {
//                NSLog(@"array[i] = \"%@\"",array[i]);
//            }
            [NSString stringWithFormat:@"\"%@\"",replc[i]];
            //            NSString * str = [NSString stringWithFormat:@"\"%@\"",[strAnswerPronunciation substringWithRange:NSMakeRange(18, 2)]];
            NSString * str = array[i];
            NSRange range = [enString rangeOfString:str];
            if (range.location != NSNotFound) {
                
                enString = [enString stringByReplacingCharactersInRange:range withString:replc[i]];
            }
        }
        
        
    }
//    _EnLabel.text = @"ss";
    
//    CGFloat height = [LGDUtils getHeightFromLabel:_EnLabel withWidth: (SCREEN_WIDTH) - (AutoTrans(40))];
//    NSLog(@"height1 = %f",height);
    
//    enString = [enString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _EnLabel.text = enString;
    [_EnLabel sizeToFit];

//    height = [LGDUtils getHeightFromLabel:_EnLabel withWidth: (SCREEN_WIDTH) - (AutoTrans(40))];
//    NSLog(@"height2 = %f",height);
    
    _ChLabel.text = _item.CHString;
    _isShowButton.userInteractionEnabled = YES;
    [_isShowButton setTitle:@"Word" forState:UIControlStateNormal];
}

-(void)isShowOnClick:(id)sender{
//    button.userInteractionEnabled = NO;
//    [button setTitle:_item.word forState:UIControlStateNormal];
    
    if (self.block) {
        self.block();
    }
}



@end
