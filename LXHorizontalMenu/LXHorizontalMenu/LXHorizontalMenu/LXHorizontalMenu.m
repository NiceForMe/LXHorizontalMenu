//
//  LXHorizontalMenu.m
//  LXHorizontalMenu
//
//  Created by HSEDU on 2018/12/4.
//  Copyright © 2018年 HSEDU. All rights reserved.
//

#import "LXHorizontalMenu.h"
#import "LXHorizontalMenuTopCell.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

static NSString *topCellId = @"topCellId";
static NSString *rootCellId = @"rootCellId";

@interface LXHorizontalMenu()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *topItemArray;
@property (nonatomic,strong) NSMutableArray *rootItemArray;
@property (nonatomic,assign) CGSize topMenuSize;
@property (nonatomic,strong) UICollectionView *topMenu;
@property (nonatomic,strong) UICollectionView *rootMenu;
@property (nonatomic,strong) UIView *separatorLine;
@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) NSInteger scrollIndex;
@property (nonatomic,assign) NSInteger editIdentifier;
@property (nonatomic,strong) LXHorizontalMenuTopCell *lastTopCell;
@end

@implementation LXHorizontalMenu

@synthesize canScroll = _canScroll;

- (instancetype)initWithFrame:(CGRect)frame topMenuSize:(CGSize)topMenuSize type:(LXHorizontalMenuType)type
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.editIdentifier = 0;
        self.isFirstLoad = YES;
        self.type = type;
        self.topMenuSize = CGSizeEqualToSize(topMenuSize, CGSizeZero) ? CGSizeMake(ScreenWidth, 50) : topMenuSize;;
        [self addTopMenu];
        [self addRootMenu];
        [self addSeparatorLine];
        if (CGRectEqualToRect(frame, CGRectZero)) {
            [self setNeedConstraint:YES];
        }
    }
    return self;
}

#pragma mark - lazy load
- (NSMutableArray *)topItemArray
{
    if (!_topItemArray) {
        _topItemArray = [NSMutableArray array];
    }
    return _topItemArray;
}

- (NSMutableArray *)rootItemArray
{
    if (!_rootItemArray) {
        _rootItemArray = [NSMutableArray array];
    }
    return _rootItemArray;
}

- (void)addTopMenu
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    if (self.type == LXHorizontalMenuCommonType) {
        layout.estimatedItemSize = CGSizeMake(50, self.topMenuSize.height);
    }
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _topMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.topMenuSize.width, self.topMenuSize.height) collectionViewLayout:layout];
    _topMenu.showsHorizontalScrollIndicator = NO;
    _topMenu.dataSource = self;
    _topMenu.backgroundColor = [UIColor whiteColor];
    _topMenu.delegate = self;
    [_topMenu autoresizesSubviews];
    _topMenu.pagingEnabled = NO;
    [self addSubview:_topMenu];
}

- (void)addRootMenu
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    _rootMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.topMenuSize.height, ScreenWidth, self.frame.size.height - self.topMenuSize.height) collectionViewLayout:layout];
    _rootMenu.showsHorizontalScrollIndicator = YES;
    _rootMenu.backgroundColor = [UIColor whiteColor];
    _rootMenu.bounces = NO;
    _rootMenu.dataSource = self;
    _rootMenu.delegate = self;
    [_rootMenu autoresizesSubviews];
    _rootMenu.pagingEnabled = YES;
    [self addSubview:_rootMenu];
}

