//
//  RUImageScanView.m
//  RUScrollView
//
//  Created by LCQ on 14-7-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUImageScanView.h"
#import <UIImageView+WebCache.h>

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

static NSString *pageIndexStr = @"0";


@interface RUImageScanView () <UIScrollViewDelegate>
{
    UIScrollView *slideScrollView;
    NSInteger dataSourceCount;
    NSMutableArray *scanViewArray;
    NSInteger pageIndex;
    BOOL isLeft;
    CGFloat newx;
    BOOL isScrolling;
    BOOL isPreEnd;
    BOOL isNextEnd;
}

@end

@implementation RUImageScanView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maxZoomScale = 3;
        self.minZoomScale = 1;
        self.hasBottom = YES;
        self.hasTop = YES;
        self.autoPlay = NO;
        self.loopPlay = NO;
        pageIndex = 0;
    }
    return self;
}

- (void)setEarlyPageIndex:(NSInteger)earlyPageIndex
{
    _earlyPageIndex = earlyPageIndex;
    pageIndex = _earlyPageIndex;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!slideScrollView) {
        dataSourceCount = _dataSource.count;
        if (dataSourceCount == 0) {
            return;
        }
        slideScrollView = [[UIScrollView alloc]init];
        slideScrollView.backgroundColor = [UIColor blackColor];
        slideScrollView.frame = self.frame;
        slideScrollView.pagingEnabled = YES;
        slideScrollView.bounces = NO;
        slideScrollView.delegate = self;
        slideScrollView.showsHorizontalScrollIndicator = NO;
        scanViewArray = [NSMutableArray array];
        if (dataSourceCount == 1) {
            slideScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            ScanView *view = [[ScanView alloc]init];
            view.frame = CGRectMake(0, slideScrollView.frame.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
            view.imageData = _dataSource[pageIndex];
            view.maximumZoomScale = _maxZoomScale;
            view.minimumZoomScale = _minZoomScale;
            view.pageIndex = pageIndex;
            view.loopPlay = _loopPlay;
            view.doubleTapBlock = self.doubleTapBlock;
            [scanViewArray addObject:view];
            [slideScrollView addSubview:view];
        }
        else if (dataSourceCount == 2 && !_loopPlay) {
            slideScrollView.contentSize = CGSizeMake(2*self.frame.size.width, self.frame.size.height);
            CGPoint offset = slideScrollView.contentOffset;
            offset.x = slideScrollView.bounds.size.width;
            slideScrollView.contentOffset = offset;
            
            for (int i = 0 ; i < 2 ; i++) {
                ScanView *view = [[ScanView alloc]init];
                view.frame = CGRectMake(i * slideScrollView.bounds.size.width, slideScrollView.frame.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
                view.imageData = _dataSource[i];
                view.maximumZoomScale = _maxZoomScale;
                view.minimumZoomScale = _minZoomScale;
                view.pageIndex = pageIndex;
                view.loopPlay = _loopPlay;
                view.doubleTapBlock = self.doubleTapBlock;
                slideScrollView.delegate = nil;
                slideScrollView.bounces = YES;
                if (pageIndex == 1) {
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = slideScrollView.bounds.size.width;
                    slideScrollView.contentOffset = offset;
                }
                else {
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = 0;
                    slideScrollView.contentOffset = offset;
                }
                [scanViewArray addObject:view];
                [slideScrollView addSubview:view];
            }
        }
        else {
            slideScrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
            CGPoint offset = slideScrollView.contentOffset;
            offset.x = slideScrollView.bounds.size.width;
            slideScrollView.contentOffset = offset;
            
            for (int i = 0 ; i < 3 ; i++) {
                ScanView *view = [[ScanView alloc]init];
                view.frame = CGRectMake(i * slideScrollView.bounds.size.width, slideScrollView.frame.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
                NSInteger tempIndex = 0;
                if (i == 0) {
                    tempIndex = pageIndex - 1;
                    if (tempIndex < 0) {
                        tempIndex = _dataSource.count - 1;
                    }
                    view.imageData = _dataSource[tempIndex];
                }
                else if (i == 1) {
                    tempIndex = pageIndex;
                    view.imageData = _dataSource[tempIndex];
                }
                else if (i == 2) {
                    tempIndex = pageIndex + 1;
                    if (tempIndex > _dataSource.count - 1) {
                        tempIndex = 0;
                    }
                    view.imageData = _dataSource[tempIndex];
                }
                view.maximumZoomScale = _maxZoomScale;
                view.minimumZoomScale = _minZoomScale;
                view.pageIndex = pageIndex;
                view.loopPlay = _loopPlay;
                view.doubleTapBlock = self.doubleTapBlock;
                [scanViewArray addObject:view];
                [slideScrollView addSubview:view];
            }
        }
        [self addSubview:slideScrollView];
    }
}

- (void)setShowAnimation:(BOOL)showAnimation
{
    _showAnimation = showAnimation;
    
}

- (NSInteger)pageIndicator
{
    return pageIndex;
}


- (void)layoutScanView
{
    for (int i = 0; i < 3; i++) {
        ScanView *view = scanViewArray[i];
        NSInteger tempIndex = 0;
        if (i == 0) {
            tempIndex = pageIndex - 1;
            if (tempIndex < 0) {
                tempIndex = _dataSource.count - 1;
            }
            view.pageIndex = tempIndex;
            view.imageData = _dataSource[tempIndex];
        }
        else if (i == 1) {
            tempIndex = pageIndex;
            view.pageIndex = tempIndex;
            view.imageData = _dataSource[tempIndex];
        }
        else if (i == 2) {
            tempIndex = pageIndex + 1;
            if (tempIndex > _dataSource.count - 1) {
                tempIndex = 0;
            }
            view.pageIndex = tempIndex;
            view.imageData = _dataSource[tempIndex];
        }
    }
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    newx = scrollView.contentOffset.x ;
    if (_loopPlay) {
        if (newx != slideScrollView.bounds.size.width && newx != 2 * slideScrollView.bounds.size.width && newx != 0) {
            if (newx > slideScrollView.bounds.size.width) {
                isLeft = YES;
            }else if(newx < slideScrollView.bounds.size.width){
                isLeft = NO;
            }
        }
    }
    else {
        if (newx != slideScrollView.bounds.size.width && newx != 2 * slideScrollView.bounds.size.width && newx != 0) {
            if (isNextEnd) {
                if (newx > 2 * slideScrollView.bounds.size.width) {
                    isLeft = YES;
                }
                else {
                    isLeft = NO;
                }
            }
            else if (isPreEnd) {
                if (newx > 0) {
                    isLeft = YES;
                }
                else {
                    isLeft = NO;
                }
            }
            else {
                if (newx > slideScrollView.bounds.size.width) {
                    isLeft = YES;
                }else if(newx < slideScrollView.bounds.size.width){
                    isLeft = NO;
                }
            }
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_loopPlay) {
        [self loopPlayOperationWithScrollView:scrollView];
    }
    else {
        [self notLoopPlayOperationWithScrollView:scrollView];
    }
}

- (void)loopPlayOperationWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 2 * slideScrollView.bounds.size.width || slideScrollView.contentOffset.x == 0) {
        if (isLeft) {
            [self showNextView];
        }
        else {
            [self showPreView];
        }
        CGPoint offset = slideScrollView.contentOffset;
        offset.x = slideScrollView.bounds.size.width;
        slideScrollView.contentOffset = offset;
    }
}

- (void)notLoopPlayOperationWithScrollView:(UIScrollView *)scrollView
{
    NSLog(@"++%f",scrollView.contentOffset.x);
    if ((scrollView.contentOffset.x == 2 * slideScrollView.bounds.size.width && !isNextEnd) || (scrollView.contentOffset.x == 0 && !isPreEnd) || (scrollView.contentOffset.x == slideScrollView.bounds.size.width && (isPreEnd || isNextEnd))) {
        if (isNextEnd || isPreEnd) {
            if (isLeft && slideScrollView.contentOffset.x != 2 * slideScrollView.bounds.size.width) {
                pageIndex = 1;
                isPreEnd = NO;
                slideScrollView.bounces = NO;
            }
            else if (!isLeft && slideScrollView.contentOffset.x != 0) {
                pageIndex = _dataSource.count - 2;
                isNextEnd = NO;
                slideScrollView.bounces = NO;
            }
        }
        else {
            if (isLeft) {
                isPreEnd = NO;
                if (pageIndex == 0) {
                    pageIndex = 1;
                }
                else if (pageIndex == _dataSource.count - 2) {
                    pageIndex = _dataSource.count - 1;
                    isNextEnd = YES;
                }
                if (!isNextEnd) {
                    [self showNextView];
                    slideScrollView.bounces = NO;
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = slideScrollView.bounds.size.width;
                    slideScrollView.contentOffset = offset;
                }
                else {
                    slideScrollView.bounces = YES;
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = 2 * slideScrollView.bounds.size.width;
                    slideScrollView.contentOffset = offset;
                }
            }
            else {
                isNextEnd = NO;
                if (pageIndex == _dataSource.count - 1) {
                    pageIndex = _dataSource.count - 2;
                }
                else if (pageIndex == 1) {
                    pageIndex = 0;
                    isPreEnd = YES;
                }
                if (!isPreEnd) {
                    [self showPreView];
                    slideScrollView.bounces = NO;
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = slideScrollView.bounds.size.width;
                    slideScrollView.contentOffset = offset;
                }
                else {
                    slideScrollView.bounces = YES;
                    CGPoint offset = slideScrollView.contentOffset;
                    offset.x = 0;
                    slideScrollView.contentOffset = offset;
                }
            }
        }
    }
}

//前一页
- (void)showPreView
{
    pageIndex -= 1;
    if (pageIndex < 0) {
        pageIndex = _dataSource.count - 1;
    }
    [self layoutScanView];
}

//后一页
- (void)showNextView
{
    pageIndex += 1;
    if (pageIndex > _dataSource.count - 1) {
        pageIndex = 0;
    }
    [self layoutScanView];
}


//单击
- (void)singleTapG:(UITapGestureRecognizer *)sender
{
    if (self.doubleTapBlock) {
        self.doubleTapBlock();
    }
}


@end


@interface ScanView () <UIScrollViewDelegate>
{
    UIImageView *customImageView;
    BOOL isDoubleTapZoom;
    CGFloat touchX;
    CGFloat touchY;
    CGFloat offsetY;
}

@end

@implementation ScanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
}

