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
        {
            self.layer.borderColor = config.layerBorderColor.CGColor;
            self.layer.cornerRadius = config.layerCornerRadius;
            self.layer.borderWidth = config.layerBorderWidth;
        }
        
        if (config.countDownBtnNewLineType) {
            self.titleLabel.numberOfLines = 0;
        }
        
        if (config.countDownBtnType) {
            if (!config.isCountDownClockOpen) {
                switch (config.countDownBtnNewLineType) {
                    case CountDownBtnNewLineType_normal:{
                        if (config.isCountDown) {
                            [self setTitle:config.titleRuningStr
                                  forState:UIControlStateNormal];
                        }else{
                            [self setTitle:config.titleBeginStr
                                  forState:UIControlStateNormal];
                        }
                    }break;
                    case CountDownBtnNewLineType_newLine:{
                        config.finalTitleStr = [config.titleBeginStr stringByAppendingString:@"\n"];
                        NSLog(@"self.finalTitleStr = %@",config.finalTitleStr);
                        [self setTitleOrAttributedTitle];
                    }break;
                        
                    default:
                        break;
                }
            }
        }
        
        {
            if (config.richTextRunningDataMutArr.count) {
                config.attributedString = [NSObject makeRichTextWithDataConfigMutArr:config.richTextRunningDataMutArr];
                [self setAttributedTitle:config.attributedString
                                forState:UIControlStateNormal];
            }else{
                [self setTitle:config.titleBeginStr
                      forState:UIControlStateNormal];
            }
            
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = config.titleLabelFont;
            [self setTitleColor:config.titleColor
                       forState:UIControlStateNormal];
            [self.titleLabel sizeToFit];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        // CountDownBtn 的点击事件回调
        @weakify(self)
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self)
            if (self.countDownClickEventBlock) {
                self.countDownClickEventBlock(self);
            }
        }];
        // 通过外界的判断条件以后，方可执行倒计时操作
