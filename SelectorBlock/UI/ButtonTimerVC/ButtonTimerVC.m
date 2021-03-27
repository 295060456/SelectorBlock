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
    self.btn.alpha = 1;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] initWithConfig:self.btnConfigModel];
        [self.view addSubview:_btn];
        _btn.frame = CGRectMake(100, 100, 100, 50);
        //点击事件回调，就不要用系统的addTarget/action/forControlEvents
        @weakify(self)
        [_btn actionCountDownClickEventBlock:^(id data) {
            NSLog(@"");
            @strongify(self)
            [self->_btn startTimer];// 可独立。不是说一点击就一定要开始计时，中间可能有业务判断逻辑
        }];
        //倒计时需要触发调用的方法：倒计时的时候外面同时干的事，随着定时器走，可以不实现
        [_btn actionCountDownBlock:^(id data) {
            NSLog(@"werty");
        }];
    }return _btn;
}

-(ButtonTimerConfigModel *)btnConfigModel{
    if (!_btnConfigModel) {
        _btnConfigModel = ButtonTimerConfigModel.new;
        _btnConfigModel.titleBeginStr = @"开始";//✅
        _btnConfigModel.titleColor = UIColor.orangeColor;//✅
        _btnConfigModel.layerBorderColor = UIColor.greenColor;//✅
        _btnConfigModel.titleLabelFont = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];//✅
        _btnConfigModel.layerCornerRadius = 6;//✅
        _btnConfigModel.layerBorderWidth = 1.f;//✅
        _btnConfigModel.titleRuningStr = @"倒计时中";
        _btnConfigModel.titleEndStr = @"倒计时完";
        _btnConfigModel.bgCountDownColor = UIColor.lightGrayColor;
        _btnConfigModel.bgEndColor = UIColor.blueColor;
        _btnConfigModel.count = 10;//✅
        _btnConfigModel.showTimeType = ShowTimeType_HHMMSS;
        _btnConfigModel.btnRunType = CountDownBtnRunType_auto;
        _btnConfigModel.countDownBtnType = CountDownBtnType_countDown;
        _btnConfigModel.countDownBtnNewLineType = CountDownBtnNewLineType_normal;
        _btnConfigModel.cequenceForShowTitleRuningStrType = CequenceForShowTitleRuningStrType_tail;
        _btnConfigModel.isCanBeClickWhenTimerCycle = YES;
//        _btnConfigModel.attributedString;
//        _btnConfigModel.richTextRunningDataMutArr;
        
        [_btnConfigModel actionBlockTimerRunning:^(id data) {
            NSLog(@"data = %@",data);
        }];
        
        [_btnConfigModel actionBlockTimerFinish:^(id data) {
            NSLog(@"死了 = %@",data);
        }];
        
    }return _btnConfigModel;
}


@end
