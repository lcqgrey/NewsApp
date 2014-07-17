//
//  RUTableView.h
//  RUScrollView
//
//  Created by LCQ on 14-5-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kRUTableViewButtonTitle = @"点击加载更多";
static NSString *const kRUTableViewButtonTitleLastPage = @"已经是最后一页了";


typedef NS_ENUM (NSInteger,RUTableViewLoadingPullUpStyle) {
    RUTableViewLoadingInFooterNone,
    RUTableViewLoadingInFooterButtonStyle,
    RUTableViewLoadingInFooterAnnimationStyle
};

@class RUTableView;

@protocol RUTableViewDelegate <NSObject>

- (void)requestMore:(RUTableView *)table with:(MJRefreshBaseView *)refreshView;//上拉加载的回调
- (void)update:(RUTableView *)table with:(MJRefreshBaseView *)refreshView;//下拉刷新的回调

@end

@interface RUTableView : UITableView

@property (nonatomic, weak) id<RUTableViewDelegate> refreshDelegate;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign) BOOL ShouldRefreshing;//判断第一次是否有必要刷新
@property (nonatomic, strong) NSDate *refreshDate;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic) RUTableViewLoadingPullUpStyle LoadingStyle; //刷新样式，不设则为普通table
@property (nonatomic, strong) UIButton *footerButton; //当样式为按钮样式时的底部按钮
@property (nonatomic, strong) UIActivityIndicatorView *activotyIndicator; //当样式为None时的底部指示剂
@property (nonatomic) BOOL isLastPage; //判断是否到最后一页了
@property (nonatomic) BOOL hasData; //判断第一页是否有数据
@property (nonatomic) BOOL isRefreshing; //判断是否正在刷新

- (void)beginRefresh; //控制头部控件刷新

- (void)endRefresh:(MJRefreshBaseView *)refreshView;

- (void)refreshWithNoneStyle; //当样式为None时调用

@end
