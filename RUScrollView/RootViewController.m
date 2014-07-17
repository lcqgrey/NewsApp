//
//  RootViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RootViewController.h"
#import "RUBarButton.h"
#import "FirstViewController.h"

@interface RootViewController ()
{
    UIButton *_preBtn;
    UIImageView *_tabBarView;
}

@end

@implementation RootViewController

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
    
    _tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 ,self.view.bounds.size.width, 49)];
    _tabBarView.backgroundColor = [UIColor lightGrayColor];
    _tabBarView.userInteractionEnabled = YES;
    [self.tabBar addSubview:_tabBarView];
    self.delegate = self;
    AppManager *instance = [AppManager defaultManager];
    
    self.viewControllers = [self tabBarViewControllers:@[@"FirstViewController",@"SecondViewController",@"ThirdViewController",@"ForthViewController"] barTitles:@[[instance getLocalString:@"First"],[instance getLocalString:@"Second"],[instance getLocalString:@"Third"],[instance getLocalString:@"Forth"]]];
    UIButton *btn = (UIButton *)(_tabBarView.subviews)[0];
    btn.enabled = NO;
    _preBtn = btn;
}


- (NSArray *)tabBarViewControllers:(NSArray *)classNameArr barTitles:(NSArray *)barTitleArr
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:classNameArr.count];
    for (int i = 0 ; i < classNameArr.count ; i++) {
        NSString *str = [classNameArr objectAtIndex:i];
        NSString *barTitle = [barTitleArr objectAtIndex:i];
        if (NSClassFromString(str)) {
            ViewControllerOrigin *vc = [[NSClassFromString(str) alloc]init];
            UIButton *btn  = [self createBarButtonFrame:CGRectMake(i*_tabBarView.bounds.size.width/classNameArr.count, 0, _tabBarView.bounds.size.width/classNameArr.count, _tabBarView.bounds.size.height) title:barTitle customImage:nil disableImage:nil index:10 + i];
            [_tabBarView addSubview:btn];
            RUNavigationViewController *navc = [[RUNavigationViewController alloc]initWithRootViewController:vc];
            [arr addObject:navc];
        }
    }
    return arr;
}


- (UIButton *)createBarButtonFrame:(CGRect)frame title:(NSString *)title customImage:(UIImage *)cImage disableImage:(UIImage *)dImage index:(NSInteger)index
{
    RUBarButton *barButton = [RUBarButton buttonWithType:UIButtonTypeCustom];

    NSValue *rect = [NSValue valueWithCGRect:frame];
    [barButton setAttributes:@{kRUButtonFrame: rect,kRUButtonTitleNomal: title, kRUButtonTitleFont: [UIFont systemFontOfSize:12], kRUButtonTitleColorNomal: [UIColor blackColor],kRUButtonTitleColorDisabled: [UIColor yellowColor],kRUButtonBgColor:[UIColor clearColor]} withClickBlock:nil];
    barButton.tag = index;
    return barButton;
}

#pragma mark - tabBarController delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIButton *btn = (UIButton *)[_tabBarView viewWithTag:tabBarController.selectedIndex+10];
    btn.enabled = NO;
    if (_preBtn != btn) {
        _preBtn.enabled = YES;
    }
    _preBtn = btn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
