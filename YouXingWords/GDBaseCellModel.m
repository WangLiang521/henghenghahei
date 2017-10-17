//
//  BaseCellModel.m
//  EasyWedding
//
//  Created by wangliang on 16/8/22.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "GDBaseCellModel.h"

@implementation GDBaseCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (NSString *)check:(NSString *)pro{
    return [LGDUtils isValidStr:pro]?pro:@"";
}



- (NSString *)subtitleBase{
    NSString * subtitleBase = nil;
//    if (!_subtitleBase) {
//        switch (self.infoType) {
//            case InfoTypeText:
//            {
//                UILabel * label = (UILabel *)self.cellAccessoryView;
//                subtitleBase = label.text;
//            }
//                break;
//                
//            case InfoTypeTextField:
//            {
//                UITextField * tft = (UITextField *)self.cellAccessoryView;
//                subtitleBase = tft.text;
//            }
//                
//            default:
//                break;
//        }
//        
//    }else{
//        subtitleBase = _subtitleBase;
//    }
    
    switch (self.infoType) {
//        case InfoTypeText:
//        {
//            UILabel * label = (UILabel *)self.cellAccessoryView;
//            subtitleBase = label.text;
//        }
//            break;

        case InfoTypeTextField:
        {
            UITextField * tft = (UITextField *)self.cellAccessoryView;
            subtitleBase = tft.text;
        }

        default:
            break;
    }
    
    if (subtitleBase.length == 0) {
        subtitleBase = _subtitleBase;
    }
    
    return subtitleBase;
}


@end
