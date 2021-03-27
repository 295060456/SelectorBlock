//
//  ButtonTimerModel.h
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "AABlock.h"
#import "TimerManager.h"//时间管理
#import "NSObject+RichText.h"//富文本
#import "ButtonTimerDefStructure.h"

NS_ASSUME_NONNULL_BEGIN

@interface ButtonTimerConfigModel : NSObject

#pragma mark —— 一些通用的设置
//倒计时开始前的背景色直接对此控件进行赋值 backgroundColor
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,strong)UIColor *layerBorderColor;
@property(nonatomic,strong)UIFont *titleLabelFont;
@property(nonatomic,assign)CGFloat layerCornerRadius;
@property(nonatomic,assign)CGFloat layerBorderWidth;
@property(nonatomic,strong)NSTimerManager *timerManager;
@property(nonatomic,assign)long count;// 倒计时
@property(nonatomic,assign)ShowTimeType showTimeType;//时间显示风格
@property(nonatomic,assign)CountDownBtnRunType btnRunType;/// 计时器启动模式
@property(nonatomic,assign)CountDownBtnType countDownBtnType;/// 时间方向
@property(nonatomic,assign)CountDownBtnNewLineType countDownBtnNewLineType;//是否换行。设置了这个属性仅仅对titleRuningStr有效，且在外层进行设置的时候需要用户手动加就换行符 \n
@property(nonatomic,assign)CequenceForShowTitleRuningStrType cequenceForShowTitleRuningStrType;/// 文本显示类型
@property(nonatomic,assign)BOOL isCanBeClickWhenTimerCycle;// 倒计时期间，默认不接受任何的点击事件
@property(nonatomic,strong)NSAttributedString *attributedString;//富文本
@property(nonatomic,strong)NSMutableArray <RichLabelDataStringsModel *>*richTextRunningDataMutArr;
#pragma mark —— 计时器未开始
@property(nonatomic,strong)NSString *titleBeginStr;
#pragma mark —— 计时器进行中
@property(nonatomic,strong)NSString *titleRuningStr;//倒计时过程中显示的非时间文字
@property(nonatomic,strong)UIColor *bgCountDownColor;//倒计时的时候此btn的背景色
#pragma mark —— 计时器结束
@property(nonatomic,strong)NSString *titleEndStr;
@property(nonatomic,strong)UIColor *bgEndColor;//倒计时完全结束后的背景色
@property(nonatomic,strong)NSString *finalTitleStr;//最终的title
#pragma mark —— 其他
@property(nonatomic,assign)BOOL isCountDownClockFinished;//倒计时是否结束
@property(nonatomic,assign)BOOL isCountDownClockOpen;//倒计时是否开始
@property(nonatomic,assign)BOOL isCountDown;//是否是第一次倒计时
@property(nonatomic,strong)NSString *formatTimeStr;//根据ShowTimeType格式化以后的时间【内部使用】
@property(nonatomic,strong)NSString *appendingStrByFormatTimeStr;//formatTimeStr后缀拼接的字符串。因为formatTimeStr是内部使用

-(void)actionBlockTimerRunning:(MKDataBlock)timerRunningBlock;// 定时器运行时的Block
-(void)actionBlockTimerFinish:(MKDataBlock)timerFinishBlock;// 定时器结束时候的Block

@end

NS_ASSUME_NONNULL_END
