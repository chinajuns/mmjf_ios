//
//  CALayer+shadow.h
//  Maomao
//
//  Created by 御顺 on 2017/11/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (shadow)

/**
 设置阴影

 @param radius 圆角
 @param opacity 阴影透明度
 @param color 颜色
 @param shadowRadius 阴影扩散的范围控制
 @param shadowOffset 阴影的范围
 */
- (void)setShadow:(CGFloat)radius opacity:(CGFloat)opacity color:(UIColor *)color shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset;

/**
 设置圆角

 @param radius 圆角
 */
- (void)setRadius:(CGFloat)radius;
@end
