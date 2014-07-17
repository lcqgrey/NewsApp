//
//  ViewControllerOrigin.h
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRequestClient.h"

typedef NS_ENUM(NSInteger, UIViewControllerKeyboard) {
    UIViewControllerKeyboardWillShow = 0,
    UIViewControllerKeyboardDidShow = 1,
    UIViewControllerKeyboardWillHide = 2,
    UIViewControllerKeyboardDidHide = 3,
    UIViewControllerKeyboardWillChangeFrame = 4
};

typedef NS_ENUM(NSInteger, UIViewControllerRequestNetWorkErrorType) {
    UIViewControllerRequestNetWorkNoConnection,
    UIViewControllerRequestNetWorkNoData,
    UIViewControllerRequestLoadImageFailed,
    UIViewControllerRequestNetWorkNone
};

typedef UIViewControllerRequestNetWorkErrorType (^RequestBackBlock)(ResponseType responseType,id responseData);

typedef void (^KeyboardDidMoveBlock)(UIViewControllerKeyboard state, CGFloat keyboardHeight);

@class RUNavigationViewController;
@interface ViewControllerOrigin : UIViewController

@property (nonatomic, copy) RequestBackBlock backBlock;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL shouldHideBottom;

- (NSString *)getNavigaitonTitle;
- (NSString *)getTi;

- (void)addKeyboardActionHandlerForRootViewWithVerOffset:(CGFloat)vOffset;
- (void)addKeyboardActionHandler:(KeyboardDidMoveBlock)block;
//xiawei add(end)

- (void)requestNetworkWithPath:(NSString *)path requestMethod:(HttpRequestMethod)requestMethod params:(NSDictionary *)para withJSONModelStr:(NSString *)modelName  showErrorView:(BOOL)show operationBlock:(RequestBackBlock)block;

- (void)requestNetworkWithPath:(NSString *)path requestMethod:(HttpRequestMethod)requestMethod params:(NSDictionary *)para withJSONModelStr:(NSString *)modelName operationBlock:(RequestBackBlock)block;

-(void)addRequestErrorViewWithMessageType:(UIViewControllerRequestNetWorkErrorType)type  showInView:(UIView *)targetView;

-(void)removeRequestErrorView;


- (void)showLoadingView;
- (void)showLoadingViewInView:(id)sender;
- (void)hiddingLoadingViewImmediately;
- (void)hiddingLoadingViewDelay;


@end
