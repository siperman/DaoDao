//
//  DDNotificationManager.h
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

//自定义的通知manager:包括内部采购通知，普通通知
@interface DDNotificationManager : NSObject

@property (nonatomic, readonly) DDUser *currentUser;

- (instancetype)initWithUser:(DDUser *)user;

// 未读IM消息
@property (nonatomic) NSInteger unreadIMMessagesCount;
// 未读的系统消息
@property (nonatomic) NSInteger unreadNotificationsCount;

- (void)refreshIM;

- (void)refreshAllNotifications;

- (void)refreshUnreadNotificationsCount:(void(^)(void))callback;

@end
