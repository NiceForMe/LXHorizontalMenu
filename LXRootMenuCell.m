//
//  LXRootMenuCell.m
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/2/20.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "LXRootMenuCell.h"

@implementation LXRootMenuCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    UIView *rootMenuView = [[UIView alloc]init];
    rootMenuView.backgroundColor = [UIColor whiteColor];
    self.rootMenuView = rootMenuView;
    rootMenuView.frame = self.contentView.bounds;
    [self.contentView addSubview:rootMenuView];
}
@end
