//
//  AppManager.m
//  RUScrollView
//
//  Created by LCQ on 14-4-30.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (id)defaultManager
{
    static AppManager *instance = nil;\
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppManager alloc]init];
    });
    return instance;
}

- (NSString *)getLocalString:(NSString *)string
{
    return NSLocalizedStringFromTable(string, @"Localizable", @"");
}

@end
