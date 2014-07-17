//
//  SecondViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "TestTableView.h"
#import "TestTableViewFirstStyleCell.h"
#import "TestTableViewSecondStyleCell.h"
#import "RUTestViewController.h"
#import "RUShareView.h"

typedef NS_ENUM (NSInteger, TestTableViewCellStyle) {
    TestTableViewFirstStyle,
    TestTableViewSecondStyle
};


@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,RUTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) TestTableView *testTable;

@end

@implementation SecondViewController
@synthesize dataSource,firstDataSource,secondDataSource,testTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)getNavigaitonTitle
{
    return [[AppManager defaultManager] getLocalString:@"Second"];
}
- (NSString *)getTi
{
    return @"2";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
        //按钮
    
//    RUButton *testBtn = [RUButton buttonWithType:UIButtonTypeCustom];
//    NSDictionary *attributes = @{kRUButtonBgColor: @"#feegds",kRUButtonTitleNomal:@"fdf",kRUButtonTitleHighlight:@"fdsfds",kRUButtonTitleFont:@"19",kRUButtonLayerCornerRadius:@"5",kRUButtonFrame:@"20,20,100,50"};
//    __weak typeof(self) weakself = self;
//    [testBtn setAttributes:attributes withClickBlock:^(RUButton *reuseBtn) {
//        [weakself share];
//    }];
//    [self.view addSubview:testBtn];
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.firstDataSource = [[NSMutableArray alloc]init];
    self.secondDataSource = [[NSMutableArray alloc]init];
      
    [self images];
    
    testTable = (TestTableView *)[[[NSBundle mainBundle] loadNibNamed:@"TestTableView" owner:self options:nil] objectAtIndex:0];
    testTable.refreshDelegate = self;

    testTable.LoadingStyle = RUTableViewLoadingInFooterAnnimationStyle;
    [self.view addSubview:testTable];
}


