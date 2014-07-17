//
//  RUButton.h
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kRUButtonBgColor = @"RUButtonBgColor";
static NSString *const kRUButtonTitleNomal = @"RUButtonTitleNomal";
static NSString *const kRUButtonTitleHighlight = @"RUButtonTitleHighlight";
static NSString *const kRUButtonTitleSelected = @"RUButtonTitleSelected";
static NSString *const kRUButtonTitleDisabled = @"RUButtonTitleDisabled";
static NSString *const kRUButtonImageNomal = @"RUButtonImageNomal";
static NSString *const kRUButtonImageHightlight = @"RUButtonImageHightlight";
static NSString *const kRUButtonTitleColorNomal = @"RUButtonTitleColorNomal";
static NSString *const kRUButtonTitleColorHighlight = @"RUButtonTitleColorHighlight";
static NSString *const kRUButtonTitleColorSelected = @"RUButtonTitleColorSelected";
static NSString *const kRUButtonTitleColorDisabled = @"RUButtonTitleColorDisabled";
static NSString *const kRUButtonTitleFont = @"RUButtonTitleFont";


static NSString *const kRUButtonFrame = @"RUButtonFrame";
static NSString *const kRUButtonType = @"RUButtonType";

static NSString *const kRUButtonLayerCornerRadius = @"RUButtonLayerCornerRadius";
static NSString *const kRUButtonLayerBorderColor = @"RUButtonLayerBorderColor";
static NSString *const kRUButtonLayerBorderWidth = @"RUButtonLayerBorderWidth";
static NSString *const kRUButtonLayerShadowColor = @"RUButtonLayerShadowColor";
static NSString *const kRUButtonLayerShadowOffSet = @"RUButtonLayerShadowOffSet";
static NSString *const kRUButtonLayerShadowOpacity = @"RUButtonLayerShadowOpacity";
static NSString *const kRUButtonLayerShadowPath = @"RUButtonLayerShadowPath";

@class RUButton;

typedef void(^ButtonClickEventTouchDown)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchDownRepeat)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchDragInside)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchDragOutside)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchDragEnter)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchDragExit)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchUpInside)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchUpOutside)(RUButton *reuseBtn);
typedef void(^ButtonClickEventTouchCancel)(RUButton *reuseBtn);

@interface RUButton : UIButton

@property (nonatomic, copy) ButtonClickEventTouchDown downBlock;
@property (nonatomic, copy) ButtonClickEventTouchDownRepeat downRepeatBlock;
@property (nonatomic, copy) ButtonClickEventTouchDragInside dragInsideBlock;
@property (nonatomic, copy) ButtonClickEventTouchDragOutside dragOutsideBlock;
@property (nonatomic, copy) ButtonClickEventTouchDragExit dragExitBlock;
@property (nonatomic, copy) ButtonClickEventTouchDragEnter dragEnterBlock;
@property (nonatomic, copy) ButtonClickEventTouchUpInside upInsideBlock;
@property (nonatomic, copy) ButtonClickEventTouchUpOutside upOutsideBlock;
@property (nonatomic, copy) ButtonClickEventTouchCancel cancelBlock;


- (void)setTitle:(NSString *)title titleFont:(UIFont *)font bgColor:(UIColor *)color customImage:(NSString *)cImage disableImage:(NSString *)dImage highImage:(NSString *)hImage;
- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(UIImage *)cImage disableImage:(UIImage *)dImage;
- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(UIImage *)cImage highImage:(UIImage *)hImage;
- (void)setTitle:(NSString *)title titleFont:(UIFont *)font customImage:(UIImage *)cImage;
- (void)setTitle:(NSString *)title titleFont:(UIFont *)font bgColor:(UIColor *)color;

- (void)setAttributes:(NSDictionary *)attributes withClickBlock:(ButtonClickEventTouchUpInside)callBlock;

@end
