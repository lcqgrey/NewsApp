//
//  newsListModel.h
//  RUScrollView
//
//  Created by LCQ on 14-6-24.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "JSONModel.h"
#import "NewsModel.h"

@interface NewsListModel : JSONModel

@property (nonatomic, strong) NSArray <NewsModel, ConvertOnDemand> *news;
@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString<Optional> *msg;

@end
