//
//  ViewControllerOrigin.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "ViewControllerOrigin.h"
#import "RootViewController.h"
#import "NetwokView.h"

@interface ViewControllerOrigin ()<NetworkViewDelegate>
{
    KeyboardDidMoveBlock keyboardDidMoveBlock;
    MBProgressHUD *mHud;
    NetwokView *errorView;
}

@end

@implementation ViewControllerOrigin
@synthesize backBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self setHidesBottomBarWhenPushed:YES];
//    self.hidesBottomBarWhenPushed = YES;
    if ([self respondsToSelector:@selector(getNavigaitonTitle)]) {
        self.navigationItem.title = [self getNavigaitonTitle];
    }
    if (TARGET_IOS_VERSION7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
        self.AutomaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    else {
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        self.navigationController.navigationBar.translucent = YES;
    }

    //设置iOS 6状态栏的颜色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    [self.navigationController.navigationBar setBackgroundImage:[self getBarImage] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = self.view.center;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    label.textAlignment = NSTextAlignmentCenter;
    
    if ([self respondsToSelector:@selector(getTi)]) {
        label.text = [self getTi];
    }
    [self.view addSubview:label];
    
    //设置导航栏的标题文字属性
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blueColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];

}


- (UIImage *)getBarImage
{
    CGRect rect;
    if (TARGET_IOS_VERSION7) {
        rect = CGRectMake(0, 0, kScreenWidth, 64);
    }
    else {
        rect = CGRectMake(0, 0, kScreenWidth, 44);
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
//    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)getNavigaitonTitle
{
    return nil;
}


- (NSString *)getTi
{
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//#if Analytics_UMeng_Enable
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
//#endif
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//#if Analytics_UMeng_Enable
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
//#endif
//}

    //需要添加错误和没有数据情况下的视图时的调用，show为YES添加
- (void)requestNetworkWithPath:(NSString *)path requestMethod:(HttpRequestMethod)requestMethod params:(NSDictionary *)para withJSONModelStr:(NSString *)modelName showErrorView:(BOOL)show operationBlock:(RequestBackBlock)block
{
    if (block) {
        self.backBlock = block;
    }
    [[AppRequestClient shareApiClientInstance] sendRequestWithPath:path withRequestMethod:requestMethod withParams:para withJSONModelStr:modelName withResponseBlock:^(ResponseType responseType, id responseData) {
        [self removeRequestErrorView];
        switch (responseType) {
            case ResponseFailure:
            {
                UIViewControllerRequestNetWorkErrorType netWorkType = backBlock(ResponseFailure,responseData);
                if (show) {
                    [self addRequestErrorViewWithMessageType:netWorkType];
                }
            }
                break;
            case ResponseSuccessAndServerError:
            {
                UIViewControllerRequestNetWorkErrorType netWorkType = backBlock(ResponseSuccessAndServerError,responseData);
                if (show) {
                    [self addRequestErrorViewWithMessageType:netWorkType];
                }
            }
                break;
            case ResponseSuccessAndDataFormatError:
            {
                UIViewControllerRequestNetWorkErrorType netWorkType = backBlock(ResponseSuccessAndDataFormatError,responseData);
                if (show) {
                    [self addRequestErrorViewWithMessageType:netWorkType];
                }
            }
            case ResponseSuccessAndDataExist:
            {
                UIViewControllerRequestNetWorkErrorType netWorkType = backBlock(ResponseSuccessAndDataExist,responseData);
                if (show) {
                    [self addRequestErrorViewWithMessageType:netWorkType];
                }
            }
                break;
            default:
                break;
        }
    }];
}
    //不需要添加错误和没有数据情况下的视图的调用
- (void)requestNetworkWithPath:(NSString *)path requestMethod:(HttpRequestMethod)requestMethod params:(NSDictionary *)para withJSONModelStr:(NSString *)modelName operationBlock:(RequestBackBlock)block
{
    [self requestNetworkWithPath:path requestMethod:requestMethod params:para withJSONModelStr:modelName showErrorView:NO operationBlock:block];
}

    //添加无网络或没有数据时的视图
-(void)addRequestErrorViewWithMessageType:(UIViewControllerRequestNetWorkErrorType)type {
    [self addRequestErrorViewWithMessageType:type showInView:self.view];
}

    //在指定视图上添加无网络或没有数据时的视图,手动调用
-(void)addRequestErrorViewWithMessageType:(UIViewControllerRequestNetWorkErrorType)type  showInView:(UIView *)targetView {
    
    if (type == UIViewControllerRequestNetWorkNone) {
        return;
    }
    if (!errorView) {
        errorView = [[[NSBundle mainBundle]loadNibNamed:@"NetworkView" owner:self options:nil]objectAtIndex:0];
        errorView.frame = targetView.bounds;
        errorView.delegate = self;
        errorView.tag = 928;
    }
    
    if (type == UIViewControllerRequestNetWorkNoConnection) {
        [errorView.networkFlagImageView setImage:[RUUtils getImage:@"/wifi_flag"]];
        errorView.userInteractionEnabled = YES;
        errorView.titleMsgLbl.text = @"网络异常,请检查网络连接是否正常!";
        errorView.subtitleLbl.text = @"点击页面,重新加载";
    }else if (type == UIViewControllerRequestLoadImageFailed) {
        [errorView.networkFlagImageView setImage:[RUUtils getImage:@"/wifi_flag"]];
        errorView.userInteractionEnabled = YES;
        errorView.titleMsgLbl.text = @"图片加载失败!";
        errorView.subtitleLbl.text = @"点击页面，重新加载";
    }
    else if (type == UIViewControllerRequestNetWorkNoData) {
        [errorView.networkFlagImageView setImage:[RUUtils getImage:@"/network_sad_face"]];
        errorView.userInteractionEnabled = NO;
        errorView.titleMsgLbl.text = @"亲,该页暂无数据!";
        errorView.subtitleLbl.text = nil;
    }
    
    [targetView addSubview:errorView];
}


//移除无网络或没有数据时的视图
-(void)removeRequestErrorView {
    if (errorView && [errorView superview]) {
        [errorView removeFromSuperview];
    }
}

//网络加载动画视图

-(void)showLoadingView
{
    [self showLoadingViewInView:self.view];
}


-(void)showLoadingViewInView:(id)sender
{
    if (mHud == nil) {
        UIView *view = (UIView *)sender;
        mHud = [[MBProgressHUD alloc]initWithView:view];
        [view addSubview:mHud];
    }
    mHud.mode = MBProgressHUDModeIndeterminate;
    [mHud show:YES];
}



-(void)hiddingLoadingViewImmediately
{
    if (mHud) {
        [mHud hide:NO];
    }
}

- (void)hiddingLoadingViewDelay
{
    if (mHud) {
        [mHud hide:NO afterDelay:1];
    }
}

- (void)addKeyboardActionHandlerForRootViewWithVerOffset:(CGFloat)vOffset {
    __block CGPoint originCenter = self.view.center;
    __weak typeof(self) weakSelf = self;
    
    [self addKeyboardActionHandler:^(UIViewControllerKeyboard state, CGFloat keyboardHeight) {
        if (state == UIViewControllerKeyboardWillShow) {
            originCenter = weakSelf.view.center;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.view.center = CGPointMake(originCenter.x, originCenter.y - vOffset);
            }];
            [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UIKeyboardWillShowNotification object:nil];
        }else if (state == UIViewControllerKeyboardWillHide) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.view.center = originCenter;
            }];
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
        }
    }];
}

- (void)addKeyboardActionHandler:(KeyboardDidMoveBlock)block {
    keyboardDidMoveBlock = block;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - keyboard notification

- (void)keyboardNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    NSDictionary* userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    UIViewControllerKeyboard keyboard = UIViewControllerKeyboardWillShow;
    if ([name isEqualToString:UIKeyboardDidShowNotification]) {
        keyboard = UIViewControllerKeyboardDidShow;
    }else if ([name isEqualToString:UIKeyboardDidHideNotification]) {
        keyboard = UIViewControllerKeyboardDidHide;
    }else if ([name isEqualToString:UIKeyboardWillShowNotification]) {
        keyboard = UIViewControllerKeyboardWillShow;
    }else if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        keyboard = UIViewControllerKeyboardWillHide;
    }else if ([name isEqualToString:UIKeyboardWillChangeFrameNotification]) {
        keyboard = UIViewControllerKeyboardWillChangeFrame;
    }
    if (keyboardDidMoveBlock) {
        keyboardDidMoveBlock(keyboard, keyboardHeight);
    }
}

@end
