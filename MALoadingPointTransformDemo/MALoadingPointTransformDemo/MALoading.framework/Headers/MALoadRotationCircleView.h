//
//  MALoadRotationCircleView.h
//  MALoading
//
//  Created by hugengya on 2019/8/5.
//  Copyright © 2019 com.angryminiant. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MALoadRotationCircleView : UIView

/**
 *  设置属性
 *
 *  @param image   旋转的图片对象
 *  @param h       加载视图的高度，也是点的高度，宽度
 */
- (void) loadImage:(nonnull UIImage *)image  h:(CGFloat)h;

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

@end

NS_ASSUME_NONNULL_END
