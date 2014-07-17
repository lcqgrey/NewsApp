//
//  FirstViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "FirstViewController.h"
#import "RUScrollView.h"
#import "NewsTableView.h"
#import "NewsCell.h"
#import "newsListModel.h"
#import "RequestParamModel.h"

#define TABLE_NUM 8
typedef void (^RefreshNoticeBlock) (MJRefreshBaseView *refreshView);
NSString *const kPathIndex = @"selectedIndex";

@interface FirstViewController ()<RUTableViewDelegate,RUTableViewDelegate>
{
    UIView *headerView;
    RUScrollView *adScrollView;
    RUScrollView *containerScrollView;
    RUScrollView *imageShowScrollView;
    RUScrollView *titleScrollView;
    NSInteger categoryCount;
    CGFloat lastScrollContentOffset;
    
    NewsTableView *currentTable;
    MJRefreshBaseView *currentRefreshView;
    BOOL islll;
    BOOL isPulDown;

    NSMutableArray *dataSourceArray;
}

@property (nonatomic, copy) RefreshNoticeBlock block;


@end

@implementation FirstViewController

@synthesize selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    categoryCount = 8;
    [self addObserver:self forKeyPath:kPathIndex options:NSKeyValueObservingOptionNew context:nil];
    
    
    titleScrollView = [[RUScrollView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 40)];
    titleScrollView.delegate = self;
    titleScrollView.backgroundColor = [UIColor grayColor];
    
    
    dataSourceArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < categoryCount; i++) {
        NSMutableArray *dataSource = [[NSMutableArray alloc]init];
        [dataSourceArray addObject:dataSource];
    }
    
    for (int i = 0; i < categoryCount; i++) {
        RUButton *titleBtn = [RUButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i*kViewWidth/4+1, 0 ,(kViewWidth-3)/4, 40);
        __weak typeof(self) weakself = self;
        [titleBtn setAttributes:@{kRUButtonTitleColorNomal:[UIColor blackColor],kRUButtonTitleColorSelected:[UIColor yellowColor],kRUButtonTitleNomal:@"头条",kRUButtonTitleFont:[UIFont systemFontOfSize:14],kRUButtonBgColor:[UIColor lightGrayColor]} withClickBlock:^(RUButton *reuseBtn) {
            [weakself didClickTitle:reuseBtn];
        }];
        titleBtn.tag = 100+i;
        if (i == 0) {
            titleBtn.selected = YES;
            selectedIndex = @(titleBtn.tag - 100);
        }
        [titleScrollView addSubview:titleBtn];

    }
    
    [self.view addSubview:titleScrollView];
    
    containerScrollView = [[RUScrollView alloc]initWithFrame:CGRectMake(0, 40, kViewWidth, kViewHeight-40)];
    containerScrollView.backgroundColor = [UIColor purpleColor];
    containerScrollView.pagingEnabled = YES;
    containerScrollView.contentSize = CGSizeMake(kViewWidth*2, kViewHeight);
    containerScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    containerScrollView.delegate = self;
    
    for (int i = 0; i < categoryCount; i++) {
        NewsTableView *customTable = [[NewsTableView alloc]initWithFrame:CGRectMake(i*containerScrollView.bounds.size.width, 0, containerScrollView.bounds.size.width , containerScrollView.bounds.size.height)];
        customTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        customTable.backgroundColor = [UIColor greenColor];
        customTable.tag = 200+i;
        customTable.index = i;
        customTable.LoadingStyle = RUTableViewLoadingInFooterAnnimationStyle;
        customTable.dataSources = [dataSourceArray objectAtIndex:i];
        customTable.dataSource = self;
        customTable.delegate = self;
        customTable.refreshDelegate = self;
        customTable.refreshDate = [[NSDate date] laterDate:[NSDate date]];
        if (i == 0) {
            customTable.tableHeaderView = [self createADScrollView];
            currentTable = customTable;
            [customTable beginRefresh];
        }

        [containerScrollView addSubview:customTable];
    }
    [self setValue:@(0) forKey:kPathIndex];
    [self.view addSubview:containerScrollView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    titleScrollView.contentSize = CGSizeMake(kViewWidth*2, 40);
    adScrollView.contentSize = CGSizeMake(kViewWidth*3, 200);
    containerScrollView.contentSize = CGSizeMake(kViewWidth*TABLE_NUM, kViewHeight - 40);
}

