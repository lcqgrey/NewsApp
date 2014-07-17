//
//  TestTableViewSecondStyleCell.m
//  RUScrollView
//
//  Created by LCQ on 14-5-22.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "TestTableViewSecondStyleCell.h"

@implementation TestTableViewSecondStyleCell

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

- (IBAction)didTapImage:(UITapGestureRecognizer *)sender {
    NSLog(@"select --%d",2*(self.index - 1) + sender.view.tag - 500);
    self.tapBlock(2*(self.index - 1) + sender.view.tag - 500);
}
@end
