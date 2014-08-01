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


@interface RUImageScanView () <UIScrollViewDelegate>
{
    UIScrollView *slideScrollView;
    NSMutableArray *scanViewArray;
    NSInteger pageIndex;
    BOOL isLeft;
    CGFloat newx;
    BOOL isScrolling;
    BOOL isPreEnd;
    BOOL isNextEnd;
    UIView *topView;
    UIView *bottomView;
    
    CGFloat oldx; // only use when dataSource.count <= 3 and loopPlay is No
    CGFloat stopOldx;
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
        self.showAnimation = NO;
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
        if (_dataSource.count == 0) {
            return;
        }
        [self loadMainView];
        
        if (_hasTop) {
            [self addTopView];
        }
        if (_hasBottom) {
            [self addBottomView];
        }
        if (self.showAnimation) {
            [self showViewAnimation];
        }
    }
}

#pragma mark - animation

- (void)showViewAnimation
{
    CGAffineTransform transform =
    CGAffineTransformScale(self.transform, 0.1, 0.1);
    [self setTransform:transform];
    self.center = self.superview.center;
    
    [UIView beginAnimations:@"imageViewBig" context:nil];
    [UIView setAnimationDuration:0.25];
    CGAffineTransform newTransform = CGAffineTransformConcat(self.transform,  CGAffineTransformInvert(self.transform));
    [self setTransform:newTransform];
    self.alpha = 1.0;
    self.center = self.superview.center;
    [UIView commitAnimations];
}

#pragma mark - create view methods

