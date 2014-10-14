//
//  RUTestViewController.m
//  RUScrollView
//
//  Created by LCQ on 14-5-12.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RUTestViewController.h"
#import "TimerManager.h"

#define kMaxZoom 3.0f

@interface RUTestViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

{
    UIPinchGestureRecognizer *pinchRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    UITapGestureRecognizer *tapProfileImageRecognizer;
    UITapGestureRecognizer *singleTap;
    CGFloat touchX;
    CGFloat touchY;
    CGFloat offsetY;
    CGFloat currentScale;
    BOOL isDoubleTapingForZoom;
}
@property (nonatomic, strong) UIScrollView *scaleScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL isZoomIn;

@end

@implementation RUTestViewController
@synthesize block,imageView,scaleScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.AutomaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.scaleScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scaleScrollView.delegate = self;
        scaleScrollView.maximumZoomScale = kMaxZoom;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.userInteractionEnabled = YES;
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        
        tapProfileImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapG:)];
        [tapProfileImageRecognizer setNumberOfTapsRequired:2];
        [tapProfileImageRecognizer setDelegate:self];
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapG:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setDelegate:self];
        
        [singleTap requireGestureRecognizerToFail:tapProfileImageRecognizer];
        
        [self.view addGestureRecognizer:tapProfileImageRecognizer];
        [self.view addGestureRecognizer:singleTap];
        [self.view addSubview:scaleScrollView];
        [self.scaleScrollView addSubview:imageView];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    TimerManager *timerManager = [[TimerManager alloc] init];
    __block TimerManager *tempTimerManager = timerManager;
//    __weak typeof(self) weakself = self;
    [timerManager addTimerCountDownWithTimeInterval:1 executeTimes:5 keyValue:@"tt" withOperationBlock:^(TimerOperationType type, NSString *key, NSInteger executeTimes) {
//        [weakself timerWith:type andKey:key andExecuteTimes:executeTimes];
        switch (type) {
            case TimerOperationStart:
                
                break;
            case TimerOperationExecute:
//                if ([key isEqualToString:@"tt"] && executeTimes == 3) {
//                    [tempTimerManager suspendTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 5) {
//                    [tempTimerManager resumeTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 7) {
//                    [tempTimerManager suspendTimerWithKey:@"ww"];
//                }
//                if ([key isEqualToString:@"yy"] && executeTimes == 9) {
//                    [tempTimerManager cancelAllTimer];
//                }
                
                break;
            case TimerOperationResume:
                
                break;
            case TimerOperationSuspend:
                
                break;
            case TimerOperationCancel:
                
                break;
                
            default:
                break;
        }
    }];
    
    [timerManager addTimerCountDownWithTimeInterval:1 executeTimes:10 keyValue:@"ww" withOperationBlock:^(TimerOperationType type, NSString *key, NSInteger executeTimes) {
//        [weakself timerWith:type andKey:key andExecuteTimes:executeTimes];
        switch (type) {
            case TimerOperationStart:
                
                break;
            case TimerOperationExecute:
                
//                if ([key isEqualToString:@"tt"] && executeTimes == 3) {
//                    [tempTimerManager suspendTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 5) {
//                    [tempTimerManager resumeTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 7) {
//                    [tempTimerManager suspendTimerWithKey:@"ww"];
//                }
//                if ([key isEqualToString:@"yy"] && executeTimes == 9) {
//                    [tempTimerManager cancelAllTimer];
//                }
                
                break;
            case TimerOperationResume:
                
                break;
            case TimerOperationSuspend:
                
                break;
            case TimerOperationCancel:
                
                break;
                
            default:
                break;
        }
    }];
    
    [timerManager addTimerCountDownWithTimeInterval:1 executeTimes:15 keyValue:@"yy" withOperationBlock:^(TimerOperationType type, NSString *key, NSInteger executeTimes) {
        switch (type) {
            case TimerOperationStart:
                
                break;
            case TimerOperationExecute:
                
//                if ([key isEqualToString:@"tt"] && executeTimes == 3) {
//                    [tempTimerManager suspendTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 5) {
//                    [tempTimerManager resumeTimerWithKey:@"tt"];
//                }
//                if ([key isEqualToString:@"ww"] && executeTimes == 7) {
//                    [tempTimerManager suspendTimerWithKey:@"ww"];
//                }
//                if ([key isEqualToString:@"yy"] && executeTimes == 9) {
//                    [tempTimerManager cancelAllTimer];
//                }
                
                break;
            case TimerOperationResume:
                
                break;
            case TimerOperationSuspend:
                
                break;
            case TimerOperationCancel:
                
                break;
                
            default:
                break;
        }
//        [weakself timerWith:type andKey:key andExecuteTimes:executeTimes];
    }];
}

