//
//  ButtonTimerVC.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "ButtonTimerVC.h"
#import "UIButton+Timer.h"

@interface ButtonTimerVC ()

@property(nonatomic,strong)ButtonTimerConfigModel *btnConfigModel;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation ButtonTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.btn.alpha = 1;
}
/*
 定时器相关方法在btn和其配置文件中均对外表达抛出
 */
#pragma mark —— lazyLoad
-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] initWithConfig:self.btnConfigModel];
        [self.view addSubview:_btn];
        _btn.frame = CGRectMake(100, 100, 100, 50);
        @weakify(self)
        // 点击事件回调
        [_btn actionCountDownClickEventBlock:^(id data) {
            NSLog(@"点击事件回调");
            @strongify(self)
            [self->_btn startTimer];// 可独立。不是说一点击就一定要开始计时，中间可能有业务判断逻辑
        }];
        // 倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
        [_btn actionCountDownBlock:^(id data) {
            NSLog(@"倒计时需要触发调用的方法");
        }];
        // 定时器运行时的Block
        [_btn actionBlockTimerRunning:^(id data) {
            NSLog(@"定时器运行时的Block");
        }];
        // 定时器结束时候的Block
        [_btn actionBlockTimerFinish:^(id data) {
            NSLog(@"定时器结束时候的Block");
        }];
        
    }return _btn;
}

-(ButtonTimerConfigModel *)btnConfigModel{
    if (!_btnConfigModel) {
        _btnConfigModel = ButtonTimerConfigModel.new;
        _btnConfigModel.titleReadyPlayStr = @"开始";//✅
        _btnConfigModel.titleReadyPlayCor = UIColor.orangeColor;//✅
        _btnConfigModel.layerBorderReadyPlayCor = UIColor.greenColor;//✅
        _btnConfigModel.titleLabelReadyPlayFont = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];//✅
        _btnConfigModel.layerCornerReadyPlayRadius = 6;//✅
        _btnConfigModel.layerBorderReadyPlayWidth = 1.f;//✅
        _btnConfigModel.titleRunningStr = @"倒计时中";//✅
        _btnConfigModel.titleEndStr = @"倒计时完";
        _btnConfigModel.bgRunningCor = UIColor.lightGrayColor;//✅
        _btnConfigModel.bgEndCor = UIColor.blueColor;
        _btnConfigModel.count = 10;//✅
        _btnConfigModel.showTimeType = ShowTimeType_SS;//✅
        _btnConfigModel.countDownBtnType = TimerStyle_anticlockwise;
        _btnConfigModel.countDownBtnNewLineType = CountDownBtnNewLineType_normal;//✅
        _btnConfigModel.cequenceForShowTitleRuningStrType = CequenceForShowTitleRuningStrType_front;//✅
        _btnConfigModel.isCanBeClickWhenTimerCycle = YES;
//        _btnConfigModel.attributedString;
//        _btnConfigModel.richTextRunningDataMutArr;
        
        // 定时器运行时的Block
        [_btnConfigModel actionBlockTimerRunning:^(id data) {
//            NSLog(@"data = %@",data);
        }];
        // 定时器结束时候的Block
        [_btnConfigModel actionBlockTimerFinish:^(id data) {
//            NSLog(@"死了 = %@",data);
        }];
        
    }return _btnConfigModel;
}

@end
