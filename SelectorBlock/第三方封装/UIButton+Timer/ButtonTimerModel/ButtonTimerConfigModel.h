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
@property(nonatomic,strong)NSTimerManager *timerManager;
@property(nonatomic,assign)long count;// 倒计时，默认5秒
@property(nonatomic,assign)ShowTimeType showTimeType;//时间显示风格
@property(nonatomic,assign)TimerStyle countDownBtnType;// 时间方向
@property(nonatomic,assign)CountDownBtnNewLineType countDownBtnNewLineType;//是否换行。设置了这个属性仅仅对titleRuningStr有效，且在外层进行设置的时候需要用户手动加就换行符 \n
@property(nonatomic,assign)CequenceForShowTitleRuningStrType cequenceForShowTitleRuningStrType;// 文本显示类型
@property(nonatomic,assign)BOOL isCanBeClickWhenTimerCycle;// 倒计时期间，默认不接受任何的点击事件
#pragma mark —— 计时器未开始
// UI
@property(nonatomic,strong)UIColor *layerBorderReadyPlayCor;
@property(nonatomic,strong)UIColor *titleReadyPlayCor;
@property(nonatomic,strong)UIFont *titleLabelReadyPlayFont;
@property(nonatomic,strong)UIColor *bgReadyPlayCor;
@property(nonatomic,assign)CGFloat layerCornerReadyPlayRadius;
@property(nonatomic,assign)CGFloat layerBorderReadyPlayWidth;
// Data
@property(nonatomic,strong)NSString *titleReadyPlayStr;//与titleReadyPlayAttributedStr互斥
@property(nonatomic,strong)NSAttributedString *titleReadyPlayAttributedStr;//富文本，与titleReadyPlayStr互斥
@property(nonatomic,strong)NSMutableArray <RichLabelDataStringsModel *>*titleReadyPlayAttributedDataMutArr;
#pragma mark —— 计时器进行中
// UI
@property(nonatomic,strong)UIColor *layerBorderRunningCor;
@property(nonatomic,strong)UIColor *titleRunningCor;
@property(nonatomic,strong)UIFont *titleLabelRunningFont;
@property(nonatomic,strong)UIColor *bgRunningCor;//计时过程中此btn的背景色
@property(nonatomic,assign)CGFloat layerBorderRunningWidth;
@property(nonatomic,assign)CGFloat layerCornerRunningRadius;
// Data
@property(nonatomic,strong)NSString *titleRunningStr;//计时过程中显示的非时间文字，与titleRunningAttributedStr互斥
@property(nonatomic,strong)NSAttributedString *titleRunningAttributedStr;//富文本，与titleRunningStr互斥
@property(nonatomic,strong)NSMutableArray <RichLabelDataStringsModel *>*titleRunningDataMutArr;
#pragma mark —— 计时器结束
// UI
@property(nonatomic,strong)UIColor *layerBorderEndCor;
@property(nonatomic,strong)UIColor *bgEndCor;//倒计时完全结束后的背景色
@property(nonatomic,strong)UIColor *titleEndCor;
@property(nonatomic,strong)UIFont *titleLabelEndFont;
@property(nonatomic,assign)CGFloat layerCornerEndRadius;
@property(nonatomic,assign)CGFloat layerBorderEndWidth;
// Data
@property(nonatomic,strong)NSString *titleEndStr;//与titleEndAttributedStr互斥
@property(nonatomic,strong)NSAttributedString *titleEndAttributedStr;//富文本，与titleEndStr互斥
@property(nonatomic,strong)NSMutableArray <RichLabelDataStringsModel *>*titleEndDataMutArr;
#pragma mark —— 其他
@property(nonatomic,strong)NSString *finalTitleStr;//最终的title
@property(nonatomic,strong)NSString *formatTimeStr;//根据ShowTimeType格式化以后的时间【内部使用】
@property(nonatomic,strong)NSString *appendingStrByFormatTimeStr;//formatTimeStr后缀拼接的字符串。因为formatTimeStr是内部使用

-(void)actionBlockTimerRunning:(MKDataBlock)timerRunningBlock;// 定时器运行时的Block
-(void)actionBlockTimerFinish:(MKDataBlock)timerFinishBlock;// 定时器结束时候的Block

@end

NS_ASSUME_NONNULL_END
