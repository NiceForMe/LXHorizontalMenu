//
//  LXHorizontalMenu.m
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define addButtonWidth 40
#define NormalMargin 10
#define angle2Radian(angle) ((angle) / 180.0 * M_PI)
#define CellShakeNumber 2.5


#import "LXHorizontalMenu.h"
#import "LXTopMenuCell.h"
#import "LXRootMenuCell.h"
#import "LXSortMenuCell.h"
#import "Masonry.h"
#import <objc/runtime.h>


static NSString *topId = @"topId";
static NSString *rootId = @"rootViewIdentifier";
static NSString *sortId = @"sortId";
static NSString *sortHeaderId = @"sortHeaderId";

static NSString *current = @"currentss";
static NSString *root = @"root2";
static NSString *rest = @"rootss";


@interface LXHorizontalMenu ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *topMenu;
@property (nonatomic,strong) UICollectionView *rootMenu;
@property (nonatomic,strong) UICollectionView *sortMenu;
@property (nonatomic,strong) LXTopMenuCell *topMenuCell;
@property (nonatomic,strong) NSMutableArray *currentItemArray;
@property (nonatomic,strong) NSIndexPath *lastIndex;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) UIButton *lastButton;
@property (nonatomic,strong) UIButton *sortMenuButton;
@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) BOOL isSortMenuExist;
@property (nonatomic,assign) CGSize topMenuSize;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIView *separateLine;

@property (nonatomic,strong) NSMutableArray *sCurrentArray;
@property (nonatomic,strong) NSMutableArray *sRestArray;
@property (nonatomic,strong) NSMutableArray *sRootArray;
@end


@implementation LXHorizontalMenu

