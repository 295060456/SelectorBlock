//
//  ButtonTimerVC.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "ButtonTimerVC.h"
#import "NSObject+CallBackInfoByBlock.h"

#import "UIButton+Timer.h"
#import "LoadingImage.h"

#import "UILabel+Gesture.h"

#import "DispatchTimerManager.h"

@interface ButtonTimerVC ()

@property(nonatomic,strong)ButtonTimerConfigModel *btnConfigModel;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *mainIMGV;
@property(nonatomic,strong)DispatchTimerManager *dispatchTimer;

@end

@implementation ButtonTimerVC

-(void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.btn.alpha = 1;
    
    [self primitAttributeStr];
    
    {
        UILabel *lab = UILabel.new;
        lab.frame = CGRectMake(100, 200, 200, 50);
//        lab.backgroundColor = UIColor.orangeColor;
        [self.view addSubview:lab];
        lab.attributedText = self.makeContentLabAttributedText;
        NSLog(@"%@",lab.attributedText);
    }
    
    self.mainIMGV.alpha = 1;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.dispatchTimer invalidate];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    {
//        self.dispatchTimer = [DispatchTimerManager scheduledTimerWithTimeInterval:.5f
//                                                                          repeats:YES
//                                                                            block:^(DispatchTimerManager * _Nonnull timer) {
//            NSLog(@"sde");
//        }];
//    }
//    // 或者
//    {
//        self.dispatchTimer = [[DispatchTimerManager alloc] initWithTimeInterval:3
//                                                                       interval:1
//                                                                         target:self
//                                                                       selector:@selector(demo1:)
//                                                                       userInfo:nil
//                                                                        repeats:YES];
//        [self.dispatchTimer resume];
//    }
    // 亦或者
    {
        self.dispatchTimer = DispatchTimerManager.new;
        self.dispatchTimer.start = 3;
        self.dispatchTimer.timeInterval = 1;
        self.dispatchTimer.target = self;
        self.dispatchTimer.selector = @selector(demo1:);
        self.dispatchTimer.repeats = YES;

        [self.dispatchTimer createDispatchTimer];
        [self.dispatchTimer resume];
    }
}

- (void)demo1:(DispatchTimerManager *)timer {
    NSLog(@"a is");
}

-(void)demo{
    NSLog(@"sde");
}

-(void)primitAttributeStr {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 100)];
    NSMutableAttributedString *attaStr = [[NSMutableAttributedString alloc] initWithString:@"富文本"];
    //下滑线
    NSMutableAttributedString *underlineStr = [[NSMutableAttributedString alloc] initWithString:@"下滑线"];
    [underlineStr addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                  NSUnderlineColorAttributeName: [UIColor redColor]
                                  } range:NSMakeRange(0, 3)];
    [attaStr appendAttributedString:underlineStr];
    //删除线
    NSMutableAttributedString *throughlineStr = [[NSMutableAttributedString alloc] initWithString:@"删除线"];
    [throughlineStr addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                    NSStrikethroughColorAttributeName: [UIColor orangeColor]
                                    } range:NSMakeRange(0, 3)];
    [attaStr appendAttributedString:throughlineStr];
    //超链接
    NSString *urlStr = @"http://www.baidu.com";
    NSMutableAttributedString *linkStr = [[NSMutableAttributedString alloc] initWithString:urlStr];
    [linkStr addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:urlStr]} range:NSMakeRange(0, urlStr.length)];
    [attaStr appendAttributedString:linkStr];
    //图片
//    NSTextAttachment *imgAttach =  [[NSTextAttachment alloc] init];
//    imgAttach.image = [UIImage imageNamed:@"dribbble64_imageio"];
//    imgAttach.bounds = CGRectMake(0, 0, 30, 30);
//    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:imgAttach];
//    [attaStr appendAttributedString:attachStr];
    
    label.attributedText = attaStr;
    NSLog(@"%@",attaStr);
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

-(NSAttributedString *)makeContentLabAttributedText{
    
    NSMutableArray *tempDataMutArr = NSMutableArray.array;
    
    RichTextConfig *config_01 = RichTextConfig.new;
    config_01.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    config_01.cor = UIColor.redColor;
    config_01.targetString = @"我";
    
    RichTextConfig *config_02 = RichTextConfig.new;
    config_02.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    config_02.cor = UIColor.blueColor;
    config_02.targetString = @"爱";
    
    RichTextConfig *config_03 = RichTextConfig.new;
    config_03.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBlack];
    config_03.cor = UIColor.brownColor;
    config_03.targetString = @"北京";
    
    RichTextConfig *config_04 = RichTextConfig.new;
    config_04.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    config_04.cor = UIColor.greenColor;
    config_04.urlStr = @"werejofn";
    config_04.targetString = @"wgoole.cn";

    return [NSObject richTextWithDataConfigMutArr:@[config_01,config_02,config_03,config_04]];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(UIImageView *)mainIMGV{
    if (!_mainIMGV) {
        _mainIMGV = UIImageView.new;

        {// A
            _mainIMGV.userInteractionEnabled = YES;
            _mainIMGV.target = self;
            _mainIMGV.numberOfTouchesRequired = 1;
            _mainIMGV.numberOfTapsRequired = 1;
            _mainIMGV.tapGR.enabled = YES;

            @weakify(self)
            [_mainIMGV actionViewBlock:^(id data) {
                NSLog(@"678976435");
            }];
            
            _mainIMGV.callbackBlock = ^(id weakSelf,
                                        id arg,
                                        UIGestureRecognizer *data3) {
                @strongify(self)
                NSLog(@"678976435");
             };
        }
        
       {// B
           _mainIMGV.userInteractionEnabled = YES;
           _mainIMGV.target = self;
           _mainIMGV.numberOfTouchesRequired = 1;
           _mainIMGV.minimumPressDuration = 1;
           _mainIMGV.longPressGR.enabled = YES;

           @weakify(self)
           _mainIMGV.callbackBlock = ^(id weakSelf,
                                       id arg,
                                       UIGestureRecognizer *data3) {
               @strongify(self)
               NSLog(@"123456");
            };
       }
        _mainIMGV.backgroundColor = UIColor.redColor;
        [self.view addSubview:_mainIMGV];
        [_mainIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.center.equalTo(self.view);
        }];
    }return _mainIMGV;
}

@end
