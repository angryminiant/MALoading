//
//  MALoadPointMoveView.m
//  MALoading
//
//  Created by ma on 2019/12/5.
//  Copyright © 2019 com.ma. All rights reserved.
//

#import "MALoadPointMoveView.h"

@interface MAPointView : UIView

@property (weak, nonatomic) CAAnimationGroup *animationGroupShow;
@property (weak, nonatomic) CAAnimationGroup *animationGroupHide;

@end

@implementation MAPointView

@end



CGFloat margin = 10;
CGFloat hMargin = 20;
CGFloat showOffsetX = 10;
CGFloat hideOffsetX = 16;

@interface MALoadPointMoveView () <CAAnimationDelegate>

@property (strong, nonatomic) NSMutableArray<MAPointView *> *pointMArray;// 点视图数组
@property (strong, nonatomic) NSMutableArray<CAAnimationGroup *> *animationGroupShowArray;// 展示动画数组
@property (strong, nonatomic) NSMutableArray<CAAnimationGroup *> *animationGroupHideArray;// 消失动画数组
@property (strong, nonatomic) NSArray *colors;// 点颜色
@property (assign, nonatomic) CGFloat h;// 点，当前view的高度
@property (assign, nonatomic) NSInteger showIndex;// 展示索引
@property (assign, nonatomic) NSInteger hideIndex;// 消失索引

@end

@implementation MALoadPointMoveView

/**
 *  设置属性
 *
 *  @param colors  点颜色数组，从左到右（无数据时，默认3个颜色值）
 *  @param h       加载视图的高度，也是点的高度，宽度
 */
- (void) loadColors:(nullable NSArray<UIColor *> *) colors h:(CGFloat)h {
    
    // 初始化点数组，动画数组
    self.pointMArray = [NSMutableArray<MAPointView *> array];
    self.animationGroupShowArray = [NSMutableArray<CAAnimationGroup *> array];
    self.animationGroupHideArray = [NSMutableArray<CAAnimationGroup *> array];
    
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
    self.h = h;
    self.frame = CGRectMake(0, 0, hMargin * 2 + colors.count * self.h + (colors.count - 1 ) * margin, self.h);
    
    // 保存点展示，消失动画，以便重利用
    for ( int i = 0 ; i < self.colors.count ; i++ ) {
        
        [self.animationGroupShowArray addObject:[self getShowAnimateGroup]];
        [self.animationGroupHideArray addObject:[self getHideAnimateGroup]];
    }
}


/**
 *  开始动画
 *
 * @note 每次开始动画，重新创建点视图
 */
- (void) startAnimating {
    
    self.showIndex = 0;
    self.hideIndex = 0;
    
    // 重置
    [self resetProperty];
    
    // 构建
    for ( int i = 0 ; i < self.colors.count ; i++ ) {
        
        MAPointView *pointView = [MAPointView new];
        
        pointView.hidden = YES;
        pointView.clipsToBounds = YES;
        pointView.layer.cornerRadius = self.h * 0.5;
        pointView.backgroundColor = self.colors[i];
        pointView.frame = CGRectMake( hMargin - showOffsetX + i * (self.h + margin) , 0, self.h, self.h);
        
        pointView.animationGroupShow = self.animationGroupShowArray[i];
        pointView.animationGroupHide = self.animationGroupHideArray[i];
        [self.pointMArray addObject:pointView];
        
        [self addSubview:pointView];
    }
    
    [self showPointAnimation];
    
}

/**
 *  结束动画
 */
- (void) stopAnimating {
    
    [self resetProperty];
    
    [self.pointMArray removeAllObjects];
    self.pointMArray = nil;
    [self.animationGroupShowArray removeAllObjects];
    self.animationGroupShowArray = nil;
    [self.animationGroupHideArray removeAllObjects];
    self.animationGroupHideArray = nil;
    
    self.colors = nil;
}

/**
 *  清空点视图
 */
- (void) resetProperty {
    
    for ( MAPointView *pointView in self.pointMArray ) {
        
        pointView.animationGroupShow = nil;
        pointView.animationGroupHide = nil;
        
        pointView.hidden = YES;
        [pointView removeFromSuperview];
    }
    [self.pointMArray removeAllObjects];
}

/**
 *  每个点的展示动画
 */
- (void) showPointAnimation {
    
    if ( self.superview == nil ) {
        [self stopAnimating];
        return;
    }
    
    if ( self.showIndex < self.pointMArray.count ) {
        
        MAPointView *pointView = self.pointMArray[self.showIndex];
        pointView.hidden = NO;
        
        [pointView.layer removeAnimationForKey:@"move-rotate-layer-show"];
        [pointView.layer addAnimation:pointView.animationGroupShow forKey:@"move-rotate-layer-show"];
        
        self.showIndex ++;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPointAnimation];
        });
    }
    else {
        
        // 消失动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidePointAnimation];
        });
        
    }

}

/**
 *  每个点的消失动画
 */
- (void) hidePointAnimation {
    
    if ( self.superview == nil ) {
        [self stopAnimating];
        return;
    }

    NSUInteger count = self.pointMArray.count;
    if ( self.hideIndex < count ) {
        
        MAPointView *pointView = self.pointMArray[count - self.hideIndex - 1];
        pointView.hidden = NO;
        
        [pointView.layer removeAnimationForKey:@"move-rotate-layer-hide"];
        [pointView.layer addAnimation:pointView.animationGroupHide  forKey:@"move-rotate-layer-hide"];
        
        self.hideIndex ++;
        
        // 不卡顿了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidePointAnimation];
        });
    }

    else {
        
        // 重置，开始动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAnimating];
        });
    }

}

/**
 *  获取展示动画组
 *
 *  @return CAAnimationGroup    动画组
 */
- (CAAnimationGroup *) getShowAnimateGroup {
    
    /* 移动x */
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.toValue = @(showOffsetX); // 終点
    
    /* 缩放 */
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.values = @[@0.0,@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9,@01.0,@1.1,@1.05,@1.0];
    animation2.calculationMode = kCAAnimationCubic;
    
    
    /* 透明 */
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.0);
    opacityAnim.toValue = @(1.0);
    
    
    /* 动画组 */
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.4;
    group.repeatCount = 1;
    
    // 动画结束后不变回初始状态
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    // 添加动画
    group.animations = [NSArray arrayWithObjects:animation1, animation2, opacityAnim, nil];
    
    return group;
}

/**
 *  获取消失动画组
 *
 *  @return CAAnimationGroup    动画组
 */
- (CAAnimationGroup *) getHideAnimateGroup {
    
    /* 移动x */
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.toValue = @(hideOffsetX); // 終点
    
    /* 移动z */
    CABasicAnimation *animation11 = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    animation11.toValue = @(-10); // 終点
    
    
    /* 缩放 */
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @(1.0);
    animation2.toValue = @(0.6);
    
    /* 透明 */
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(1.0);
    opacityAnim.toValue = @(0.0);
    
    
    /* 动画组 */
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.22;
    group.repeatCount = 1;
    
    // 动画结束后不变回初始状态
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    // 添加动画
    group.animations = [NSArray arrayWithObjects:animation1, animation11, animation2, opacityAnim, nil];
    
    return group;
}


@end




