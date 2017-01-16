//
//  ShipView.h
//  Bezier
//
//  Created by qinmin on 2017/1/16.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ship : NSObject
@property (nonatomic, assign) CGPoint position;//位置
@property (nonatomic, assign) CGSize size; //大小
@end


@interface Wave : NSObject
@property (nonatomic, assign) CGFloat speed; //速度
@property (nonatomic, assign) CGPoint cp1; //控制点1
@property (nonatomic, assign) CGPoint cp2; //控制点2
@property (nonatomic, assign) CGPoint p1; //起点
@property (nonatomic, assign) CGPoint p2; //终点
@end

@interface ShipView : UIView

@end
