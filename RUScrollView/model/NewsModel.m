//
//  NewsModel.m
//  RUScrollView
//
//  Created by LCQ on 14-6-24.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"id": @"newsId",
                                                      @"PUBLISHDATE": @"publishDate"
                                                      }];
}

@end