- (void)timerWith:(TimerOperationType)type andKey:(NSString *)key andExecuteTimes:(NSInteger)executeTimes
{
    switch (type) {
        case TimerOperationStart:
            
            break;
        case TimerOperationExecute:
            
            if ([key isEqualToString:@"tt"] && executeTimes == 3) {
                TimerManager *timerManager = [TimerManager instance];
                [timerManager suspendTimerWithKey:@"tt"];
            }
            if ([key isEqualToString:@"ww"] && executeTimes == 5) {
                TimerManager *timerManager = [TimerManager instance];
                [timerManager resumeTimerWithKey:@"tt"];
            }
            if ([key isEqualToString:@"ww"] && executeTimes == 7) {
                TimerManager *timerManager = [TimerManager instance];
                [timerManager suspendTimerWithKey:@"ww"];
            }
            if ([key isEqualToString:@"yy"] && executeTimes == 9) {
                TimerManager *timerManager = [TimerManager instance];
                [timerManager cancelAllTimer];
            }
            
            break;
        case TimerOperationResume:
            
            break;
        case TimerOperationSuspend:
            
            break;
        case TimerOperationCancel:
            
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        return;
    }
    imageView.image = image;
}

//
//- (void)setUrlStr:(NSString *)urlStr
//{
//    if (_urlStr == urlStr) {
//        return;
//    }
//    NSString *str = [[ImageBaseURL stringByAppendingString:self.server_name] stringByAppendingString:LargeType];
//    _urlStr = [str stringByAppendingString:urlStr];
//    NSURL *url = [NSURL URLWithString:_urlStr];
//    __weak UIImageView *tempImageView = imageView;
//    [imageView setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if (!image || error) {
//            tempImageView.contentMode = UIViewContentModeCenter;
//            tempImageView.image = [UIImage getImageAtPath:LoadingFailed];
//        }
//        else {
//            tempImageView.contentMode = UIViewContentModeScaleAspectFit;
//        }
//    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//}

#pragma mark - scrollView delegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    currentScale = scrollView.zoomScale; //记录当前scale
    
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
    if(isDoubleTapingForZoom){
        xcenter = kMaxZoom*(kScreenWidth - touchX);
        ycenter = kMaxZoom*(kScreenHeight - touchY);
        if(xcenter > (kMaxZoom - 0.5)*kScreenWidth){//放大后左边超界
            xcenter = (kMaxZoom - 0.5)*kScreenWidth;
        }else if(xcenter <0.5*kScreenWidth){//放大后右边超界
            xcenter = 0.5*kScreenWidth;
        }
        if(ycenter > (kMaxZoom - 0.5)*kScreenHeight){//放大后左边超界
            ycenter = (kMaxZoom - 0.5)*kScreenHeight +offsetY*kMaxZoom;
        }else if(ycenter <0.5*kScreenHeight){//放大后右边超界
            ycenter = 0.5*kScreenHeight +offsetY*kMaxZoom;
        }
        isDoubleTapingForZoom = NO;
    }
    [imageView setCenter:CGPointMake(xcenter, ycenter)];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

//双击
- (void)tapG:(UITapGestureRecognizer *)sender
{
    touchX = [sender locationInView:sender.view].x;
    touchY = [sender locationInView:sender.view].y;
    if(currentScale > 1.0){
        isDoubleTapingForZoom = NO;
        currentScale = 1.0;
        [scaleScrollView setZoomScale:1.0 animated:YES];
    }else{
        isDoubleTapingForZoom = YES;
        currentScale = kMaxZoom;
        [scaleScrollView setZoomScale:kMaxZoom animated:YES];
    }
}
//单击
- (void)singleTapG:(UITapGestureRecognizer *)sender
{
    if (block) {
        block();
    }
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end
