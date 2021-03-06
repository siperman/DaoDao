//
//  UIView+EmptyNotice.h
//  Soouya
//
//  Created by hetao on 15/12/4.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SYEmptyNoticeType) {
    SYEmptyNoticeTypeNetworkError,
    SYEmptyNoticeTypeEmptyAsk,
    SYEmptyNoticeTypeEmptyMessage,
    SYEmptyNoticeTypeEmptyMyAsk,
    SYEmptyNoticeTypeEmptyMyAnswer,

};

@interface UIView (EmptyNotice)

- (void)showEmptyNotice:(SYEmptyNoticeType)type;

- (void)removeEmptyNotice;

- (void)configureEmptyNoticeForDataSource:(NSArray *)dataSource type:(SYEmptyNoticeType)type;

@end
