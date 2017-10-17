//
//  GDDownLoadView.m
//  TBCycleProgress
//
//  Created by Apple on 2017/2/4.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "GDDownLoadView.h"

#import "TBCycleView.h"

#import "GDSessionManager.h"

@interface GDDownLoadView ()

@property (strong, nonatomic) TBCycleView *cycleView;

@property (strong, nonatomic)  UIButton  *startBtn;

@property (nonatomic, strong)  GDSessionManager* manager;

@end



@implementation GDDownLoadView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.cycleView.label.text = [NSString stringWithFormat:@"%.2f%%", sender.value*100];
        //        [self.cycleView drawProgress:sender.value];
        [self creatCycleViewWithFrame:frame];
        [self creatStartBtnWithFrame:frame];
    }
    return self;
}



- (void)creatCycleViewWithFrame:(CGRect)frame{
    self.cycleView = [[TBCycleView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.cycleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cycleView];
}

- (void)creatStartBtnWithFrame:(CGRect)frame{
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.startBtn setBackgroundImage:[UIImage imageNamed:ImageStop] forState:UIControlStateNormal];
    
    [self.startBtn setImage:[self reSizeImage:[UIImage imageNamed:ImageStop] toSize:CGSizeMake(StartBtnWH, StartBtnWH)] forState:UIControlStateNormal];
    //    CGFloat y = (frame.size.height - 30) / 2.0;
    //    CGFloat x = (frame.size.width - 30) / 2.0;
    //    [self.startBtn setImageEdgeInsets:UIEdgeInsetsMake(y, x, y,x)];
    //    [self.startBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    self.startBtn.frame = CGRectMake(20, (frame.size.height - 30) / 2.0, MAX(frame.size.width - 40, 30), 30);
    self.startBtn.center = self.center;
    self.startBtn.tag = 10;
    [self.startBtn addTarget:self action:@selector(tapStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startBtn];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    //    UIGraphicsBeginImageContext(reSize);
    UIGraphicsBeginImageContextWithOptions(reSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

- (void)tapStartBtn:(UIButton *)sender
{
    
    
    
    if (sender.tag == 10) {
        //        点击了开始
        //        [self.startBtn setBackgroundImage:[UIImage imageNamed:ImageStart] forState:UIControlStateNormal];
        [self.startBtn setImage:[self reSizeImage:[UIImage imageNamed:ImageStart] toSize:CGSizeMake(StartBtnWH, StartBtnWH)] forState:UIControlStateNormal];
        sender.tag = 20;
        
        //        NSString * url = @"http://115.28.162.22/youcan/resources/book/12.zip";
        NSString * url = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
        NSString * FileName = @"1.zip";
        
        
        NSString *str = [NSString stringWithFormat:@"Documents/%@/%@.%@",@"res",@"1",ArchiveType];
        NSString *muPath = [NSHomeDirectory() stringByAppendingPathComponent:str];
        NSLog(@"muPath = %@",muPath);
//        _manager = [[GDSessionManager alloc] initWithUrl:self.downUrl FileName:self.FileName ChaosFileType:@"" successPath:self.muPath];
        _manager = [GDSessionManager share];
        [_manager addToDownloadQueueWithUrl:self.downUrl FileName:self.FileName ChaosFileType:@"" successPath:self.muPath];
        
        __weak __block GDDownLoadView * weakSelf = self;
        [_manager startWithProgressblock:^(long long totalLength, long long downloadLength) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.cycleView drawProgress:1.0 * downloadLength / totalLength];
            });
        } CompletionBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.startBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
                
                [weakSelf.startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            });
        } failBlock:^(NSError *error) {
            
        }];
        
    }else{
        //        点击了暂停
        //        [self.startBtn setBackgroundImage:[UIImage imageNamed:ImageStop] forState:UIControlStateNormal];
        [self.startBtn setImage:[self reSizeImage:[UIImage imageNamed:ImageStop] toSize:CGSizeMake(StartBtnWH, StartBtnWH)] forState:UIControlStateNormal];
        sender.tag = 10;
        [_manager stop];
    }
    
}














@end
