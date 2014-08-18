//
//  HomeMenuView.h
//  WineApp
//
//  Created by stone on 14-8-9.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMenuView;
@protocol HomeMenuDelegate <NSObject>

- (void)didClickViewAtIndex:(NSInteger)index;

@end

@interface HomeMenuView : UIView

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat margin;
@property (nonatomic, weak) id<HomeMenuDelegate> delegate;

@end
