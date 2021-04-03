//
//  UILabel+RichText.h
//  UBallLive
//
//  Created by Jobs on 2020/11/4.
//

#import <UIKit/UIKit.h>
#import "NSString+Extras.h"

NS_ASSUME_NONNULL_BEGIN

@interface RichLabelDataStringsModel : NSObject
/*
    range 可以直接赋值，也可以根据subString 和 dataString 比较得出
 **/
@property(nonatomic,assign)NSRange range;//作用域
@property(nonatomic,strong)NSString *subString;//作用域子字符串
//
@property(nonatomic,strong)UIFont *font;//添加字体
@property(nonatomic,strong)UIColor *cor;//添加文字颜色
@property(nonatomic,assign)NSUnderlineStyle underlineStyle;//添加下划线
@property(nonatomic,strong)NSMutableParagraphStyle *paragraphStyle;//添加段落样式
@property(nonatomic,strong)NSString *urlStr;//添加超链接

@end

@interface NSObject (RichText)

@property(nonatomic,strong)NSString *dataString;//总的字符串

+(NSAttributedString *)makeRichTextWithDataConfigMutArr:(NSArray <RichLabelDataStringsModel *>*_Nonnull)richTextDataConfigMutArr;

@end

NS_ASSUME_NONNULL_END

/*
 
 示例代码
 
 +(NSAttributedString *)makeContentLabAttributedTextWithModel:(MKRollDataModel *_Nullable)model{
     NSMutableArray *tempDataMutArr = NSMutableArray.array;
     RichLabelDataStringsModel *title_1_Model = RichLabelDataStringsModel.new;
     RichLabelDataStringsModel *title_2_Model = RichLabelDataStringsModel.new;
     RichLabelDataStringsModel *title_3_Model = RichLabelDataStringsModel.new;
     RichLabelDataStringsModel *title_4_Model = RichLabelDataStringsModel.new;
     
     {
         title_1_Model.dataString = @"恭喜";
         
         RichLabelFontModel *richLabelFontModel = RichLabelFontModel.new;
         richLabelFontModel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
         richLabelFontModel.range = NSMakeRange(0, title_1_Model.dataString.length);
         
         RichLabelTextCorModel *richLabelTextCorModel = RichLabelTextCorModel.new;
         richLabelTextCorModel.cor = COLOR_RGB(46, 51, 77);
         richLabelTextCorModel.range = NSMakeRange(0, title_1_Model.dataString.length);
         
         title_1_Model.richLabelFontModel = richLabelFontModel;
         title_1_Model.richLabelTextCorModel = richLabelTextCorModel;
     }
     
     {

         title_2_Model.dataString = [NSString stringWithFormat:@"'%@'",[NSString ensureNonnullString:model.friendName ReplaceStr:@"暂无用户名"]];
         
         RichLabelFontModel *richLabelFontModel = RichLabelFontModel.new;
         richLabelFontModel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
         richLabelFontModel.range = NSMakeRange(title_1_Model.dataString.length, title_2_Model.dataString.length);
         
         RichLabelTextCorModel *richLabelTextCorModel = RichLabelTextCorModel.new;
         richLabelTextCorModel.cor = COLOR_RGB(203, 32, 64);
         richLabelTextCorModel.range = NSMakeRange(title_1_Model.dataString.length, title_2_Model.dataString.length);
         
         
         title_2_Model.richLabelFontModel = richLabelFontModel;
         title_2_Model.richLabelTextCorModel = richLabelTextCorModel;
     }
     
     {

         title_3_Model.dataString = [NSString stringWithFormat:@"在【%@】中中奖",[NSString ensureNonnullString:model.gameName ReplaceStr:@"暂无游戏名"]];
         
         RichLabelFontModel *richLabelFontModel = RichLabelFontModel.new;
         richLabelFontModel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
         richLabelFontModel.range = NSMakeRange(title_1_Model.dataString.length + title_2_Model.dataString.length, title_3_Model.dataString.length);
         
         RichLabelTextCorModel *richLabelTextCorModel = RichLabelTextCorModel.new;
         richLabelTextCorModel.cor = COLOR_RGB(46, 51, 77);
         richLabelTextCorModel.range = NSMakeRange(title_1_Model.dataString.length + title_2_Model.dataString.length, title_3_Model.dataString.length);
         
         
         title_3_Model.richLabelFontModel = richLabelFontModel;
         title_3_Model.richLabelTextCorModel = richLabelTextCorModel;
     }
     
     {
         
         title_4_Model.dataString = [NSString stringWithFormat:@"%@元",[NSString ensureNonnullString:model.winMoney.stringValue ReplaceStr:@"0"]];
         
         RichLabelFontModel *richLabelFontModel = RichLabelFontModel.new;
         richLabelFontModel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
         richLabelFontModel.range = NSMakeRange(title_1_Model.dataString.length + title_2_Model.dataString.length + title_3_Model.dataString.length, title_4_Model.dataString.length);
         
         RichLabelTextCorModel *richLabelTextCorModel = RichLabelTextCorModel.new;
         richLabelTextCorModel.cor = COLOR_RGB(203, 32, 64);
         richLabelTextCorModel.range = NSMakeRange(title_1_Model.dataString.length + title_2_Model.dataString.length + title_3_Model.dataString.length, title_4_Model.dataString.length);
         
         
         title_4_Model.richLabelFontModel = richLabelFontModel;
         title_4_Model.richLabelTextCorModel = richLabelTextCorModel;
     }
     
     [tempDataMutArr addObject:title_1_Model];
     [tempDataMutArr addObject:title_2_Model];
     [tempDataMutArr addObject:title_3_Model];
     [tempDataMutArr addObject:title_4_Model];
     
     return [NSObject makeRichTextWithDataConfigMutArr:tempDataMutArr];
 }
 
 **/

