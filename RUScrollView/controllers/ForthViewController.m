//
//  ForthViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "ForthViewController.h"
#import "RUImageScanView.h"

@interface ForthViewController ()

@end

@implementation ForthViewController

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
    return [[AppManager defaultManager] getLocalString:@"Forth"];
}


- (NSString *)getTi
{
    return @"4";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIImage *balloon = [RUUtils getImage:@"1.jpg"];
    [[[self view] layer] setContents:(id)[balloon CGImage]];
    CGMutablePathRef path =CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 100);
    CGPathAddLineToPoint(path,NULL, 200, 0);
    CGPathAddLineToPoint(path, NULL, 200, 200);
    CGPathAddLineToPoint(path, NULL, 0, 100);
    [shapeLayer setBounds:CGRectMake(0, 0, 200, 200)];
    [shapeLayer setFillColor:[[UIColor purpleColor]CGColor]];
    [shapeLayer setPosition:CGPointMake(200, 200)];
    [shapeLayer setPath:path];
    [shapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [shapeLayer setLineWidth:10.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:2],
      nil]];  
    [[[self view] layer]setMask:shapeLayer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
