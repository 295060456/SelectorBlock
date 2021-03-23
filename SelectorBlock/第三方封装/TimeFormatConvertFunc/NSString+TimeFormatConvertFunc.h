//
//  NSString+TimeFormatConvertFunc.h
//  SelectorBlock
//
//  Created by Jobs on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TimeFormatConvertFunc)

//传入 秒  得到 xx:xx:xx
-(NSString *)getHHMMSS;
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSS;

@end

NS_ASSUME_NONNULL_END
