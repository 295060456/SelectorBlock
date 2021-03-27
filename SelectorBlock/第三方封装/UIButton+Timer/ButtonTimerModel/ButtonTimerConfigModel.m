//
//  ButtonTimerModel.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "ButtonTimerConfigModel.h"

@interface ButtonTimerConfigModel ()

@property(nonatomic,copy)MKDataBlock timerRunningBlock;// 定时器运行时的Block
@property(nonatomic,copy)MKDataBlock timerFinishBlock;// 定时器结束时候的Block

@end

@implementation ButtonTimerConfigModel

@synthesize countDownBtnType = _countDownBtnType;

// 定时器运行时的Block
-(void)actionBlockTimerRunning:(MKDataBlock)timerRunningBlock{
    self.timerRunningBlock = timerRunningBlock;
}
// 定时器结束时候的Block
-(void)actionBlockTimerFinish:(MKDataBlock)timerFinishBlock{
    self.timerFinishBlock = timerFinishBlock;
}
#pragma mark —— 重写set方法
-(void)setCountDownBtnType:(CountDownBtnType)countDownBtnType{
    switch (countDownBtnType) {
        case CountDownBtnType_normal:{//普通模式
            _timerManager.timerStyle = TimerStyle_clockwise;//顺时针模式
        }break;
        case CountDownBtnType_countDown:{//倒计时模式
            _timerManager.timerStyle = TimerStyle_anticlockwise;//逆时针模式（倒计时模式）
        }break;
            
        default:
            break;
    }
}
#pragma mark —— lazyLoad
-(NSTimerManager *)timerManager{
    if (!_timerManager) {
        _timerManager = NSTimerManager.new;
        
        {
            switch (self.countDownBtnType) {
                case CountDownBtnType_normal:{
                    _timerManager.timerStyle = TimerStyle_clockwise;//顺时针模式
                }break;
                case CountDownBtnType_countDown:{
                    _timerManager.timerStyle = TimerStyle_anticlockwise;//逆时针模式（倒计时模式）
                    _timerManager.anticlockwiseTime = self.count;//逆时针模式（倒计时）的顶点时间
                }break;
                default:
                    break;
            }
        }
        @weakify(self)
        //倒计时启动
        [_timerManager actionNSTimerManagerRunningBlock:^(id data) {
            @strongify(self)
            NSLog(@"正在倒计时...");
            if (self.timerRunningBlock) {
                self.timerRunningBlock(data);
            }
        }];
        //倒计时结束
        [_timerManager actionNSTimerManagerFinishBlock:^(id data) {
            @strongify(self)
            if (self.timerFinishBlock) {
                self.timerFinishBlock(data);
            }
        }];
    }return _timerManager;
}

@end
