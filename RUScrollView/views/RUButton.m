//
//  RUButton.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUButton.h"
#import "RUUtils.h"
#import <objc/runtime.h>

@implementation RUButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title titleFont:(UIFont *)font bgColor:(UIColor *)color customImage:(NSString *)cImage disableImage:(NSString *)dImage highImage:(NSString *)hImage
{
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (font) {
        self.titleLabel.font = font;
    }
    if (color) {
        self.backgroundColor = color;
    }
    if (cImage) {
        [self setImage:[UIImage imageNamed:cImage] forState:UIControlStateNormal];
    }
    if (hImage) {
        [self setImage:[UIImage imageNamed:dImage] forState:UIControlStateHighlighted];
    }
    if (dImage) {
        [self setImage:[UIImage imageNamed:hImage] forState:UIControlStateDisabled];
    }

}

- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(NSString *)cImage disableImage:(NSString *)dImage
{
    [self setTitle:title titleFont:(UIFont *)font bgColor:nil customImage:cImage disableImage:dImage highImage:nil];
}

- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(NSString *)cImage highImage:(NSString *)hImage
{
    [self setTitle:title titleFont:(UIFont *)font bgColor:nil customImage:cImage disableImage:nil highImage:hImage];
}

- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(NSString *)cImage
{
    [self setTitle:title titleFont:(UIFont *)font bgColor:nil customImage:cImage disableImage:nil highImage:nil];
}

- (void)setTitle:(NSString *)title titleFont:(UIFont *)font bgColor:(UIColor *)color
{
    [self setTitle:title titleFont:(UIFont *)font bgColor:(UIColor *)color customImage:nil disableImage:nil highImage:nil];
}

