//
//  ButtonTimerDefStructure.h
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#ifndef ButtonTimerDefStructure_h
#define ButtonTimerDefStructure_h

typedef enum : NSUInteger {
    ShowTimeType_SS = 0,//秒
    ShowTimeType_MMSS,//分秒
    ShowTimeType_HHMMSS,//时分秒
} ShowTimeType;

typedef enum : NSUInteger {
    CountDownBtnType_normal = 0,//普通模式
    CountDownBtnType_countDown//倒计时模式
} CountDownBtnType;

typedef enum : NSUInteger {
    CountDownBtnNewLineType_normal = 0,//普通模式
    CountDownBtnNewLineType_newLine//换行模式
} CountDownBtnNewLineType;

typedef enum : NSUInteger {
    CequenceForShowTitleRuningStrType_front = 0,//TitleRuningStr（固定值） 相对于 currentTime（浮动值）在前面 | 首在前
    CequenceForShowTitleRuningStrType_tail//TitleRuningStr（固定值） 相对于 currentTime（浮动值）在后面 | 首在后
} CequenceForShowTitleRuningStrType;

typedef enum : NSUInteger {
    CountDownBtnRunType_manual = 0,//手动触发计时器模式
    CountDownBtnRunType_auto//自启动模式
} CountDownBtnRunType;

#endif /* ButtonTimerDefStructure_h */
