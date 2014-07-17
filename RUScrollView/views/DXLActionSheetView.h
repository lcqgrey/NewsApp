//
//  DXLActionSheetView.h
//  DaoxilaApp
//
//  Created by LCQ on 14-6-27.
//  Copyright (c) 2014年 com.daoxila. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DXLActionSheetView;
@protocol DXLActionSheetViewDelegate <NSObject>

@optional
- (void)didActionSheet:(UIButton *)actionSheet withButtonIndex:(NSInteger)buttonIndex;

@end

@interface DXLActionSheetView : UIView
@property (nonatomic, weak) id<DXLActionSheetViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addButtonWithTitle:(NSString *)title;

- (void)show;

@end

@interface DXLActionSheetViewButton : UIButton

@end
