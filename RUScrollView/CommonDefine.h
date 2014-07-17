//
//  CommonDefine.h
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//


#import "ViewControllerOrigin.h"
#import "RUButton.h"
#import "RUUtils.h"
#import "RUNavigationViewController.h"
#import "AppManager.h"
#import "MJRefresh.h"
#import "NSDate+DateCalculate.h"
#import "UIViewExt.h"
#import "WXHLGlobalUICommon.h"
#import "AppRequestClient.h"


#define ApiBaseURL @"http://ipad-bjwb.bjd.com.cn/"
#define ApiNewsURL @"DigitalPublication/publish/Handler/APINewsList.ashx"

#define Analytics_UMeng_Enable 1

#define kNetChangeNotification @"netChangeNotification" //网络发生改变时的通知key

#define PlaceholderImage @"/placeholderImage"
#define DefaultFailImage @"/default_fail"

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kViewWidth          self.view.bounds.size.width
#define kViewHeight         self.view.bounds.size.height
#define kViewOriginX        self.view.frame.origin.x
#define kViewOriginY        self.view.frame.origin.y
#define kViewWidthInView(view)     (view).bounds.size.width
#define kViewHeightInView(view)   (view).bounds.size.height

#define AppRequestClientInstance ((AppRequestClient *)[AppRequestClient shareApiClientInstance])


#define IOS_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]
#define TARGET_IOS_VERSION7     (([[[UIDevice currentDevice]systemVersion] floatValue]) >= 7.0)
#define SHAREAPP    (AppDelegate*)[UIApplication sharedApplication].delegate
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define ColorWithRGB(r,g,b,a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kArc4random arc4random()%256
#define RandomColor ColorWithRGB(kArc4random,kArc4random,kArc4random,1)