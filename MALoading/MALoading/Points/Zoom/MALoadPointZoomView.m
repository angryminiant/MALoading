//
//  MALoadPointZoomView.m
//  MALoading
//
//  Created by ma on 2019/12/5.
//  Copyright © 2019 com.ma. All rights reserved.
//

#import "MALoadPointZoomView.h"

static const NSInteger kCircleCount = 3;

@interface MALoadPointZoomView ()

@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) NSArray *colors;// 点颜色

@end

@implementation MALoadPointZoomView


/**
 *  设置属性
 *
 *  @param colors  点颜色数组，从左到右（无数据时，默认3个颜色值）
 *  @param h       加载视图的高度，也是点的高度，宽度
 */
- (void) loadColors:(nullable NSArray<UIColor *> *) colors h:(CGFloat)h {
        
    if ( colors == nil  || colors.count == 0 ) {
        
        UIColor *color1 = MARGBColor(254, 100, 97, 1);
        UIColor *color2 = MARGBColor(255, 244, 00, 1);
        UIColor *color3 = MARGBColor(00, 190, 255, 1);
        colors = @[color1, color2, color3];
    }
    self.colors = colors;
    
    if ( h <= 0 ) {
        h = 10;
    }
    CGFloat w = (colors.count*2 + 1) * h;
    self.frame = CGRectMake(0, 0, w, h);
    _circleView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_circleView];
        
    CGFloat circleWidth = h;
    CGFloat y = 0;
    for (NSInteger i = 0; i < kCircleCount; ++i) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = MARGBColor(227, 72, 76, 1).CGColor;
        layer.cornerRadius = circleWidth/2;
        layer.frame = CGRectMake(circleWidth + i*(circleWidth*2), y, circleWidth, circleWidth);
        [_circleView.layer addSublayer:layer];
    }
}


/**
 *  开始画
 *
 */
- (void)startAnimating {
    
    for (NSInteger i = 0; i < kCircleCount; ++i) {
        
        CALayer *layer = self.circleView.layer.sublayers[i];
        
        CAKeyframeAnimation *animation =  [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.removedOnCompletion = NO;
        animation.repeatCount = MAXFLOAT;
        animation.duration = 1.2;
        animation.values = @[@1.0, @1.7, @1.0, @1.0];
        animation.beginTime = CACurrentMediaTime() + i * 0.2;
        animation.keyTimes = @[@0.0,@0.2, @0.4,@1.0];
        animation.timingFunctions = @[
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                      ];
        
        [layer addAnimation:animation forKey:[NSString stringWithFormat:@"spotify_animation_%@",@(i)]];
        
    }
}


/**
 *  结束移除动画
 *
 */
- (void) stopAnimating {
    
    for (NSInteger i = 0; i < kCircleCount; ++i) {
        
        CALayer *layer = self.circleView.layer.sublayers[i];
        [layer removeAnimationForKey:[NSString stringWithFormat:@"spotify_animation_%@",@(i)]];
    }
}


/**
 *  清空动画（结束移除动画 & 移除动画控件）
 *
 */
- (void) clearAnimating {
    
    [self stopAnimating];
    [self.circleView removeFromSuperview];
    self.circleView = nil;
}

@end
