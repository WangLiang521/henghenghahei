//
//  ChooseResCell.m
//  YouXingWords
//
//  Created by tih on 16/9/19.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ChooseResCell.h"
#import "GDDownLoadView.h"

@interface ChooseResCell()
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *descriptionLabel;
@property (nonatomic,retain)UIImageView *checkImg;
@property (nonatomic,retain)UIView *downView;

@property (nonatomic,retain)GDDownLoadView *downLoadView;

//@property (copy, nonatomic)  UILabel *  lblStatus;
@property (copy, nonatomic)  UIButton *  lblStatus;

@end
@implementation ChooseResCell

-(void)setFrame:(CGRect)frame{
    frame.size.width =SCREEN_WIDTH-( AutoTrans(30))*2;
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
//        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        CGRect frameNameLbl = CGRectMake(AutoTrans(36), AutoTrans(30), AutoTrans(500), AutoTrans(40));
//        _nameLabel = [[UILabel alloc]initWithFrame:frameNameLbl];
//        _nameLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
////        [_nameLabel sizeToFit];
//        [self addSubview:_nameLabel];
//        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36),CGRectGetMaxY(_nameLabel.frame)+(AutoTrans(10)), AutoTrans(500), AutoTrans(40))];
//        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//        _descriptionLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
//        //_titleLabel.text = @"hahahah";
//        [self addSubview:_descriptionLabel];
//        CGRect frame = CGRectMake(self.frame.size.width-(AutoTrans(62))-(AutoTrans(36)), AutoTrans(45), AutoTrans(62),AutoTrans(62));
//        _checkImg = [[UIImageView alloc]initWithFrame:frame];
//        _checkImg.image =nil;
//        [self addSubview:_checkImg];
//        CGFloat xStatus = CGRectGetMaxX(frameNameLbl) + 5;
//        CGFloat wStatus  = SCREEN_WIDTH - xStatus - 5 - ( AutoTrans(62));
//        CGRect frameStatus = CGRectMake(AutoTrans(xStatus),  AutoTrans(30), wStatus, AutoTrans(40));
//        _lblStatus = [[UILabel alloc] initWithFrame:frameStatus];
//        _lblStatus.text = @"下载";
//        
////        self.downView = [UIView new];
////        self.downView.frame = frame;
////        self.downView.backgroundColor = [UIColor whiteColor];
////        [self addSubview:self.downView];
////        _downLoadView = [[GDDownLoadView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        [self.downView addSubview:_downLoadView];
////        
//        
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36), AutoTrans(153)-1, self.frame.size.width-(AutoTrans(36))*2, 1)];
//        label.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
//        [self addSubview:label];
        
        WS(weakSelf);
        
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        CGRect frameNameLbl = CGRectMake(AutoTrans(36), AutoTrans(30), AutoTrans(500), AutoTrans(40));
        _nameLabel = [[UILabel alloc]initWithFrame:frameNameLbl];
        _nameLabel.font = [UIFont systemFontOfSize:AutoTrans(35)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        //        [_nameLabel sizeToFit];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(AutoTrans(36));
            make.height.mas_equalTo(AutoTrans(40));
            make.top.mas_equalTo(AutoTrans(30));
//            make.width.mas_equalTo(AutoTrans(250));
//            make.left.mas_equalTo(AutoTrans(36));
        }];
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36),CGRectGetMaxY(_nameLabel.frame)+(AutoTrans(10)), AutoTrans(500), AutoTrans(40))];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _descriptionLabel.font = [UIFont systemFontOfSize:AutoTrans(30)];
        //_titleLabel.text = @"hahahah";
        [self addSubview:_descriptionLabel];
        CGRect frame = CGRectMake(self.frame.size.width-(AutoTrans(62))-(AutoTrans(36)), AutoTrans(45), AutoTrans(62),AutoTrans(62));
        _checkImg = [[UIImageView alloc]initWithFrame:frame];
        _checkImg.image =nil;
        [self addSubview:_checkImg];
//        CGFloat xStatus = CGRectGetMaxX(frameNameLbl) + 5;
//        CGFloat wStatus  = SCREEN_WIDTH - xStatus - 5 - ( AutoTrans(62));
//        CGRect frameStatus = CGRectMake(AutoTrans(xStatus),  AutoTrans(30), wStatus, AutoTrans(40));
//        _lblStatus = [[UILabel alloc] initWithFrame:frameStatus];
//        _lblStatus.text = @"下载";
//        [self addSubview:_lblStatus];
//        _lblStatus.textColor = [UIColor colorWithHexString:@"333333"];
//        _lblStatus.textAlignment = NSTextAlignmentRight;
//        
//        [_lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(5);
//            make.centerY.mas_equalTo(weakSelf.nameLabel.mas_centerY);
//            make.height.mas_equalTo(weakSelf.nameLabel);
//            make.right.mas_equalTo(-(AutoTrans(62)) - 25);
//        }];
        
        _lblStatus = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lblStatus.text = @"下载";
        [self addSubview:_lblStatus];
