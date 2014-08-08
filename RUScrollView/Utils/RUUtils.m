//
//  RUUtils.m
//  RUScrollView
//
//  Created by LCQ on 14-6-20.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUUtils.h"

@implementation RUUtils

+ (UIViewController*)viewInviewController:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (UIColor *)getColor:(id)sender
{
    UIColor *color = nil;
    if ([self paraIsKindOfClass:[UIColor class] para:sender]) {
        color = sender;
    }
    else if ([self paraIsKindOfClass:[NSString class] para:sender]) {
        NSString *str = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *tempArr = [str componentsSeparatedByString:@","];
        if (tempArr.count == 1) {
            color = [self colorWithHexString:tempArr[0]];
        }
        else if (tempArr.count == 3) {
            color = [UIColor colorWithRed:[tempArr[0] floatValue]/255.0 green:[tempArr[1] floatValue]/255.0 blue:[tempArr[2] floatValue]/255.0 alpha:1];
        }
        else if (tempArr.count == 4) {
            color = [UIColor colorWithRed:[tempArr[0] floatValue]/255.0 green:[tempArr[1] floatValue]/255.0 blue:[tempArr[2] floatValue]/255.0 alpha:[tempArr[3] floatValue]];
        }
        else {
            NSAssert(tempArr.count != 1 || tempArr.count != 3 || tempArr.count != 4, @"you must past a para like this \"#666666\" or \"666666\" or \"r,g,b\" or \"r,g,b,a\" ");
        }
    }
    
    return color;
}

+ (UIFont *)getFont:(id)sender
{
    UIFont *font = nil;
    if ([self paraIsKindOfClass:[UIFont class] para:sender]) {
        font = sender;
    }
    else if ([self paraIsKindOfClass:[NSString class] para:sender]) {
        NSString *str = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *tempArr = [str componentsSeparatedByString:@","];
        if (tempArr.count == 1) {
            font = [UIFont systemFontOfSize:[tempArr[0] floatValue]];
        }
        else if (tempArr.count == 2) {
            font = [UIFont fontWithName:tempArr[0] size:[tempArr[1] floatValue]];
        }
        else {
            NSAssert(tempArr.count != 1 || tempArr.count != 2, @"you must past a para like this \"fontName ,fontSize\" or \"fontSize\" ");
        }
    }

    return font;
}

+ (CGRect)getFrame:(id)sender
{
    CGRect rect = CGRectNull;
    
    if ([RUUtils paraIsKindOfClass:[NSValue class] para:sender]) {
        rect = [sender CGRectValue];
    }
    else if ([RUUtils paraIsKindOfClass:[NSString class] para:sender]) {
        NSString *str = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *tempArr = [str componentsSeparatedByString:@","];
        if (tempArr.count == 4) {
            rect = CGRectMake([tempArr[0] floatValue], [tempArr[1] floatValue], [tempArr[2] floatValue], [tempArr[3] floatValue]);
        }
        else {
            NSAssert(tempArr.count != 4, @"you must past a para like this \"x,y,w,h\" ");
        }
    }
    
    return rect;
}

+ (CGSize)getSize:(id)sender
{
    CGSize size = CGSizeZero;
    if ([RUUtils paraIsKindOfClass:[NSValue class] para:sender]) {
        size = [sender CGSizeValue];
    }
    else if ([RUUtils paraIsKindOfClass:[NSString class] para:sender]) {
        NSString *str = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *tempArr = [str componentsSeparatedByString:@","];
        if (tempArr.count == 2) {
            size = CGSizeMake([tempArr[0] floatValue], [tempArr[1] floatValue]);
        }
        else {
            NSAssert(tempArr.count != 2, @"you must past a para like this \"w,h\" ");
        }
    }
    
    return size;
}

+ (UIImage *)getImage:(id)sender
{
    if (sender == nil) {
        return nil;
    }
    UIImage *image = nil;
    NSAssert(!(![RUUtils paraIsKindOfClass:[NSString class] para:sender] && ![RUUtils paraIsKindOfClass:[UIImage class] para:sender]), @"past must be a NSString  or UIImage class");
    if ([RUUtils paraIsKindOfClass:[NSString class] para:sender]) {
        if ([sender hasPrefix:@"/"]) {
            NSString *str = [ImageBoundle stringByAppendingString:sender];
            image = [UIImage imageNamed:str];
        }
        else {
            NSString *str = sender;
            image = [UIImage imageNamed:str];
        }
    }
    else if ([RUUtils paraIsKindOfClass:[UIImage class] para:sender]) {
        image = sender;
    }
    if (image == nil) {
        NSLog(@"%@",[NSString stringWithFormat:@"image with name \"%@\" has not found",sender]);
    }
    return image;
}

+ (BOOL)paraIsKindOfClass:(id)class para:(id)para
{
    if ([para isKindOfClass:class]) {
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    if ([stringToConvert hasPrefix:@"#"]) {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

@end
