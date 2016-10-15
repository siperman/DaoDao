//
//  DDReloadView.m
//  DaoDao
//
//  Created by hetao on 2016/10/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDReloadView.h"

@implementation DDReloadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = BackgroundColor;
}

+ (instancetype)showReloadViewOnView:(UIView *)view reloadAction:(void (^)())reload
{
    DDReloadView *reloadView = LoadView(@"DDReloadView");
    reloadView.bounds = view.bounds;
    reloadView.top = 0.0;
    reloadView.left = 0.0;

    reloadView.reloadBlock = reload;

    view.autoresizesSubviews = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        scrollView.scrollEnabled = NO;
    }

    [view addSubview:reloadView];

    return reloadView;
}

- (void)reload
{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end
