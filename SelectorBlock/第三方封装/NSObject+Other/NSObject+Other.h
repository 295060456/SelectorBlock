//
//  NSObject+Other.h
//  SelectorBlock
//
//  Created by Jobs on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Other)
/**
*  判断对象 / 数组是否为空
*  为空返回 YES
*  不为空返回 NO
*/
+(BOOL)isNullString:(NSString *)string;
/**
 切角
 
 @param view TargetView
 @param cornerRadiusValue 切角参数
 */
+(void)cornerCutToCircleWithView:(UIView *__nonnull)view
                 andCornerRadius:(CGFloat)cornerRadiusValue;
/**
 描边
 
 @param view TargetView
 @param colour 颜色
 @param WidthOfBorder 边线宽度
 */
+(void)colourToLayerOfView:(UIView *__nonnull)view
                withColour:(UIColor *__nonnull)colour
            andBorderWidth:(CGFloat)WidthOfBorder;

@end

NS_ASSUME_NONNULL_END
