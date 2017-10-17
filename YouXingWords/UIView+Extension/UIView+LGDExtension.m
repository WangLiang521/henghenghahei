//
//  UIView+LGDExtension.m
//  自定义Tabbar
//
//  Created by liguodong on 16/4/11.
//  Copyright © 2016年 liguodong. All rights reserved.
//

#import "UIView+LGDExtension.h"

#import <objc/runtime.h>

@interface UIView ()
@property (copy, nonatomic)  TapBlock gdExtblock;
@end

@implementation UIView (LGDExtension)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}


+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
//    UIGraphicsBeginImageContext(reSize);
    UIGraphicsBeginImageContextWithOptions(reSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return reSizeImage;

}

+ (void)fitWidthImage:(UIImage *)image toWidth:(CGFloat)width finishBlock:(UIImageAndHeightBlock)finishBlock{
    CGSize size = image.size;
    CGFloat height = 0;
    if (size.width > 0) {
        height = size.height * width / size.width;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * imageFinish = [UIView reSizeImage:image toSize:CGSizeMake(width, height)];
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(imageFinish,height);
        });

    });

}

+ (void)setShadowView:(UIView *)view{
    view.layer.shadowRadius = 6;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 4);
    view.layer.shadowOpacity = 0.7;
}

+(void)setCornerRadiusToView:(UIView *)view Color:(UIColor *)color BorderWidth:(CGFloat)borderWidth{
    view.layer.cornerRadius = view.frame.size.height / 2.0;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = borderWidth;
    view.clipsToBounds = YES;
    if ([view isMemberOfClass:[UIButton class]] && color ) {
        UIButton * button = (UIButton *)view;
        
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if ([view isMemberOfClass:[UILabel class]] && color ) {
        UILabel * label = (UILabel *)view;
        label.textColor = color;
    }

}

+ (UIImage *)CutImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGSize originalsize = [originalImage size];
//    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);

    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }

    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;

        rate = widthRate>heightRate?heightRate:widthRate;

        CGImageRef imageRef = nil;

        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
//        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小

        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);


        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);

        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        return standardImage;
    }

    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;

        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }

//        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小

UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

        CGContextRef con = UIGraphicsGetCurrentContext();

        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);

        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);

        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        return standardImage;
    }

    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}


//裁剪图片的另外一种方案
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;

    if ((image.size.width / image.size.height) < (1 / 1))
    {
        newSize.width = image.size.width;
        newSize.height = image.size.width * 1 / 1;

        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));

    }
    else
    {
        newSize.height = image.size.height;
        newSize.width = image.size.height * 1 / 1;

        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));

    }

    return [UIImage imageWithCGImage:imageRef];
}



+(UIImage *)captureImageFromViewLow:(UIView *)orgView {
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)tapBlock:(TapBlock)block{
    //创建手势对象
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapAction:)];
    //配置属性
    //轻拍次数
    tap.numberOfTapsRequired =1;
    //轻拍手指个数
    tap.numberOfTouchesRequired =1;
    //讲手势添加到指定的视图上
    [self addGestureRecognizer:tap];
//    block = self.block;
    self.userInteractionEnabled = YES;
    self.gdExtblock = block;
}

-(void)tapAction:(id)sender{
    
    if (self.gdExtblock) {
        self.gdExtblock();
    }
}



- (TapBlock)gdExtblock{
    return objc_getAssociatedObject(self, @"block");
}

- (void)setGdExtblock:(TapBlock)gdExtblock{
    objc_setAssociatedObject(self, @"block", gdExtblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//- (NSString *)tag {
//    return objc_getAssociatedObject(self, tagKey);
//}
//
//- (void)setTag:(NSString *)tag {
//    objc_setAssociatedObject(self, tagKey, tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

@end












