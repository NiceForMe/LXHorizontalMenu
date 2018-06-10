//
//  LXTopMenuCell.h
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LXTopMenuCellStateType){
    LXTopMenuCellNormalStateType,
    LXTopMenuCellSelectStateType
};

@interface LXTopMenuCell : UICollectionViewCell
@property (nonatomic,assign) LXTopMenuCellStateType stateType;
@property (nonatomic,strong) UIColor *itemLabelNormalColor;
@property (nonatomic,strong) UIColor *itemLabelSelectColor;
@property (nonatomic,assign) CGFloat itemLabelNormalFontSize;
@property (nonatomic,assign) CGFloat itemLabelSelectFontSize;
@property (nonatomic,strong) UIButton *itemButton;
@property (nonatomic,strong) UIColor *indicatorLineColor;
@property (nonatomic,strong) UIView *indicatorLine;
@end
