//
//  MGRoundView.m
//  CER_IKE_01
//
//  Created by guohq on 2019/1/28.
//  Copyright © 2019年 ike. All rights reserved.
//

#import "MGLineRoundView.h"
#import "UIView+Extension.h"

@implementation MGLineRoundView

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制路径: 圆形(中心坐标200、200、半径100、起点弧度0、终点弧度2PI、画的方向0逆1正) 第五个参数 是startAngle开始的角度
    CGContextAddArc(ctx, self.bounds.size.width / 2, self.bounds.size.width / 2, 10, M_PI_2 * 3, _currentAngle, 0);
    /*给当前View一个边框*/
    // CGContextAddRect(ctx, self.bounds);
    //修改图形状态参数
    CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
//    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.9, 2.0);//笔颜色
    CGContextSetLineWidth(ctx, 3);//线条宽度
    //渲染上下文
    CGContextStrokePath(ctx);
    
}

- (void)setCurrentAngle:(CGFloat)currentAngle{
    if (currentAngle < M_PI_2 * 3) return;
    _currentAngle = currentAngle;

    if (!self.hidden) {
        [self setNeedsDisplay];
    }
}

@end