- (void)setAttributes:(NSDictionary *)attributes withClickBlock:(ButtonClickEventTouchUpInside)callBlock
{
    self.upInsideBlock = callBlock;
    for (NSString *key in attributes) {
        id value = [attributes objectForKey:key];
        if ([key caseInsensitiveCompare:kRUButtonBgColor] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self setBackgroundColor:color];
            }
            else {
                [self inputError:kRUButtonBgColor class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleNomal] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self setTitle:value forState:UIControlStateNormal];
            }
            else {
                [self inputError:kRUButtonTitleNomal class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleHighlight] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value ]) {
                [self setTitle:value forState:UIControlStateHighlighted];
            }
            else {
                [self inputError:kRUButtonTitleHighlight class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleSelected] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self setTitle:value forState:UIControlStateSelected];
            }
            else {
                [self inputError:kRUButtonTitleSelected class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleDisabled] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self setTitle:value forState:UIControlStateDisabled];
            }
            else {
                [self inputError:kRUButtonTitleDisabled class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleColorNomal] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self setTitleColor:color forState:UIControlStateNormal];
            }
            else {
                [self inputError:kRUButtonTitleColorNomal class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleColorHighlight] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self setTitleColor:color forState:UIControlStateHighlighted];
            }
            else {
                [self inputError:kRUButtonTitleColorHighlight class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleColorSelected] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self setTitleColor:color forState:UIControlStateSelected];
            }
            else {
                [self inputError:kRUButtonTitleColorSelected class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleColorDisabled] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self setTitleColor:color forState:UIControlStateDisabled];
            }
            else {
                [self inputError:kRUButtonTitleColorDisabled class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonTitleFont] == NSOrderedSame) {
            UIFont *font = [RUUtils getFont:value];
            if (font) {
                self.titleLabel.font = font;
            }
            else {
                [self inputError:kRUButtonTitleFont class:@[@"UIFont",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonImageNomal] == NSOrderedSame) {
            UIImage *image = [RUUtils getImage:value];
            if (image) {
                [self setImage:image forState:UIControlStateNormal];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonImageHightlight] == NSOrderedSame) {
            UIImage *image = [RUUtils getImage:value];
            if (image) {
                [self setImage:image forState:UIControlStateHighlighted];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonLayerCornerRadius] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self.layer setCornerRadius:[value floatValue]];
                self.layer.masksToBounds = YES;
            }
            else {
                [self inputError:kRUButtonLayerCornerRadius class:@[@"NSString"]];
            }
                    }
        else if ([key caseInsensitiveCompare:kRUButtonLayerBorderWidth] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self.layer setBorderWidth:[value floatValue]];
            }
            else {
                [self inputError:kRUButtonLayerBorderColor class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonLayerBorderColor] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self.layer setBorderColor:color.CGColor];
            }
            else {
                [self inputError:kRUButtonLayerBorderColor class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonLayerShadowOffSet] == NSOrderedSame) {
            CGSize size = [RUUtils getSize:value];
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                [self.layer setShadowOffset:size];
            }
            else {
                [self inputError:kRUButtonFrame class:@[@"NSValue",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonLayerShadowColor] == NSOrderedSame) {
            UIColor *color = [RUUtils getColor:value];
            if (color) {
                [self.layer setShadowColor:color.CGColor];
            }
            else {
                [self inputError:kRUButtonLayerShadowColor class:@[@"UIColor",@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonLayerShadowOpacity] == NSOrderedSame) {
            if ([RUUtils paraIsKindOfClass:[NSString class] para:value]) {
                [self.layer setShadowOpacity:[value floatValue]];
            }
            else {
                [self inputError:kRUButtonLayerShadowOpacity class:@[@"NSString"]];
            }
        }
        else if ([key caseInsensitiveCompare:kRUButtonFrame] == NSOrderedSame) {
            CGRect frame = [RUUtils getFrame:value];
            if (!CGRectEqualToRect(frame, CGRectNull)) {
                self.frame = frame;
            }
            else {
                [self inputError:kRUButtonFrame class:@[@"NSValue",@"NSString"]];
            }
        }
        else {
            [self inputError:key class:nil];
        }
    }
    
    [self addTarget:self action:@selector(clickButtonEventDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(clickButtonEventDownRepeat) forControlEvents:UIControlEventTouchDownRepeat];
    [self addTarget:self action:@selector(clickButtonEventDragInside) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(clickButtonEventDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(clickButtonEventDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(clickButtonEventDragExit) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(clickButtonEventUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(clickButtonEventUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(clickButtonEventCancel) forControlEvents:UIControlEventTouchCancel];
    
}

- (void)clickButtonEventDown
{
    if (_downBlock) {
        _downBlock(self);
    }
}

- (void)clickButtonEventDownRepeat
{
    if (_downRepeatBlock) {
        _downRepeatBlock(self);
    }
}

- (void)clickButtonEventDragInside
{
    if (_dragInsideBlock) {
        _dragInsideBlock(self);
    }
}

- (void)clickButtonEventDragOutside
{
    if (_dragOutsideBlock) {
        _dragOutsideBlock(self);
    }
}

- (void)clickButtonEventDragEnter
{
    if (_dragEnterBlock) {
        _dragEnterBlock(self);
    }
}

- (void)clickButtonEventDragExit
{
    if (_dragExitBlock) {
        _dragExitBlock(self);
    }
}

- (void)clickButtonEventUpInside
{
    if (_upInsideBlock) {
        _upInsideBlock(self);
    }
}

- (void)clickButtonEventUpOutside
{
    if (_upOutsideBlock) {
        _upOutsideBlock(self);
    }
}

- (void)clickButtonEventCancel
{
    if (_cancelBlock) {
        _cancelBlock(self);
    }
}

- (void)inputError:(id)key class:(NSArray *)class
{
    if (class.count == 1) {
        NSLog(@"%@" ,[NSString stringWithFormat:@"value from key \"%@\" error , it is not a \"%@\" class",key,[class lastObject]]);
    }
    else if (class.count == 2) {
        NSLog(@"%@" ,[NSString stringWithFormat:@"value from key \"%@\" error , it is not a \"%@\" or \"%@\" class",key,[class firstObject],[class lastObject]]);
    }
    else if (class.count == 0) {
        NSLog(@"%@" ,[NSString stringWithFormat:@"%@ is invalid",key]);
    }
}

@end
