//
//  UIButton+Timer.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "UIButton+Timer.h"

@implementation UIButton (Timer)

static char *UIButton_Timer_btnTimerConfig = "UIButton_Timer_btnTimerConfig";
static char *UIButton_CountDownBtn_isDataStrMakeNewLine = "UIButton_CountDownBtn_isDataStrMakeNewLine";
static char *UIButton_CountDownBtn_countDownBlock = "UIButton_CountDownBtn_countDownBlock";
static char *UIButton_CountDownBtn_countDownClickEventBlock = "UIButton_CountDownBtn_countDownClickEventBlock";
static char *UIButton_CountDownBtn_timerRunningBlock = "UIButton_CountDownBtn_timerRunningBlock";
static char *UIButton_CountDownBtn_timerFinishBlock = "UIButton_CountDownBtn_timerFinishBlock";

@dynamic btnTimerConfig;
@dynamic isDataStrMakeNewLine;
@dynamic countDownBlock;
@dynamic countDownClickEventBlock;
@dynamic timerRunningBlock;
@dynamic timerFinishBlock;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithConfig:(ButtonTimerConfigModel *_Nonnull)config{
    if (self = [super init]) {
        self.btnTimerConfig = config;
        [self setLayerConfigReadyPlay];
        [self setTitleReadyPlay];
        [self setTitleLabelConfigReadyPlay];
        // CountDownBtn 的点击事件回调
        @weakify(self)
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self)
            if (self.countDownClickEventBlock) {
                self.countDownClickEventBlock(self);
            }
        }];
    }return self;
}
#pragma clang diagnostic pop
#pragma mark —— UI配置
/// 计时器未开始
-(void)setLayerConfigReadyPlay{
    self.layer.borderColor = self.btnTimerConfig.layerBorderReadyPlayCor.CGColor;
    self.layer.cornerRadius = self.btnTimerConfig.layerCornerReadyPlayRadius;
    self.layer.borderWidth = self.btnTimerConfig.layerBorderReadyPlayWidth;
}

