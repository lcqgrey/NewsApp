//
//  NetwokView.m
//  DaoxilaApp
//
//  Created by li yajie on 7/30/13.
//  Copyright (c) 2013 com.daoxila. All rights reserved.
//

#import "NetwokView.h"

@implementation NetwokView
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:gesture];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    self.subtitleLbl.textColor = [UIColor darkTextColor];
    [self performSelector:@selector(didBack) withObject:nil afterDelay:0.25];
    if ([delegate respondsToSelector:@selector(refreshRequest:)]) {
        [delegate refreshRequest:self];
    }
}

- (void)didBack
{
    self.subtitleLbl.textColor = [UIColor darkGrayColor];
}

@end
