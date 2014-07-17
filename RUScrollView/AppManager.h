//
//  AppManager.h
//  RUScrollView
//
//  Created by LCQ on 14-4-30.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

+ (id)defaultManager;

- (NSString *)getLocalString:(NSString *)string;//本地化字符

@end
