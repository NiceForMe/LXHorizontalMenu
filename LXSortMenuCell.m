//
//  LXSortMenuCell.m
//  LXHorizontalMenu
//
//  Created by NiceForMe on 17/3/25.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "LXSortMenuCell.h"

@implementation LXSortMenuCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    UILabel *itemLable = [[UILabel alloc]init];
    self.itemLable = itemLable;
    itemLable.backgroundColor = [UIColor lightGrayColor];
    itemLable.textAlignment = NSTextAlignmentCenter;
    itemLable.frame = self.contentView.bounds;
    itemLable.font = [UIFont systemFontOfSize:14];
    itemLable.layer.cornerRadius = 25;
    itemLable.layer.masksToBounds = YES;
    [self.contentView addSubview:itemLable];
}
@end
