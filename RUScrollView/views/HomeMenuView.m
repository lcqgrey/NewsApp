//
//  HomeMenuView.m
//  WineApp
//
//  Created by stone on 14-8-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "HomeMenuView.h"

#define pi M_PI
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)
#define smallCircleRadius 20

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
//    return radiansToDegrees(rads);
    return  rads;
}
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return radiansToDegrees(rads);
    
}

@implementation HomeMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    CGFloat halfMargin = 0.5 * halfMargin;
    CGFloat radius1 = distanceBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(_radius - smallCircleRadius, _radius));
    
    CGFloat startAngle1 = angleBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(_radius, _radius -  smallCircleRadius));
    CGFloat endAngle1 = angleBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(_radius -  smallCircleRadius, _radius));
    CGFloat radius2 = distanceBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(0, centerY - halfMargin));
    CGFloat startAngle2 = angleBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(0, _radius));
    CGFloat endAngle2 = angleBetweenPoints(CGPointMake(centerX, centerY), CGPointMake(_radius, 0));
    
    NSLog(@"%f %f %f %f %f %f ",radius1, radius2,startAngle1,startAngle2, endAngle1, endAngle2);
    //first circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, _radius, 0);
    CGContextAddLineToPoint(context, _radius, _radius - smallCircleRadius);
    CGContextAddArc(context, centerX, centerY, radius1, - (M_PI + startAngle1),- (M_PI + endAngle1), 1);
    CGContextAddLineToPoint(context, 0, _radius);
    CGContextAddArc(context, centerX, centerY, radius2,- (M_PI + startAngle2),- (M_PI + endAngle2), 0);
    //second circle
    CGContextMoveToPoint(context, _radius + _margin, 0);
    CGContextAddLineToPoint(context, _radius + _margin, _radius - smallCircleRadius);
    CGContextAddArc(context, centerX, centerY, radius1, startAngle1,endAngle1, 0);
    CGContextAddLineToPoint(context, rect.size.width, _radius);
    CGContextAddArc(context, centerX, centerY, radius2, startAngle2,endAngle2, 1);
    //third circle
    CGContextMoveToPoint(context, _radius + _margin, _radius + _margin + smallCircleRadius);
    CGContextAddLineToPoint(context, _radius + _margin, rect.size.height);
    CGContextAddArc(context, centerX, centerY, radius2, startAngle2, endAngle2, 1);
    CGContextAddLineToPoint(context, _radius + _margin + smallCircleRadius, _radius + _margin);
//    CGContextAddArc(context, centerX, centerY, radius2, startAngle2,endAngle2, 1);
//    CGContextMoveToPoint(context, self.bounds.size.width, _radius + _margin);
//    CGContextAddLineToPoint(context, _radius + _margin, _radius + _margin);
//    CGContextAddLineToPoint(context, _radius + _margin, 2 * _radius + _margin);
//    CGContextAddArc(context, _radius + _margin, _radius + _margin, _radius,  0.5 * M_PI, 0, 1);
//    //forth circle
//    CGContextMoveToPoint(context, _radius, 2 * _radius + _margin);
//    CGContextAddLineToPoint(context, _radius, _radius + _margin);
//    CGContextAddLineToPoint(context, 0, _radius + _margin);
//    CGContextAddArc(context, _radius,  _radius + _margin, _radius,  - M_PI, 0.5 * M_PI, 1);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapG];
    
//    [self addImageView];
    // Drawing code
}

- (void)addImageView
{
    CGFloat length = 0.5 * _radius;
    CGFloat temp = 22;
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(length - temp, length - temp, length + temp, length + temp)];
    imageView1.image = [MyUtils getImage:@"/8.jpg"];
    imageView1.clipsToBounds = YES;
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_radius + _margin, length - temp, length + temp, length + temp)];
    imageView2.image = [MyUtils getImage:@"/8.jpg"];
    imageView2.clipsToBounds = YES;
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView2];
    
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(_radius + _margin , _radius + _margin, length + temp, length + temp)];
    imageView3.image = [MyUtils getImage:@"/8.jpg"];
    imageView3.clipsToBounds = YES;
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(length - temp, _radius + _margin, length + temp, length + temp)];
    imageView4.image = [MyUtils getImage:@"/8.jpg"];
    imageView4.clipsToBounds = YES;
    imageView4.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView4];
}

- (void)didTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    CGFloat distance1 = [MyUtils distanceFrom:point topoint:CGPointMake(self.radius, self.radius)];
    if (point.x > 0 && point.x < self.radius && point.y > 0 && point.y < self.radius && distance1 < self.radius) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickViewAtIndex:)]) {
            [self.delegate didClickViewAtIndex:0];
        }
    }
    CGFloat distance2 = [MyUtils distanceFrom:point topoint:CGPointMake(self.radius + self.margin, self.radius)];
    if (point.x > self.margin + self.radius && point.x < 2 * self.radius + self.margin && point.y > 0 && point.y < self.radius && distance2 < self.radius) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickViewAtIndex:)]) {
            [self.delegate didClickViewAtIndex:1];
        }
    }
    CGFloat distance3 = [MyUtils distanceFrom:point topoint:CGPointMake(self.radius + self.margin, self.radius + self.margin)];
    if (point.x > self.radius + self.margin && point.x < 2 * self.radius + self.margin && point.y > self.radius + self.margin && point.y < 2 * self.radius + self.margin && distance3 < self.radius) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickViewAtIndex:)]) {
            [self.delegate didClickViewAtIndex:2];
        }
    }
    CGFloat distance4 = [MyUtils distanceFrom:point topoint:CGPointMake(self.radius, self.radius + self.margin)];
    if (point.x > 0 && point.x < self.radius && point.y > self.radius + self.margin && point.y < 2 * self.radius + self.margin && distance4 < self.radius) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickViewAtIndex:)]) {
            [self.delegate didClickViewAtIndex:3];
        }
    }
    
}

@end