#pragma mark - overwrite

- (NSString *)getNavigaitonTitle
{
    return [[AppManager defaultManager] getLocalString:@"First"];
}

#pragma mark - request

- (void)requestServerForRefreshing //进入时和下拉刷新时调用
{
    currentTable.page = 1;
    NSDictionary *dic = [RequestParamModel newsListParamDictionaryWithStartRecord:@(currentTable.page) len:@"12" cid:@(213)];
    [self requestNetworkWithPath:ApiNewsURL requestMethod:HttpRequestMethodGET params:dic withJSONModelStr:@"NewsListModel" showErrorView:YES operationBlock:^UIViewControllerRequestNetWorkErrorType(ResponseType responseType, id responseData) {
        return [self refreshData:responseData responseType:responseType];
    }];
}

- (void)requestServerForLoadingMore //上拉加载时调用
{
    NSDictionary *dic = [RequestParamModel newsListParamDictionaryWithStartRecord:@(currentTable.page) len:@"12" cid:@(213)];
    [self requestNetworkWithPath:ApiNewsURL requestMethod:HttpRequestMethodGET params:dic withJSONModelStr:@"NewsListModel" operationBlock:^UIViewControllerRequestNetWorkErrorType(ResponseType responseType, id responseData) {
        return [self refreshData:responseData responseType:responseType];
    }];
}

#pragma mark - refresh data method

- (UIViewControllerRequestNetWorkErrorType)refreshData:(id)data responseType:(ResponseType)type
{
    UIViewControllerRequestNetWorkErrorType errorType = UIViewControllerRequestNetWorkNone;
    if (AppRequestClientInstance.hasNet) { //有网时的操作
        switch (type) {
            case ResponseFailure:
                errorType = UIViewControllerRequestNetWorkNoConnection;
                break;
            case ResponseSuccessAndDataExist:
            {
                if ([data isKindOfClass:[JSONModel class]]) {
                    if (isPulDown) {
                        [currentTable.dataSources removeAllObjects];
                        isPulDown = NO;
                    }
                    NSInteger lastCount = currentTable.dataSources.count;
                    NewsListModel *model = data;
                    [currentTable.dataSources addObjectsFromArray:model.news];
                    if (currentTable.dataSources.count == 0) {
                        errorType = UIViewControllerRequestNetWorkNoData;
                    }
                    else if (currentTable.dataSources.count != 0 && currentTable.dataSources.count == lastCount) {
                        currentTable.isLastPage = YES;
                        errorType = UIViewControllerRequestNetWorkNone;
                    }
                    else {
                        currentTable.page += 1;
                        errorType = UIViewControllerRequestNetWorkNone;
                    }
                }
            }
                break;
            case ResponseSuccessAndDataFormatError:
                errorType = UIViewControllerRequestNetWorkNoData;
                break;
            case ResponseSuccessAndServerError:
                errorType = UIViewControllerRequestNetWorkNoData;
                break;
            default:
                break;
        }
    }
    else { //没有网络时的操作
        
    }
    [self endRefresh:currentTable with:currentRefreshView];
    return errorType;
}

#pragma mark - RUTableView delegate

- (void)requestMore:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{
    currentRefreshView = refreshView;
    currentTable.isRefreshing = YES;
    [self requestServerForLoadingMore];
}

- (void)update:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{
    currentRefreshView = refreshView;
    currentTable.isRefreshing = YES;
    isPulDown = YES;
    [self requestServerForRefreshing];
    table.isLastPage = NO;
}

- (void)endRefresh:(RUTableView *)table with:(MJRefreshBaseView *)refreshView
{
    table.isRefreshing = NO;
    [table performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1];
    [table performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}

#pragma mark - create view

- (UIView *)createADScrollView
{
    headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 200)];
    headerView.backgroundColor = [UIColor yellowColor];
    
    adScrollView = [[RUScrollView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 200)];
    adScrollView.backgroundColor = [UIColor grayColor];
    adScrollView.pagingEnabled = YES;
    adScrollView.delegate = self;
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(adScrollView.bounds.size.width*i, 0, kViewWidth,200)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = RandomColor;
        [adScrollView addSubview:imageView];
    }
    [headerView addSubview:adScrollView];
    
    UIPageControl *pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(10, adScrollView.bounds.size.height - 30, kViewWidth-30, 30)];
    pageC.numberOfPages = 3;
    [pageC addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:pageC];
    
    return headerView;
}



