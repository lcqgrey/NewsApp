//
//  DXLShareView.m
//  DaoxilaAlbum
//
//  Created by LCQ on 14-5-13.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import "RUShareView.h"
#define LINESPACE 5
#define ITEMSPACE 30

#define MAX_NUM_ONE_ROW 3
#define MAX_NUM_ONE_PAGE 6
#define MAX_ROW_ONE_PAGE 2

#define Top 10
#define Bottom 10
#define Left 30
#define Right 30

#define TITLE_HEIGHT 25
#define HEADER_HEIGHT 30
#define FOOTER_HEIGHT 50


@interface RUShareView () <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSArray *shareCategoryArray;
    NSArray *imageArray;
    UIView *containor;
    UIView *tempView;
    UIScrollView *shareScrollView;
    UILabel *titleLabel;
    
    UIButton *cancelBtn;
    NSInteger rows;
    NSInteger pages;
    CGFloat height;
    UIView *seperatorLine;
    UIPageControl *pageC;
    NSInteger currentPage;
    
    NSString *cancelTitle;
    NSString *topTitle;
    
}

@end

@implementation RUShareView


- (id)initWithTitle:(NSString *)title cancelButton:(NSString *)cancelButtonTitle imagePath:(NSArray *)imagePaths title:(NSArray *)titles
{
    self = [super init];
    if (self) {
        if (titles) {
            if (imagePaths.count != titles.count) {
                NSLog(@"imagepaths and titles number is not equal");
                return nil;
            }
        }
        
        self.maxNumberOnePage = MAX_NUM_ONE_PAGE;
        self.maxNumberOneRow = MAX_NUM_ONE_ROW;
        self.maxRowOnePage = MAX_ROW_ONE_PAGE;
        self.titleFont = [UIFont systemFontOfSize:14];
        self.footerHeight = FOOTER_HEIGHT;
        self.headerHeight = HEADER_HEIGHT;
        self.inset = UIEdgeInsetsMake(Top, Left, Bottom, Right);
        self.lineWith = LINESPACE;
        self.itemSpace = ITEMSPACE;
        self.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        
        self.topTitleColor = [UIColor blackColor];
        self.bottomTitleColor = [UIColor colorWithRed:139/255.0f green:139/255.0f blue:139/255.0f alpha:1];
        
        self.pageTintColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
        self.currentPageTintColor = [UIColor colorWithRed:135/255.0 green:160/255.0 blue:0/255.0 alpha:1];
        
        topTitle = title;
        cancelTitle = cancelButtonTitle;
        
        if (imagePaths) {
            imageArray = imagePaths;
        }
        if (titles) {
            shareCategoryArray = titles;
        }
        if (titles) {
            self.contentTitleHeight = TITLE_HEIGHT;
        }
            //初始化
        if (imageArray.count != 0 && imageArray) {
            tempView = [[UIView alloc]init];
            containor = [[UIView alloc]init];
            if (topTitle) {
                titleLabel = [[UILabel alloc]init];
            }
            shareScrollView = [[UIScrollView alloc]init];

            pageC = [[UIPageControl alloc]init];
            if (cancelTitle) {
                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            [self addSubview:tempView];
            [self addSubview:containor];
            [containor addSubview:titleLabel];
            [containor addSubview:shareScrollView];
            [containor addSubview:pageC];
            [containor addSubview:seperatorLine];
            [containor addSubview:cancelBtn];
            [containor addSubview:cancelBtn];
        }
        else {
            NSLog(@"imagepaths do not be nil");
        }
        

    }
    return self;
}

//重新布局所有的子视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = self.superview.frame;
    tempView.frame = self.frame;
    
    if (imageArray.count != 0) {
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShareView:)];
        [tempView addGestureRecognizer:tapG];

            //头部
        if (topTitle) {
            titleLabel.textColor = self.topTitleColor;
            titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerHeight);
            height += titleLabel.bounds.size.height;
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = topTitle;
        }
        
        rows = ceil(imageArray.count/(float)self.maxNumberOneRow);
        pages = ceil(imageArray.count/(float)self.maxNumberOnePage);
            //滚动视图
        shareScrollView.pagingEnabled = YES;
        shareScrollView.showsHorizontalScrollIndicator = NO;
        shareScrollView.delegate = self;
        
        shareScrollView.frame = CGRectMake(0, height, self.bounds.size.width, ((self.bounds.size.width - Left - Right - 2*self.itemSpace)/3 + self.contentTitleHeight + self.lineWith) * self.maxRowOnePage + Top+ Bottom );
        
        shareScrollView.contentSize = CGSizeMake(pages*shareScrollView.bounds.size.width, shareScrollView.bounds.size.height);
        height += shareScrollView.bounds.size.height;
        
            //添加collectionView
        for (int i = 0; i < pages; i++) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.minimumLineSpacing = self.lineWith;
            layout.minimumInteritemSpacing = self.itemSpace;
            layout.sectionInset = self.inset;
            layout.itemSize = CGSizeMake((shareScrollView.bounds.size.width - (self.maxNumberOneRow+1)*self.itemSpace)/self.maxNumberOneRow ,(shareScrollView.bounds.size.width - (self.maxNumberOneRow+1)*self.itemSpace)/self.maxNumberOneRow + self.contentTitleHeight);
            
            DXLShareCollectionView *collection = [[DXLShareCollectionView alloc]initWithFrame:CGRectMake(shareScrollView.bounds.size.width * i , 0, shareScrollView.bounds.size.width, shareScrollView.bounds.size.height) collectionViewLayout:layout];
            collection.collectionViewLayout = layout;
            
            collection.shareTitleArray = [[NSMutableArray alloc]init];
            collection.shareImageArray = [[NSMutableArray alloc]init];
            for (int j = 0; j < self.maxNumberOnePage; j++) {
                if ((i*self.maxNumberOnePage+j) >= imageArray.count) {
                    break;
                }
                if (shareCategoryArray.count != 0) {
                    [collection.shareTitleArray addObject:[shareCategoryArray objectAtIndex:i*self.maxNumberOnePage+j]];
                }
                [collection.shareImageArray addObject:[imageArray objectAtIndex:i*self.maxNumberOnePage+j]];
            }
            collection.delegate = self;
            collection.dataSource = self;
            collection.tag = 300 + i;
            
            
            [collection registerClass:[DXLShareCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
            collection.backgroundColor = [UIColor clearColor];
            collection.userInteractionEnabled = YES;
            [shareScrollView addSubview:collection];
        }
            //pageControl
        pageC.numberOfPages = pages;
        pageC.hidesForSinglePage = YES;
        pageC.pageIndicatorTintColor = self.pageTintColor;
        pageC.currentPageIndicatorTintColor = self.currentPageTintColor;
        [pageC addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

        
            //尾部
        if (cancelTitle) {
            [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            cancelBtn.frame = CGRectMake(0, height, self.bounds.size.width, self.footerHeight);
            
            
            height += cancelBtn.bounds.size.height;
            
            [cancelBtn setTitleColor:self.bottomTitleColor forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
            
            //分割线
            seperatorLine = [[UIView alloc]init];
            seperatorLine.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
            if (self.seperatorLineColor) {
                seperatorLine.backgroundColor = _seperatorLineColor;
            }
            else {
                seperatorLine.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
            }
            
            [cancelBtn addSubview:seperatorLine];
            

        }
    }
    

    containor.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, height);
    containor.backgroundColor = self.backgroundColor;
    pageC.frame = CGRectMake(0, height - cancelBtn.bounds.size.height - 1 - 20, self.bounds.size.width, 20);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containor.frame = CGRectMake(0, self.bounds.size.height-height, self.bounds.size.width, height);
    } completion:^(BOOL finished) {
        ;
    }];
}

