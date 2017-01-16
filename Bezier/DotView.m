//
//  DotView.m
//  Bezier
//
//  Created by qinmin on 2017/1/15.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "DotView.h"

@implementation Dot

@end

@interface DotView ()
{
    Dot     *_startDot;
    Dot     *_endDot;
    
    CGPoint _controlPoint;
    CGFloat _lastDistance;
}
@end

@implementation DotView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupDots];
        [self setupGesture];
        [self setupControlPoint];
    }
    return self;
}

- (void)setupDots
{
    _startDot = [[Dot alloc] init];
    _startDot.position = CGPointMake(100, 200);
    _startDot.size = CGSizeMake(50, 50);
    
    _endDot = [[Dot alloc] init];
    _endDot.position = CGPointMake(100, 290);
    _endDot.size = CGSizeMake(50, 50);
}

- (void)setupGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:panGesture];
}

- (void)setupControlPoint
{
    CGFloat cpx = (_startDot.position.x + _endDot.position.x)/2;
    CGFloat cpy = 0.5;
    _controlPoint = CGPointMake(cpx, cpy);
}

- (void)handleGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint offset = [gesture locationInView:self];
    //CGPoint velocity = [gesture translationInView:self];
    //NSLog(@"%@", NSStringFromCGPoint(velocity));
    
    CGPoint endPos = _endDot.position;
    endPos.x = offset.x;
    endPos.y = offset.y;
    _endDot.position = endPos;
    
    float distance = sqrtf(pow(_startDot.position.x - _endDot.position.x, 2) + pow(_startDot.position.y - _endDot.position.y, 2));
    
    CGSize size;
    if (distance - _lastDistance < 0.00000) {
        size = _startDot.size;
        size.width = size.width + 0.001 * distance;
        size.height = size.width;
        NSLog(@"%@", NSStringFromCGSize(size));
        if (size.width > 50 ) {
            size.width = size.height = 30;
        }
    }else {
        size = _startDot.size;
        size.width = size.width - 0.001 * distance;
        size.height = size.width;
        NSLog(@"%@", NSStringFromCGSize(size));
        if (size.width < 15 ) {
            size.width = size.height = 15;
        }
    }
    _startDot.size = _endDot.size = size;
    _lastDistance = distance;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_startDot.position.x-_startDot.size.width/2, _startDot.position.y-_startDot.size.height/2, _startDot.size.width,  _startDot.size.height)].CGPath);
    
    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_endDot.position.x-_endDot.size.width/2, _endDot.position.y-_endDot.size.height/2, _endDot.size.width,  _endDot.size.height)].CGPath);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGPathRelease(path);
    
    // 求动点相对于x轴的偏移角
    // a = (1,0), b = (end.x-start.x, end.y-start.y), cost=a*b/(|a||b|)
    float cost = (_endDot.position.x-_startDot.position.x)/sqrtf(pow(_endDot.position.x-_startDot.position.x, 2) + pow(_endDot.position.y-_startDot.position.y, 2));
    float t = acosf(cost);
    float sint = sin(t);
    
    // 修正动点在定点上方时候的角度问题
    int i = 1;
    if (_endDot.position.y < _startDot.position.y) {
        cost = cos(-t);
        sint = sin(-t);
        i = -1;
    }
    
    float deltax = _startDot.size.width/2 * sint;
    float deltay = _startDot.size.height/2 * cost;
    
    float cpx = (_startDot.position.x+_endDot.position.x)/2;
    float cpy = (_startDot.position.y+_endDot.position.y)/2 - _controlPoint.y*cost;
    float cpy1 = (_startDot.position.y+_endDot.position.y)/2 + _controlPoint.y*cost;
    
    // 画四边形
    CGContextSetLineWidth(ctx, 0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, _startDot.position.x+deltax-1*i, _startDot.position.y-deltay);
    CGContextAddLineToPoint(ctx, _startDot.position.x-deltax+1*i, _startDot.position.y+deltay);
    CGContextAddLineToPoint(ctx, _endDot.position.x+deltax-1*i, _endDot.position.y-deltay);
    CGContextMoveToPoint(ctx, _endDot.position.x+deltax-1*i, _endDot.position.y-deltay);
    CGContextAddLineToPoint(ctx, _endDot.position.x-deltax+1*i, _endDot.position.y+deltay);
    CGContextAddLineToPoint(ctx, _startDot.position.x-deltax+1*i, _startDot.position.y+deltay);
    CGContextDrawPath(ctx, kCGPathEOFillStroke);
    
    // 画贝塞尔曲线
    [[UIColor whiteColor] setFill];
    CGContextSetLineWidth(ctx, 0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, _startDot.position.x+deltax+1*i, _startDot.position.y-deltay);
    CGContextAddQuadCurveToPoint(ctx, cpx, cpy, _endDot.position.x+deltax+1*i, _endDot.position.y-deltay);
    CGContextMoveToPoint(ctx, _startDot.position.x-deltax-1*i, _startDot.position.y+deltay);
    CGContextAddQuadCurveToPoint(ctx, cpx, cpy1, _endDot.position.x-deltax-1*i, _endDot.position.y+deltay);
    CGContextDrawPath(ctx, kCGPathEOFillStroke);
    
    
}

@end
