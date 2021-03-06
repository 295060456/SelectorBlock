//
//  NSObject+Other.m
//  SelectorBlock
//
//  Created by Jobs on 2021/2/18.
//

#import "NSObject+Other.h"
#import <objc/runtime.h>

@implementation NSObject (Other)

/**
*  判断对象 / 数组是否为空
*  为空返回 YES
*  不为空返回 NO
*/
+(BOOL)isNullString:(NSString *)string{
    if (string == nil ||
        string == NULL ||
        (NSNull *)string == NSNull.null ||
        [string isKindOfClass:NSNull.class] ||
        [string isEqualToString:@"(null)"]||
        [string isEqualToString:@"null"]||
        [string isEqualToString:@"<null>"]) {
        return YES;
    }

    string = StringFormat(@"%@",string);
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉两端的空格
    if (string.length == 0) {
        return YES;
    }return NO;
}
/**
 切角
 
 @param view TargetView
 @param cornerRadiusValue 切角参数
 */
+(void)cornerCutToCircleWithView:(UIView *__nonnull)view
                 andCornerRadius:(CGFloat)cornerRadiusValue{
    view.layer.cornerRadius = cornerRadiusValue;
    view.layer.masksToBounds = YES;
}
/**
 描边
 
 @param view TargetView
 @param colour 颜色
 @param WidthOfBorder 边线宽度
 */
+(void)colourToLayerOfView:(UIView *__nonnull)view
                withColour:(UIColor *__nonnull)colour
            andBorderWidth:(CGFloat)WidthOfBorder{
    view.layer.borderColor = colour.CGColor;
    view.layer.borderWidth = WidthOfBorder;
}

@end
