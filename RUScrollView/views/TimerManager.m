//
//  TimerManager.m
//  testApp
//
//  Created by LCQ on 14-9-29.
//  Copyright (c) 2014年 simple. All rights reserved.
//

#import "TimerManager.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, TimerStatus) {
    TimerPrepare,
    TimerExecute,
    TimerResume,
    TimerSuspend
};

@interface TimerManager ()

@property (nonatomic, strong) NSMutableDictionary *timerDic;

@end

@implementation TimerManager

static TimerManager *myInstance = nil;

+ (TimerManager *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myInstance = [[TimerManager alloc]init];
    });
    return myInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timerDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block
{
    [self addTimerWithTimeInterval:interval keyValue:value withOperationBlock:block executedImmediately:YES];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block executedImmediately:(BOOL)yesOrNo
{
   [self addTimerWithTimeInterval:interval delegate:nil keyValue:value withOperationBlock:block executedImmediately:yesOrNo];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value
{
    [self addTimerWithTimeInterval:interval delegate:aDelegate keyValue:value executedImmediately:YES];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value executedImmediately:(BOOL)yesOrNo
{
    [self addTimerWithTimeInterval:interval delegate:aDelegate keyValue:value withOperationBlock:nil executedImmediately:yesOrNo];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block
{
    [self addTimerWithTimeInterval:interval delegate:aDelegate keyValue:value withOperationBlock:block executedImmediately:YES];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block executedImmediately:(BOOL)yesOrNo
{
    if ([self.timerDic objectForKey:value]) {
        return;
    }
    
    NSLog(@"add new timer %@",value);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(0, 0), interval*NSEC_PER_SEC, 0);
    __weak typeof(self) weakself = self;
    dispatch_source_set_event_handler(timer, ^{
        [weakself executeTimerWithKey:value];
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"%@ timer cancel complete",value);
    });
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:timer forKey:@"timer"];
    [dic setObject:@(0) forKey:@"executeTimes"];
    [dic setObject:@(TimerPrepare) forKey:@"timerStatus"];
    if (aDelegate) {
        __weak id<TimerManagerDelegate> delegate = aDelegate;
        [dic setObject:delegate forKey:@"delegate"];
    }
    if (block) {
        TimerOperationBlock timerBlock = block;
        [dic setObject:timerBlock forKey:@"block"];
    }
    [self.timerDic setObject:dic forKey:value];
    
    if (yesOrNo) {
        [self resumeTimerWithKey:value];
    }
}


- (void)resumeTimerWithKey:(NSString *)key
{
    NSMutableDictionary *dic = [self.timerDic objectForKey:key];
    dispatch_source_t timer = [dic objectForKey:@"timer"];
    if (!timer) {
        return;
    }
    TimerStatus status = [[[self.timerDic objectForKey:key] objectForKey:@"timerStatus"] integerValue];
    if (status != TimerResume) {
        NSLog(@"resume timer %@",key);
        [dic setObject:@(TimerResume) forKey:@"timerStatus"];
        dispatch_resume(timer);
        [self setDelegateAndBlockWith:key andOperationType:TimerOperationResume];
    }
    
}

- (void)suspendTimerWithKey:(NSString *)key
{
    NSMutableDictionary *dic = [self.timerDic objectForKey:key];
    dispatch_source_t timer = [[self.timerDic objectForKey:key] objectForKey:@"timer"];
    if (!timer) {
        return;
    }
    TimerStatus status = [[[self.timerDic objectForKey:key] objectForKey:@"timerStatus"] integerValue];
    if (status != TimerSuspend) {
        NSLog(@"suspend timer %@",key);
        [dic setObject:@(TimerSuspend) forKey:@"timerStatus"];
        dispatch_suspend(timer);
        [self setDelegateAndBlockWith:key andOperationType:TimerOperationSuspend];
    }
}

- (void)cancelTimerWithKey:(NSString *)key
{
    dispatch_source_t timer = [[self.timerDic objectForKey:key] objectForKey:@"timer"];
    if (!timer) {
        return;
    }
    TimerStatus status = [[[self.timerDic objectForKey:key] objectForKey:@"timerStatus"] integerValue];
    if (status == TimerResume || status == TimerExecute) {
        dispatch_source_cancel(timer);
    }
    else {
        dispatch_resume(timer);
        dispatch_source_cancel(timer);
    }
    NSLog(@"start cancel timer %@",key);
    [self setDelegateAndBlockWith:key andOperationType:TimerOperationCancel];
    
    [self.timerDic removeObjectForKey:key];
}

- (void)cancelAllTimer
{
    for (NSString *key in self.timerDic) {
        dispatch_source_t timer = [[self.timerDic objectForKey:key] objectForKey:@"timer"];
        if (!timer) {
            continue;
        }
        TimerStatus status = [[[self.timerDic objectForKey:key] objectForKey:@"timerStatus"] integerValue];
        if (status == TimerResume || status == TimerExecute) {
            dispatch_source_cancel(timer);
        }
        else if (status == TimerSuspend) {
            dispatch_resume(timer);
            dispatch_source_cancel(timer);
        }
        NSLog(@"start cancel timer %@",key);
        [self setDelegateAndBlockWith:key andOperationType:TimerOperationCancel];

    }
    [self.timerDic removeAllObjects];
}

    
- (void)executeTimerWithKey:(NSString *)key
{
    NSLog(@"execute timer %@",key);
    NSMutableDictionary *dic = [self.timerDic objectForKey:key];
    [dic setObject:@(TimerExecute) forKey:@"timerStatus"];
    NSInteger number = [[[self.timerDic objectForKey:key] objectForKey:@"executeTimes"] integerValue];
    number++;
    [[self.timerDic objectForKey:key] setObject:@(number) forKey:@"executeTimes"];
    [self setDelegateAndBlockWith:key andOperationType:TimerOperationExecute];
}

- (void)setDelegateAndBlockWith:(NSString *)key andOperationType:(TimerOperationType)type
{
    id delegate = [[self.timerDic objectForKey:key] objectForKey:@"delegate"];
    TimerOperationBlock block = [[self.timerDic objectForKey:key] objectForKey:@"block"];
    NSInteger number = [[[self.timerDic objectForKey:key] objectForKey:@"executeTimes"] integerValue];
    NSLog(@"%@+++++%d",key,number);
    if (delegate) {
        [delegate timerDidOperation:type withKey:key withExecuteTimes:number];
    }
    if (block) {
        block(type, key, number);
    }
}

- (void)dealloc
{
    for (NSString *key in self.timerDic) {
        id delegate = [[self.timerDic objectForKey:key] objectForKey:@"delegate"];
        TimerOperationBlock block = [[self.timerDic objectForKey:key] objectForKey:@"block"];
        if (delegate) {
            delegate = nil;
        }
        if (block) {
            block = nil;
        }
        [self resumeTimerWithKey:key];
        [self cancelTimerWithKey:key];
    }
}


@end
