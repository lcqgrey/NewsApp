//
//  DXLMessageView.h
//  DaoxilaApp
//
//  Created by LCQ on 14-6-26.
//  Copyright (c) 2014年 com.daoxila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXLAlertView;
@protocol DXLAlertViewDelegate <NSObject>

@optional

- (void)didAlertView:(DXLAlertView *)alertView withButtonIndex:(NSInteger)index;

@end


@interface DXLAlertView : UIView

@property (nonatomic, weak) id<DXLAlertViewDelegate> delegate;
@property (nonatomic, assign) NSTextAlignment msgLabelTextAlignment;


- (id)initWithMessageTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)showAnimation;

@end
