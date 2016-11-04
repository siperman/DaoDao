//
//  DDUserManager.m
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUserManager.h"
#import "SYCache.h"
#import "SYUtils.h"
#import "SYPrefManager.h"
#import "DDChatKitManager.h"

#ifdef DEBUG
#define FILE_NAME @"edf_local_v2.data" // user data
#else
#define FILE_NAME @"edf_server_v2.data" // user data
#endif

@interface DDUserManager ()

@property (nonatomic, readwrite) BOOL isLogined;
@property (nonatomic, copy) NSString *userId;
@end

@implementation DDUserManager

+ (instancetype)manager
{
    static DDUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance loadUserInfo];
    });

    return instance;
}

- (void)loadUserInfo
{
    if (_user == nil) {
        DDUser *user_ = [[SYCache sharedInstance] itemForKey:FILE_NAME];
        if (user_) {
            _user = user_;

            self.isLogined = YES;
            // 触发注册设备，注册leancloud
            [self updateUser];
        }
    }
}

- (void)setUser:(DDUser *)user
{
    if (_user != user) {
        BOOL loginState = _isLogined;

        // Save cookies 在全局user改变之前
        [SYPrefManager resetCookies];

        _user = user;

        if (user) {
            _isLogined = YES;
            [[SYCache sharedInstance] saveItem:_user forKey:FILE_NAME];

            [self updateUser];
        } else {
            _isLogined = NO;

            [self clearUser];
        }

        POST_NOTIFICATION(kUpdateUserInfoNotification, nil);

        if (loginState != _isLogined || !_isLogined) {
            POST_NOTIFICATION(kUserDidChangeLoggingStateNotification, nil);
        }
    }
}

- (void)updateUser
{
    // 获取系统消息
    if (!self.notificationManager) {
        self.notificationManager = [[DDNotificationManager alloc] initWithUser:self.user];
    }

    // 变更用户
    if (!self.userId ||
        ![self.userId isEqualToString:self.user.uid]) {
        self.userId = self.user.uid;

        //刷新未读消息数
        [self.notificationManager refreshAllNotifications];

        [DDChatKitManager invokeThisMethodAfterLoginSuccessWithClientId:self.user.uid success:^{
            debugLog(@"登入成功");
            //刷新未读消息数
            [self.notificationManager refreshIM];
        } failed:^(NSError *error) {
            debugLog(@"登入失败 %@", error);
        }];
    }
}

- (void)clearUser
{
    //移除文件缓存
    [[SYCache sharedInstance] saveItem:nil forKey:FILE_NAME];

    self.notificationManager = nil;
    self.userId = nil;

    [DDChatKitManager invokeThisMethodBeforeLogoutSuccess:^{
        debugLog(@"登出成功");
    } failed:^(NSError *error) {
        debugLog(@"登出失败 %@", error);
    }];
}

@end
