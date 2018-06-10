//
//  LXTopMenuCell.m
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "LXTopMenuCell.h"
#import "Masonry.h"
#import <objc/runtime.h>

@implementation LXTopMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.itemButton setTitleColor:self.itemLabelNormalColor forState:UIControlStateNormal];
    [self.itemButton.titleLabel setFont:[UIFont systemFontOfSize:self.itemLabelNormalFontSize]];
    self.itemButton = itemButton;
}
- (void)setStateType:(LXTopMenuCellStateType)stateType
{
    _stateType = stateType;
    if (self.stateType == LXTopMenuCellNormalStateType) {
        [self.indicatorLine removeFromSuperview];
    }else{
        UIView *indicatorLine = [[UIView alloc]init];
        self.indicatorLine = indicatorLine;
        indicatorLine.backgroundColor = self.indicatorLineColor;
        [self addSubview:indicatorLine];
        [indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).with.offset(0);
//            make.right.equalTo(self.mas_right).with.offset(0);
//            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.right.bottom.equalTo(self.itemButton);
            make.height.mas_equalTo(1);
        }];
    }
}
- (UIColor *)indicatorLineColor
{
    if (!_indicatorLineColor) {
        _indicatorLineColor = [UIColor blackColor];
    }
    return _indicatorLineColor;
}
- (void)setItemLabelSelectColor:(UIColor *)itemLabelSelectColor
{
    _itemLabelSelectColor = itemLabelSelectColor;
}
- (void)setItemLabelSelectFontSize:(CGFloat)itemLabelSelectFontSize
{
    _itemLabelSelectFontSize = itemLabelSelectFontSize;
}
- (void)setItemLabelNormalColor:(UIColor *)itemLabelNormalColor
{
    _itemLabelNormalColor = itemLabelNormalColor;
    [self.itemButton setTitleColor:itemLabelNormalColor forState:UIControlStateNormal];
}
- (void)setItemLabelNormalFontSize:(CGFloat)itemLabelNormalFontSize
{
    _itemLabelNormalFontSize = itemLabelNormalFontSize;
    [self.itemButton.titleLabel setFont:[UIFont systemFontOfSize:itemLabelNormalFontSize]];
}

@end
