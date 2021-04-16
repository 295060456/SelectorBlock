//
//  DispatchTimerManager.m
//  SelectorBlock
//
//  Created by Jobs on 2021/4/16.
//

#import "DispatchTimerManager.h"

#define lock(...) \
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);\
    __VA_ARGS__;\
    dispatch_semaphore_signal(_semaphore);

@interface DispatchTimerManager ()

@end

@implementation DispatchTimerManager{
    BOOL _valid;
    BOOL _repeats;
    BOOL _running;
    NSTimeInterval _timeInterval;
    dispatch_source_t _timer;
    dispatch_semaphore_t _semaphore;
    SEL _selector;
    id _userInfo;
    __weak id _target;
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self invalidate];
}

+ (DispatchTimerManager *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                  target:(id)target
                                                selector:(SEL)selector
                                                userInfo:(nullable id)userInfo
                                                 repeats:(BOOL)repeats {
    DispatchTimerManager *timer = [[DispatchTimerManager alloc] initWithTimeInterval:0
                                                                            interval:interval
                                                                              target:target
                                                                            selector:selector
                                                                            userInfo:userInfo
                                                                             repeats:repeats];
    [timer resume];
    return timer;
}

+ (DispatchTimerManager *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                 repeats:(BOOL)repeats
                                                   block:(void (^)(DispatchTimerManager *timer))block {
    NSParameterAssert(block);
    DispatchTimerManager *timer = [[DispatchTimerManager alloc] initWithTimeInterval:0
                                                                            interval:interval
                                                                              target:self
                                                                            selector:@selector(executeBlockFromTimer:)
                                                                            userInfo:[block copy]
                                                                             repeats:repeats];
    [timer resume];
    return timer;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)start
                            interval:(NSTimeInterval)interval
                              target:(id)target
                            selector:(SEL)selector
                            userInfo:(nullable id)userInfo
                             repeats:(BOOL)repeats {
    if (self = [super init]) {
        _valid = YES;
        _timeInterval = interval;
        _repeats = repeats;
        _target = target;
        _selector = selector;
        _userInfo = userInfo;
        _semaphore = dispatch_semaphore_create(1);
        __weak typeof(self) weakSelf = self;
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                        0,
                                        0,
                                        dispatch_get_main_queue());
        dispatch_source_set_timer(_timer,
                                  dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                                  interval * NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(_timer, ^{[weakSelf fire];});
    }return self;
}

+ (void)executeBlockFromTimer:(DispatchTimerManager *)aTimer {
    void (^block)(DispatchTimerManager *) = [aTimer userInfo];
    if (block) block(aTimer);
}
// 后续添加queue支持
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block){
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0,
                                                     0,
                                                     queue);
    if (timer){
        dispatch_source_set_timer(timer,
                                  /*
                                   1、使用 dispatch_time 或者 DISPATCH_TIME_NOW：系统会使用默认时钟来进行计时；然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止
                                   2、使用 dispatch_walltime ：可以让计时器按照真实时间间隔进行计时
                                   **/
                                  dispatch_walltime(NULL, 0),
                                  interval,
                                  /*
                                      指的是一个期望的容忍时间。
                                      将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。
                                      在调用时推荐设置一个合理的 leeway 值。
                                      需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
                                   */
                                  leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);// 恢复dispatch定时器计时
    }return timer;
}

- (void)fire {
    if (!_valid) {return;}
    lock(id target = _target;)
    if (!target) {
        [self invalidate];
    } else {
        // 执行selector
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
        if (!_repeats) {
            [self invalidate];
        }
    }
}
/// 启动
- (void)resume {
    if (_running) return;
    dispatch_resume(_timer);// 恢复dispatch定时器计时
    _running = YES;
}
/// 暂停
- (void)suspend {
    if (!_running) return;
    dispatch_suspend(_timer);// 暂停dispatch定时器计时【特别注意：dispatch_suspend 之后的 Timer，是不能被释放的，否则会引起崩溃】
    _running = NO;
}
/// 关闭
- (void)invalidate {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (_valid) {
        dispatch_source_cancel(_timer);// 真正意义上的停止dispatch定时器计时
        _timer = NULL;
        _target = NULL;
        _userInfo = NULL;
        _valid = NO;
    }
    dispatch_semaphore_signal(_semaphore);
}

- (id)userInfo {
    lock(id ui = _userInfo) return ui;
}

- (BOOL)repeats {
    lock(BOOL re = _repeats) return re;
}

- (NSTimeInterval)timeInterval {
    lock(NSTimeInterval ti = _timeInterval) return ti;
}

- (BOOL)isValid {
    lock(BOOL va = _valid) return va;
}

@end
