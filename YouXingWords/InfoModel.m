//
//  InfoModel.m
//  BaiLifeShop
//
//  Created by Apple on 2017/2/20.
//  Copyright © 2017年 com.jinyouApp. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"goodsSpecsList" : @"GoodsSpecsModel"
             };
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.height = 44;
        
    }
    return self;
}

- (NSString *)check:(NSString *)pro{
    return [LGDUtils isValidStr:pro]?pro:@"";
}


- (NSString *)placeHolderImageName{
    if (!_placeHolderImageName) {
        return @"icon_mine_normal";
    }
    return _placeHolderImageName;
}

- (NSString *)placeHolder{
    if (!_placeHolder) {
        NSString* str = nil;
        switch (self.infoType) {
            case InfoTypeTextField:
                str = @"请输入";
                break;
            case  InfoTypeTextView:
                str = @"请输入";
                break;
            case InfoTypeText:
                str = @"请选择";
                break;
                
            default:
                break;
        }
        _placeHolder = [NSString stringWithFormat:@"%@%@",str,self.titleBase];
    }
    return _placeHolder;
}


@end
