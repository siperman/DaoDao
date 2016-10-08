//
//  UIViewController+EmptyNotice.h
//  Soouya
//
//  Created by hetao on 15/12/7.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+EmptyNotice.h"

@interface UIViewController (EmptyNotice)

- (void)showEmptyNotice:(SYEmptyNoticeType)type;

- (void)removeEmptyNotice;

- (void)configureEmptyNoticeForDataSource:(NSArray *)dataSource type:(SYEmptyNoticeType)type;

@end
