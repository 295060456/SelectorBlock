//
//  DispatchTimerManager.m
//  SelectorBlock
//
//  Created by Jobs on 2021/4/14.
//

#import "DispatchTimerManager.h"

@interface DispatchTimerManager ()

@property(nonatomic,copy)dispatch_block_t dispatchTimerBlock;

@end

@implementation DispatchTimerManager

- (void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopDispatchTimer];
}

-(instancetype)init{
    if (self = [super init]) {
        
    }return self;
}
/// 暂停dispatch定时器计时【特别注意：dispatch_suspend 之后的 Timer，是不能被释放的，否则会引起崩溃】
-(void)suspendDispatchTimer{
    dispatch_suspend(self.dispatchTimer);
}
/// 真正意义上的停止dispatch定时器计时
-(void)stopDispatchTimer{
    dispatch_source_cancel(self.dispatchTimer);
    _dispatchTimer = nil; // OK
}
/// 恢复dispatch定时器计时
-(void)resumeDispatchTimer{
    dispatch_resume(self.dispatchTimer);
}

-(void)actionBlockDispatchTimerManager:(dispatch_block_t)dispatchTimerBlock{
    self.dispatchTimerBlock = dispatchTimerBlock;
}
#pragma mark —— lazyLoad
-(dispatch_source_t)dispatchTimer{
    if (!_dispatchTimer) {
        _dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                0,
                                                0,
                                                self.queue);
        dispatch_source_set_timer(_dispatchTimer,
                                  self.dispatch_time,
                                  self.interval,
                                  self.leeway);
        if (self.dispatchTimerBlock) {
            /*
                这个函数在执行完之后，block 会立马执行一遍，后面隔一定时间间隔再执行一次。
                而 NSTimer 第一次执行是到计时器触发之后。
                这也是和 NSTimer 之间的一个显著区别
             **/
            dispatch_source_set_event_handler(_dispatchTimer, self.dispatchTimerBlock);
        }
        dispatch_resume(_dispatchTimer);
    }return _dispatchTimer;
}

-(dispatch_queue_t)queue{
    if (!_queue) {
        _queue = dispatch_get_main_queue();
    }return _queue;
}

-(uint64_t)interval{
    if (!_interval) {
        _interval = 1;
    }return _interval;
}

-(dispatch_time_t)dispatch_time{
    if (!_dispatch_time) {
        /*
         1、使用 dispatch_time 或者 DISPATCH_TIME_NOW：系统会使用默认时钟来进行计时；然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止
         2、使用 dispatch_walltime ：可以让计时器按照真实时间间隔进行计时
         **/
        _dispatch_time = dispatch_walltime(NULL, 0);//让计时器按照真实时间间隔进行计时
    }return _dispatch_time;
}

@end
