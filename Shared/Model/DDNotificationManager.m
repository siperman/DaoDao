//
//  DDNotificationManager.m
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDNotificationManager.h"

@interface DDNotificationManager ()

@property (nonatomic, readwrite) DDUser *currentUser;

@end

@implementation DDNotificationManager

- (instancetype)initWithUser:(DDUser *)user
{
    self = [super init];

    _currentUser = user;

    [self subscribeNotication:UIApplicationDidBecomeActiveNotification selector:@selector(refreshAllNotifications)];

    return self;
}

- (void)dealloc
{
    POST_NOTIFICATION(kNewIMMessageNotification, nil);

    [self unsubscribeAllNotications];
}

#pragma mark - Notifications

- (void)setUnreadIMMessagesCount:(NSInteger)unreadIMMessagesCount
{
    _unreadIMMessagesCount = unreadIMMessagesCount;

    POST_NOTIFICATION(kNewIMMessageNotification, nil);
}

- (void)setUnreadNotificationsCount:(NSInteger)unreadNotificationsCount
{
    _unreadNotificationsCount = unreadNotificationsCount;
}

- (void)refreshAllNotifications
{
    [self refreshUnreadNotificationsCount:nil];
}

- (void)refreshUnreadNotificationsCount:(void(^)(void))callback
{
//    [SYRequestEngine requestRemainWithParams:@{
//                                               kModelKey : @"Msg"
//                                               }
//                                    callback:^(BOOL success, NSInteger httpCode, id response) {
//                                        if (success) {
//                                            self.unreadNotificationsCount = [response[kObjKey] integerValue];
//
//                                            POST_NOTIFICATION(kUpdateBadgeNotification, nil);
//
//                                            if (self.unreadNotificationsCount > 0 &&
//                                                callback) {
//                                                callback();
//                                            }
//                                        }
//                                    }];
}

@end