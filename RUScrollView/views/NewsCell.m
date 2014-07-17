//
//  NewsCell.m
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    __weak UIImageView *tempImageView = self.newsPicture;
    [self.newsPicture setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[RUUtils getImage:PlaceholderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (!image || error) {
            tempImageView.contentMode = UIViewContentModeCenter;
            tempImageView.image = [RUUtils getImage:DefaultFailImage];
        }
        else {
            tempImageView.clipsToBounds = YES;
            tempImageView.contentMode = UIViewContentModeScaleToFill;
            
        }
    }];
}

@end
