//
//  DXLActionSheetView.m
//  DaoxilaApp
//
//  Created by LCQ on 14-6-27.
//  Copyright (c) 2014年 com.daoxila. All rights reserved.
//

#import "DXLActionSheetView.h"

#define defaultWith [UIScreen mainScreen].bounds.size.width
#define defaultButtonHeight 42.5

@interface DXLActionSheetView ()
{
    CGFloat height;
    UIView *baffleView;
    UIView *containorView;
    NSInteger count;
    DXLActionSheetViewButton *lastSelectedButton;
    NSMutableArray *titleArray;
    NSString *actionTitle;
}
@end

@implementation DXLActionSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        titleArray = [[NSMutableArray alloc]init];
        
        baffleView = [[UIView alloc]initWithFrame:self.frame];
        baffleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        baffleView.alpha = 0;
        [self addSubview:baffleView];
        
        containorView = [[UIView alloc]init];
        containorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containorView];
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args, NSString *)){
            [titleArray addObject:str];
        }
        
        if (cancelButtonTitle) {
            [titleArray addObject:cancelButtonTitle];
        }
        if (title) {
            actionTitle = title;
        }
        if (delegate) {
            self.delegate = delegate;
        }


    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)loadingView
{
    count = titleArray.count;
    if (actionTitle) {
        height += 10;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, defaultWith, 15)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = actionTitle;
        height += titleLabel.bounds.size.height;
        [containorView addSubview:titleLabel];
        height += titleLabel.bounds.size.height;
        UIView *seperatorline = [[UIView alloc]initWithFrame:CGRectMake(0, height, defaultWith, 1)];
        seperatorline.backgroundColor = [RUUtils getColor:@"#D4D4D4"];
        [containorView addSubview:seperatorline];
        height += 1;
    }
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            if (i != count - 1) {
                DXLActionSheetViewButton *nomalButton = [DXLActionSheetViewButton buttonWithType:UIButtonTypeCustom];
                nomalButton.frame = CGRectMake(0, height, defaultWith, defaultButtonHeight);
                [nomalButton setTitle:titleArray[i] forState:UIControlStateNormal];
                [nomalButton setTitleColor:[RUUtils getColor:@"#333333"] forState:UIControlStateNormal];
                nomalButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [nomalButton setBackgroundImage:[self getImage:YES] forState:UIControlStateNormal];
                [nomalButton setBackgroundImage:[self getImage:NO] forState:UIControlStateHighlighted];
                [nomalButton setImage:[RUUtils getImage:@"hotel_list_checkmark"] forState:UIControlStateSelected];
                nomalButton.tag = i;
                
                [nomalButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
                [containorView addSubview:nomalButton];
                
                height += nomalButton.bounds.size.height;
            }
            else {
                UIButton *nomalButton = [UIButton buttonWithType:UIButtonTypeCustom];
                nomalButton.frame = CGRectMake(0, height, defaultWith, defaultButtonHeight);
                [nomalButton setTitle:titleArray[i] forState:UIControlStateNormal];
                [nomalButton setTitleColor:[RUUtils getColor:@"#333333"] forState:UIControlStateNormal];
                nomalButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [nomalButton setBackgroundImage:[self getImage:NO] forState:UIControlStateNormal];
                nomalButton.tag = i;
                [nomalButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
                [containorView addSubview:nomalButton];
                
                height += nomalButton.bounds.size.height;
            }
            
            if (i != count - 1 && i != count - 2) {
                UIView *seperatorline = [[UIView alloc]initWithFrame:CGRectMake(defaultButtonHeight, height, defaultWith - defaultButtonHeight, 1)];
                seperatorline.backgroundColor = [RUUtils getColor:@"#D4D4D4"];
                [containorView addSubview:seperatorline];
                height += 1;
            }
        }
    }
    containorView.frame = CGRectMake(0, self.bounds.size.height, defaultWith, height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)addButtonWithTitle:(NSString *)title
{
    [titleArray addObject:title];
}

- (void)show
{
    [self showAnimation];
}

- (void)didClick:(DXLActionSheetViewButton *)sender
{
    if (sender.tag != count - 1 && sender != lastSelectedButton) {
        [sender setSelected:YES];
        [lastSelectedButton setSelected:NO];
        lastSelectedButton = sender;
    }
    [self hiddenAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didActionSheet:withButtonIndex:)]) {
        [self.delegate didActionSheet:sender withButtonIndex:sender.tag];
    }
}

- (void)didTap:(UITapGestureRecognizer *)sender
{
    [self hiddenAnimation];
}

- (void)showAnimation
{
    [self loadingView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containorView.frame = CGRectMake(0, self.bounds.size.height-height, defaultWith, height);
        baffleView.alpha = 0.4;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
        [baffleView addGestureRecognizer:tap];
    }];
}

- (void)hiddenAnimation
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containorView.frame = CGRectMake(0, self.bounds.size.height, defaultWith, height);
        baffleView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImage *)getImage:(BOOL)normal
{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (normal) {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    else {
        CGContextSetFillColorWithColor(context, [RUUtils getColor:@"#DADADA"].CGColor);
    }
    
    CGContextFillRect(context, self.bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface DXLActionSheetViewButton ()

@end

@implementation DXLActionSheetViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


#pragma mark 设置Button内部的image的范围
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(0, 0, imageW, imageH);
}

#pragma mark 设置Button内部的title的范围
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height;
    CGFloat titleW = contentRect.size.width - titleH;
    CGFloat titleX = titleH;
    
    return CGRectMake(titleX, 0, titleW, titleH);
}

@end
