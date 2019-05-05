# LXHorizontalMenu
仿今日头条、腾讯新闻、新浪微博等主页面的第三方,支持对频道的增、改、移位，调用方便，便于开发者重构
![img](https://github.com/NiceForMe/LXHorizontalMenu/blob/master/LXHorizontalMenu%20gif.gif)
# 使用方法
- 将LXHorizontalMenu拖入到工程中去
- 添加头文件 #import “LXHorizontalMenu.h”
- 初始化LXHorizontalMenu
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    LXHorizontalMenu *menu = [[LXHorizontalMenu alloc]initWithFrame:self.view.frame topMenuSize:CGSizeMake(MenuWidth - 50, 50) type:LXHorizontalMenuCommonType];
    menu.dataSource = self;
    menu.normalTextColor = [UIColor blackColor];
    menu.selectTextColor = [UIColor redColor];
    menu.underLineColor = [UIColor blueColor];
    menu.selectFont = [UIFont systemFontOfSize:14];
    menu.canScroll = NO;
    self.menu = menu;
    [self.view addSubview:menu];
}
```
## 数据源方法
```objective-c
#pragma mark - LXHorizontalMenu dataSource
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
 ```
## 代理方法
```objective-c
- (void)horizontalMenu:(LXHorizontalMenu *)horizontalMenu didSelectItemWithIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}
```
# 联系我
如果有任何建议、想法以及对源码的意见加我QQ或者微信:771717844，看到反馈我会第一时间回复大家。
欢迎iOSers提出宝贵的意见，也欢迎各位大牛批评指正，喜欢的朋友点个star
# Discussing
- email:771717844@qq.com
- [sina weibo](http://weibo.com/2759926645/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1)
- [submit issues](https://github.com/NiceForMe/LXPopOverMenu/issues)
