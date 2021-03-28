//
//  UIButton+Timer.h
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "AABlock.h"
#import "NSObject+Time.h"
#import "NSObject+RichText.h"//富文本
#import "TimerManager.h"//时间管理
#import "ButtonTimerDefStructure.h"
#import "ButtonTimerConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Timer)

@property(nonatomic,copy)MKDataBlock countDownBlock;//倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
@property(nonatomic,copy)MKDataBlock countDownClickEventBlock;//点击事件回调，就不要用系统的addTarget/action/forControlEvents
@property(nonatomic,copy)MKDataBlock timerRunningBlock;// 定时器运行时的Block
@property(nonatomic,copy)MKDataBlock timerFinishBlock;// 定时器结束时候的Block
@property(nonatomic,assign,readonly)BOOL isDataStrMakeNewLine;//readonly作用外部不能赋值，只能内部赋值
@property(nonatomic,strong)ButtonTimerConfigModel *btnTimerConfig;

// 定时器运行时的Block
-(void)actionBlockTimerRunning:(MKDataBlock _Nullable)timerRunningBlock;
// 定时器结束时候的Block
-(void)actionBlockTimerFinish:(MKDataBlock _Nullable)timerFinishBlock;
// 倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
-(void)actionCountDownBlock:(MKDataBlock _Nullable)countDownBlock;
// 点击事件回调，就不要用系统的addTarget/action/forControlEvents
-(void)actionCountDownClickEventBlock:(MKDataBlock _Nullable)countDownClickEventBlock;

-(void)timeFailBeginFrom:(NSInteger)timeCount;//倒计时时间次数 自启动直接调用
-(void)timerDestroy;//可以不结束直接掐死
-(void)startTimer;//开启倒计时【手动控制计时器的启动时机】
-(instancetype)initWithConfig:(ButtonTimerConfigModel *_Nonnull)config;

@end

NS_ASSUME_NONNULL_END