//        @weakify(config)
//        self.allowCountdownBlock = ^(NSNumber *data){
//            @strongify(self)
//            @strongify(config)
//            if (data.boolValue) {
//                if ((config.isCountDownClockFinished && config.btnRunType == CountDownBtnRunType_auto) ||//自启动模式
//                    config.btnRunType == CountDownBtnRunType_manual) {//手动启动模式
//                    config.isCountDownClockFinished = NO;
//                    config.isCountDownClockOpen = NO;
//
//                    [self timeFailBeginFrom:config.count];//根据需求来
//                }
//            }
//        };
        
    }return self;
}
#pragma clang diagnostic pop
/// 设置普通标题或者富文本标题
-(void)setTitleOrAttributedTitle{
    if (self.btnTimerConfig.richTextRunningDataMutArr.count) {
        //富文本
        [self setAttributedTitle:self.btnTimerConfig.attributedString
                        forState:UIControlStateNormal];
    }else{
        [self setTitle:self.btnTimerConfig.finalTitleStr
              forState:UIControlStateNormal];
    }
}
//开启倒计时
-(void)startTimer{
    [self timeFailBeginFrom:self.btnTimerConfig.count];
}
//倒计时方法:
- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {
        self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleBeginStr stringByAppendingString:@"\n"];
        NSLog(@"self.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    }

    [self setTitleOrAttributedTitle];
    
    self.btnTimerConfig.countDownBtnType = CountDownBtnType_countDown;
    self.btnTimerConfig.count = timeCount;
    self.enabled = NO;
    
    //启动方式——1
//    [NSTimerManager nsTimeStart:self.nsTimerManager
//                    withRunLoop:nil];
    //启动方式——2
    [self.btnTimerConfig.timerManager nsTimeStartSysAutoInRunLoop];
}
//？？？？？？？？？？？？？？？？
- (void)timerRuning:(long)currentTime {
    //其他一些基础设置
    {
        self.enabled = self.btnTimerConfig.isCanBeClickWhenTimerCycle;//倒计时期间，默认不接受任何的点击事件
        self.backgroundColor = self.btnTimerConfig.bgCountDownColor;
    }
    
    //显示数据的二次封装
    {
        // 显示的时间格式
        switch (self.btnTimerConfig.showTimeType) {
            case ShowTimeType_SS:{
                self.btnTimerConfig.formatTimeStr = [NSString stringWithFormat:@"%ld秒",(long)currentTime];
            }break;
            case ShowTimeType_MMSS:{
                self.btnTimerConfig.formatTimeStr = [[NSString stringWithFormat:@"%ld",(long)currentTime] getMMSS];
            }break;
            case ShowTimeType_HHMMSS:{
                self.btnTimerConfig.formatTimeStr = [[NSString stringWithFormat:@"%ld",(long)currentTime] getHHMMSS];
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
                        self.btnTimerConfig.titleRuningStr = [self.btnTimerConfig.titleRuningStr stringByAppendingString:@"\n"];
                        self.isDataStrMakeNewLine = YES;
                    }
                }
                self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleRuningStr stringByAppendingString:self.btnTimerConfig.formatTimeStr];
            }break;
            case CequenceForShowTitleRuningStrType_tail:{//首在后
                if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {//提行
                    self.btnTimerConfig.formatTimeStr = [self.btnTimerConfig.formatTimeStr stringByAppendingString:@"\n"];//每次都要刷新，所以不必用isDataStrMakeNewLine来进行约束是否加\n
                }
                self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.formatTimeStr stringByAppendingString:self.btnTimerConfig.titleRuningStr];
            }break;
            default:
                self.btnTimerConfig.finalTitleStr = @"异常值";
                break;
        }
    }
    NSLog(@"%@",self.btnTimerConfig.titleRuningStr);
    NSLog(@"%@",self.btnTimerConfig.formatTimeStr);
    NSLog(@"self.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    if(self.btnTimerConfig.richTextRunningDataMutArr.count){
        //富文本 每一次时间触发方法都刷新数据并赋值
        NSMutableArray *tempDataMutArr = NSMutableArray.array;
        RichLabelDataStringsModel *formatTimeModel = RichLabelDataStringsModel.new;
        RichLabelDataStringsModel *titleRuningModel = RichLabelDataStringsModel.new;

        for (int i = 0; i < self.btnTimerConfig.richTextRunningDataMutArr.count; i ++) {
            RichLabelDataStringsModel *richLabelDataStringsModel = self.btnTimerConfig.richTextRunningDataMutArr[i];

            if (i == 0) {
                //修改range
                if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_front) {
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(0, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(0, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(0, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(0, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(0, self.btnTimerConfig.titleRuningStr.length);
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
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(self.btnTimerConfig.titleRuningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(self.btnTimerConfig.titleRuningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(self.btnTimerConfig.titleRuningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(self.btnTimerConfig.titleRuningStr.length, self.btnTimerConfig.formatTimeStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(self.btnTimerConfig.titleRuningStr.length, self.btnTimerConfig.formatTimeStr.length);
                }else if (self.btnTimerConfig.cequenceForShowTitleRuningStrType == CequenceForShowTitleRuningStrType_tail){
                    richLabelDataStringsModel.richLabelFontModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelTextCorModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelUnderlineModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelParagraphStyleModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRuningStr.length);
                    richLabelDataStringsModel.richLabelURLModel.range = NSMakeRange(self.btnTimerConfig.formatTimeStr.length, self.btnTimerConfig.titleRuningStr.length);
                }else{}
                
                titleRuningModel.dataString = self.btnTimerConfig.titleRuningStr;
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
        self.btnTimerConfig.attributedString = [NSObject makeRichTextWithDataConfigMutArr:tempDataMutArr];
    }
    [self setTitleOrAttributedTitle];
}

-(void)timerDestroy{
    self.enabled = YES;
    self.btnTimerConfig.isCountDownClockFinished = YES;
    if (self.btnTimerConfig.countDownBtnNewLineType == CountDownBtnNewLineType_newLine) {
        self.btnTimerConfig.finalTitleStr = [self.btnTimerConfig.titleEndStr stringByAppendingString:@"\n"];
    }
    NSLog(@"self.btnTimerConfig.titleEndStr = %@",self.btnTimerConfig.titleEndStr);
    NSLog(@"self.btnTimerConfig.finalTitleStr = %@",self.btnTimerConfig.finalTitleStr);
    [self setTitleOrAttributedTitle];
    self.backgroundColor = self.btnTimerConfig.bgEndColor;
    [self.btnTimerConfig.timerManager nsTimeDestroy];
}
//点击事件回调，就不要用系统的addTarget/action/forControlEvents
-(void)actionCountDownClickEventBlock:(MKDataBlock _Nullable)countDownClickEventBlock{
    self.countDownClickEventBlock = countDownClickEventBlock;
}
//倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
-(void)actionCountDownBlock:(MKDataBlock _Nullable)countDownBlock{
    self.countDownBlock = countDownBlock;
}
// 定时器运行时的Block
-(void)actionBlockTimerRunning:(MKDataBlock)timerRunningBlock{
    self.timerRunningBlock = timerRunningBlock;
}
// 定时器结束时候的Block
-(void)actionBlockTimerFinish:(MKDataBlock)timerFinishBlock{
    self.timerFinishBlock = timerFinishBlock;
}
#pragma mark SET | GET
#pragma mark —— @property(nonatomic,strong)ButtonTimerModel *btnTimerConfig;
-(ButtonTimerConfigModel *)btnTimerConfig{
    ButtonTimerConfigModel *BtnTimerConfig = objc_getAssociatedObject(self, UIButton_Timer_btnTimerConfig);
    if (!BtnTimerConfig) {
        BtnTimerConfig = ButtonTimerConfigModel.new;
        // 这里添加默认配置
        objc_setAssociatedObject(self,
                                 UIButton_Timer_btnTimerConfig,
                                 BtnTimerConfig,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // 定时器运行时的Block
    [BtnTimerConfig actionBlockTimerRunning:^(id data) {
        NSLog(@"data = %@",data);
        if (self.timerRunningBlock) {
            self.timerRunningBlock(data);
        }
    }];
    // 定时器结束时候的Block
    [BtnTimerConfig actionBlockTimerFinish:^(id data) {
        NSLog(@"死了 = %@",data);
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