#pragma mark - collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if ([collectionView isKindOfClass:[DXLShareCollectionView class]]) {
        DXLShareCollectionView *dxl = (DXLShareCollectionView *)collectionView;
        count = dxl.shareImageArray.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DXLShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.shareImageView.image = [self imageAtIndexPath:indexPath imageArray:((DXLShareCollectionView *)collectionView).shareImageArray];
    cell.titleHeight = self.contentTitleHeight;
    cell.titleFont = _titleFont;
    cell.titleColor = _contentTitleColor;
    
    if (((DXLShareCollectionView *)collectionView).shareTitleArray.count != 0) {
        cell.shareTitlelb.text = [((DXLShareCollectionView *)collectionView).shareTitleArray objectAtIndex:indexPath.row];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectBlock) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+currentPage*self.maxNumberOnePage inSection:currentPage];
        _selectBlock(self,newIndexPath ,currentPage);//block触发点击事件
    }
}


#pragma mark - scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    pageC.currentPage = currentPage;
}

#pragma mark - pageControl event
- (void)changePage:(UIPageControl *)pageCont
{
    NSInteger page = pageCont.currentPage;
    currentPage = page;
    CGPoint offSet = shareScrollView.contentOffset;
    offSet.x = shareScrollView.bounds.size.width*page;
    shareScrollView.contentOffset = offSet;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath imageArray:(NSArray *)images {
    UIImage *image = nil;
    NSString *imageName = [images objectAtIndex:indexPath.row];
    if ([imageName hasPrefix:@"/"]) {
        NSString *str = [ShareImageBoundle stringByAppendingString:imageName];
        image = [UIImage imageNamed:str];
    }
    else {
        NSString *str = imageName;
        image = [UIImage imageNamed:str];
    }
    return image;
}

#pragma mark - click event
//点取消触发
- (void)cancelShare:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containor.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//点分享视图以外触发
- (void)closeShareView:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containor.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end


#pragma mark - collectionView

@interface DXLShareCollectionView ()

@end

@implementation DXLShareCollectionView



@end



#pragma mark - collectionViewCell
@interface DXLShareCollectionViewCell ()

@end

@implementation DXLShareCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shareImageView = [[UIImageView alloc] init];
        _shareImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shareImageView.clipsToBounds = YES;
        _shareImageView.backgroundColor = [UIColor whiteColor];
        
        self.shareTitlelb = [[UILabel alloc] init];
        _shareTitlelb.textAlignment = NSTextAlignmentCenter;
        _shareTitlelb.numberOfLines = 0;
        _shareTitlelb.textColor = [RUUtils colorWithHexString:@"666666"];
        [self addSubview:_shareTitlelb];
        [self addSubview:_shareImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_titleColor) {
        _shareTitlelb.textColor = _titleColor;
    }
    if (_titleFont) {
        _shareTitlelb.font = _titleFont;
    }
    _shareImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - _titleHeight);
    _shareTitlelb.frame = CGRectMake(0, self.bounds.size.height - _titleHeight,self.bounds.size.width, _titleHeight);
}

@end


