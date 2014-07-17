//
//  NewsTableView.h
//  RUScrollView
//
//  Created by LCQ on 14-6-24.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUTableView.h"

@interface NewsTableView : RUTableView

@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger cid;
@property (nonatomic) NSInteger lastRefreshDate;

@end
