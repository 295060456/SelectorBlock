//
//  CADisplayLink_TimerManager.h
//  Timer
//
//  Created by Jobs on 2020/9/1.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerManager_DefineStructure.h"
#import "AABlock.h"

//此类虽然为工具类，但是不允许用单例，因为timer需要被释放
NS_ASSUME_NONNULL_BEGIN
/**
 
    屏幕刷新时调用CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。
    CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。
    所以通常情况下，按照iOS设备屏幕的刷新率60次/秒
    延迟iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。
    但如果调用的方法比较耗时，超过了屏幕刷新周期，就会导致跳过若干次回调调用机会。
    如果CPU过于繁忙，无法保证屏幕60次/秒的刷新率，就会导致跳过若干次调用回调方法的机会，跳过次数取决CPU的忙碌程度。
 
    使用场景：
    从原理上可以看出，CADisplayLink适合做界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染。
 **/
@interface CADisplayLink_TimerManager : NSObject

@property(nonatomic,strong)CADisplayLink *displayLink;
@property(nonatomic,copy)MKDataBlock CADisplayLinkTimerManagerBlock;

@end

NS_ASSUME_NONNULL_END
