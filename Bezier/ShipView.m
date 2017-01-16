//
//  ShipView.m
//  Bezier
//
//  Created by qinmin on 2017/1/16.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "ShipView.h"

@implementation Ship

@end

@implementation Wave

@end


@interface ShipView ()
{
    CADisplayLink   *_displayLink;
    Wave            *_wave1;
    Wave            *_wave2;
    Ship            *_ship;
}
@end

@implementation ShipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupTimer];
        
        [self setupWave];
        [self setupShip];
    }
    return self;
}

- (void)setupTimer
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerTick:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setupWave
{
    _wave1 = [[Wave alloc] init];
    _wave1.cp1 = CGPointMake(200, 150);
    _wave1.cp2 = CGPointMake(300, 280);
    _wave1.p1 = CGPointMake(0, 200);
    _wave1.p2 = CGPointMake(420, 200);
    _wave1.speed = 320;
    
    _wave2 = [[Wave alloc] init];
    _wave2.cp1 = CGPointMake(200-420+1, 150);
    _wave2.cp2 = CGPointMake(300-420+1, 250);
    _wave2.p1 = CGPointMake(0-420+1, 200);
    _wave2.p2 = CGPointMake(420-420+1, 200);
    _wave2.speed = _wave1.speed;
}

- (void)setupShip
{
    _ship = [[Ship alloc] init];
    _ship.size = CGSizeMake(30, 30);
    _ship.position = CGPointMake(210, 250);
}

- (void)addDeltaX:(CGFloat)x forWave:(Wave *)wave
{
    // fix 无线循环
    if (wave.p1.x + x >= 420) {
        x = - 420 * 2 + 8;
    }
    
    CGPoint cp1 = wave.cp1;
    cp1.x += x;
    wave.cp1 = cp1;
    
    CGPoint cp2 = wave.cp2;
    cp2.x += x;
    wave.cp2 = cp2;
    
    CGPoint p1 = wave.p1;
    p1.x += x;
    wave.p1 = p1;
    
    CGPoint p2 = wave.p2;
    p2.x += x;
    wave.p2 = p2;
}

- (void)timerTick:(CADisplayLink *)displayLink
{
    CGFloat delta = displayLink.duration * _wave1.speed;
    [self addDeltaX:delta forWave:_wave1];
    [self addDeltaX:delta forWave:_wave2];
    
    Wave *currentWave;
    if (_wave1.p1.x <= _ship.position.x && _ship.position.x <= _wave1.p2.x) {
        currentWave = _wave1;
    }else {
        currentWave = _wave2;
    }
    
    float t = (_ship.position.x - currentWave.p1.x)/(currentWave.p2.x - currentWave.p1.x);
    float y = currentWave.p1.y*pow(1-t, 3) + 3*currentWave.cp1.y*t*pow(1-t, 2) +3*currentWave.cp2.y*t*t*(1-t)+currentWave.p2.y*pow(t, 3);
    CGPoint position = _ship.position;
    position.y = y-_ship.size.height-2;
    _ship.position = position;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddPath(path, NULL, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_ship.position.x, _ship.position.y, _ship.size.width,  _ship.size.height)].CGPath);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGPathRelease(path);
    
    
    CGContextMoveToPoint(ctx, _wave1.p1.x, _wave1.p1.y);
    CGContextAddCurveToPoint(ctx, _wave1.cp1.x, _wave1.cp1.y, _wave1.cp2.x, _wave1.cp2.y, _wave1.p2.x, _wave1.p2.y);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextMoveToPoint(ctx, _wave2.p1.x, _wave2.p1.y);
    CGContextAddCurveToPoint(ctx, _wave2.cp1.x, _wave2.cp1.y, _wave2.cp2.x, _wave2.cp2.y, _wave2.p2.x, _wave2.p2.y);
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
