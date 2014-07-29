//
//  ThirdViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "ThirdViewController.h"
#import "DXLAlertView.h"
#import "DXLActionSheetView.h"

@interface ThirdViewController () <DXLAlertViewDelegate,DXLActionSheetViewDelegate>

@end

@implementation ThirdViewController

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
    return [[AppManager defaultManager] getLocalString:@"Third"];
}
- (NSString *)getTi
{
    return @"3";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 200, 50);
    [cancelButton.layer setCornerRadius:5];
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    cancelButton.tag = 0;
    [cancelButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    

    NSString *string = @"4000-5000";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    if (regex != nil) {
        NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
        for (NSTextCheckingResult *result in results) {
            NSRange range = [result rangeAtIndex:0];
            NSString *r = [string substringWithRange:range];
            NSLog(@"--%d++++%@",range.location,r);
        }
    }
    
    NSMutableOrderedSet *orderSet = [[NSMutableOrderedSet alloc] init]; //有序的集合，且自动移除相同的元素
    [orderSet addObject:@"4000"];
    [orderSet addObject:@"4000"];
    [orderSet addObject:@"5000"];
    [orderSet addObject:@"6000"];
    [orderSet addObject:@"5000"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didClick:(UIButton *)sender
{
    DXLAlertView *alert = [[DXLAlertView alloc]initWithMessageTitle:@"123" message:@"档期紧张,我们的顾问会尽快给您提供该吉日的酒店信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"fdsfds",@"fdsf",nil];
    [alert showAnimation];
//    DXLActionSheetView *vie = [[DXLActionSheetView alloc]initWithMessageTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享到新浪",@"分享到腾讯",@"分享到微信", nil];
//    [vie show];
}

- (void)didActionSheet:(UIButton *)actionSheet withButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d %@",buttonIndex,actionSheet.titleLabel.text);
}

//- (void)didSelectAlertButton:(UIButton *)button withButtonIndex:(NSInteger)index
//{
//    NSLog(@"%@  %d",button.titleLabel.text,index);
//}

@end
