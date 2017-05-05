//
//  LXHorizontalMenu.h
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//  My name is Xiao

#import <UIKit/UIKit.h>

@protocol LXHorizontalMenuDelegate,LXHorizontalMenuDataSource;

/**
 - LXHorizontalMenuTopMenuCommonType: topmenu自适应宽度
 - LXHorizontalMenuTopMenuAverageType: 等宽
 */
typedef NS_ENUM(NSInteger,LXHorizontalTopMenuType){
    LXHorizontalMenuTopMenuCommonType,
    LXHorizontalMenuTopMenuAverageType
};

@interface LXHorizontalMenu : UIView

/**
 剩余item数组
 */
@property (nonatomic,strong) NSMutableArray *restItemArray;

/**
 rootview数组
 */
@property (nonatomic,strong) NSMutableArray *rootMenuItems;

/**
 常规颜色
 */
@property (nonatomic,strong) UIColor *itemLabelNormalColor;

/**
 点击颜色
 */
@property (nonatomic,strong) UIColor *itemLabelSelectColor;

/**
 topmenu背景颜色
 */
@property (nonatomic,strong) UIColor *topMenuBackGoundColor;

/**
 常规字体大小
 */
@property (nonatomic,assign) CGFloat itemLabelNormalFontSize;

/**
 点击字体大小
 */
@property (nonatomic,assign) CGFloat itemLabelSelectFontSize;

/**
 sortbutton image
 */
@property (nonatomic,strong) UIImage *sortButtonImage;
@property (nonatomic,assign) LXHorizontalTopMenuType type;
@property (nonatomic,weak) id<LXHorizontalMenuDataSource>dataSource;
@property (nonatomic,weak) id<LXHorizontalMenuDelegate>delegate;

/**
 唯一初始化方法

 @param frame set frame for menu
 @param showSortMenu weather show sortMenu
 @param currentItemArray current item array
 @param allItemArray all item array
 @param restItemArray rest item array
 @param topMenuHeight top menu height
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame ShowSortMenu:(BOOL)ShowSortMenu currentItemArray:(NSMutableArray *)currentItemArray restItemArray:(NSMutableArray *)restItemArray rootMenuItems:(NSMutableArray *)rootMenuItems topMenuSize:(CGSize)topMenuSize;
@end

/**
 LXHorizontalMenuDataSource
 */
@protocol LXHorizontalMenuDataSource <NSObject>

@required
- (NSInteger)numberOfCurrentItemInHorizontalMenu:(LXHorizontalMenu *)horizontalMenu;
- (NSInteger)numberOfRestItemInHorizontalMenu:(LXHorizontalMenu *)horizontalMenu;
@end
\
/**
 LXHorizontalMenuDelegate
 */
@protocol LXHorizontalMenuDelegate <NSObject>

@optional

- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didSelectButtonWithIndex:(NSInteger)index;
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didDeleteButtonWithIndex:(NSInteger)index;
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didAddButtonWithIndex:(NSInteger)index;
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didmoveButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end
