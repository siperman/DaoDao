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

//    [self subscribeNotication:UIApplicationDidBecomeActiveNotification selector:@selector(refreshAllNotifications)];
    [self subscribeNotication:LCCKNotificationMessageReceived selector:@selector(refreshIM:)]; // 订阅聊天消息推送

    return self;
}

- (void)dealloc
{
    POST_NOTIFICATION(kNewIMMessageNotification, nil);

    [self unsubscribeAllNotications];
}

#pragma mark - Notifications

- (void)refreshIM:(NSNotification*) notification
{
    NSDictionary *userInfo = [notification object];
    NSArray *msgs = userInfo[LCCKDidReceiveMessagesUserInfoMessagesKey];
    if ([msgs isKindOfClass:[NSArray class]]) {
        self.unreadIMMessagesCount += msgs.count;
    }
    POST_NOTIFICATION(kNewIMMessageNotification, nil);
}

- (void)setUnreadIMMessagesCount:(NSInteger)unreadIMMessagesCount
{
    _unreadIMMessagesCount = unreadIMMessagesCount;
    POST_NOTIFICATION(kUpdateUnreadCountNotification, nil);
}

- (void)refreshIM
{
    [[LCCKConversationListService sharedInstance] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        if (!error) {
            self.unreadIMMessagesCount = totalUnreadCount;
        }
    }];
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
