//
//  DXLMessageView.m
//  DaoxilaApp
//
//  Created by LCQ on 14-6-26.
//  Copyright (c) 2014年 com.daoxila. All rights reserved.
//

#import "DXLAlertView.h"

#define defaultWith ([UIScreen mainScreen].bounds.size.width - 80)
#define defaultDetailHeight 60
#define defaultButtonHeight 32.5

@interface DXLAlertView ()
{
    CGFloat height;
    UIView *baffleView;
    UIView *containorView;
    BOOL shouldAnimation;
}

@end

@implementation DXLAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (id)initWithMessageTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        baffleView = [[UIView alloc]initWithFrame:self.frame];
        baffleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        baffleView.alpha = 0;
        [self addSubview:baffleView];
        
        containorView = [[UIView alloc]init];
        [containorView.layer setCornerRadius:8];
        [self addSubview:containorView];
        
        height += 10;
        if (title) {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(defaultWith - 30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height, defaultWith - 30, size.height)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = title;
            titleLabel.numberOfLines = 0;
            height += titleLabel.bounds.size.height;
            [containorView addSubview:titleLabel];
        }
        if (message) {
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(defaultWith - 30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            if (size.height < defaultDetailHeight) {
                size.height = defaultDetailHeight;
            }
            UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height, defaultWith - 30, size.height)];
            msgLabel.textAlignment = NSTextAlignmentCenter;
            msgLabel.font = [UIFont systemFontOfSize:14];
            msgLabel.textColor = [RUUtils getColor:@"#333333"];
            msgLabel.text = message;
            msgLabel.numberOfLines = 0;

            msgLabel.tag = 155;
            height += msgLabel.bounds.size.height;
            [containorView addSubview:msgLabel];
        }
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *titleStrArr = [[NSMutableArray alloc]init];
        if (cancelButtonTitle) {
            [titleStrArr addObject:cancelButtonTitle];
        }
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [titleStrArr addObject:str];
        }
        if (titleStrArr.count == 1) {
            height += 20;
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake((defaultWith - (defaultWith - 45)/2)/2, height, (defaultWith - 45)/2, defaultButtonHeight);
            [cancelButton setTitle:titleStrArr[0] forState:UIControlStateNormal];
            [cancelButton setBackgroundColor:[RUUtils getColor:@"#c9c9c9"]];
            [cancelButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton.layer setCornerRadius:5];
            cancelButton.tag = 0;
            [containorView addSubview:cancelButton];
            height += cancelButton.bounds.size.height;
        }
        if (titleStrArr.count == 2) {
            height += 20;
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(15, height, (defaultWith - 45)/2, defaultButtonHeight);
            [cancelButton setTitle:titleStrArr[0] forState:UIControlStateNormal];
            [cancelButton.layer setCornerRadius:5];
            [cancelButton setBackgroundColor:[RUUtils getColor:@"#c9c9c9"]];
            cancelButton.tag = 0;
            [cancelButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            [containorView addSubview:cancelButton];
            
            UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmButton.frame = CGRectMake((defaultWith - 45)/2 + 30, height, (defaultWith - 45)/2, defaultButtonHeight);
            [confirmButton setTitle:titleStrArr[1] forState:UIControlStateNormal];
            [confirmButton setBackgroundColor:[RUUtils getColor:@"ff6e6e"]];
            confirmButton.tag = 1;
            [confirmButton.layer setCornerRadius:5];
            [confirmButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            [containorView addSubview:confirmButton];
            height += cancelButton.bounds.size.height;
        }
        if (titleStrArr.count > 2) {
            height += 20;
            for (int i = 0; i < titleStrArr.count; i++) {
                UIButton *nomalButton = [UIButton buttonWithType:UIButtonTypeCustom];
                nomalButton.frame = CGRectMake(15, height, defaultWith - 30, defaultButtonHeight);
                [nomalButton setTitle:titleStrArr[i] forState:UIControlStateNormal];
                [nomalButton setBackgroundColor:[RUUtils getColor:@"#c9c9c9"]];
                nomalButton.tag = i;
                [nomalButton.layer setCornerRadius:5];
                [nomalButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
                [containorView addSubview:nomalButton];
                height += defaultButtonHeight + 10;
            }
        }
        if (delegate) {
            self.delegate = delegate;
        }
        containorView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)showAnimation
{
    shouldAnimation = YES;
    [self showAnimation:YES];
}

- (void)show
{
    shouldAnimation = NO;
    [self showAnimation:NO];
}



- (void)showAnimation:(BOOL)animation
{

    if (animation) {
        
        containorView.frame = CGRectMake(0, 0, defaultWith, height + 20);
        CGAffineTransform transform =
        CGAffineTransformScale(self.transform, 0.1, 0.1);
        [containorView setTransform:transform];
        containorView.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView beginAnimations:@"imageViewBig" context:nil];
        [UIView setAnimationDuration:0.25];
        CGAffineTransform newTransform = CGAffineTransformConcat(self.transform,  CGAffineTransformInvert(self.transform));
        [containorView setTransform:newTransform];
        containorView.alpha = 1.0;
        baffleView.alpha = 0.4;
        containorView.center = [UIApplication sharedApplication].keyWindow.center;
        [UIView commitAnimations];

    }
    else {
        containorView.frame = CGRectMake(0, 0, defaultWith, height + 20);
        containorView.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:self];

    }
}


- (void)hiddenAnimation:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:@"imageViewSmall" context:nil];
        [UIView setAnimationDuration:0.1];
        CGAffineTransform newTransform =  CGAffineTransformScale(containorView.transform, 0.1, 0.1);
        [containorView setTransform:newTransform];
        baffleView.alpha = 0;
        [UIView commitAnimations];
        
        [self performSelector:@selector(hidden) withObject:nil afterDelay:0.1];
    }
    else {
        [self hidden];
    }

}

- (void)hidden
{
    [self removeFromSuperview];
}

- (void)setMsgLabelTextAlignment:(NSTextAlignment)msgLabelTextAlignment
{
    UILabel *label = (UILabel *)[containorView viewWithTag:155];
    [label setTextAlignment:msgLabelTextAlignment];
}

- (void)didClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAlertView:withButtonIndex:)]) {
        [self.delegate didAlertView:self withButtonIndex:sender.tag];
    }
    [self hiddenAnimation:shouldAnimation];
}
    //需要点击按钮变色时可能用到
- (UIImage *)getImage:(BOOL)normal
{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (normal) {
        CGContextSetFillColorWithColor(context, [RUUtils getColor:@"ff6e6e"].CGColor);
    }
    else {
        CGContextSetFillColorWithColor(context, [RUUtils getColor:@"eb4b4b"].CGColor);
    }
    
    CGContextFillRect(context, self.bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
