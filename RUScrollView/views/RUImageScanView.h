//
//  RUImageScanView.h
//  RUScrollView
//
//  Created by LCQ on 14-7-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureBlock)(void);

@interface RUImageScanView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) CGFloat maxZoomScale;
@property (nonatomic) CGFloat minZoomScale;
@property (nonatomic) BOOL hasTop;
@property (nonatomic) BOOL hasBottom;
@property (nonatomic) BOOL autoPlay;
@property (nonatomic) BOOL loopPlay;
@property (nonatomic) NSInteger earlyPageIndex;
@property (nonatomic, readonly, getter = pageIndicator) NSInteger pageIndicator;
@property (nonatomic, copy) GestureBlock doubleTapBlock;
@property (nonatomic) BOOL showAnimation;

@end


@interface ScanView : UIScrollView
@property (nonatomic) BOOL loopPlay;
@property (nonatomic, strong) id imageData;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, copy) GestureBlock doubleTapBlock;


@end