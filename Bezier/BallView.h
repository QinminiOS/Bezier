//
//  MyView.h
//  UIkit
//
//  Created by qinmin on 2017/1/14.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ball : NSObject
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float accelerate;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGSize size;
@end

@interface Rope : NSObject
@property (nonatomic, assign) float k;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint control;
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;
@end

@interface BallView : UIView
- (void)stop;
- (void)start;
@end
