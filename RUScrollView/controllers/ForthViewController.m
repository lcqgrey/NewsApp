//
//  ForthViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-4-29.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "ForthViewController.h"
#import "RUImageScanView.h"
#import "TestView.h"

@interface ForthViewController ()
{
    CAShapeLayer *shapeLayer;
    
}
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
    
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//     UIImage *balloon = [RUUtils getImage:@"/1.jpg"];
//    imageView.image = balloon;
//    [self.view addSubview:imageView];
    
    

//    [[[self view] layer] setContents:(id)[balloon CGImage]];
//    CGMutablePathRef path =CGPathCreateMutable(); CGPathMoveToPoint(path, NULL, 0, 100);
//    CGPathAddLineToPoint(path, NULL, 200, 0);
//    CGPathAddLineToPoint(path, NULL, 200,200);
//    CGPathAddLineToPoint(path, NULL, 0, 100);
//    shapeLayer = [[CAShapeLayer alloc] init];
//    [shapeLayer setBounds:CGRectMake(0, 0, 200, 200)];
//    [shapeLayer setFillColor:[[UIColor purpleColor] CGColor]];
//    [shapeLayer setPosition:CGPointMake(200, 200)];
//    [shapeLayer setPath:path];
//    [[[self view] layer] setMask:shapeLayer];
////    [[[self view] layer] addSublayer:shapeLayer];
//    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
//    [self.view addGestureRecognizer:tapG];
    CGFloat radius = 120;
    CGFloat margin = 10;
    TestView *view = [[TestView alloc]initWithFrame:CGRectMake((kScreenWidth - 2 * radius - margin) * 0.5, self.view.bounds.size.height - 2 * radius - 160, 2 * radius + margin, 2 * radius + margin)];
    view.radius = radius;
    view.margin = margin;
    [self.view addSubview:view];

}



- (void)didTap
{
    NSLog(@"tap");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
