//
//  TestView.m
//  RUScrollView
//
//  Created by 鲁长庆 on 14-8-8.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    
     //first circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context,  _radius, 0);
    CGContextAddLineToPoint(context, _radius, _radius);
    CGContextAddLineToPoint(context, 0, _radius);
    CGContextAddArc(context, _radius, _radius, _radius,  - M_PI, - 0.5 * M_PI, 0);
    //second circle
    CGContextMoveToPoint(context, _radius + _margin, 0);
    CGContextAddLineToPoint(context, _radius + _margin, _radius);
    CGContextAddLineToPoint(context, self.bounds.size.width, _radius);
    CGContextAddArc(context, _radius + _margin, _radius, _radius,  0, - 0.5 * M_PI, 1);
    //third circle
    CGContextMoveToPoint(context, self.bounds.size.width, _radius + _margin);
    CGContextAddLineToPoint(context, _radius + _margin, _radius + _margin);
    CGContextAddLineToPoint(context, _radius + _margin, 2 * _radius + _margin);
    CGContextAddArc(context, _radius + _margin, _radius + _margin, _radius,  0.5 * M_PI, 0, 1);
    //forth circle
    CGContextMoveToPoint(context, _radius, 2 * _radius + _margin);
    CGContextAddLineToPoint(context, _radius, _radius + _margin);
    CGContextAddLineToPoint(context, 0, _radius + _margin);
    CGContextAddArc(context, _radius,  _radius + _margin, _radius,  - M_PI, 0.5 * M_PI, 1);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapG];
    // Drawing code
}
- (void)didTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    CGFloat distance1 = [self distanceFrom:point topoint:CGPointMake(self.radius, self.radius)];
    if (point.x > 0 && point.x < self.radius && point.y > 0 && point.y < self.radius && distance1 < self.radius) {
        NSLog(@"tap1");
    }
    CGFloat distance2 = [self distanceFrom:point topoint:CGPointMake(self.radius + self.margin, self.radius)];
    if (point.x > self.margin + self.radius && point.x < 2 * self.radius + self.margin && point.y > 0 && point.y < self.radius && distance2 < self.radius) {
        NSLog(@"tap2");
    }
    CGFloat distance3 = [self distanceFrom:point topoint:CGPointMake(self.radius + self.margin, self.radius + self.margin)];
    if (point.x > self.radius + self.margin && point.x < 2 * self.radius + self.margin && point.y > self.radius + self.margin && point.y < 2 * self.radius + self.margin && distance3 < self.radius) {
        NSLog(@"tap3");
    }
    CGFloat distance4 = [self distanceFrom:point topoint:CGPointMake(self.radius, self.radius + self.margin)];
    if (point.x > 0 && point.x < self.radius && point.y > self.radius + self.margin && point.y < 2 * self.radius + self.margin && distance4 < self.radius) {
        NSLog(@"tap4");
    }
    
}

- (CGFloat)distanceFrom:(CGPoint)fromPoint topoint:(CGPoint)topoint
{
    CGFloat x = fromPoint.x - topoint.x;
    CGFloat y = fromPoint.y - topoint.y;
    return sqrtf(x * x + y * y);
}

@end
