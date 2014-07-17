//
//  NSDate+DateCalculate.h
//  RUScrollView
//
//  Created by LCQ on 14-5-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateCalculate)

+ (int)lastDate:(NSDate *)ldate;//上一次时间距现在相差的秒
+ (int)firstDate:(NSDate *)fDate secondDate:(NSDate *)sDate;//两个时间相差的秒

@end