- (void)loadMainView
{
    slideScrollView = [[UIScrollView alloc]init];
    slideScrollView.backgroundColor = [UIColor blackColor];
    slideScrollView.frame = self.frame;
    slideScrollView.pagingEnabled = YES;
    slideScrollView.bounces = NO;
    slideScrollView.delegate = self;
    slideScrollView.showsHorizontalScrollIndicator = NO;
    scanViewArray = [NSMutableArray array];
    if (_dataSource.count == 1) {
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
    else if ((_dataSource.count == 2 || _dataSource.count == 3) && !_loopPlay) {
        slideScrollView.contentSize = CGSizeMake(_dataSource.count*self.frame.size.width, self.frame.size.height);
        CGPoint offset = slideScrollView.contentOffset;
        offset.x = slideScrollView.bounds.size.width;
        slideScrollView.contentOffset = offset;
        
        for (int i = 0 ; i < _dataSource.count ; i++) {
            ScanView *view = [[ScanView alloc]init];
            view.frame = CGRectMake(i * slideScrollView.bounds.size.width, slideScrollView.frame.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
            view.imageData = _dataSource[i];
            view.maximumZoomScale = _maxZoomScale;
            view.minimumZoomScale = _minZoomScale;
            view.pageIndex = pageIndex;
            view.loopPlay = _loopPlay;
            view.doubleTapBlock = self.doubleTapBlock;
            slideScrollView.delegate = self;
            slideScrollView.bounces = YES;
            if (pageIndex == 0) {
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = 0;
                slideScrollView.contentOffset = offset;
            }
            else if (pageIndex == 1) {
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = slideScrollView.bounds.size.width;
                slideScrollView.contentOffset = offset;
            }
            else {
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = 2 * slideScrollView.bounds.size.width;
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
    
    if (!_loopPlay) {
        oldx = slideScrollView.contentOffset.x;
        stopOldx = slideScrollView.contentOffset.x;
    }
}

- (void)addTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    
    [self addSubview:topView];
}

- (void)addBottomView
{
    if (self.bottomType == BottomViewBarType) {
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    }
    else if (self.bottomType == BottomViewTextType) {
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        UITextView *textView = [[UITextView alloc]initWithFrame:bottomView.frame];
        [bottomView addSubview:textView];
    }
    [self addSubview:bottomView];
}

#pragma mark - setter and getter

- (void)setShowAnimation:(BOOL)showAnimation
{
    _showAnimation = showAnimation;
    
}

- (NSInteger)pageIndicator
{
    return pageIndex;
}


#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidScroll:)]) {
        [self.delegate viewDidScroll:scrollView];
    }
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
        if (_dataSource.count <= 3) {
            if (newx > 0 && newx < 2 * slideScrollView.bounds.size.width) {
                if (newx - oldx > 0) {
                    isLeft = YES;
                }
                else if (newx - oldx < 0) {
                    isLeft = NO;
                }
                oldx = newx;
            }
            return;
        }
        if (isPreEnd) {
            if (scrollView.contentOffset.x > slideScrollView.bounds.size.width) {
                slideScrollView.bounces = NO;
            }
            if (scrollView.contentOffset.x == slideScrollView.bounds.size.width) {
                pageIndex = 0;
                [self showNextView];
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = slideScrollView.bounds.size.width;
                slideScrollView.contentOffset = offset;
            }
            else if (scrollView.contentOffset.x == 2 * slideScrollView.bounds.size.width) {
                pageIndex = 1;
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = slideScrollView.bounds.size.width;
                slideScrollView.contentOffset = offset;
                [self showNextView];
                isPreEnd = NO;
            }
        }
        else if (isNextEnd) {
            if (scrollView.contentOffset.x < 2 * slideScrollView.bounds.size.width) {
                slideScrollView.bounces = NO;
            }
            if (scrollView.contentOffset.x == slideScrollView.bounds.size.width) {
                pageIndex = _dataSource.count - 1;
                [self showPreView];
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = slideScrollView.bounds.size.width;
                slideScrollView.contentOffset = offset;
            }
            else if (scrollView.contentOffset.x == 0) {
                pageIndex = _dataSource.count - 2;
                
                CGPoint offset = slideScrollView.contentOffset;
                offset.x = slideScrollView.bounds.size.width;
                slideScrollView.contentOffset = offset;
                [self showPreView];
                isNextEnd = NO;
            }
        }
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidEndDecelerating:)]) {
        [self.delegate viewDidEndDecelerating:scrollView];
    }
    
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
    if (_dataSource.count <= 3) {
        if (fabs(newx - stopOldx) == slideScrollView.bounds.size.width) {
            if (isLeft) {
                pageIndex += 1;
                if (self.delegate && [self.delegate respondsToSelector:@selector(nextPageAtIndex:)]) {
                    [self.delegate nextPageAtIndex:pageIndex];
                }
            }
            else {
                pageIndex -= 1;
                if (self.delegate && [self.delegate respondsToSelector:@selector(prePageAtIndex:)]) {
                    [self.delegate prePageAtIndex:pageIndex];
                }
            }
            stopOldx = newx;
        }
        else if (fabs(newx - stopOldx) == 2 * slideScrollView.bounds.size.width) {
            if (isLeft) {
                pageIndex += 2;
                if (self.delegate && [self.delegate respondsToSelector:@selector(nextPageAtIndex:)]) {
                    [self.delegate nextPageAtIndex:pageIndex];
                }
            }
            else {
                pageIndex -= 2;
                if (self.delegate && [self.delegate respondsToSelector:@selector(prePageAtIndex:)]) {
                    [self.delegate prePageAtIndex:pageIndex];
                }
            }
            stopOldx = newx;
        }
        return;
    }
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
                    if (self.delegate && [self.delegate respondsToSelector:@selector(nextPageAtIndex:)]) {
                        [self.delegate nextPageAtIndex:pageIndex];
                    }
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
                    if (self.delegate && [self.delegate respondsToSelector:@selector(prePageAtIndex:)]) {
                        [self.delegate prePageAtIndex:pageIndex];
                    }
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

#pragma mark - reuse scanView

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

//前一页
- (void)showPreView
{
    pageIndex -= 1;
    if (pageIndex < 0) {
        pageIndex = _dataSource.count - 1;
    }
    [self layoutScanView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(prePageAtIndex:)]) {
        [self.delegate prePageAtIndex:pageIndex];
    }
}

//后一页
- (void)showNextView
{
    pageIndex += 1;
    if (pageIndex > _dataSource.count - 1) {
        pageIndex = 0;
    }
    [self layoutScanView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextPageAtIndex:)]) {
        [self.delegate nextPageAtIndex:pageIndex];
    }
}

#pragma mark - gesture

//单击
- (void)singleTapG:(UITapGestureRecognizer *)sender
{
    if (self.doubleTapBlock) {
        self.doubleTapBlock();
    }
}


@end

#pragma mark - ***********  ScanView

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
#pragma mark - setter and getter

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
