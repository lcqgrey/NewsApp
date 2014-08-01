//
//  RUImageScanView.h
//  RUScrollView
//
//  Created by LCQ on 14-7-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUImageScanViewDelegate <NSObject>

@optional

- (void)nextPageAtIndex:(NSInteger)index;

- (void)prePageAtIndex:(NSInteger)index;

- (void)viewDidScroll:(UIScrollView *)scrollView;

- (void)viewDidEndDecelerating:(UIScrollView *)scrollView;

@end

typedef void(^GestureBlock)(void);

typedef NS_ENUM (NSUInteger, BottomViewType) {
    BottomViewBarType,
    BottomViewTextType
};

@interface RUImageScanView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) CGFloat maxZoomScale; //default 3
@property (nonatomic) CGFloat minZoomScale; //default 1
@property (nonatomic) BOOL hasTop;    //default YES
@property (nonatomic) BOOL hasBottom; //default YES
@property (nonatomic) BOOL autoPlay; //default NO
@property (nonatomic) BOOL loopPlay; //default NO
@property (nonatomic) BottomViewType bottomType;
@property (nonatomic) NSInteger earlyPageIndex; //default 0
@property (nonatomic, readonly, getter = pageIndicator) NSInteger pageIndicator;
@property (nonatomic, copy) GestureBlock doubleTapBlock;
@property (nonatomic) BOOL showAnimation; //default NO

@property (nonatomic, weak) id<RUImageScanViewDelegate> delegate;

@end


@interface ScanView : UIScrollView
@property (nonatomic) BOOL loopPlay;
@property (nonatomic, strong) id imageData;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, copy) GestureBlock doubleTapBlock;


@end