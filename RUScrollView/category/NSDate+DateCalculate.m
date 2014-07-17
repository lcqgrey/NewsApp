//
//  NSDate+DateCalculate.m
//  RUScrollView
//
//  Created by LCQ on 14-5-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "NSDate+DateCalculate.h"

@implementation NSDate (DateCalculate)

+ (int)lastDate:(NSDate *)ldate
{
    NSTimeInterval secondsToNow = [ldate timeIntervalSinceNow];
    return secondsToNow;
}

+ (int)firstDate:(NSDate *)fDate secondDate:(NSDate *)sDate
{
    NSTimeInterval secondsBetweenTowDays = [fDate timeIntervalSinceDate:sDate];
    return secondsBetweenTowDays;
}

@end
