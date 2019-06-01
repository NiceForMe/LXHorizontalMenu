//
//  ViewController.m
//  LXHorizontalMenu
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "LXHorizontalMenu.h"
#import "SecondVC.h"

#define MenuWidth self.view.frame.size.width
#define MenuHeight self.view.frame.size.height
#define angle2Radian(angle) ((angle) / 180.0 * M_PI)
#define CellShakeNumber 2.5

@interface ViewController ()<LXHorizontalMenuDataSource,LXHorizontalMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *topArray;
@property (nonatomic,strong) NSMutableArray *restTopArray;
@property (nonatomic,strong) NSMutableArray *bottomArray;
@property (nonatomic,strong) LXHorizontalMenu *menu;
@property (nonatomic,strong) UICollectionView *sortMenu;
@property (nonatomic,assign) BOOL isSortMenuExist;
@end

@implementation ViewController
#pragma mark - lazy load
- (NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [NSMutableArray arrayWithObjects:@"数学一",@"数学二",@"数学三",@"英语一",@"思想品德政治一",@"计算机科学技术一",@"数学是", nil];
    }
    return _topArray;
}

- (NSMutableArray *)restTopArray
{
    if (!_restTopArray) {
        _restTopArray = [NSMutableArray arrayWithObjects:@"自动化",@"心理学",@"汉语言文学", nil];
    }
    return _restTopArray;
}

- (NSMutableArray *)bottomArray
{
    if (!_bottomArray) {
        _bottomArray = [NSMutableArray array];
    }
    return _bottomArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initMenu];
    [self initSortMenu];
    [self loadNewData];
}

#pragma mark - 模拟网络请求
- (void)loadNewData
{
    for (NSInteger i = 0; i < self.topArray.count; i++) {
        SecondVC *vc = [[SecondVC alloc]init];
        [self addChildViewController:vc];
        vc.string = self.topArray[i];
        [self.bottomArray addObject:vc];
    }
    [self.menu reloadData];
}

#pragma mark - 初始化Menu
- (void)initMenu
{
    LXHorizontalMenu *menu = [[LXHorizontalMenu alloc]initWithFrame:self.view.frame topMenuSize:CGSizeMake(MenuWidth - 50, 50) type:LXHorizontalMenuCommonType];
    menu.dataSource = self;
    menu.delegate = self;
    menu.normalTextColor = [UIColor blackColor];
    menu.selectTextColor = [UIColor redColor];
    menu.underLineColor = [UIColor blueColor];
    menu.selectFont = [UIFont systemFontOfSize:14];
    menu.canScroll = NO;
    self.menu = menu;
    [self.view addSubview:menu];
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(MenuWidth - 50, 0, 50, 50);
    [sortBtn setTitle:@"Sort" forState:UIControlStateNormal];
    sortBtn.backgroundColor = [UIColor lightGrayColor];
    [sortBtn addTarget:self action:@selector(showSortMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortBtn];
}

- (NSInteger)numberOfItemsWithHorizontalMenu:(LXHorizontalMenu *)horizontalMenu
{
    return self.topArray.count;
}

- (NSString *)titleForHorizontalMenuAtIndex:(NSInteger)index horizontalMenu:(LXHorizontalMenu *)horizontalMenu
{
    return self.topArray[index];
}

- (UIView *)viewForHorizontalMenuAtIndex:(NSInteger)index horizontalMenu:(LXHorizontalMenu *)horizontalMenu
{
    SecondVC *vc = self.bottomArray[index];
    return vc.view;
}

- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didSelectItemWithIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}

