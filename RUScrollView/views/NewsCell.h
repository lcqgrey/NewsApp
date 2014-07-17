//
//  NewsCell.h
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsPicture;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (copy, nonatomic) NSString *imageUrl;

@end
