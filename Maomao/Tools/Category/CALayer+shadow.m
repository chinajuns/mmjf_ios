//
//  CALayer+shadow.m
//  Maomao
//
//  Created by 御顺 on 2017/11/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "CALayer+shadow.h"

@implementation CALayer (shadow)
//设置阴影
- (void)setShadow:(CGFloat)radius opacity:(CGFloat)opacity color:(UIColor *)color shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset{
    self.cornerRadius = radius;
    self.shadowOpacity = opacity;// 阴影透明度
    self.shadowColor = color.CGColor;// 阴影的颜色
    self.shadowRadius = shadowRadius;// 阴影扩散的范围控制
    self.shadowOffset = shadowOffset;// 阴影的范围
}
//设置圆角
- (void)setRadius:(CGFloat)radius{
    self.cornerRadius = radius;
    self.masksToBounds = YES;
}
@end