- (void)share
{
    RUShareView *shareView = [[RUShareView alloc]initWithTitle:@"分享方式" cancelButton:@"取消" imagePath:@[@"123",@"123",@"123",@"123",@"123",@"123",@"123"] title:@[@"weixin",@"weibo",@"facebook",@"doban",@"sina",@"souhu",@"kaixin"]];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)images
{
    for (int i = 0; i < 12; i++) {
        if (dataSource.count < 20) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"images.bundle/%d.jpg",dataSource.count + 1]];
            [dataSource addObject:image];
        }
        else {
            break;
        }
    }
}

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    NSInteger allCount = dataSource.count;
    NSInteger index = 0;
    [firstDataSource removeAllObjects];
    [secondDataSource removeAllObjects];
    for (int i=0; ; i++) {
        if (i%2 == 0 && allCount >= 3) {
            for (int j= 0; ; j++) {
                if (j < 3) {
                    [firstDataSource addObject:dataSource[index + j]];
                }
                else {
                    break;
                }
            }
            allCount -= 3;
            index += 3;
        }
        else if (i%2 == 1 && allCount >= 4) {
            
            for (int j= 0; ; j++) {
                if (j < 4) {
                    [secondDataSource addObject:dataSource[index + j]];
                }
                else {
                    break;
                }
            }
            allCount -= 4;
            index += 4;
        }
        else {
            break;
        }
        count += 1;
    }
    if (allCount != 0) {
        count += 1;
        if (count%2 == 1) {
            for (int i= 0; i<allCount; i++) {
                [firstDataSource addObject:dataSource[index + i]];
            }
        }
        else {
            for (int i= 0; i<allCount; i++) {
                [secondDataSource addObject:dataSource[index + i]];
            }
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        static NSString *firstCell = @"FirstCell";
        TestTableViewFirstStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCell];
        if (cell == nil) {
            cell = (TestTableViewFirstStyleCell *)[[[NSBundle mainBundle] loadNibNamed:@"TestTableViewFirstStyleCell" owner:self options:nil] objectAtIndex:0];
        }
        if (indexPath.row/2*3 < firstDataSource.count) {
            cell.firstImageView.image = firstDataSource[indexPath.row/2*3];
            cell.firstImageView.userInteractionEnabled = YES;
        }
        else {
            cell.firstImageView.image = nil;
            cell.firstImageView.userInteractionEnabled = NO;
        }
        if (indexPath.row/2*3 + 1 < firstDataSource.count) {
            cell.secondImageView.image = firstDataSource[indexPath.row/2*3 + 1];
            cell.secondImageView.userInteractionEnabled = YES;
        }
        else {
            cell.secondImageView.image = nil;
            cell.secondImageView.userInteractionEnabled = NO;
        }
        if (indexPath.row/2*3 + 2 < firstDataSource.count) {
            cell.thirdImageView.image = firstDataSource[indexPath.row/2*3 + 2];
            cell.secondImageView.userInteractionEnabled = YES;
        }
        else {
            cell.thirdImageView.image = nil;
            cell.secondImageView.userInteractionEnabled = NO;
        }
        cell.index = indexPath.row;
        __weak typeof(self) weakself = self;
        cell.tapBlock = ^(NSInteger index) {
            [weakself didSelectCell:TestTableViewFirstStyle imageViewAtIndex:index];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString *secondCell = @"SecondCell";
        TestTableViewSecondStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCell];
        if (cell == nil) {
            cell = (TestTableViewSecondStyleCell *)[[[NSBundle mainBundle] loadNibNamed:@"TestTableViewSecondStyleCell" owner:self options:nil] objectAtIndex:0];
        }
        if ((indexPath.row - 1)/2*4 < secondDataSource.count) {
            cell.firstImageView.image = secondDataSource[(indexPath.row - 1)/2*4];
            cell.firstImageView.userInteractionEnabled = YES;
        }
        else {
            cell.firstImageView.image = nil;
            cell.firstImageView.userInteractionEnabled = NO;
        }
        if ((indexPath.row - 1)/2*4 + 1 < secondDataSource.count) {
            cell.secondImageView.image = secondDataSource[(indexPath.row - 1)/2*4 + 1];
            cell.secondImageView.userInteractionEnabled = YES;
        }
        else {
            cell.secondImageView.image = nil;
            cell.secondImageView.userInteractionEnabled = NO;
        }
        if ((indexPath.row - 1)/2*4 + 2 < secondDataSource.count) {
            cell.thirdImageView.image = secondDataSource[(indexPath.row - 1)/2*4 + 2];
            cell.thirdImageView.userInteractionEnabled = YES;
        }
        else {
            cell.thirdImageView.image = nil;
            cell.thirdImageView.userInteractionEnabled = NO;
        }
        if ((indexPath.row - 1)/2*4 + 3 < secondDataSource.count) {
            cell.forthImageView.image = secondDataSource[(indexPath.row - 1)/2*4 + 3];
            cell.forthImageView.userInteractionEnabled = YES;
        }
        else {
            cell.forthImageView.image = nil;
            cell.forthImageView.userInteractionEnabled = NO;
        }
        cell.index = indexPath.row;
        __weak typeof(self) weakself = self;
        cell.tapBlock = ^(NSInteger index) {
            [weakself didSelectCell:TestTableViewSecondStyle imageViewAtIndex:index];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.f;
}

- (NSInteger)getFirstVisibleImageViewInCell
{
    NSInteger index = 0;
    NSIndexPath *indexPath = [testTable.indexPathsForVisibleRows firstObject];
    CGFloat height = testTable.contentOffset.y - indexPath.row*180.f;
    if (indexPath.row%2 != 0) {
        
        TestTableViewSecondStyleCell *testCell = [testTable.visibleCells firstObject];
        if (testCell.firstImageView.bottom > height) {
            index = 2*(indexPath.row - 1) + testCell.firstImageView.tag - 500;//index与firstDataSource对应
            NSLog(@"first visible view  %d",index);
        }
        else {
            NSInteger index = 2*(indexPath.row - 1) + testCell.thirdImageView.tag - 500;
            NSLog(@"first visible view  %d",index);
        }
    }
    else {
        TestTableViewFirstStyleCell *testCell = [testTable.visibleCells firstObject];
        index = indexPath.row + testCell.firstImageView.tag - 500 + indexPath.row/2;
        NSLog(@"first visible view  %d",index);//index与secondDataSource对应
    }
    return index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self getFirstVisibleImageViewInCell];
}

#pragma mark - tap block event

- (void)didSelectCell:(TestTableViewCellStyle)tableViewCell imageViewAtIndex:(NSInteger)index
{
    RUTestViewController *testVC = [[RUTestViewController alloc]init];
    if (tableViewCell == TestTableViewFirstStyle) {
        testVC.image = firstDataSource[index];
    }
    else {
        testVC.image = secondDataSource[index];
    }
    [testVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - pull up and pull down event


- (void)requestMore:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{
    
    if (dataSource.count < 20) {
        [self images];
        table.isLastPage = NO;
    }
    else {
        table.isLastPage = YES;

    }
    [self endRefresh:table with:refreshView];
    
}

- (void)update:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{
    [dataSource removeAllObjects];
    table.isLastPage = NO;
    [self images];
    [self endRefresh:table with:refreshView];
}

- (void)endRefresh:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{

    [table endRefresh:refreshView];
    [table reloadData];
}

@end
