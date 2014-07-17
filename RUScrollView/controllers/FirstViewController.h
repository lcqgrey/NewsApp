//
//  FirstViewController.h
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : ViewControllerOrigin<UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UIPageViewControllerDelegate>

@property (nonatomic, copy) NSNumber *selectedIndex;

@end
