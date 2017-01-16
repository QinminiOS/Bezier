//
//  MyView.m
//  UIkit
//
//  Created by qinmin on 2017/1/14.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "BallView.h"

@implementation Ball

@end

@implementation Rope

@end


@interface BallView ()
{
    CADisplayLink   *_displayLink;
    Ball            *_ball;
    Rope            *_rope;
}
@end

@implementation BallView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupTimer];
        [self setupBall];
        [self setupRope];
    }
    return self;
}

- (void)setupTimer
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setupBall
{
    _ball = [[Ball alloc] init];
    _ball.accelerate = 300; //加速度
    _ball.speed = 0; //速度
    _ball.size = CGSizeMake(30, 30); //球大小
    _ball.position = CGPointMake(195, 100); //球的初始位置
}

- (void)setupRope
{
    _rope = [[Rope alloc] init];
    _rope.position = CGPointMake(200, 420); //绳子中间点的位置
    _rope.start = CGPointMake(150, 420); //绳子起点
    _rope.end = CGPointMake(270, 420); //绳子终点
    _rope.control = CGPointMake(210, 420); //绳子的控制点
    _rope.x = 0; //绳子偏移量
    _rope.k = 20; //劲度系数
}

- (void)timerTick:(CADisplayLink *)displayLink
{
    //NSLog(@"%f", displayLink.duration);
    CGRect ballRect = CGRectMake(_ball.position.x, _ball.position.y+1, _ball.size.width, _ball.size.height);
    
    BOOL ropeMove = NO;
    //球与绳子碰撞检测
    if (CGRectContainsPoint(ballRect, _rope.position)) {
        ropeMove = YES;
        // delta x
        // f = kx
        _rope.x = _rope.position.y - _rope.end.y;
    }else {
        //球向上离开绳子
        _rope.x = 0;
    }
    
    _ball.speed += (_ball.accelerate - _rope.k * _rope.x) * displayLink.duration;
    float s = _ball.speed * displayLink.duration;
    _ball.position = CGPointMake(_ball.position.x, _ball.position.y + s);
    
    // 球与绳子碰撞检测
    if (ropeMove) {
        float x = _ball.position.x + _ball.size.width/2;
        float y = _ball.position.y + _ball.size.height;
        
        // 中间点 公式的t为0.5
        float t = 0.5;
        
        // 根据公式逆推出控制点
        float cx = (x - (1-t)*(1-t)*_rope.start.x - t*t*_rope.end.x)/(2*t*(1-t));
        float cy = (y - (1-t)*(1-t)*_rope.start.y - t*t*_rope.end.y)/(2*t*(1-t));
        
        _rope.position = CGPointMake(x, y);
        _rope.control = CGPointMake(cx, cy);
        
        // fix 小球未与绳子接触，小球的位置高于绳子的位置
        if (y <= _rope.end.y) {
            _rope.position = CGPointMake((_rope.end.x+_rope.start.x)/2, _rope.start.y);
            _rope.control = _rope.position;
        }
    }
    
    //fix position
    if (_ball.position.y < 100) {
        _ball.position = CGPointMake(_ball.position.x, 100);
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 画两个固定点
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rope.start.x-_ball.size.width/2, _rope.start.y-_ball.size.height/2, _ball.size.width,  _ball.size.height)].CGPath);
    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rope.end.x-_ball.size.width/2, _rope.end.y-_ball.size.height/2, _ball.size.width, _ball.size.height)].CGPath);
    CGRect ballRect = CGRectMake(_ball.position.x, _ball.position.y, _ball.size.width, _ball.size.height);
    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:ballRect].CGPath);

    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGPathRelease(path);
    
    // 画绳子的贝塞尔曲线
    CGContextMoveToPoint(ctx, _rope.start.x, _rope.start.y);
    CGContextAddQuadCurveToPoint(ctx, _rope.control.x, _rope.control.y, _rope.end.x, _rope.end.y);
    
    // 画最高点标记线
    CGContextMoveToPoint(ctx, _ball.position.x-30, 100);
    CGContextAddLineToPoint(ctx, _ball.position.x +50, 100);
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)stop
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)start
{
    [self setupTimer];
}

@end
