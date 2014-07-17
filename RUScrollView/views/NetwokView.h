//
//  NetwokView.h
//  DaoxilaApp
//
//  Created by li yajie on 7/30/13.
//  Copyright (c) 2013 com.daoxila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetwokView;
@protocol NetworkViewDelegate <NSObject>

@optional
-(void) refreshRequest:(NetwokView*) networkView;

@end

@interface NetwokView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *networkFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLbl;


@property (nonatomic,weak) id<NetworkViewDelegate> delegate;

@end
