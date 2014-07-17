//
//  DXLShareView.h
//  DaoxilaAlbum
//
//  Created by LCQ on 14-5-13.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShareImageBoundle @"images.bundle" //you should to write your image boundle path if you has

@class RUShareView;
typedef void(^ShareSelectedOperation)(RUShareView *shareView,NSIndexPath *indexPath ,NSInteger currentPage);

@interface RUShareView : UIView

@property (nonatomic, copy) ShareSelectedOperation selectBlock;
@property (nonatomic) UIEdgeInsets inset; //内容主体的内边距
@property (nonatomic) CGFloat maxNumberOneRow;
@property (nonatomic) CGFloat maxNumberOnePage;
@property (nonatomic) CGFloat maxRowOnePage; //可见的最大行
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;
@property (nonatomic) UIFont *titleFont; //内容的文字字体
@property (nonatomic) CGFloat lineWith; //两行之间的宽度
@property (nonatomic) CGFloat itemSpace; //两列之间的最小空隙
@property (nonatomic) CGFloat contentTitleHeight; //内容文字的高度
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *topTitleColor;
@property (nonatomic, strong) UIColor *bottomTitleColor;
@property (nonatomic, strong) UIColor *contentTitleColor;
@property (nonatomic, strong) UIColor *seperatorLineColor; //分割线颜色
@property (nonatomic, strong) UIColor *pageTintColor;
@property (nonatomic, strong) UIColor *currentPageTintColor;

- (id)initWithTitle:(NSString *)title cancelButton:(NSString *)cancelButtonTitle imagePath:(NSArray *)imagePaths title:(NSArray *)titles;

@end

@interface DXLShareCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *shareTitleArray;
@property (nonatomic, strong) NSMutableArray *shareImageArray;

@end

@interface DXLShareCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UILabel *shareTitlelb;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic, strong) UIColor *titleColor;

@end