#pragma mark - data processing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self requestNetWorkWithIndex:[selectedIndex integerValue]];
}

- (void)requestNetWorkWithIndex:(NSInteger)index
{
    NSLog(@"index %d are ready to request data",index);

    RUTableView *tableView = (RUTableView *)[containerScrollView viewWithTag:[selectedIndex integerValue] + 200];
//    NSLog(@"+++%d",[NSDate lastDate:tableView.refreshDate]);
    if ([NSDate lastDate:tableView.refreshDate] > 20) {
//        [tableView.header beginRefreshing];
        tableView.refreshDate = [NSDate date];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    }
}


#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RUTableView *tab = (RUTableView *)tableView;
    NSLog(@"selectedIndex %d RUTable index %d are ready reload count %d",[selectedIndex integerValue],tab.index,tab.dataSources.count);
    NSLog(@"%d",tab.dataSources.count);
    return tab.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"Cell";
    NewsCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:self options:nil] objectAtIndex:0];
    }
    NewsTableView *tab = (NewsTableView *)tableView;
    NewsModel *news = [tab.dataSources objectAtIndex:indexPath.row];
    cell.imageUrl = news.picUrl;
    cell.newsTitle.text = news.title;
    cell.newsDescription.text = news.summary;

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [RUUtils colorWithHexString:@"#eeeeee"];
    cell.selectedBackgroundView = view;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == adScrollView) {
        UIPageControl *pageC = [headerView.subviews lastObject];
        pageC.currentPage = scrollView.contentOffset.x/kViewWidth;
    }
    if (scrollView == containerScrollView) {
        NSInteger index = containerScrollView.contentOffset.x/kViewWidth;
        [self changeTitleDidScroll:index];
        selectedIndex = @(index);
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[RUTableView class]]) {
        RUTableView *temp = (RUTableView *)scrollView;
        if (!temp.isRefreshing) {
            if (temp.contentOffset.y + temp.bounds.size.height > temp.contentSize.height && temp.contentSize.height > temp.bounds.size.height) {
                    [temp refreshWithNoneStyle];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - click events

- (void)didClickTitle:(id)sender
{
    RUButton *lastBtn = (RUButton *)[titleScrollView viewWithTag:[selectedIndex integerValue]+100];
    lastBtn.selected = NO;
    RUButton *btn = sender;
    btn.selected = YES;
    [self setValue:@(btn.tag - 100) forKey:kPathIndex];
    CGPoint offSet = containerScrollView.contentOffset;
    offSet.x = kViewWidth*[selectedIndex integerValue];
    containerScrollView.contentOffset = offSet;
}

#pragma mark - change news page

- (void)changePage:(UIPageControl *)sender
{
    NSInteger page = sender.currentPage;
    CGPoint offSet = adScrollView.contentOffset;
    offSet.x = kViewWidth*page;
    adScrollView.contentOffset = offSet;
}

- (void)changeTitleDidScroll:(NSInteger)index
{
    UIButton *lastBtn = (UIButton *)[titleScrollView viewWithTag:[selectedIndex integerValue]+100];
    lastBtn.selected = NO;
    
    if ([selectedIndex integerValue] < 4 && index > 3) {
        CGPoint offSet = titleScrollView.contentOffset;
        offSet.x = kViewWidth;
        titleScrollView.contentOffset = offSet;
    }
    else if ([selectedIndex integerValue] > 3 && index < 4) {
        CGPoint offSet = titleScrollView.contentOffset;
        offSet.x = 0;
        titleScrollView.contentOffset = offSet;
    }
    [self setValue:@(index) forKey:kPathIndex];
    UIButton *btn = (UIButton *)[titleScrollView viewWithTag:index+100];
    btn.selected = YES;
    
}

@end
