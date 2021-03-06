//
//  MKRankTBVCell.m
//  MonkeyKingVideo
//
//  Created by Jobs on 2021/1/20.
//  Copyright © 2021 MonkeyKingVideo. All rights reserved.
//

#import "MKRankTBVCell.h"

@interface MKRankTBVCell ()
// UI
@property(nonatomic,strong)UIImageView *userHeaderIMGV;

@end

@implementation MKRankTBVCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    MKRankTBVCell *cell = (MKRankTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[MKRankTBVCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:ReuseIdentifier];
//        [UIView cornerCutToCircleWithView:cell andCornerRadius:6];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    _userHeaderIMGV.callbackBlock;
//    _userHeaderIMGV.tapGR;
    
    NSLog(@"%@",_userHeaderIMGV.callbackBlock);
    NSLog(@"%@",_userHeaderIMGV.tapGR);
}

-(void)richElementsInCellWithModel:(id _Nullable)model{
    self.userHeaderIMGV.alpha = 1;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return KHeight(80);
}
#pragma mark —— lazyLoad
-(UIImageView *)userHeaderIMGV{
    if (!_userHeaderIMGV) {
        _userHeaderIMGV = UIImageView.new;
        _userHeaderIMGV.image = [UIImage imageNamed:@"替代头像"];
        [self.contentView addSubview:_userHeaderIMGV];
        [_userHeaderIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(45.5, 45.5));
            make.left.equalTo(self.contentView).offset(KWidth(10));
        }];
        [UIView cornerCutToCircleWithView:_userHeaderIMGV
                          andCornerRadius:45.5 / 2];
        [UIView colourToLayerOfView:_userHeaderIMGV
                         withColour:UIColor.redColor
                     andBorderWidth:0.5];
        {// A
            _userHeaderIMGV.userInteractionEnabled = YES;
            _userHeaderIMGV.target = self;
//            _userHeaderIMGV.tapGRSEL = NSStringFromSelector(@selector(skipToSingeUserCenter));
            _userHeaderIMGV.callbackBlock = ^(id weakSelf,
                                              id arg,
                                              UIGestureRecognizer *data3) {
                NSLog(@"成功点击");
            };
            NSLog(@"KK = %@",_userHeaderIMGV.callbackBlock);
            _userHeaderIMGV.numberOfTouchesRequired = 1;
            _userHeaderIMGV.numberOfTapsRequired = 1;
            _userHeaderIMGV.tapGR.enabled = YES;
        }
    }return _userHeaderIMGV;
}

@end
