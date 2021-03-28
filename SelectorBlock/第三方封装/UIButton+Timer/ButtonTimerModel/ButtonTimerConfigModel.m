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
@synthesize count = _count;

// 定时器运行时的Block
-(void)actionBlockTimerRunning:(MKDataBlock)timerRunningBlock{
    self.timerRunningBlock = timerRunningBlock;
}
// 定时器结束时候的Block
-(void)actionBlockTimerFinish:(MKDataBlock)timerFinishBlock{
    self.timerFinishBlock = timerFinishBlock;
}
#pragma mark —— 重写set方法
-(void)setCountDownBtnType:(TimerStyle)countDownBtnType{
    _countDownBtnType = countDownBtnType;
    _timerManager.timerStyle = _countDownBtnType;
}

-(void)setCount:(long)count{
    _count = count;
    _timerManager.anticlockwiseTime = _count;//逆时针模式（倒计时）的顶点时间
}
#pragma mark —— lazyLoad
-(NSTimerManager *)timerManager{
    if (!_timerManager) {
        _timerManager = NSTimerManager.new;
        _timerManager.timerStyle = self.countDownBtnType;//逆时针模式（倒计时模式）
        if (self.countDownBtnType == TimerStyle_anticlockwise) {
            _timerManager.anticlockwiseTime = self.count;//逆时针模式（倒计时）的顶点时间
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

-(long)count{
    if (!_count) {
        _count = 5;
    }return _count;
}
/// 计时器未开始
-(NSAttributedString *)titleReadyPlayAttributedStr{
    if (!_titleReadyPlayAttributedStr) {
        _titleReadyPlayAttributedStr = self.titleReadyPlayAttributedDataMutArr.count ? [NSObject makeRichTextWithDataConfigMutArr:self.titleReadyPlayAttributedDataMutArr] : nil;
    }return _titleReadyPlayAttributedStr;
}

-(NSMutableArray<RichLabelDataStringsModel *> *)titleReadyPlayAttributedDataMutArr{
    if (!_titleReadyPlayAttributedDataMutArr) {
        _titleReadyPlayAttributedDataMutArr = NSMutableArray.array;
    }return _titleReadyPlayAttributedDataMutArr;
}
/// 计时器进行中
-(NSAttributedString *)titleRunningAttributedStr{
    if (!_titleRunningAttributedStr) {
        _titleRunningAttributedStr = self.titleRunningDataMutArr.count ? [NSObject makeRichTextWithDataConfigMutArr:self.titleRunningDataMutArr] : nil;
    }return _titleRunningAttributedStr;
}

-(NSMutableArray<RichLabelDataStringsModel *> *)titleRunningDataMutArr{
    if (!_titleRunningDataMutArr) {
        _titleRunningDataMutArr = NSMutableArray.array;
    }return _titleRunningDataMutArr;
}
/// 计时器结束
-(NSAttributedString *)titleEndAttributedStr{
    if (!_titleEndAttributedStr) {
        _titleEndAttributedStr = self.titleEndDataMutArr.count ? [NSObject makeRichTextWithDataConfigMutArr:self.titleEndDataMutArr] : nil;
    }return _titleEndAttributedStr;
}

-(NSMutableArray<RichLabelDataStringsModel *> *)titleEndDataMutArr{
    if (!_titleEndDataMutArr) {
        _titleEndDataMutArr = NSMutableArray.array;
    }return _titleEndDataMutArr;
}
/// 默认值
/// 计时器未开始
-(UIColor *)layerBorderReadyPlayCor{
    if (!_layerBorderReadyPlayCor) {
        _layerBorderReadyPlayCor = UIColor.clearColor;
    }return _layerBorderReadyPlayCor;
}

-(UIColor *)titleReadyPlayCor{
    if (!_titleReadyPlayCor) {
        _titleReadyPlayCor = UIColor.clearColor;
    }return _titleReadyPlayCor;
}

-(UIFont *)titleLabelReadyPlayFont{
    if (!_titleLabelReadyPlayFont) {
        _titleLabelReadyPlayFont = [UIFont systemFontOfSize:5 weight:UIFontWeightRegular];
    }return _titleLabelReadyPlayFont;
}

-(UIColor *)bgReadyPlayCor{
    if (!_bgReadyPlayCor) {
        _bgReadyPlayCor = UIColor.clearColor;
    }return _bgReadyPlayCor;
}

-(CGFloat)layerCornerReadyPlayRadius{
    if (!_layerCornerReadyPlayRadius) {
        _layerCornerReadyPlayRadius = 6.f;
    }return _layerCornerReadyPlayRadius;
}

-(CGFloat)layerBorderReadyPlayWidth{
    if (!_layerBorderReadyPlayWidth) {
        _layerBorderReadyPlayWidth = 0.5f;
    }return _layerBorderReadyPlayWidth;
}
/// 计时器进行中
-(UIColor *)layerBorderRunningCor{
    if (!_layerBorderRunningCor) {
        _layerBorderRunningCor = UIColor.clearColor;
    }return _layerBorderRunningCor;
}

-(UIColor *)titleRunningCor{
    if (!_titleRunningCor) {
        _titleRunningCor = UIColor.clearColor;
    }return _titleRunningCor;
}

-(UIFont *)titleLabelRunningFont{
    if (!_titleLabelRunningFont) {
        _titleLabelRunningFont = [UIFont systemFontOfSize:5 weight:UIFontWeightRegular];
    }return _titleLabelRunningFont;
}

-(UIColor *)bgRunningCor{
    if (!_bgRunningCor) {
        _bgRunningCor = UIColor.clearColor;
    }return _bgRunningCor;
}

-(CGFloat)layerBorderRunningWidth{
    if (!_layerBorderRunningWidth) {
        _layerBorderRunningWidth = .5f;
    }return _layerBorderRunningWidth;
}

-(CGFloat)layerCornerRunningRadius{
    if (!_layerCornerRunningRadius) {
        _layerCornerRunningRadius = 6.f;
    }return _layerCornerRunningRadius;
}
/// 计时器结束
-(UIColor *)layerBorderEndCor{
    if (!_layerBorderEndCor) {
        _layerBorderEndCor = UIColor.clearColor;
    }return _layerBorderEndCor;
}

-(UIColor *)bgEndCor{
    if (!_bgEndCor) {
        _bgEndCor = UIColor.clearColor;
    }return _bgEndCor;
}

-(UIColor *)titleEndCor{
    if (!_titleEndCor) {
        _titleEndCor = UIColor.clearColor;
    }return _titleEndCor;
}

-(UIFont *)titleLabelEndFont{
    if (!_titleLabelEndFont) {
        _titleLabelEndFont = [UIFont systemFontOfSize:5 weight:UIFontWeightRegular];
    }return _titleLabelEndFont;
}

-(CGFloat)layerCornerEndRadius{
    if (!_layerCornerEndRadius) {
        _layerCornerEndRadius = 6.f;
    }return _layerCornerEndRadius;
}

-(CGFloat)layerBorderEndWidth{
    if (!_layerBorderEndWidth) {
        _layerBorderEndWidth = .5f;
    }return _layerBorderEndWidth;
}

@end