-(void)setTitleLabelConfigReadyPlay{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = self.btnTimerConfig.countDownBtnNewLineType;
    self.titleLabel.font = self.btnTimerConfig.titleLabelReadyPlayFont;
    [self setTitleColor:self.btnTimerConfig.titleReadyPlayCor
               forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}
/// 计时器进行中
-(void)setLayerConfigRunning{
    self.layer.borderColor = self.btnTimerConfig.layerBorderRunningCor.CGColor;
    self.layer.cornerRadius = self.btnTimerConfig.layerCornerRunningRadius;
    self.layer.borderWidth = self.btnTimerConfig.layerBorderRunningWidth;
}

-(void)setTitleLabelConfigRunning{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = self.btnTimerConfig.countDownBtnNewLineType;
    self.titleLabel.font = self.btnTimerConfig.titleLabelRunningFont;
    [self setTitleColor:self.btnTimerConfig.titleRunningCor
               forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}
/// 计时器结束
-(void)setLayerConfigEnd{
    self.layer.borderColor = self.btnTimerConfig.layerBorderEndCor.CGColor;
    self.layer.cornerRadius = self.btnTimerConfig.layerCornerEndRadius;
    self.layer.borderWidth = self.btnTimerConfig.layerBorderEndWidth;
}

-(void)setTitleLabelConfigEnd{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = self.btnTimerConfig.countDownBtnNewLineType;
    self.titleLabel.font = self.btnTimerConfig.titleLabelEndFont;
    [self setTitleColor:self.btnTimerConfig.titleEndCor
               forState:UIControlStateNormal];
    [self.titleLabel sizeToFit];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}
#pragma mark —— 设置普通标题或者富文本标题
/// 计时器未开始
-(void)setTitleReadyPlay{
    if (self.btnTimerConfig.titleReadyPlayAttributedDataMutArr.count ||
        self.btnTimerConfig.titleReadyPlayAttributedStr) {
        //富文本
        [self setAttributedTitle:self.btnTimerConfig.titleReadyPlayAttributedStr
                        forState:UIControlStateNormal];
    }else{
        [self setTitle:self.btnTimerConfig.titleReadyPlayStr
              forState:UIControlStateNormal];
    }
}
/// 计时器进行中
-(void)setTitleRunning{
    if (self.btnTimerConfig.titleRunningDataMutArr.count ||
        self.btnTimerConfig.titleRunningAttributedStr) {
        //富文本
        [self setAttributedTitle:self.btnTimerConfig.titleRunningAttributedStr
                        forState:UIControlStateNormal];
    }else{
//        [self setTitle:self.btnTimerConfig.finalTitleStr
//              forState:UIControlStateNormal];
        [self setTitle:self.btnTimerConfig.titleRunningStr
              forState:UIControlStateNormal];
    }
}
/// 计时器结束
-(void)setTitleEnd{
    if (self.btnTimerConfig.titleEndDataMutArr.count ||
        self.btnTimerConfig.titleEndAttributedStr) {
        //富文本
        [self setAttributedTitle:self.btnTimerConfig.titleRunningAttributedStr
                        forState:UIControlStateNormal];
    }else{
        [self setTitle:self.btnTimerConfig.titleEndStr
              forState:UIControlStateNormal];
    }
}
#pragma mark —— 时间方法
//开启倒计时
-(void)startTimer{
    [self timeFailBeginFrom:self.btnTimerConfig.count];
}
//倒计时方法:
-(void)timeFailBeginFrom:(NSInteger)timeCount{
    
    if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {
        self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleReadyPlayStr stringByAppendingString:@"\n"];
        NSLog(@"self.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    }

    [self setTitleReadyPlay];
    [self setLayerConfigReadyPlay];
    [self setTitleLabelConfigReadyPlay];
    self.btnTimerConfig.countDownBtnType = TimerStyle_anticlockwise;
    self.btnTimerConfig.count = timeCount;
    self.enabled = NO;
    
    //启动方式——1
//    [NSTimerManager nsTimeStart:self.nsTimerManager
//                    withRunLoop:nil];
    //启动方式——2
    [self.btnTimerConfig.timerManager nsTimeStartSysAutoInRunLoop];
}

-(void)timerRuning:(long)currentTime {
    //其他一些基础设置
    {
        self.enabled = self.btnTimerConfig.isCanBeClickWhenTimerCycle;//倒计时期间，默认不接受任何的点击事件
        self.backgroundColor = self.btnTimerConfig.bgRunningCor;
    }
    
    //显示数据的二次封装
    {
        // 显示的时间格式
        switch (self.btnTimerConfig.showTimeType) {
            case ShowTimeType_SS:{
                self.btnTimerConfig.formatTimeStr = [NSString stringWithFormat:@"%ld秒",(long)currentTime];
            }break;
            case ShowTimeType_MMSS:{
                self.btnTimerConfig.formatTimeStr = [NSObject getMMSSFromStr:[NSString stringWithFormat:@"%ld",(long)currentTime]];
            }break;
            case ShowTimeType_HHMMSS:{
                self.btnTimerConfig.formatTimeStr = [NSObject getHHMMSSFromStr:[NSString stringWithFormat:@"%ld",(long)currentTime]];
            }break;
            default:
                self.btnTimerConfig.formatTimeStr = @"异常值";
                break;
        }
        //字符串拼接
        switch (self.btnTimerConfig.cequenceForShowTitleRuningStrType) {
            case CequenceForShowTitleRuningStrType_front:{//首在前
                if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine){//提行
                    
                    if (!self.isDataStrMakeNewLine) {
                        self.btnTimerConfig.titleRunningStr = [self.btnTimerConfig.titleRunningStr stringByAppendingString:@"\n"];
                        self.isDataStrMakeNewLine = YES;
                    }
                }
                self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleRunningStr stringByAppendingString:self.btnTimerConfig.formatTimeStr];
            }break;
            case CequenceForShowTitleRuningStrType_tail:{//首在后
                if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {//提行
                    self.btnTimerConfig.formatTimeStr = [self.btnTimerConfig.formatTimeStr stringByAppendingString:@"\n"];//每次都要刷新，所以不必用isDataStrMakeNewLine来进行约束是否加\n
                }
                self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.formatTimeStr stringByAppendingString:self.btnTimerConfig.titleRunningStr];
            }break;
            default:
                self.btnTimerConfig.finalTitleStr = @"异常值";
                break;
        }
    }
    NSLog(@"%@",self.btnTimerConfig.titleRunningStr);
    NSLog(@"%@",self.btnTimerConfig.formatTimeStr);
    NSLog(@"self.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    if(self.btnTimerConfig.titleReadyPlayAttributedDataMutArr.count){
        //富文本 每一次时间触发方法都刷新数据并赋值
        NSMutableArray *tempDataMutArr = NSMutableArray.array;
        RichLabelDataStringsModel *formatTimeModel = RichLabelDataStringsModel.new;
        RichLabelDataStringsModel *titleRuningModel = RichLabelDataStringsModel.new;

        for (int i = 0; i < self.btnTimerConfig.titleReadyPlayAttributedDataMutArr.count; i ++) {
            RichLabelDataStringsModel *richLabelDataStringsModel = self.btnTimerConfig.titleReadyPlayAttributedDataMutArr[i];

            if (i == 0) {
                //修改range
                if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_front) {
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(0, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(0, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(0, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(0, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(0, self.btnTimerConfig.titleRunningStr.length);
                }else if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_tail){
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(0, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(0, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(0, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(0, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(0, self.btnTimerConfig.formatTimeStr.length);
                }else{}
                
                formatTimeModel.dataString = self.btnTimerConfig.formatTimeStr;
                formatTimeModel.richLabelFontModel = richLabelDataStringsModel.richLabelFontModel;
                formatTimeModel.richLabelTextCorModel = richLabelDataStringsModel.richLabelTextCorModel;
                formatTimeModel.richLabelUnderlineModel = richLabelDataStringsModel.richLabelUnderlineModel;
                formatTimeModel.richLabelParagraphStyleModel = richLabelDataStringsModel.richLabelParagraphStyleModel;
                formatTimeModel.richLabelURLModel = richLabelDataStringsModel.richLabelURLModel;
            }
            else if (i == 1){
                
                //修改range
                if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_front) {
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(self.btnTimerConfig.titleRunningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(self.btnTimerConfig.titleRunningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(self.btnTimerConfig.titleRunningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(self.btnTimerConfig.titleRunningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(self.btnTimerConfig.titleRunningStr.length, self.btnTimerConfig.formatTimeStr.length);
                }else if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_tail){
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRunningStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRunningStr.length);
                }else{}
                
                titleRuningModel.dataString = self.btnTimerConfig.titleRunningStr;
                titleRuningModel.richLabelFontModel = richLabelDataStringsModel.richLabelFontModel;
                titleRuningModel.richLabelTextCorModel = richLabelDataStringsModel.richLabelTextCorModel;
                titleRuningModel.richLabelUnderlineModel = richLabelDataStringsModel.richLabelUnderlineModel;
                titleRuningModel.richLabelParagraphStyleModel = richLabelDataStringsModel.richLabelParagraphStyleModel;
                titleRuningModel.richLabelURLModel = richLabelDataStringsModel.richLabelURLModel;
            }else{}
        }
        
        switch (self.btnTimerConfig.cequenceForShowTitleRuningStrType) {
            case CequenceForShowTitleRuningStrType_front:{
                [tempDataMutArr addObject:titleRuningModel];
                [tempDataMutArr addObject:formatTimeModel];
            }break;
            case CequenceForShowTitleRuningStrType_tail:{
                [tempDataMutArr addObject:formatTimeModel];
                [tempDataMutArr addObject:titleRuningModel];
            }break;
            default:
                break;
        }
        self.btnTimerConfig.titleReadyPlayAttributedStr = [NSObject makeRichTextWithDataConfigMutArr:tempDataMutArr];
    }
    [self setTitleRunning];
    [self setLayerConfigRunning];
    [self setTitleLabelConfigRunning];
}

-(void)timerDestroy{
    self.enabled = YES;
    if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {
        self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleEndStr stringByAppendingString:@"\n"];
    }
    NSLog(@"self.btnTimerConfig.titleEndStr = %@",self.btnTimerConfig.titleEndStr);
    NSLog(@"self.btnTimerConfig.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    [self setTitleEnd];
    [self setTitleLabelConfigEnd];
    [self setLayerConfigEnd];
    self.backgroundColor = self.btnTimerConfig.bgEndCor;
    [self.btnTimerConfig.timerManager nsTimeDestroy];
}
#pragma mark —— Block
//点击事件回调，就不要用系统的addTarget/action/forControlEvents
-(void)actionCountDownClickEventBlock:(MKDataBlock _Nullable)countDownClickEventBlock{
    self.countDownClickEventBlock = countDownClickEventBlock;
}
//倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
-(void)actionCountDownBlock:(MKDataBlock _Nullable)countDownBlock{
    self.countDownBlock = countDownBlock;
}
// 定时器运行时的Block
-(void)actionBlockTimerRunning:(MKDataBlock _Nullable)timerRunningBlock{
    self.timerRunningBlock = timerRunningBlock;
}
// 定时器结束时候的Block
-(void)actionBlockTimerFinish:(MKDataBlock _Nullable)timerFinishBlock{
    self.timerFinishBlock = timerFinishBlock;
}
#pragma mark SET | GET
#pragma mark —— @property(nonatomic,strong)ButtonTimerModel *btnTimerConfig;
-(ButtonTimerConfigModel *)btnTimerConfig{
    ButtonTimerConfigModel *BtnTimerConfig = objc_getAssociatedObject(self, UIButton_Timer_btnTimerConfig);
    if (!BtnTimerConfig) {
        BtnTimerConfig = ButtonTimerConfigModel.new;
        // 这里添加默认配置
//        BtnTimerConfig.
        objc_setAssociatedObject(self,
                                 UIButton_Timer_btnTimerConfig,
                                 BtnTimerConfig,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // 定时器运行时的Block
    @weakify(self)
    [BtnTimerConfig actionBlockTimerRunning:^(id data) {
        @strongify(self)
        NSLog(@"data = %@",data);
        if ([data isKindOfClass:NSTimerManager.class]) {
            NSTimerManager *timeManager = (NSTimerManager *)data;
            timeManager.timerStyle = BtnTimerConfig.countDownBtnType;
            [self timerRuning:(long)timeManager.anticlockwiseTime];
        }
        
        if (self.timerRunningBlock) {
            self.timerRunningBlock(data);
        }
    }];
    // 定时器结束时候的Block
    [BtnTimerConfig actionBlockTimerFinish:^(id data) {
        NSLog(@"定时器结束 = %@",data);
        @strongify(self)
        if (self.timerFinishBlock) {
            self.timerFinishBlock(data);
        }
    }];
    return BtnTimerConfig;
}

-(void)setBtnTimerConfig:(ButtonTimerConfigModel *)btnTimerConfig{
    objc_setAssociatedObject(self,
                             UIButton_Timer_btnTimerConfig,
                             btnTimerConfig,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark —— @property(nonatomic,assign)BOOL isDataStrMakeNewLine;//给原始数据只添加一次 \n
-(BOOL)isDataStrMakeNewLine{
    return [objc_getAssociatedObject(self, UIButton_CountDownBtn_isDataStrMakeNewLine) boolValue];;
}

-(void)setIsDataStrMakeNewLine:(BOOL)isDataStrMakeNewLine{
    objc_setAssociatedObject(self,
                             UIButton_CountDownBtn_isDataStrMakeNewLine,
                             [NSNumber numberWithBool:isDataStrMakeNewLine],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark —— @property(nonatomic,copy)MKDataBlock countDownBlock;
-(MKDataBlock)countDownBlock{
    return objc_getAssociatedObject(self, UIButton_CountDownBtn_countDownBlock);
}

-(void)setCountDownBlock:(MKDataBlock)countDownBlock{
    objc_setAssociatedObject(self,
                             UIButton_CountDownBtn_countDownBlock,
                             countDownBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark —— @property(nonatomic,copy)MKDataBlock countDownClickEventBlock;
-(MKDataBlock)countDownClickEventBlock{
    return objc_getAssociatedObject(self, UIButton_CountDownBtn_countDownClickEventBlock);
}

-(void)setCountDownClickEventBlock:(MKDataBlock)countDownClickEventBlock{
    objc_setAssociatedObject(self,
                             UIButton_CountDownBtn_countDownClickEventBlock,
                             countDownClickEventBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark —— @property(nonatomic,copy)MKDataBlock timerRunningBlock;// 定时器运行时的Block
-(MKDataBlock)timerRunningBlock{
    return objc_getAssociatedObject(self, UIButton_CountDownBtn_timerRunningBlock);
}

-(void)setTimerRunningBlock:(MKDataBlock)timerRunningBlock{
    objc_setAssociatedObject(self,
                             UIButton_CountDownBtn_timerRunningBlock,
                             timerRunningBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark —— @property(nonatomic,copy)MKDataBlock timerFinishBlock;// 定时器结束时候的Block
-(MKDataBlock)timerFinishBlock{
    return objc_getAssociatedObject(self, UIButton_CountDownBtn_timerFinishBlock);
}

-(void)setTimerFinishBlock:(MKDataBlock)timerFinishBlock{
    objc_setAssociatedObject(self,
                             UIButton_CountDownBtn_timerFinishBlock,
                             timerFinishBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
