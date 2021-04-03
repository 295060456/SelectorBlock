//
//  ButtonTimerVC.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "ButtonTimerVC.h"

#import "UIButton+Timer.h"
#import "LoadingImage.h"

#import "UILabel+Gesture.h"

@interface ButtonTimerVC ()

@property(nonatomic,strong)ButtonTimerConfigModel *btnConfigModel;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation ButtonTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.btn.alpha = 1;
    
    {
        UILabel *lab = UILabel.new;
        lab.frame = CGRectMake(100, 200, 200, 50);
        lab.backgroundColor = UIColor.orangeColor;
        [self.view addSubview:lab];
        lab.attributedText = self.makeContentLabAttributedText;
        NSLog(@"");
    }
}

-(NSAttributedString *)makeContentLabAttributedText{
    
    NSMutableArray *tempDataMutArr = NSMutableArray.array;
    
    {
        RichLabelDataStringsModel *title_1_Model = RichLabelDataStringsModel.new;
        title_1_Model.subString = @"我";
        title_1_Model.cor = UIColor.redColor;
        title_1_Model.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        [tempDataMutArr addObject:title_1_Model];
    }
    
    {
        RichLabelDataStringsModel *title_2_Model = RichLabelDataStringsModel.new;
        title_2_Model.subString = @"爱";
        title_2_Model.cor = UIColor.blueColor;
        title_2_Model.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        [tempDataMutArr addObject:title_2_Model];
    }
    
    {
        RichLabelDataStringsModel *title_3_Model = RichLabelDataStringsModel.new;
        title_3_Model.subString = @"北京";
        title_3_Model.cor = UIColor.brownColor;
        title_3_Model.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBlack];
        [tempDataMutArr addObject:title_3_Model];
    }
    
    {
        RichLabelDataStringsModel *title_4_Model = RichLabelDataStringsModel.new;
        title_4_Model.subString = @"天安门";
        title_4_Model.cor = UIColor.greenColor;
        title_4_Model.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
        [tempDataMutArr addObject:title_4_Model];
    }

    return [NSObject makeRichTextWithDataConfigMutArr:tempDataMutArr];
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
#pragma mark —— 计时器未开始
        _btnConfigModel.titleReadyPlayStr = @"  获取验证码   ";//✅
        _btnConfigModel.layerBorderReadyPlayCor = UIColor.whiteColor;
        _btnConfigModel.titleReadyPlayCor = UIColor.whiteColor;;
        _btnConfigModel.titleLabelReadyPlayFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _btnConfigModel.bgReadyPlayCor = [UIColor colorWithPatternImage:KIMG(@"gradualColor")];
        _btnConfigModel.layerCornerReadyPlayRadius = 15;
        _btnConfigModel.layerBorderReadyPlayWidth = .5f;
//#pragma mark —— 计时器进行中
//        _btnConfigModel.layerBorderRunningCor = KLightGrayColor;
//        _btnConfigModel.titleRunningCor = kWhiteColor;
//        _btnConfigModel.titleLabelRunningFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//        _btnConfigModel.bgRunningCor = KLightGrayColor;
//        _btnConfigModel.layerBorderRunningWidth = 15;
//        _btnConfigModel.layerCornerRunningRadius = .5f;
//#pragma mark —— 计时器结束
//        _btnConfigModel.layerBorderEndCor = kWhiteColor;
//        _btnConfigModel.bgEndCor = kWhiteColor;
//        _btnConfigModel.titleEndCor = kWhiteColor;
//        _btnConfigModel.titleLabelEndFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//        _btnConfigModel.layerCornerEndRadius = 15;
//        _btnConfigModel.layerBorderEndWidth = .5f;

    }return _btnConfigModel;
}

@end
