# LXHorizontalMenu
仿今日头条、腾讯新闻主页面的第三方,支持对频道的增、改、移位，调用方便，便于开发者重构
![img](https://github.com/NiceForMe/LXHorizontalMenu/blob/master/LXHorizontalMenu%20gif.gif)
# 使用方法
- 将LXHorizontalMenu拖入到工程中去
- 添加头文件 #import “LXHorizontalMenu.h”
- 初始化LXHorizontalMenu
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    LXHorizontalMenu *menu = [[LXHorizontalMenu alloc]initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height) showSortMenu:YES currentItemArray:self.currentItemsArray restItemArray:self.restItemsArray rootMenuItems:[self rootMenuArray] topMenuHeight:50];
    menu.sortButtonImage = [UIImage imageNamed:@"1"];
    menu.topMenuBackGoundColor = [UIColor redColor];
    menu.delegate = self;
    menu.dataSource = self;
    menu.itemLabelNormalColor = [UIColor purpleColor];
    menu.itemLabelNormalFontSize = 13;
    menu.itemLabelSelectColor = [UIColor greenColor];
    menu.itemLabelSelectFontSize = 17;
    [self.view addSubview:menu];
}
```
## 数据源方法
```objective-c
#pragma mark - LXHorizontalMenu dataSource
- (NSInteger)numberOfCurrentItemInHorizontalMenu:(LXHorizontalMenu *)horizontalMenu
{
    return self.currentItemsArray.count;
}
- (NSInteger)numberOfRestItemInHorizontalMenu:(LXHorizontalMenu *)horizontalMenu
{
    return self.restItemsArray.count;
}
 ```
## 代理方法
```objective-c
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didSelectButtonWithIndex:(NSInteger)index
{
    
}
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didDeleteButtonWithIndex:(NSInteger)index
{
    [self.restItemsArray addObject:self.currentItemsArray[index]];
    [self.currentItemsArray removeObjectAtIndex:index];
    [self storeArray];
}
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didAddButtonWithIndex:(NSInteger)index
{
    ThirdView *tv = [[ThirdView alloc]init];
    tv.label.text = self.restItemsArray[index];
    [horizontalMenu.rootMenuItems addObject:tv];
    [self.currentItemsArray addObject:self.restItemsArray[index]];
    [self.restItemsArray removeObjectAtIndex:index];
    [self storeArray];
}
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didmoveButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    //currentItemsArray
    id objc = [self.currentItemsArray objectAtIndex:fromIndex];
    [self.currentItemsArray removeObject:objc];
    [self.currentItemsArray insertObject:objc atIndex:toIndex];
    [self storeArray];
}
```
# 联系我
如果有任何建议、想法以及对源码的意见加我QQ或者微信:771717844
欢迎iOSers提出宝贵的意见，也欢迎各位大牛批评指正，喜欢的朋友点个star
# Discussing
- email:771717844@qq.com
- [sina weibo](http://weibo.com/2759926645/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1)
- [submit issues](https://github.com/NiceForMe/LXPopOverMenu/issues)
