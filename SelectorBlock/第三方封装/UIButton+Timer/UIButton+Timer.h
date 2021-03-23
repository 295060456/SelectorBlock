//
//  UIButton+Timer.h
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "ButtonTimerModel.h"
#import "NSString+TimeFormatConvertFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Timer)

@property(nonatomic,copy)MKDataBlock countDownBlock;//倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
@property(nonatomic,copy)MKDataBlock countDownClickEventBlock;//点击事件回调，就不要用系统的addTarget/action/forControlEvents
@property(nonatomic,copy)MKDataBlock allowCountdownBlock;//外界条件判断通过以后开始倒计时
@property(nonatomic,assign,readonly)BOOL isDataStrMakeNewLine;//readonly作用外部不能赋值，只能内部赋值
@property(nonatomic,strong)ButtonTimerModel *btnTimerConfig;

-(void)actionCountDownBlock:(MKDataBlock _Nullable)countDownBlock;//倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
-(void)actionCountDownClickEventBlock:(MKDataBlock _Nullable)countDownClickEventBlock;//点击事件回调，就不要用系统的addTarget/action/forControlEvents
-(void)timeFailBeginFrom:(NSInteger)timeCount;//倒计时时间次数 自启动直接调用
-(void)timerDestroy;//可以不结束直接掐死

- (instancetype)initWithConfig:(ButtonTimerModel *_Nonnull)config;

@end

NS_ASSUME_NONNULL_END