@synthesize itemLabelNormalFontSize = _itemLabelNormalFontSize;
@synthesize itemLabelNormalColor = _itemLabelNormalColor;
@synthesize itemLabelSelectColor = _itemLabelSelectColor;
@synthesize itemLabelSelectFontSize = _itemLabelSelectFontSize;
@synthesize topMenuBackGoundColor = _topMenuBackGoundColor;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame ShowSortMenu:(BOOL)ShowSortMenu currentItemArray:(NSMutableArray *)currentItemArray restItemArray:(NSMutableArray *)restItemArray rootMenuItems:(NSMutableArray *)rootMenuItems topMenuSize:(CGSize)topMenuSize
{
    if (self = [super initWithFrame:frame]) {
        self.isSortMenuExist = NO;
        self.currentItemArray = currentItemArray;
        self.restItemArray = restItemArray;
        self.rootMenuItems = rootMenuItems;
        self.topMenuSize = topMenuSize;
        self.isFirstLoad = YES;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.topMenu];
        [self addSubview:self.rootMenu];
        if (ShowSortMenu) {
            [self.containerView addSubview:self.sortMenuButton];
            [self addSubview:self.sortMenu];
        }
    }
    return self;
}
#pragma mark - lazy load
- (NSMutableArray *)sCurrentArray
{
    if (!_sCurrentArray) {
        _sCurrentArray = [NSMutableArray array];
    }
    return _sCurrentArray;
}
- (NSMutableArray *)sRestArray
{
    if (!_sRestArray) {
        _sRestArray = [NSMutableArray array];
    }
    return _sRestArray;
}
- (NSMutableArray *)sRootArray
{
    if (!_sRootArray) {
        _sRootArray = [NSMutableArray array];
    }
    return _sRootArray;
}
- (NSMutableArray *)restItemArray
{
    if (!_restItemArray) {
        _restItemArray = [NSMutableArray array];
    }
    return _restItemArray;
}
- (NSMutableArray *)currentItemArray
{
    if (!_currentItemArray) {
        _currentItemArray = [NSMutableArray array];
    }
    return _currentItemArray;
}
- (NSMutableArray *)rootMenuItems
{
    if (!_rootMenuItems) {
        _rootMenuItems = [NSMutableArray array];
    }
    return _rootMenuItems;
}
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.topMenuSize.height);
    }
    return _containerView;
}
- (UIButton *)sortMenuButton
{
    if (!_sortMenuButton) {
        _sortMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortMenuButton.backgroundColor = [UIColor yellowColor];
        [_sortMenuButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        _sortMenuButton.frame = CGRectMake(CGRectGetMaxX(self.topMenu.frame), CGRectGetMinY(self.topMenu.frame), self.containerView.frame.size.width - self.topMenuSize.width, self.topMenuSize.height);
        [_sortMenuButton addTarget:self action:@selector(showSortMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortMenuButton;
}
- (UICollectionView *)topMenu
{
    if (!_topMenu) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.topMenuSize.width, self.topMenuSize.height) collectionViewLayout:layout];
        _topMenu.showsHorizontalScrollIndicator = NO;
        _topMenu.backgroundColor = self.topMenuBackGoundColor;
        _topMenu.dataSource = self;
        _topMenu.delegate = self;
        [_topMenu autoresizesSubviews];
        _topMenu.pagingEnabled = YES;
        [_topMenu reloadData];
    }
    return _topMenu;
}
- (UICollectionView *)rootMenu
{
    if (!_rootMenu) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _rootMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), ScreenWidth, ScreenHeight) collectionViewLayout:layout];
        _rootMenu.showsHorizontalScrollIndicator = YES;
        _rootMenu.bounces = NO;
        _rootMenu.dataSource = self;
        _rootMenu.delegate = self;
        [_rootMenu registerClass:[LXRootMenuCell class] forCellWithReuseIdentifier:rootId];
        [_rootMenu autoresizesSubviews];
        _rootMenu.pagingEnabled = YES;
        [_rootMenu reloadData];
    }
    return _rootMenu;
}
- (UICollectionView *)sortMenu
{
    if (!_sortMenu) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, self.topMenuSize.height);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _sortMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), ScreenWidth, 0) collectionViewLayout:layout];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
        [_sortMenu addGestureRecognizer:longGesture];
        _sortMenu.showsHorizontalScrollIndicator = YES;
        _sortMenu.bounces = NO;
        _sortMenu.dataSource = self;
        _sortMenu.delegate = self;
        [_sortMenu registerClass:[LXSortMenuCell class] forCellWithReuseIdentifier:sortId];
        [_sortMenu registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortHeaderId];
        [_sortMenu autoresizesSubviews];
        _sortMenu.pagingEnabled = YES;
        [_sortMenu reloadData];
    }
    return _sortMenu;
}
#pragma mark - collection datasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.sortMenu) {
        return 2;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.topMenu) {
        return [self.dataSource numberOfCurrentItemInHorizontalMenu:self];
    }else if (collectionView == self.rootMenu){
        return [self.dataSource numberOfCurrentItemInHorizontalMenu:self];
    }else{
        if (section == 0) {
            return [self.dataSource numberOfCurrentItemInHorizontalMenu:self];
        }else{
            return [self.dataSource numberOfRestItemInHorizontalMenu:self];
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.topMenu) {
        NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [_topMenu registerClass:[LXTopMenuCell class] forCellWithReuseIdentifier:identifier];
        LXTopMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.indicatorLineColor = _indicatorLineColor;
        self.topMenuCell = cell;
        if (cell.stateType == LXTopMenuCellSelectStateType) {
            cell.itemLabelNormalColor = _itemLabelSelectColor;
            cell.itemLabelNormalFontSize = _itemLabelSelectFontSize;
        }else{
            if (_itemLabelNormalColor != nil) {
                cell.itemLabelNormalColor = _itemLabelNormalColor;
            }else{
                cell.itemLabelNormalColor = self.itemLabelNormalColor;
            }
            if (_itemLabelNormalFontSize != 0) {
                cell.itemLabelNormalFontSize = _itemLabelNormalFontSize;
            }else{
                cell.itemLabelNormalFontSize = self.itemLabelNormalFontSize;
            }
        }
        [cell.itemButton setTitle:self.currentItemArray[indexPath.row] forState:UIControlStateNormal];
        cell.itemButton.tag = indexPath.row;
        [cell.itemButton addTarget:self action:@selector(showWithButton:) forControlEvents:UIControlEventTouchUpInside];
        CGSize itemSize = [self getWidthWithString:self.currentItemArray[indexPath.row]];
        CGRect itemFrame = cell.itemButton.frame;
        itemFrame = CGRectMake(0, 0, itemSize.width, self.topMenuSize.height);
        if (self.type == LXHorizontalMenuTopMenuCommonType) {
            cell.itemButton.frame = itemFrame;
            [cell.contentView addSubview:cell.itemButton];
        }else{
            [cell.contentView addSubview:cell.itemButton];
            [cell.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.height.equalTo(cell.contentView);
                make.width.mas_equalTo(itemSize.width);
            }];
        }
        if (self.isFirstLoad == YES && indexPath.row == 0) {
            [self showWithButton:cell.itemButton];
            self.isFirstLoad = NO;
        }
        return cell;
    }else if (collectionView == self.rootMenu){
        LXRootMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rootId forIndexPath:indexPath];
        UIView *rootView = self.rootMenuItems[indexPath.row];
        rootView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:rootView];
        return cell;
    }
    LXSortMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sortId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.currentItemArray.count > indexPath.row) {
            cell.itemLable.text = self.currentItemArray[indexPath.row];
        }
    }else{
        if (self.restItemArray.count > indexPath.row) {
            cell.itemLable.text = self.restItemArray[indexPath.row];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sortHeaderId forIndexPath:indexPath];
    if (collectionView == self.sortMenu) {
        for (UILabel *lableView in view.subviews) {
            if ([lableView isKindOfClass:[UILabel class]]) {
                [lableView removeFromSuperview];
            }
        }
        view.backgroundColor = [UIColor lightGrayColor];
        UILabel *headerLable = [[UILabel alloc]init];
        headerLable.frame = CGRectMake(NormalMargin, 0, ScreenWidth - 2 * NormalMargin, 50);
        if (indexPath.section == 0) {
            headerLable.text = @"常用频道(长按可拖动调整频道顺序，点击删除)";
        }else if (indexPath.section == 1){
            headerLable.text = @"所有频道(点击添加您感兴趣的频道)";
        }
        [view addSubview:headerLable];
    }
    return view;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.sortMenu) {
        if (indexPath.section == 0) {
            if (self.currentItemArray.count == 1) {
                return;
            }
            NSInteger index = indexPath.row;
            if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenu:didDeleteButtonWithIndex:)]) {
                [self.delegate horizontalMenu:self didDeleteButtonWithIndex:index];
            }
            [self.rootMenuItems removeObjectAtIndex:index];
            [self.sortMenu reloadData];
            [self.topMenu reloadData];
            [self.rootMenu reloadData];
        }else{
            NSInteger index = indexPath.row;
            if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenu:didAddButtonWithIndex:)]) {
                [self.delegate horizontalMenu:self didAddButtonWithIndex:index];
            }
            [self.sortMenu reloadData];
            [self.topMenu reloadData];
            [self.rootMenu reloadData];
        }
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (collectionView == self.sortMenu) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenu:didmoveButtonFromIndex:toIndex:)]) {
            [self.delegate horizontalMenu:self didmoveButtonFromIndex:sourceIndexPath.item toIndex:destinationIndexPath.item];
        }
        //root
        id rootObj = [self.rootMenuItems objectAtIndex:sourceIndexPath.item];
        [self.rootMenuItems removeObject:rootObj];
        [self.rootMenuItems insertObject:rootObj atIndex:destinationIndexPath.item];
        [self.sortMenu reloadData];
        [self.topMenu reloadData];
        [self.rootMenu reloadData];
    }
}
- (void)setType:(LXHorizontalTopMenuType)type
{
    _type = type;
}
- (void)showWithButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectBtn" object:nil];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.tag inSection:0];
    self.currentIndex = button.tag;
    if (self.lastButton) {
        LXTopMenuCell *topCell = (LXTopMenuCell *)self.lastButton.superview.superview;
        topCell.stateType = LXTopMenuCellNormalStateType;
        [topCell.itemButton setTitleColor:self.itemLabelNormalColor forState:UIControlStateNormal];
        [topCell.itemButton.titleLabel setFont:[UIFont systemFontOfSize:self.itemLabelNormalFontSize]];
    }
    
    self.lastButton = button;
    LXTopMenuCell *topCell = (LXTopMenuCell *)button.superview.superview;
    topCell.stateType = LXTopMenuCellSelectStateType;
    [topCell.itemButton setTitleColor:self.itemLabelSelectColor forState:UIControlStateNormal];
    [topCell.itemButton.titleLabel setFont:[UIFont systemFontOfSize:self.itemLabelSelectFontSize]];
    //rootMenu
    [self.rootMenu scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenu:didSelectButtonWithIndex:)]) {
        [self.delegate horizontalMenu:self didSelectButtonWithIndex:button.tag];
    }
    //topBtn
    [UIView animateWithDuration:0.0 animations:^{
        CGFloat topWidth = self.topMenu.frame.size.width;
        if (topCell.center.x < topWidth / 2) {
//            [self.topMenu setContentOffset:CGPointZero];
        }else if (topCell.center.x > topWidth / 2){
            [self.topMenu scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }];
}
#pragma mark - showSortMenu
- (void)showSortMenu
{
    if (self.isSortMenuExist) {
        self.isSortMenuExist = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.sortMenu.frame = CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), ScreenWidth, 0);
        }];
    }else{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:5.0 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sortMenu.frame = CGRectMake(0, CGRectGetMaxY(self.topMenu.frame), ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished) {
            
        }];
        self.isSortMenuExist = YES;
    }
}
#pragma mark - handleLongGesture
- (void)handleLongGesture:(UILongPressGestureRecognizer *)longGesture
{
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            [self allCellStartShake];
            NSIndexPath *indexPath = [self.sortMenu indexPathForItemAtPoint:[longGesture locationInView:self.sortMenu]];
            if (indexPath == nil) {
                break;
            }
            [self.sortMenu beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self.sortMenu updateInteractiveMovementTargetPosition:[longGesture locationInView:self.sortMenu]];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self.sortMenu endInteractiveMovement];
        }
        default:
            [self.sortMenu cancelInteractiveMovement];
            break;
    }
}
#pragma mark - shake start and stop
- (void)allCellStartShake
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"transform.rotation";
    keyAnimation.values = @[@(-angle2Radian(CellShakeNumber)),@(angle2Radian(CellShakeNumber)),@(-angle2Radian(CellShakeNumber))];
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.duration = 0.2;
    keyAnimation.repeatCount = MAXFLOAT;
    for (UICollectionViewCell *cell in self.sortMenu.visibleCells) {
        [cell.layer addAnimation:keyAnimation forKey:nil];
    }
}
- (void)allCellStopShake
{
    for (UICollectionViewCell *cell in self.sortMenu.visibleCells) {
        [cell.layer removeAllAnimations];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.rootMenu) {
        NSInteger index = self.rootMenu.contentOffset.x / ScreenWidth;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        LXTopMenuCell *topCell = (LXTopMenuCell *)[self.topMenu cellForItemAtIndexPath:indexPath];
        [self showWithButton:topCell.itemButton];
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.topMenu) {
        return UIEdgeInsetsMake(0, NormalMargin, 0, NormalMargin);
    }else if (collectionView == self.rootMenu){
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.topMenu) {
        if (self.currentItemArray.count > indexPath.row) {
            if (self.type == LXHorizontalMenuTopMenuCommonType) {
                NSString *itemStr = self.currentItemArray[indexPath.row];
                CGSize size = [self getWidthWithString:itemStr];
                return CGSizeMake(size.width, self.topMenuSize.height);
            }else{
                return CGSizeMake((self.topMenu.frame.size.width - (self.currentItemArray.count + 1) * NormalMargin)  / self.currentItemArray.count, self.topMenuSize.height);
            }
        }
    }else if (collectionView == self.rootMenu){
        return CGSizeMake(ScreenWidth, ScreenHeight);
    }
    return CGSizeMake((ScreenWidth - 4 * NormalMargin) / 3, 50);
}
#pragma mark - private method
- (CGSize)getWidthWithString:(NSString *)string
{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size = [string sizeWithAttributes:attrs];
    return size;
}
#pragma mark - getter
- (UIColor *)topMenuBackGoundColor
{
    if (!_topMenuBackGoundColor) {
        _topMenuBackGoundColor = [UIColor whiteColor];
    }
    return _topMenuBackGoundColor;
}
- (CGFloat)itemLabelNormalFontSize
{
    if (!_itemLabelNormalFontSize) {
        _itemLabelNormalFontSize = 13;
    }
    return _itemLabelNormalFontSize;
}
- (CGFloat)itemLabelSelectFontSize
{
    if (!_itemLabelSelectFontSize) {
        _itemLabelSelectFontSize = 17;
    }
    return _itemLabelSelectFontSize;
}
- (UIColor *)itemLabelNormalColor
{
    if (!_itemLabelNormalColor) {
        _itemLabelNormalColor = [UIColor blackColor];
    }
    return _itemLabelNormalColor;
}
- (UIColor *)itemLabelSelectColor
{
    if (!_itemLabelSelectColor) {
        _itemLabelSelectColor = [UIColor blueColor];
    }
    return _itemLabelSelectColor;
}
#pragma mark - setter
- (void)setSortButtonImage:(UIImage *)sortButtonImage
{
    _sortButtonImage = sortButtonImage;
    [self.selectButton setImage:sortButtonImage forState:UIControlStateNormal];
}
- (void)setTopMenuBackGoundColor:(UIColor *)topMenuBackGoundColor
{
    _topMenuBackGoundColor = topMenuBackGoundColor;
    self.topMenu.backgroundColor = topMenuBackGoundColor;
}
- (void)setItemLabelNormalColor:(UIColor *)itemLabelNormalColor
{
    _itemLabelNormalColor = itemLabelNormalColor;
}
- (void)setItemLabelNormalFontSize:(CGFloat)itemLabelNormalFontSize
{
    _itemLabelNormalFontSize = itemLabelNormalFontSize;
}
- (void)setItemLabelSelectColor:(UIColor *)itemLabelSelectColor
{
    _itemLabelSelectColor = itemLabelSelectColor;
}
- (void)setItemLabelSelectFontSize:(CGFloat)itemLabelSelectFontSize
{
    _itemLabelSelectFontSize = itemLabelSelectFontSize;
}
@end