//        _lblStatus.textColor = [UIColor colorWithHexString:@"333333"];
        _lblStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
        _lblStatus.font = [UIFont systemFontOfSize:15];
        [_lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(weakSelf.nameLabel.mas_centerY);
            make.height.mas_equalTo(weakSelf.nameLabel);
            make.right.mas_equalTo(-(AutoTrans(62)) - 25);
            make.width.mas_equalTo(100);
        }];
        [_lblStatus setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateHighlighted];
        
        
        [_lblStatus tapBlock:^{
            
            if (weakSelf.tapFileBlock) {
                weakSelf.tapFileBlock(_lblStatus.currentTitle);
            }
        }];
        
        //        self.downView = [UIView new];
        //        self.downView.frame = frame;
        //        self.downView.backgroundColor = [UIColor whiteColor];
        //        [self addSubview:self.downView];
        //        _downLoadView = [[GDDownLoadView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //        [self.downView addSubview:_downLoadView];
        //
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(AutoTrans(36), AutoTrans(153)-1, self.frame.size.width-(AutoTrans(36))*2, 1)];
        label.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [self addSubview:label];
        
    }
    return  self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setItem:(ChooseResModel *)item{
    _item = item;
    self.nameLabel.text = item.title;
    NSString *descriptionStr;
    if ([item.isLocked isEqualToNumber:@1]) {
        descriptionStr = [NSString stringWithFormat:@"当前进度%@/%@  已解锁",item.passedCount,item.passesCount];
    }else{
        descriptionStr = [NSString stringWithFormat:@"当前进度%@/%@  解锁需要：%@优钻",item.passedCount,item.passesCount,item.coins];
    }
    
    if ([item.isUsed isEqualToNumber:@1]) {
        _checkImg.image =[UIImage imageNamed:@"icon_jujiao"];
        

    }else{
        _checkImg.image = [UIImage imageNamed:@"icon_checkNew"];
    }
    self.descriptionLabel.text =descriptionStr;
//    self.lblStatus.text = status;
    NSString * status = [NSString stringWithFormat:@"%@",item.status];

    [self.lblStatus setTitle:status forState:UIControlStateNormal];
    
    
    _downLoadView.downUrl = @"";
    _downLoadView.muPath = @"";
    _downLoadView.FileName = @"";
    
    
    
//    NSMutableDictionary * downInfo = [NSMutableDictionary dictionary];
//    downInfo[@"downloadLength"] = @(self.downloadLength);
//    downInfo[@"totalLength"] = @(self.totalLength);
//    [[NSNotificationCenter defaultCenter] postNotificationName:self.ChaosFileName object:nil userInfo:downInfo];
    
    
    [self addNote];
    
    
    [self refreshLblStatusType];
}

- (void)addNote{
    
    [self removeNote];
    WS(weakSelf);
    [[NSNotificationCenter defaultCenter] addObserverForName:_item.fileName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([note.name isEqualToString:weakSelf.item.fileName]) {
                NSDictionary * downInfo = note.userInfo;
        //            NSInteger downloadLength = [downInfo[@"downloadLength"] integerValue];
        //            NSInteger totalLength = [downInfo[@"totalLength"] integerValue];
        //            CGFloat progress = downloadLength * 1.0 / totalLength * 100.0;
                
                NSString * status = [NSString stringWithFormat:@"%@", downInfo[@"text"]];
                
                [self.lblStatus setTitle:status forState:UIControlStateNormal];
                //                weakSelf.lblStatus.text = [NSString stringWithFormat:@" %@ ", downInfo[@"text"]];
                weakSelf.item.status = downInfo[@"text"];
                
                
                
                
                [weakSelf refreshLblStatusType];
                
                
               
//                NSLog(@"status = %@",status);
            }
        });
        
    }];
}

- (void)removeNote{
    NSLog(@"removeNote");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)refreshLblStatusType{
//    [self.lblStatus sizeToFit];
    NSString * statusName = _item.status;
    UIColor * textColor = nil;
    if ([statusName isEqualToString:@"可用"]) {
//        _lblStatus.layer.cornerRadius = 3;
//        _lblStatus.layer.borderColor = ColorRegisterVC.CGColor;
        _lblStatus.layer.borderWidth = 0;
//        _lblStatus.layer.masksToBounds = YES;
//        _lblStatus.textColor = [UIColor colorWithHexString:@"999999"];
 [self.lblStatus sizeToFit];
        textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        _lblStatus.layer.cornerRadius = 3;
        _lblStatus.layer.borderColor = ColorRegisterVC.CGColor;
        _lblStatus.layer.borderWidth = 0.5f;
        _lblStatus.layer.masksToBounds = YES;
        textColor = ColorRegisterVC;
    }

    [_lblStatus setTitleColor:textColor forState:UIControlStateNormal];
    
    CGFloat width = [LGDUtils getWidthFromBtn:_lblStatus withHeight:AutoTrans(40)];
    [_lblStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+10);
    }];
    
}

@end
