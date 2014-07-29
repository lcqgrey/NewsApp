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
@property (nonatomic) NSInteger initialPageIndex;
@property (nonatomic, getter = pageIndicator) NSInteger pageIndicator;
@property (nonatomic, copy) GestureBlock tapBlock;

@end


@interface ScanView : UIScrollView

@property (nonatomic, strong) id imageData;
@property (nonatomic, copy) GestureBlock tapBlock;


@end