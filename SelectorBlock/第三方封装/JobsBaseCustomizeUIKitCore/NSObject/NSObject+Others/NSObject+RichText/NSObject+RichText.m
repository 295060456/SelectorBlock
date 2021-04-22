//
//  UILabel+RichText.m
//  UBallLive
//
//  Created by Jobs on 2020/11/4.
//

#import "NSObject+RichText.h"

@implementation RichLabelDataStringsModel
#pragma mark —— 默认值
-(NSRange)range{
    if (_range.location == 0 &&
        _range.length == 0 &&
        ![NSString isNullString:self.subString] &&
        ![NSString isNullString:self.dataString]) {
        _range = [self.dataString rangeOfString:self.subString];
    }return _range;
}

-(NSString *)urlStr{
    if (!_urlStr) {
        _urlStr = @"www.google.com";
    }return _urlStr;
}

-(NSMutableParagraphStyle *)paragraphStyle{
    if (!_paragraphStyle) {
        _paragraphStyle = NSMutableParagraphStyle.new;
        //行间距
        _paragraphStyle.lineSpacing = 10;
        //段落间距
        _paragraphStyle.paragraphSpacing = 20;
        //对齐方式
        _paragraphStyle.alignment = NSTextAlignmentLeft;
        //指定段落开始的缩进像素
        _paragraphStyle.firstLineHeadIndent = 30;
        //调整全部文字的缩进像素
        _paragraphStyle.headIndent = 10;
    }return _paragraphStyle;
}

@end

@implementation NSObject (RichText)

static char *NSObject_RichText_dataString = "NSObject_RichText_dataString";
@dynamic dataString;

+(NSAttributedString *)makeRichTextWithDataConfigMutArr:(NSArray <RichLabelDataStringsModel *>*_Nonnull)richTextDataConfigMutArr{
    
    NSString *resultString = @"";
    // 先拼接字符串
    for (RichLabelDataStringsModel *model in richTextDataConfigMutArr) {
        if (model.subString) {
            resultString = [resultString stringByAppendingString:model.subString];
        }
    }

    for (RichLabelDataStringsModel *model in richTextDataConfigMutArr) {
        model.dataString = resultString;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:resultString];
    
    for (RichLabelDataStringsModel *richLabelDataStringsModel in richTextDataConfigMutArr) {
        //添加字体 & 设置作用域
        if (richLabelDataStringsModel.font) {
            [attrString addAttribute:NSFontAttributeName
                               value:richLabelDataStringsModel.font
                               range:richLabelDataStringsModel.range];
        }
        //添加文字颜色 & 设置作用域
        if (richLabelDataStringsModel.cor) {
            [attrString addAttribute:NSForegroundColorAttributeName
                               value:richLabelDataStringsModel.cor
                               range:richLabelDataStringsModel.range];
        }
        //添加段落样式 & 设置作用域
        if (richLabelDataStringsModel.paragraphStyle) {
            [attrString addAttribute:NSParagraphStyleAttributeName
                               value:richLabelDataStringsModel.paragraphStyle
                               range:richLabelDataStringsModel.range];
        }
        //添加下划线 & 设置作用域
        [attrString addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInteger:richLabelDataStringsModel.underlineStyle]
                           range:richLabelDataStringsModel.range];
        //添加超链接 & 设置作用域
        [attrString addAttribute:NSLinkAttributeName
                           value:[NSURL URLWithString:richLabelDataStringsModel.urlStr]
                           range:richLabelDataStringsModel.range];
    }
    return attrString;
}
#pragma mark —— @property(nonatomic,strong)NSString *dataString;//总的字符串
-(NSString *)dataString{
    return objc_getAssociatedObject(self, NSObject_RichText_dataString);
}

-(void)setDataString:(NSString *)dataString{
    objc_setAssociatedObject(self,
                             NSObject_RichText_dataString,
                             dataString,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

 //NSFontAttributeName               字号 UIFont 默认12
 //NSParagraphStyleAttributeName     段落样式  NSParagraphStyle
 //NSForegroundColorAttributeName    前景色   UIColor
 //NSBackgroundColorAttributeName    背景色   UIColor
 //NSObliquenessAttributeName        字体倾斜     NSNumber
 //NSExpansionAttributeName          字体加粗     NSNumber  比例 0就是不变 1增加一倍
 //NSKernAttributeName               字间距   CGFloat
 //NSUnderlineStyleAttributeName     下划线     1或0
 //NSUnderlineColorAttributeName     下划线颜色
 //NSStrikethroughStyleAttributeName 删除线   1或0
 //NSStrikethroughColorAttributeName 某种颜色
 //NSStrokeColorAttributeName        same as ForegroundColor
 //NSStrokeWidthAttributeName        CGFloat
 //NSLigatureAttributeName           连笔字  1或0  没看出效果
 //NSShadowAttributeName             阴影    NSShawdow
 //NSTextEffectAttributeName         设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 //NSAttachmentAttributeName         NSTextAttachment  设置文本附件,常用插入图片
 //NSLinkAttributeName               链接  NSURL (preferred) or NSString
 //NSBaselineOffsetAttributeName     基准线偏移   NSNumber
 //NSWritingDirectionAttributeName   文字方向     @[@(1),@(2)]  分别代表不同的文字出现方向等等，我想你一定用不到它 - -
 //NSVerticalGlyphFormAttributeName  水平或者竖直文本  1竖直 0水平 在iOS没卵用，不支持竖版
