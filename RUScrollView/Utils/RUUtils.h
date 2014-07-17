//
//  RUUtils.h
//  RUScrollView
//
//  Created by LCQ on 14-6-20.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageBoundle @"images.bundle" //you should to write your image boundle path if you has
#define GetRect( x, y, w, h) CGRectMake( (x), (y), (w), (h))

@interface RUUtils : NSObject

    //sender is a UIColor or NSString class (if NSString class like this "#666666" or "666666" or "r,g,b" or "r,g,b,a" )
+ (UIColor *)getColor:(id)sender;
    //sender is a UIFont or NSString class
+ (UIFont *)getFont:(id)sender;
    //sender is a NSString or NSValue class
+ (CGRect)getFrame:(id)sender;
    //sender is a NSValue or NSString class
+ (CGSize)getSize:(id)sender;
    //sender is  a UIImage or NSString class (if NSString class like this "/imageName" or "imageName" or "boundlePath/imageName" )
+ (UIImage *)getImage:(id)sender;

+ (BOOL)paraIsKindOfClass:(id)class para:(id)para;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
