//
//  MALoadPointZoomView.h
//  MALoading
//
//  Created by MA on 2019/7/11.
//  Copyright © 2019 com.angryminiant. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  加载点:缩放动画
 *
 */
@interface MALoadPointZoomView : UIView

/**
 *  设置属性
 *
 *  @param colors  点颜色数组，从左到右（无数据时，默认3个颜色值）
 *  @param h       加载视图的高度，也是点的高度，宽度
 */
- (void) loadColors:(nullable NSArray<UIColor *> *) colors h:(CGFloat)h;

/**
 *  开始动画
 *
 */
- (void)startAnimating;

/**
 *  结束移除动画
 *
 */
- (void) stopAnimating;


/**
 *  清空动画（结束移除动画 & 移除动画控件）
 *
 */
- (void) clearAnimating;
@end

NS_ASSUME_NONNULL_END