- (void)setImageData:(id)imageData
{
    _imageData = imageData;
    if (!customImageView) {
        customImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        customImageView.userInteractionEnabled = YES;
        customImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:customImageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [customImageView addGestureRecognizer:doubleTap];
    }
    isDoubleTapZoom = NO;
    [self setZoomScale:1.0];

    if ([_imageData isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:_imageData];
        __weak UIImageView *tempImageView = customImageView;
        [customImageView setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!image || error) {
                tempImageView.image = [RUUtils getImage:PlaceholderImage];
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else if ([_imageData isKindOfClass:[NSURL class]]) {
        NSURL *url = _imageData;
        __weak UIImageView *tempImageView = customImageView;
        [customImageView setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!image || error) {
                tempImageView.image = [RUUtils getImage:PlaceholderImage];
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else if ([_imageData isKindOfClass:[UIImage class]]) {
        customImageView.image = _imageData;
    }
}


#pragma mark - scrollView delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return customImageView;
}

//双击
- (void)didDoubleTap:(UITapGestureRecognizer *)sender
{
    touchX = [sender locationInView:sender.view].x;
    touchY = [sender locationInView:sender.view].y;
    if (self.zoomScale > 1.0) {
        isDoubleTapZoom = YES;
    }
    if(isDoubleTapZoom){
        isDoubleTapZoom = NO;
        [self setZoomScale:1.0 animated:YES];
    }else{
        isDoubleTapZoom = YES;
        pageIndexStr = [NSString stringWithFormat:@"%d",self.pageIndex];
        [self setZoomScale:self.maximumZoomScale animated:YES];

        //双击放大时，改变偏移量，让图片显示点击位置的部分图片。
        CGPoint offset = self.contentOffset;
        offset.x = self.maximumZoomScale * touchX - touchX;
        offset.y = self.maximumZoomScale * touchY - touchY;
        self.contentOffset = offset;
    }
}


- (void)dealloc
{
    NSLog(@"is dealloc");
}

@end
