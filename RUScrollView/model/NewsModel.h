//
//  NewsModel.h
//  RUScrollView
//
//  Created by LCQ on 14-6-24.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "JSONModel.h"

@protocol NewsModel <NSObject>

@end

@interface NewsModel : JSONModel

@property (nonatomic) NSInteger rownum;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *newsUrl;
@property (nonatomic) NSInteger typeId;
@property (nonatomic) NSInteger sequence;
@property (nonatomic) NSInteger attribute;
@property (nonatomic) NSInteger lastUpdateTime;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, copy) NSString * picUrl;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic) NSInteger commentCount;

@end
