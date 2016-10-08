//
//  UIViewController+EmptyNotice.m
//  Soouya
//
//  Created by hetao on 15/12/7.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "UIViewController+EmptyNotice.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

@implementation UIViewController (EmptyNotice)

- (void)showEmptyNotice:(SYEmptyNoticeType)type
{
    [self.view showEmptyNotice:type];
}

- (void)removeEmptyNotice
{
    [self.view removeEmptyNotice];
}

- (void)configureEmptyNoticeForDataSource:(NSArray *)dataSource type:(SYEmptyNoticeType)type
{
    [self.view configureEmptyNoticeForDataSource:dataSource type:type];
}

@end
