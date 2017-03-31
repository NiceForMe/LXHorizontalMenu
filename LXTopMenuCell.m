//
//  LXTopMenuCell.m
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "LXTopMenuCell.h"

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
    itemButton.frame = self.contentView.bounds;
}
- (void)setItemLabelSelectColor:(UIColor *)itemLabelSelectColor
{
    _itemLabelSelectColor = itemLabelSelectColor;
//    [self.itemButton setTitleColor:itemLabelSelectColor forState:UIControlStateNormal];
}
- (void)setItemLabelSelectFontSize:(CGFloat)itemLabelSelectFontSize
{
    _itemLabelSelectFontSize = itemLabelSelectFontSize;
//    [self.itemButton.titleLabel setFont:[UIFont systemFontOfSize:itemLabelSelectFontSize]];
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
