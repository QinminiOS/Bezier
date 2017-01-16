//
//  FormulaView.m
//  Bezier
//
//  Created by qinmin on 2017/1/16.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "FormulaView.h"

@interface FormulaView ()
{
    CGFloat _t;
    CGFloat _deltaT;
    
    CGPoint _p1;
    CGPoint _p2;
    CGPoint _control;
    
    CGPoint *_pointArr;
    CADisplayLink   *_displayLink;
    
    int     _currentIndex;
}
@end

@implementation FormulaView

- (void)dealloc
{
    if (_pointArr) {
        free(_pointArr);
        _pointArr = NULL;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupPoint];
        [self setupSliceInfo];
        [self createBezierPoint];
        [self setupTimer];
    }
    return self;
}

- (void)setupPoint
{
    _p1 = CGPointMake(10, 100);
    _p2 = CGPointMake(400, 100);
    _control = CGPointMake(100, 800);
    
}

// 切分点信息
- (void)setupSliceInfo
{
    _t = 0.0;
    _deltaT = 0.01;
    _currentIndex = 0;
}

// 创建线段的切分点
- (void)createBezierPoint
{
    int count = 1.0/_deltaT;
    _pointArr = (CGPoint *)malloc(sizeof(CGPoint) * (count+1));

    // t的范围[0,1]
    for (int i = 0; i < count+1; i++) {
        float t = i * _deltaT;
        
        // 二次方计算公式
        float cx = (1-t)*(1-t)*_p1.x + 2*t*(1-t)*_control.x + t*t*_p2.x;
        float cy = (1-t)*(1-t)*_p1.y + 2*t*(1-t)*_control.y + t*t*_p2.y;
        _pointArr[i] = CGPointMake(cx, cy);
    }
}

- (void)setupTimer
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)timerTick:(CADisplayLink *)displayLink
{
    _currentIndex += 1;
    int count = 1.0/_deltaT;
    if (_currentIndex > count+1) {
        _currentIndex = 1;
    }
    [self setNeedsDisplay];
}

// 画图
- (void)drawRect:(CGRect)rect
{
    if (_pointArr == NULL) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 4);
    
    // 系统贝塞尔曲线
    [[UIColor blackColor] setStroke];
    CGContextMoveToPoint(ctx, _p1.x, _p1.y);
    CGContextAddQuadCurveToPoint(ctx, _control.x, _control.y, _p2.x, _p2.y);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    // 线段代替曲线
    [[UIColor redColor] setStroke];
    CGContextMoveToPoint(ctx, _pointArr[0].x, _pointArr[0].y);
    for (int i = 1; i < _currentIndex; i++) {
        CGContextAddLineToPoint(ctx, _pointArr[i].x, _pointArr[i].y);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
