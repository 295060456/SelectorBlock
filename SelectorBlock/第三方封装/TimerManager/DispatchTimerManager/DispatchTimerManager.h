//
//  DispatchTimerManager.h
//  SelectorBlock
//
//  Created by Jobs on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import "TimerManager_DefineStructure.h"

NS_ASSUME_NONNULL_BEGIN

/**
    前言：
    Dispatch Source Timer 是一种与 Dispatch Queue 结合使用的定时器。
    当需要在后台 queue 中定期执行任务的时候，使用 Dispatch Source Timer 要比使用 NSTimer 更加自然，也更加高效（无需在 main queue 和后台 queue 之前切换）。
 
    优点：
    计时准确
    可以使用子线程，解决定时间跑在主线程上卡UI问题
 */

@interface DispatchTimerManager : NSObject

@property(nonatomic,retain)dispatch_source_t dispatchTimer;
/*
    指的是一个期望的容忍时间。
    将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。
    在调用时推荐设置一个合理的 leeway 值。
    需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
 */
@property(nonatomic,assign)uint64_t leeway;
@property(nonatomic,assign)uint64_t interval;
/// 核心属性
@property(nonatomic,assign)dispatch_time_t dispatch_time;
@property(nonatomic,retain)dispatch_queue_t queue;
/// 计时器调用
-(void)actionBlockDispatchTimerManager:(dispatch_block_t)dispatchTimerBlock;

/// 暂停dispatch定时器计时【特别注意：dispatch_suspend 之后的 Timer，是不能被释放的，否则会引起崩溃】
-(void)suspendDispatchTimer;
/// 完全停止dispatch定时器计时
-(void)stopDispatchTimer;
/// 恢复dispatch定时器计时
-(void)resumeDispatchTimer;

@end

NS_ASSUME_NONNULL_END