- (void)setNeedConstraint:(BOOL)needConstraint
{
    _needConstraint = needConstraint;
    if (needConstraint == YES) {
        _topMenu.translatesAutoresizingMaskIntoConstraints = NO;
        _rootMenu.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint constraintWithItem:_topMenu attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;;
        [NSLayoutConstraint constraintWithItem:_topMenu attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;;
        [NSLayoutConstraint constraintWithItem:_topMenu attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.topMenuSize.width].active = YES;
        [NSLayoutConstraint constraintWithItem:_topMenu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.topMenuSize.height].active = YES;
        [NSLayoutConstraint constraintWithItem:_rootMenu attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topMenu attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_rootMenu attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_rootMenu attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_rootMenu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
    }
}

- (void)addSeparatorLine
{
    UIView *sepLine = [[UIView alloc]init];
    self.separatorLine = sepLine;
    sepLine.backgroundColor = [UIColor lightGrayColor];
    sepLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:sepLine];
    [NSLayoutConstraint constraintWithItem:sepLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.topMenu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:sepLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.topMenu attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:sepLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0].active = YES;
    [NSLayoutConstraint constraintWithItem:sepLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topMenu attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
}

#pragma mark - reload data
- (void)reloadData
{
    [self.rootMenu reloadData];
    [self.rootMenu layoutIfNeeded];
    [self.topMenu reloadData];
    [self.topMenu layoutIfNeeded];
}

#pragma mark - reload data after edit
- (void)reloadDataAfterEdit
{
    [self.topMenu reloadData];
    [self.topMenu layoutIfNeeded];
    [self.rootMenu reloadData];
    [self.rootMenu layoutIfNeeded];
}


#pragma mark - scrollToIndex
- (void)scrollToIndex:(NSInteger)index
{
    if (index < 0) {
        index = 0;
    }else if (index > [self.dataSource numberOfItemsWithHorizontalMenu:self] - 1){
        index = [self.dataSource numberOfItemsWithHorizontalMenu:self] - 1;
    }
    LXHorizontalMenuTopCell *topCell = (LXHorizontalMenuTopCell *)[self.topMenu cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (topCell != nil) {
        [self showWithButton:topCell.itemButton];
    }
}

#pragma mark - collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItemsWithHorizontalMenu:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.rootMenu) {
        NSString *identifier = [self.dataSource titleForHorizontalMenuAtIndex:indexPath.row horizontalMenu:self];
        [self.rootMenu registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        UICollectionViewCell *rootCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        rootCell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *rootView = [self.dataSource viewForHorizontalMenuAtIndex:indexPath.row horizontalMenu:self];
        if (rootView != nil) {
            if (rootCell.contentView.subviews.count == 0) {
                [rootCell.contentView addSubview:rootView];
                rootView.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootCell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rootCell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootCell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;
                [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootCell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
                [rootView layoutIfNeeded];
            }
        }
        return rootCell;
    }else if (collectionView == self.topMenu){
        NSString *titleString = [self.dataSource titleForHorizontalMenuAtIndex:indexPath.row horizontalMenu:self];
        [self.topMenu registerClass:[LXHorizontalMenuTopCell class] forCellWithReuseIdentifier:titleString];
        LXHorizontalMenuTopCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:titleString forIndexPath:indexPath];
        if (self.isFirstLoad == YES && indexPath.row == self.defaultIndex) {
            topCell.type = LXHorizontalMenuTopCellSelectType;
            self.isFirstLoad = NO;
            self.lastTopCell = topCell;
            [self.rootMenu scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        topCell.normalColor = self.normalTextColor;
        topCell.selectColor = self.selectTextColor;
        topCell.normalFont = self.normalFont;
        topCell.selectFont = self.selectFont;
        topCell.underLineColor = self.underLineColor;
        topCell.title = titleString;
        topCell.itemButton.tag = indexPath.row;
        [topCell.itemButton addTarget:self action:@selector(showWithButton:) forControlEvents:UIControlEventTouchUpInside];
        return topCell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"123" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.rootMenu) {
        NSInteger index = self.rootMenu.contentOffset.x / ScreenWidth;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        LXHorizontalMenuTopCell *topCell = (LXHorizontalMenuTopCell *)[self.topMenu cellForItemAtIndexPath:indexPath];
        [self showWithButton:topCell.itemButton];
    }
}

- (void)showWithButton:(UIButton *)button
{
    NSInteger index = button.tag;
    [self setValue:[NSNumber numberWithInteger:index] forKey:@"currentIndex"];
//    self.currentIndex = index;
    if (self.lastTopCell) {
        self.lastTopCell.type = LXHorizontalMenuTopCellCommonType;
    }
    LXHorizontalMenuTopCell *currentCell = (LXHorizontalMenuTopCell *)[self.topMenu cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    self.lastTopCell = currentCell;
    currentCell.type = LXHorizontalMenuTopCellSelectType;
    [self.rootMenu scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    if (self.type == LXHorizontalMenuCommonType) {
        if (self.scrollType == LXHorizontalMenuScrollTypeCenter) {
            [self.topMenu scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    [self.topMenu reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenu:didSelectItemWithIndex:)]) {
        [self.delegate horizontalMenu:self didSelectItemWithIndex:index];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.topMenu) {
        if (self.type == LXHorizontalMenuAverageType) {
            return CGSizeMake(self.topMenuSize.width / [self.dataSource numberOfItemsWithHorizontalMenu:self], self.topMenuSize.height);
        }else{
            return CGSizeMake(200, self.topMenuSize.height);
        }
    }else if (collectionView == self.rootMenu){
        return CGSizeMake(ScreenWidth, self.rootMenu.frame.size.height);
    }else{
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.topMenu) {
        if (self.type == LXHorizontalMenuAverageType) {
            return UIEdgeInsetsZero;
        }else{
            return UIEdgeInsetsMake(0, 10, 0, 10);
        }
    }else{
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.topMenu) {
        if (self.type == LXHorizontalMenuAverageType) {
            return 0;
        }else{
            return 10;
        }
    }else{
        return 0;
    }
}

#pragma mark - setter
- (void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    _separatorLineColor = separatorLineColor;
    self.separatorLine.backgroundColor = separatorLineColor;
}

- (void)setCanScroll:(BOOL)canScroll
{
    _canScroll = canScroll;
    if (canScroll == YES) {
        self.rootMenu.scrollEnabled = YES;
    }else{
        self.rootMenu.scrollEnabled = NO;
    }
}

- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    _normalTextColor = normalTextColor;
}

- (void)setUnderLineColor:(UIColor *)underLineColor
{
    _underLineColor = underLineColor;
}

- (void)setSelectTextColor:(UIColor *)selectTextColor
{
    _selectTextColor = selectTextColor;
}

- (void)setNormalFont:(UIFont *)normalFont
{
    _normalFont = normalFont;
}

- (void)setDefaultIndex:(NSInteger)defaultIndex
{
    _defaultIndex = defaultIndex;
}
#pragma mark - getter
- (BOOL)canScroll
{
    return YES;
}


@end
