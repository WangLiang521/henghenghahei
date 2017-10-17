//
//  GDTextView.m
//  BaiLifeShop
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "GDTextView.h"


@interface GDTextView ()<UITextViewDelegate>

@property (assign, nonatomic)  BOOL notFirst;

@end

@implementation GDTextView

- (NSString *)text{
    return self.textView.text;
}


- (void)layoutSubviews{
    if (!_notFirst) {
//        [self setUpViews];
    }
    _notFirst = YES;
}

- (void)setUpViews{
    WS(weakSelf);
    self.textView = [UITextView new];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    
    self.placeHolder = [UILabel new];
    [self addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(5);
    }];
    self.placeHolder.font = [UIFont systemFontOfSize:14];
    self.placeHolder.textColor = [UIColor lightGrayColor];
    
    
    [self.KVOController observe:self.textView keyPath:@"text" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakSelf textViewDidChange:weakSelf.textView];
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"self = %@,text = %@",self.textView.text,textView.text);
    if (self.textView.text.length > 0) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
}

- (void)otherInit{
    [self setUpViews];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self otherInit];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self otherInit];
    }
    return self;
}





@end
