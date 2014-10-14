//
//  TimerManager.h
//  testApp
//
//  Created by LCQ on 14-9-29.
//  Copyright (c) 2014年 simple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TimerOperationType) {
    TimerOperationStart,
    TimerOperationExecute,
    TimerOperationResume,
    TimerOperationSuspend,
    TimerOperationCancel
};

typedef void(^TimerOperationBlock)(TimerOperationType type, NSString *key, NSInteger executeTimes);

@protocol TimerManagerDelegate <NSObject>

- (void)timerDidOperation:(TimerOperationType)type withKey:(NSString *)key withExecuteTimes:(NSInteger)executeTimes;

@end

@interface TimerManager : NSObject

+ (TimerManager *)instance;

    //the timer count down
- (void)addTimerCountDownWithTimeInterval:(NSTimeInterval)interval executeTimes:(NSUInteger)times delegate:(id)aDelegate keyValue:(NSString *)value; //execute immediately

- (void)addTimerCountDownWithTimeInterval:(NSTimeInterval)interval executeTimes:(NSUInteger)times delegate:(id)aDelegate keyValue:(NSString *)value executedImmediately:(BOOL)yesOrNo;

- (void)addTimerCountDownWithTimeInterval:(NSTimeInterval)interval executeTimes:(NSUInteger)times keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block; //execute immediately

- (void)addTimerCountDownWithTimeInterval:(NSTimeInterval)interval executeTimes:(NSUInteger)times keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block executedImmediately:(BOOL)yesOrNo;


    //
- (void)addTimerWithTimeInterval:(NSTimeInterval)interval keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block; //execute immediately

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval keyValue:(NSString *)value withOperationBlock:(TimerOperationBlock)block executedImmediately:(BOOL)yesOrNo;

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value; //execute immediately

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval delegate:(id)aDelegate keyValue:(NSString *)value executedImmediately:(BOOL)yesOrNo;



- (void)resumeTimerWithKey:(NSString *)key;

- (void)suspendTimerWithKey:(NSString *)key;

- (void)cancelTimerWithKey:(NSString *)key;

- (void)cancelAllTimer;

@end
