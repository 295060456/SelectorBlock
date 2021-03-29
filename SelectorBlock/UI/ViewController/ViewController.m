//
//  ViewController.m
//  SelectorBlock
//
//  Created by Jobs on 2021/2/18.
//

#import "ViewController.h"

@interface ViewController ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    self.tableView.alpha = 1;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches
//          withEvent:(UIEvent *)event{
//    NSLog(@"%@",self.navigationController);
//    [self comingToVC:CheckMemFreeVC.new];
//}

// NSInvocation的使用，方法多参数传递
-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    
    [self comingToVC:ButtonTimerVC.new];
    
    NSString *arg1 = @"a";
    NSString *arg2 = @"b";
    NSString *arg3 = @"c";
    MKDataBlock arg4 = ^(id data){
        NSLog(@"嗯，不错");
    };
    
    NSArray *paramarrays = @[arg1,
                             arg2,
                             arg3,
                             arg4];
    
    [NSObject methodName:@"test:withArg2:andArg3:block:"
                  target:self
             paramarrays:paramarrays];
    
//    [self methodName:@"test:withArg2:andArg3:block:"
//              target:self
//         paramarrays:paramarrays];
}
/// NSInvocation的使用，方法多参数传递
/// @param methodName 方法名
/// @param target 靶点，方法在哪里
/// @param paramarrays 参数数组
-(void)methodName:(NSString *)methodName
           target:(id _Nonnull)target
      paramarrays:(NSArray *)paramarrays{
    SEL selector = NSSelectorFromString(methodName);
    /*
     NSMethodSignature有两个常用的只读属性
     a. numberOfArguments:方法参数的个数
     b. methodReturnLength:方法返回值类型的长度，大于0表示有返回值
     **/
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    //或使用下面这种方式
    //NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    //只能使用该方法来创建，不能使用alloc init
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    /*
     注意:
     1、下标从2开始，因为0、1已经被target与selector占用
     2、设置参数，必须传递参数的地址，不能直接传值
     **/
    for (int i = 2; i < paramarrays.count + 2; i++) {
        NSLog(@"i = %d",i);
        id d = paramarrays[i - 2];
        [invocation setArgument:&d atIndex:i];
    }
    // 执行方法
    [invocation invoke];
    //可以在invoke方法前添加，也可以在invoke方法后添加
    //通过方法签名的methodReturnLength判断是否有返回值
    if (signature.methodReturnLength > 0) {
        NSString *result = nil;
        [invocation getReturnValue:&result];
        NSLog(@"result = %@",result);
    }
}

- (NSString *)test:(NSString *)arg1
          withArg2:(NSString *)arg2
           andArg3:(NSString *)arg3
             block:(MKDataBlock)block{
    NSLog(@"%@---%@---%@", arg1, arg2, arg3);
    if (block) {
        block(@"嗯！！");
    }
    return @"gaga";
}
/// 最基本的方法
-(void)baseMethod{//
    NSString *methodNameStr = @"test:withArg2:andArg3:block:";
    SEL selector = NSSelectorFromString(methodNameStr);
    /*
     NSMethodSignature有两个常用的只读属性
     a. numberOfArguments:方法参数的个数
     b. methodReturnLength:方法返回值类型的长度，大于0表示有返回值
     **/
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    //或使用下面这种方式
    //NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];

    //只能使用该方法来创建，不能使用alloc init
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;

    NSString *arg1 = @"a";
    NSString *arg2 = @"b";
    NSString *arg3 = @"c";

    MKDataBlock block = ^(id data){
        NSLog(@"嗯，不错");
    };

    MKDataBlock arg4 = block;
    /*
     注意:
     1、下标从2开始，因为0、1已经被target与selector占用
     2、设置参数，必须传递参数的地址，不能直接传值
     **/
    [invocation setArgument:&arg1 atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    [invocation setArgument:&arg3 atIndex:4];
    [invocation setArgument:&arg4 atIndex:5];
    // 执行方法
    [invocation invoke];

    //可以在invoke方法前添加，也可以在invoke方法后添加
    //通过方法签名的methodReturnLength判断是否有返回值
    if (signature.methodReturnLength > 0) {
        NSString *result = nil;
        [invocation getReturnValue:&result];
        NSLog(@"result = %@",result);
    }
}
#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MKRankTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MKRankTBVCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKRankTBVCell *tableViewCell = [MKRankTBVCell cellWithTableView:tableView];
    return tableViewCell;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.backgroundColor = UIColor.lightGrayColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationBarAndStatusBarHeight(nil));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo([MKRankTBVCell cellHeightWithModel:nil]);
        }];

    }return _tableView;
}

@end
