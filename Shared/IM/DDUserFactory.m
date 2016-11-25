//
//  DDUserFactory.m
//  DaoDao
//
//  Created by hetao on 2016/10/24.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUserFactory.h"
#import "SYCache.h"
#import <libkern/OSAtomic.h>
#import "LCCKUser.h"

static NSString * const SYCachedUserInfoFileName = @"conv_user";

@interface DDUserFactory ()
@property (nonatomic, strong) NSMutableDictionary <NSString*, LCCKUser*>*cachedUsers;
@property (nonatomic, strong) dispatch_queue_t updateUserInfoQueue;
@property (nonatomic, assign) OSSpinLock spinlock;
@end

@implementation DDUserFactory

+ (instancetype)sharedInstance
{
    static DDUserFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    _spinlock = OS_SPINLOCK_INIT;

    NSDictionary *dict = [[SYCache sharedInstance] itemForKey:SYCachedUserInfoFileName];
    if (!dict) {
        _cachedUsers = [NSMutableDictionary dictionary];
    } else {
        _cachedUsers = [NSMutableDictionary dictionaryWithDictionary:dict];
    }

    _updateUserInfoQueue = dispatch_queue_create("com.daotong.daodao", DISPATCH_QUEUE_SERIAL);

    [self updateLocalUserInfo];

    return self;
}

+ (void)cacheUser:(LCCKUser *)user
{
    [[self sharedInstance] cacheUser:user];
}

- (void)cacheUser:(LCCKUser *)user
{
    NSDictionary *tempUsrs = nil;

    if (user.userId) {
        [self.cachedUsers setObject:user forKey:user.userId];

        OSSpinLockLock(&_spinlock);
        tempUsrs = [NSDictionary dictionaryWithDictionary:self.cachedUsers];
        OSSpinLockUnlock(&_spinlock);

        [[SYCache sharedInstance] saveItem:tempUsrs forKey:SYCachedUserInfoFileName];
    }
}

- (void)cacheUsers:(NSArray <LCCKUser *>*)users
{
    NSDictionary *tempUsrs = nil;

    if (users.count > 0) {
        OSSpinLockLock(&_spinlock);
        for (LCCKUser *user in users) {
            if (user.userId) {
                [self.cachedUsers setObject:user forKey:user.userId];
            }
        }
        tempUsrs = [NSDictionary dictionaryWithDictionary:self.cachedUsers];
        OSSpinLockUnlock(&_spinlock);

        [[SYCache sharedInstance] saveItem:tempUsrs forKey:SYCachedUserInfoFileName];
    }
}

- (void)updateLocalUserInfo
{
    if (self.cachedUsers.allKeys.count == 0) {
        return;
    }
    NSString *userids = [self.cachedUsers.allKeys componentsJoinedByString:@","];
    WeakSelf;
    dispatch_async(self.updateUserInfoQueue, ^{
        [weakSelf requestUserInfos:userids];
    });
}

+ (LCCKUser *)getUserById:(NSString *)userId
{
    return [[self sharedInstance] getUserById:userId];
}

- (LCCKUser *)getUserById:(NSString *)userId
{
    return [self.cachedUsers objectForKey:userId];
//    LCCKUser *user = [self.cachedUsers objectForKey:userId];
//    if (user) {
//        return user;
//    } else if (userId.length > 0) {
//        [self requestUserInfo:userId];
//    }
//    return nil;
}

- (void)requestUserInfo:(NSString *)userId
{
    if (userId) {
        [SYRequestEngine requestUserWithId:userId
                                 callback:^(BOOL success, id response) {
                                     if (success) {
                                         LCCKUser *user = [LCCKUser fromDict:response[kObjKey]];
                                         if (user) {
                                             [self cacheUser:user];
                                         }
                                     }
                                 }];
    }
}

- (void)requestUserInfos:(NSString *)userIds
{
    if (userIds) {
        WeakSelf;
        [SYRequestEngine requestUserWithIds:userIds callback:^(BOOL success, id response) {
            if (success) {
                NSArray *users = [LCCKUser parseFromDicts:response[kPageKey][kResultKey]];
                [weakSelf cacheUsers:users];
            }
        }];
    }
}

@end
