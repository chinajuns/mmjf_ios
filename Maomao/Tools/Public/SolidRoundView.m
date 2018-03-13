//
//  SolidRoundView.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "SolidRoundView.h"

@implementation SolidRoundView

-(void)drawRect:(CGRect)rect{
    // 获取图形上下
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width;
    /**
     
     画实心圆
     */
    CGRect frame = CGRectMake(width/8,
                              width/8,
                              rect.size.width - width/4,
                              rect.size.height - width/4);
    //填充当前绘画区域内的颜色
    [[UIColor whiteColor] set];
    //填充当前矩形区域
    CGContextFillRect(ctx, rect);
    //以矩形frame为依据画一个圆
    CGContextAddEllipseInRect(ctx, frame);
    //填充当前绘画区域内的颜色
    [[UIColor orangeColor] set];
    //填充(沿着矩形内围填充出指定大小的圆)
    CGContextFillPath(ctx);
    
}

@end
