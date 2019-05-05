//
//  LXHorizontalMenuTopCell.m
//  LXHorizontalMenu
//
//  Created by HSEDU on 2018/12/4.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import "LXHorizontalMenuTopCell.h"
#import "Masonry.h"

@interface LXHorizontalMenuTopCell()
@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,strong) UIView *underLineView;
@end

@implementation LXHorizontalMenuTopCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
    }
    return self;
}
- (void)setType:(LXHorizontalMenuTopCellType)type
{
    _type = type;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    for (UIButton *button in self.contentView.subviews) {
        [button removeFromSuperview];
    }
    UIButton *button = [[UIButton alloc]init];
    self.itemButton = button;
    if (self.type == LXHorizontalMenuTopCellCommonType) {
        button.titleLabel.font = self.normalFont;
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
    }else{
        button.titleLabel.font = self.selectFont;
        [button setTitleColor:self.selectColor forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat btnWidth = [self getWidthWithText:title font:button.titleLabel.font];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    if (self.type == LXHorizontalMenuTopCellSelectType) {
        UIView *underLineView = [[UIView alloc]init];
        self.underLineView = underLineView;
        underLineView.backgroundColor = self.underLineColor;
        [self.contentView addSubview:underLineView];
        [underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(button);
            make.height.mas_equalTo(1.5);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    self.itemWidth = btnWidth;
}

- (UIColor *)underLineColor
{
    if (_underLineColor == nil) {
        _underLineColor = [UIColor blackColor];
    }
    return _underLineColor;
}

- (UIColor *)normalColor
{
    if (_normalColor == nil) {
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}

- (UIColor *)selectColor
{
    if (_selectColor == nil) {
        _selectColor = [UIColor redColor];
    }
    return _selectColor;
}

- (UIFont *)normalFont
{
    if (_normalFont == nil) {
        _normalFont = [UIFont systemFontOfSize:13];
    }
    return _normalFont;
}

- (UIFont *)selectFont
{
    if (_selectFont == nil) {
        _selectFont = [UIFont systemFontOfSize:13];
    }
    return _selectFont;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.width = self.itemWidth + 10;
    layoutAttributes.frame = cellFrame;
    return layoutAttributes;
}

- (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
- (CGFloat)getHeightByWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
@end
