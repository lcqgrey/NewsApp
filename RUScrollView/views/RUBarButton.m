//
//  RUBarButtion.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUBarButton.h"
#import "RUButton.h"


@implementation RUBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


#pragma mark 设置Button内部的image的范围
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.6;
    
    return CGRectMake(0, 0, imageW, imageH);
}

#pragma mark 设置Button内部的title的范围
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
