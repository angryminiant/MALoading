//
//  MALoadPointMoveView.h
//  MALoading
//
//  Created by ma on 2019/12/5.
//  Copyright © 2019 com.ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  加载点:缩放-平移动画
 *
 */
@interface MALoadPointMoveView : UIView

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
 * @note 每次开始动画，重新创建点视图
 */
- (void) startAnimating;

/**
 *  结束动画
 */
- (void) stopAnimating;

@end

NS_ASSUME_NONNULL_END
