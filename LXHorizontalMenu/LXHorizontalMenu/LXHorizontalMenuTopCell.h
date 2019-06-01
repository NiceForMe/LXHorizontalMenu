//
//  LXHorizontalMenuTopCell.h
//  LXHorizontalMenu
//
//  Created by HSEDU on 2018/12/4.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LXHorizontalMenuTopCellType){
    LXHorizontalMenuTopCellCommonType,
    LXHorizontalMenuTopCellSelectType
};



@interface LXHorizontalMenuTopCell : UICollectionViewCell
@property (nonatomic,assign) LXHorizontalMenuTopCellType type;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) UIFont *normalFont;
@property (nonatomic,strong) UIFont *selectFont;
@property (nonatomic,strong) UIColor *underLineColor;
@property (nonatomic,strong) UIButton *itemButton;

@end
