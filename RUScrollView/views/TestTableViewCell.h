//
//  TestTableViewCell.h
//  RUScrollView
//
//  Created by LCQ on 14-5-22.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapOperationBlock)(NSInteger index);

@interface TestTableViewCell : UITableViewCell

@property (nonatomic) NSInteger index;
@property (nonatomic, copy) TapOperationBlock tapBlock;

@end
