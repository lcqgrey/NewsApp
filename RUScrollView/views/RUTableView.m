//
//  RUTableView.m
//  RUScrollView
//
//  Created by LCQ on 14-5-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUTableView.h"
@interface RUTableView ()<UIScrollViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    CGFloat height;
    UIView *containor;
}
@end

@implementation RUTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSources = [NSMutableArray array];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setLoadingStyle:(RUTableViewLoadingPullUpStyle)LoadingStyle
{
    _LoadingStyle = LoadingStyle;
    if (_LoadingStyle == RUTableViewLoadingInFooterButtonStyle) {
        
    }
    [self createHeader];
    [self createFooter];
}



//添加下拉头部
- (void)createHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self refresh:refreshView];
    };
//    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshVivew ,MJRefreshState state)  {
//        
//    };
//    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshVivew){
//        
//    };
    _header = header;
}


//添加上拉尾部
- (void)createFooter
{
    //三种加载样式
    if (_LoadingStyle == RUTableViewLoadingInFooterNone) {
        
        containor = [[UIView alloc]initWithFrame:CGRectZero];
        
        self.tableFooterView = containor;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:containor.bounds];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        titleLabel.hidden = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.tag = 357;
        titleLabel.text = kRUTableViewButtonTitleLastPage;
        [containor addSubview:titleLabel];
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.center = containor.center;
        self.activotyIndicator = act;
        [containor addSubview:act];
    }
    else if (_LoadingStyle == RUTableViewLoadingInFooterButtonStyle) {
        UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        footerButton.frame = CGRectMake(0, 0, kViewWidthInView(self), 49);
        
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.tag = 455;
        act.center = footerButton.center;
        [footerButton addSubview:act];
        [footerButton setTitle:kRUTableViewButtonTitle forState:UIControlStateNormal];
        footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [footerButton setBackgroundColor:[UIColor whiteColor]];
        [footerButton addTarget:self action:@selector(didFooterClick:) forControlEvents:UIControlEventTouchUpInside];
        footerButton.hidden = YES;
        
        self.tableFooterView = footerButton;
        self.footerButton = footerButton;
    }
    else if (_LoadingStyle == RUTableViewLoadingInFooterAnnimationStyle) {
        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
        footer.scrollView = self;
        
        footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            [self refresh:refreshView];
        };
//        footer.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView ,MJRefreshState state)  {
//        };
//        footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView){
//            
//        };
        _footer = footer;
    }
    
}

- (void)refresh:(MJRefreshBaseView *)refreshView
{
    _isRefreshing = YES;
    if (containor) {
        containor.bounds = CGRectMake(0, 0, self.bounds.size.width, 0);
    }
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(update:with:)]) {
            [self.refreshDelegate update:self with:refreshView];
        }
    }
    else {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(requestMore:with:)]) {
            [self.refreshDelegate requestMore:self with:refreshView];
        }
    }
}

- (void)didFooterClick:(UIButton *)sender
{
    UIActivityIndicatorView *act = (UIActivityIndicatorView *)[sender viewWithTag:455];
    [act startAnimating];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self refresh:nil];
}

- (void)setIsLastPage:(BOOL)isLastPage
{
    _isLastPage = isLastPage;
}

- (void)refreshWithNoneStyle
{
    if (_LoadingStyle == RUTableViewLoadingInFooterNone) {
        containor.bounds = CGRectMake(0, 0, self.bounds.size.width, 10);
        [self.activotyIndicator startAnimating];
        [self refresh:nil];
    }
}

- (void)beginRefresh
{
    if (_header) {
        [_header beginRefreshing];
        _isRefreshing = YES;
    }

}

- (void)endRefresh:(MJRefreshBaseView *)refreshView
{
    if (refreshView) {
        [refreshView endRefreshing];
    }
    if (_LoadingStyle == RUTableViewLoadingInFooterAnnimationStyle) {
        if (_isLastPage) {
            refreshView.needShowNoticeWhenNoData = YES;
        }
        else {
            refreshView.needShowNoticeWhenNoData = NO;
        }
        _isRefreshing = NO;
    }
    else if (_LoadingStyle == RUTableViewLoadingInFooterButtonStyle) {
        [[_footerButton.subviews firstObject] stopAnimating];
        if (_isLastPage) {
            _footerButton.hidden = NO;
            [_footerButton setTitle:kRUTableViewButtonTitleLastPage forState:UIControlStateNormal];
        }
        else {
            _footerButton.hidden = NO;
            [_footerButton setTitle:kRUTableViewButtonTitle forState:UIControlStateNormal];
        }
        _isRefreshing = NO;
    }
    else if (_LoadingStyle == RUTableViewLoadingInFooterNone) {
        [_activotyIndicator stopAnimating];
        [self showMessageForLastPage];
    }
}

- (void)showMessageForLastPage
{
    UILabel *la = (UILabel *)[containor viewWithTag:357];
    if (_isLastPage) {
        la.hidden = NO;
        CGRect temp = containor.frame;
        temp.size.height = 50;
        containor.frame = temp;
        [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.25];
    }
    else {
        containor.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        la.hidden = YES;
        _isRefreshing = NO;
    }
}

- (void)showMessage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGPoint offsetNew = self.contentOffset;
        CGPoint offsetOld = self.contentOffset;
        offsetNew.y += 50;
        NSValue *oldValue = [NSValue valueWithCGPoint:offsetOld];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
                self.contentOffset = offsetNew;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self performSelector:@selector(hiddenMessage:) withObject:oldValue afterDelay:0];
                }
            }];
        });
    });
    
}

- (void)hiddenMessage:(NSValue *)value
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGPoint targetPoint = [value CGPointValue];
        CGRect temp = containor.frame;
        temp.size.height = 0;
        containor.frame = temp;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                self.contentOffset = targetPoint;
            } completion:^(BOOL finished) {
                if (finished) {
                    containor.frame = temp;
                    UILabel *la = (UILabel *)[containor viewWithTag:357];
                    la.hidden = YES;
                    [containor bringSubviewToFront:self.activotyIndicator];
                    _isRefreshing = NO;
                }
            }];
        });
    });
}


@end
