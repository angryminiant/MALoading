//
//  MALoadRotationCircleView.m
//  MALoading
//
//  Created by ma on 2019/12/5.
//  Copyright © 2019 com.ma. All rights reserved.
//

#import "MALoadRotationCircleView.h"

@interface MALoadRotationCircleView ()

@property (strong, nonatomic) UIImageView *imageView;

@end
@implementation MALoadRotationCircleView

/**
 *  设置属性
 *
 *  @param image   旋转的图片对象
 *  @param h       加载视图的高度，也是点的高度，宽度
 */
- (void) loadImage:(nonnull UIImage *)image  h:(CGFloat)h {
    
    if ( h <= 0 ) {
        h = 40;
    }
    self.frame = CGRectMake(0, 0, h, h);
    
    // 自定义视图
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    if ( image == nil || CGSizeEqualToSize(image.size, CGSizeZero) ) {
        NSLog(@"image could not null in MALoading/MALoadRotationCircleView [- (void) loadImage:(nonnull UIImage *)image  h:(CGFloat)h]");
    }
    else {
        [self.imageView setImage:image];
    }
    
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
}

/**
 *  开始动画
 *
 */
- (void)startAnimating {
    
    //  旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 1.0f;
    animation.repeatCount = INT_MAX;
    [self.imageView.layer addAnimation:animation forKey:@"rotate"];
}

/**
 *  结束移除动画
 *
 */
- (void) stopAnimating {
    
    [self.imageView.layer removeAnimationForKey:@"rotate"];
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

@end
