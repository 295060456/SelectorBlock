//
//  NSString+TimeFormatConvertFunc.m
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import "NSString+TimeFormatConvertFunc.h"

@implementation NSString (TimeFormatConvertFunc)

//传入 秒  得到 xx:xx:xx
-(NSString *)getHHMMSS{
    NSInteger seconds = self.integerValue;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds / 3600];//format of hour
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds % 3600) / 60];//format of minute
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds % 60];//format of second
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];//format of time
    NSLog(@"format_time : %@",format_time);
    return format_time;
}
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSS{
    NSInteger seconds = self.integerValue;
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds / 60];//format of minute
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds % 60];//format of second
    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];//format of time
    NSLog(@"format_time : %@",format_time);
    return format_time;
}

@end
