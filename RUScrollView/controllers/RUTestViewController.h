//
//  RUTestViewController.h
//  RUScrollView
//
//  Created by LCQ on 14-5-12.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SingleTapBlcok)(void);

@interface RUTestViewController : UIViewController

//@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) SingleTapBlcok block;

@end
