//
//  LXHorizontalMenu.h
//  LXHorizontalMenu
//
//  Created by HSEDU on 2018/12/4.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 顶部collectionview样式

 - LXHorizontalMenuCommonType: 普通样式，根据title给每个cell动态计算宽度
 - LXHorizontalMenuAverageType: 设置的顶部视图宽度处以item个数，等比例展示
 */
typedef NS_ENUM(NSInteger,LXHorizontalMenuType){
    LXHorizontalMenuCommonType,
    LXHorizontalMenuAverageType
};

/**
 顶部collectionview滚动方式

 - LXHorizontalMenuScrollTypeCenter: 当前cell滚动时一直保持居中
 - LXHorizontalMenuScrollTypeNoneAuto: 顶部collectionview不自动滚动
 */
typedef NS_ENUM(NSInteger,LXHorizontalMenuScrollType){
    LXHorizontalMenuScrollTypeCenter,
    LXHorizontalMenuScrollTypeNoneAuto
};


@class LXHorizontalMenu;
@protocol LXHorizontalMenuDataSource <NSObject>

@required
//cell的数量，类似tableview的numberOfRows
- (NSInteger)numberOfItemsWithHorizontalMenu:(LXHorizontalMenu *)horizontalMenu;
//顶部collectionview的title，返回值为字符串
- (NSString *)titleForHorizontalMenuAtIndex:(NSInteger)index horizontalMenu:(LXHorizontalMenu *)horizontalMenu;
//底部视图，类似于tableview的cellForRowAtIndexPath
- (UIView *)viewForHorizontalMenuAtIndex:(NSInteger)index horizontalMenu:(LXHorizontalMenu *)horizontalMenu;

@end

@protocol LXHorizontalMenuDelegate <NSObject>
//滑动、点击第几个cell
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didSelectItemWithIndex:(NSInteger)index;
@end

@interface LXHorizontalMenu : UIView
@property (nonatomic,weak) id<LXHorizontalMenuDataSource>dataSource;
@property (nonatomic,weak) id<LXHorizontalMenuDelegate>delegate;

/**
 type common是自适应宽度，average均分宽短
 */
@property (nonatomic,assign) LXHorizontalMenuType type;

/**
 scrollType 顶部collectionview滚动模式，始终居中或者不自动滚动，如果想要顶部视图不自动滚动要设置为LXHorizontalMenuScrollTypeNoneAuto
 */
@property (nonatomic,assign) LXHorizontalMenuScrollType scrollType;
/**
 是否要自动布局
 */
@property (nonatomic,assign) BOOL needConstraint;

/**
 separatorLineColor 顶部视图bottom分割线颜色，默认灰色
 */
@property (nonatomic,strong) UIColor *separatorLineColor;
/**
 commonTextColor 正常状态下字体颜色，默认黑色
 */
@property (nonatomic,strong) UIColor *normalTextColor;
/**
 selectTextColor 被选择情况下字体颜色，默认红色
 */
@property (nonatomic,strong) UIColor *selectTextColor;
/**
 normalFont 正常状态下字体大小，默认13
 */
@property (nonatomic,strong) UIFont *normalFont;
/**
 selectFont 选择状态下的字体大小
 */
@property (nonatomic,strong) UIFont *selectFont;
/**
 defaultIndex 设置默认第几个tab,默认第1个
 */
@property (nonatomic,assign) NSInteger defaultIndex;
/**
 underLineColor 顶部视图每个cell的下划线颜色，默认黑色
 */
@property (nonatomic,strong) UIColor *underLineColor;
/**
 canScroll 是否可以手动滑动，默认为YES
 */
@property (nonatomic,assign) BOOL canScroll;
/**
 currentIndex 当前处于第几个tab,只读属性
 */
@property (nonatomic,assign,readonly) NSInteger currentIndex;
/**
 唯一初始化方法

 @param frame 可设CGRectZero使用自动布局
 @param topMenuSize 顶部视图的Size,默认值为CGSizeMake(屏幕宽度,50)
 @param type 顶部视图模式枚举
 @return menu
 */
- (instancetype)initWithFrame:(CGRect)frame topMenuSize:(CGSize)topMenuSize type:(LXHorizontalMenuType)type;

/**
 scrollToIndex

 @param index 滑动到某个子视图
 */
- (void)scrollToIndex:(NSInteger)index;

/**
 刷新视图,会调用三个数据源方法
 */
- (void)reloadData;

@end