#pragma mark - 初始化筛选Collectionview
- (void)initSortMenu
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(MenuWidth, 50);
    layout.itemSize = CGSizeMake((MenuWidth - 5 * 10) / 3, 40);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *sortMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.menu.frame) + 50, MenuWidth, 0) collectionViewLayout:layout];
    self.sortMenu = sortMenu;
    sortMenu.showsHorizontalScrollIndicator = YES;
    sortMenu.bounces = NO;
    sortMenu.dataSource = self;
    sortMenu.delegate = self;
    sortMenu.userInteractionEnabled = YES;
    [sortMenu registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [sortMenu registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [sortMenu autoresizesSubviews];
    sortMenu.pagingEnabled = YES;
    [self.view addSubview:sortMenu];
    [sortMenu reloadData];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
    [sortMenu addGestureRecognizer:longGesture];
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

- (void)showSortMenu
{
    if (self.isSortMenuExist) {
        self.isSortMenuExist = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.sortMenu.frame = CGRectMake(0, CGRectGetMaxY(self.menu.frame), MenuWidth, 0);
        }];
    }else{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:5.0 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sortMenu.frame = CGRectMake(0, CGRectGetMinY(self.menu.frame) + 50, MenuWidth, MenuHeight);
        } completion:^(BOOL finished) {
            
        }];
        self.isSortMenuExist = YES;
    }
}

#pragma mark - UICollectionview datasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? self.topArray.count : self.restTopArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UILabel *lableView in view.subviews) {
        if ([lableView isKindOfClass:[UILabel class]]) {
            [lableView removeFromSuperview];
        }
    }
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *headerLable = [[UILabel alloc]init];
    headerLable.font = [UIFont systemFontOfSize:14];
    headerLable.frame = CGRectMake(10, 0, MenuWidth - 2 * 10, 50);
    if (indexPath.section == 0) {
        headerLable.text = @"常用频道(长按可拖动调整频道顺序，点击删除)";
    }else if (indexPath.section == 1){
        headerLable.text = @"所有频道(点击添加您感兴趣的频道)";
    }
    [view addSubview:headerLable];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *itemLable = [[UILabel alloc]init];
    itemLable.backgroundColor = [UIColor lightGrayColor];
    itemLable.textAlignment = NSTextAlignmentCenter;
    itemLable.frame = cell.contentView.bounds;
    itemLable.font = [UIFont systemFontOfSize:12];
    itemLable.layer.cornerRadius = 20;
    itemLable.layer.masksToBounds = YES;
    itemLable.text = indexPath.section == 0 ? self.topArray[indexPath.row] : self.restTopArray[indexPath.row];
    [cell.contentView addSubview:itemLable];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //数据源操作
        [self.restTopArray addObject:self.topArray[indexPath.item]];
        [self.topArray removeObject:self.topArray[indexPath.item]];
        [self.bottomArray removeObjectAtIndex:indexPath.item];
        //刷新视图
        [self.sortMenu reloadData];
        [self.menu reloadData];
        //如果被删除cell的item小于等于menu当前的index,那么就让menu向前滚到一个cell
        if (indexPath.item <= self.menu.currentIndex) {
            [self.menu scrollToIndex:self.menu.currentIndex - 1];
        }
    }else{
        //操作数据源
        [self.topArray addObject:self.restTopArray[indexPath.item]];
        [self.restTopArray removeObject:self.restTopArray[indexPath.item]];
        //新加VC
        SecondVC *vc = [[SecondVC alloc]init];
        vc.string = self.topArray.lastObject;
        [self.bottomArray addObject:vc];
        [self.sortMenu reloadData];
        //刷新视图
        [self.menu reloadData];
        [self.menu scrollToIndex:self.menu.currentIndex];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        [self.topArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [self.bottomArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [self.sortMenu reloadData];
        [self.menu reloadData];
        //如果menu当前所在的index和拖动indexPath.item相等，那么就将当前cell移动到destinationIndexPath.item位置,这里有点小问题，如果destinationIndexPath.item还没有加载，这时候collectionview是找不到这个cell的，这时候无法移动。
        if (self.menu.currentIndex == sourceIndexPath.item) {
            [self.menu scrollToIndex:destinationIndexPath.item];
        }
    }
}



@end
