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
    NSInteger dataSourceCount;
    NSMutableArray *scanViewArray;
    NSInteger pageIndex;
    BOOL isLeft;
    CGFloat newx;
    CGFloat oldx;
    CGPoint oldOffset;
}

@end

@implementation RUImageScanView

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
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

- (void)setInitialPageIndex:(NSInteger)initialPageIndex
{
    _initialPageIndex = initialPageIndex;
    pageIndex = initialPageIndex;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    if (dataSource.count == 0) {
        return;
    }
    dataSourceCount = _dataSource.count;
    slideScrollView = [[UIScrollView alloc]init];
    slideScrollView.frame = self.frame;
    slideScrollView.pagingEnabled = YES;
    slideScrollView.delegate = self;
    scanViewArray = [NSMutableArray array];
    if (dataSourceCount == 1) {
        slideScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        ScanView *view = [[ScanView alloc]init];
        view.frame = CGRectMake(slideScrollView.bounds.size.width, slideScrollView.bounds.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
        view.imageData = _dataSource[pageIndex];
        view.maximumZoomScale = _maxZoomScale;
        view.minimumZoomScale = _minZoomScale;
        view.tapBlock = self.tapBlock;
        [slideScrollView addSubview:view];
        [scanViewArray addObject:view];
    }
    else {
        slideScrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
        CGPoint offset = slideScrollView.contentOffset;
        offset.x = slideScrollView.bounds.size.width;
        slideScrollView.contentOffset = offset;
        
        oldOffset = slideScrollView.contentOffset;
        oldx = slideScrollView.contentOffset.x;
        
        for (int i = 0 ; i < dataSourceCount ; i++) {
            ScanView *view = [[ScanView alloc]init];
            view.frame = CGRectMake(i * slideScrollView.bounds.size.width, slideScrollView.bounds.origin.y, slideScrollView.bounds.size.width, slideScrollView.bounds.size.height);
            NSInteger tempIndex = 0;
            if (i == 0) {
                tempIndex = pageIndex - i;
                if (tempIndex < 0) {
                    tempIndex = _dataSource.count;
                }
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 1) {
                tempIndex = pageIndex;
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 2) {
                tempIndex = pageIndex + i;
                if (tempIndex > _dataSource.count) {
                    tempIndex = 0;
                }
                view.imageData = _dataSource[tempIndex];
            }
            view.maximumZoomScale = _maxZoomScale;
            view.minimumZoomScale = _minZoomScale;
            view.tapBlock = self.tapBlock;
            [slideScrollView addSubview:view];
            [scanViewArray addObject:view];
        }
    }
    [self addSubview:slideScrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (NSInteger)pageIndicator
{
    return pageIndex;
}


#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    newx = scrollView.contentOffset.x ;
    if (newx != oldx ) {
        if (newx > oldx) {
            isLeft = YES;
        }else if(newx < oldx){
            isLeft = NO;
        }
        oldx = newx;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isLeft) {
        [self showNextView];
    }
    else {
        [self showPreView];
    }
}

- (void)showPreView
{
    if (fabs(slideScrollView.contentOffset.x - oldOffset.x) >= slideScrollView.bounds.size.width) {
        pageIndex -= 1;
        if (pageIndex < 0) {
            pageIndex = _dataSource.count;
        }
        for (int i = 0; i < scanViewArray.count; i++) {
            ScanView *view = scanViewArray[i];
            NSInteger tempIndex = 0;
            if (i == 0) {
                tempIndex = pageIndex - i;
                if (tempIndex < 0) {
                    tempIndex = _dataSource.count;
                }
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 1) {
                tempIndex = pageIndex;
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 2) {
                tempIndex = pageIndex + i;
                if (tempIndex > _dataSource.count) {
                    tempIndex = 0;
                }
                view.imageData = _dataSource[tempIndex];
            }
        }
        oldOffset = slideScrollView.contentOffset;
    }
}

- (void)showNextView
{
    if (fabs(slideScrollView.contentOffset.x - oldOffset.x) >= slideScrollView.bounds.size.width) {
        pageIndex += 1;
        if (pageIndex > _dataSource.count) {
            pageIndex = 0;
        }
        for (int i = 0; i < scanViewArray.count; i++) {
            ScanView *view = scanViewArray[i];
            NSInteger tempIndex = 0;
            if (i == 0) {
                tempIndex = pageIndex - i;
                if (tempIndex < 0) {
                    tempIndex = _dataSource.count;
                }
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 1) {
                tempIndex = pageIndex;
                view.imageData = _dataSource[tempIndex];
            }
            else if (i == 2) {
                tempIndex = pageIndex + i;
                if (tempIndex > _dataSource.count) {
                    tempIndex = 0;
                }
                view.imageData = _dataSource[tempIndex];
            }
        }
        oldOffset = slideScrollView.contentOffset;
    }
}

@end


@interface ScanView () <UIScrollViewDelegate>
{
    UIImageView *customImageView;
    BOOL isZoomScale;
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
        customImageView = [[UIImageView alloc]initWithFrame:frame];
        customImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:customImageView];
        self.delegate = self;
    }
    return self;
}

- (void)setImagedata:(id)imagedata
{
    _imageData = imagedata;
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
    if(isZoomScale){
        xcenter = scrollView.maximumZoomScale*(kWidth - touchX);
        ycenter = scrollView.maximumZoomScale*(kHeight - touchY);
        if(xcenter > (scrollView.maximumZoomScale - 0.5)*kWidth){//放大后左边超界
            xcenter = (scrollView.maximumZoomScale - 0.5)*kWidth;
        }else if(xcenter <0.5*kWidth){//放大后右边超界
            xcenter = 0.5*kWidth;
        }
        if(ycenter > (scrollView.maximumZoomScale - 0.5)*kHeight){//放大后左边超界
            ycenter = (scrollView.maximumZoomScale - 0.5)*kHeight +offsetY*scrollView.maximumZoomScale;
        }else if(ycenter <0.5*kHeight){//放大后右边超界
            ycenter = 0.5*kHeight +offsetY*scrollView.maximumZoomScale;
        }
    }
    [customImageView setCenter:CGPointMake(xcenter, ycenter)];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return customImageView;
}

//双击
- (void)doubleTap:(UITapGestureRecognizer *)sender
{
    touchX = [sender locationInView:sender.view].x;
    touchY = [sender locationInView:sender.view].y;
    if(isZoomScale){
        isZoomScale = NO;
        [self setZoomScale:1.0 animated:YES];
    }else{
        isZoomScale = YES;
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }
}

//单击
- (void)singleTapG:(UITapGestureRecognizer *)sender
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)dealloc
{
    NSLog(@"i am dealloc");
}

@end
