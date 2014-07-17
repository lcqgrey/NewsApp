//
//  TestTableViewFirstStyleCell.h
//  RUScrollView
//
//  Created by LCQ on 14-5-22.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTableViewCell.h"

@interface TestTableViewFirstStyleCell : TestTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
- (IBAction)didTapImage:(UITapGestureRecognizer *)sender;

@end
