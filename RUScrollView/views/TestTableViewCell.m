//
//  TestTableViewCell.m
//  RUScrollView
//
//  Created by LCQ on 14-5-22.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell
@synthesize tapBlock,index;

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

@end
