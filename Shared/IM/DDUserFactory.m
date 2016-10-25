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

static NSString * const SYCachedUserInfoFileName = @"conv_user";

@interface DDUserFactory ()
@property (nonatomic, strong) NSMutableDictionary *cachedUsers;
@property (nonatomic, strong) dispatch_queue_t updateUserInfoQueue;
@property (nonatomic, assign) OSSpinLock spinlock;
@end

@implementation DDUserFactory

//- (instancetype)init
//{
//    self = [super init];
//    _spinlock = OS_SPINLOCK_INIT;
//
//    NSDictionary *dict = [[SYCache sharedInstance] itemForKey:SYCachedUserInfoFileName];
//    if (!dict) {
//        _cachedUsers = [NSMutableDictionary dictionary];
//    } else {
//        _cachedUsers = [NSMutableDictionary dictionaryWithDictionary:dict];
//    }
//
//    _updateUserInfoQueue = dispatch_queue_create("com.soouya.soouya", DISPATCH_QUEUE_SERIAL);
//
//    [self updateLocalUserInfo];
//
//    return self;
//}
//
//- (void)cacheUser:(id<CDUserModel>)user
//{
//    NSDictionary *tempUsrs = nil;
//
//    if (user.userId) {
//        OSSpinLockLock(&_spinlock);
//        [self.cachedUsers setObject:user forKey:user.userId];
//        tempUsrs = [NSDictionary dictionaryWithDictionary:self.cachedUsers];
//        OSSpinLockUnlock(&_spinlock);
//
//        // TODO: 换用更高效方法
//        [[SYCache sharedInstance] saveItem:tempUsrs forKey:SYCachedUserInfoFileName];
//    }
//}
//
//- (void)cacheUsers:(NSArray <id<CDUserModel>>*)users
//{
//    NSDictionary *tempUsrs = nil;
//
//    if (users.count > 0) {
//        OSSpinLockLock(&_spinlock);
//        for (id<CDUserModel> user in users) {
//            if (user.userId) {
//                [self.cachedUsers setObject:user forKey:user.userId];
//            }
//        }
//        tempUsrs = [NSDictionary dictionaryWithDictionary:self.cachedUsers];
//        OSSpinLockUnlock(&_spinlock);
//
//        // TODO: 换用更高效方法
//        [[SYCache sharedInstance] saveItem:tempUsrs forKey:SYCachedUserInfoFileName];
//    }
//}
//
//- (void)updateLocalUserInfo
//{
//    if (self.cachedUsers.allKeys.count == 0) {
//        return;
//    }
//    NSString *userids = [self.cachedUsers.allKeys componentsJoinedByString:@","];
//    WEAKSELF
//    dispatch_async(self.updateUserInfoQueue, ^{
//        [weakSelf requestUserInfos:userids];
//    });
//}
//
//#pragma mark - CDUserDelegate
//
//// cache users that will be use in getUserById
//- (void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block {
//    block(YES, nil); // don't forget it
//}
//
//- (id <CDUserModel> )getUserById:(NSString *)userId
//{
//    id<CDUserModel> user = [self.cachedUsers objectForKey:userId];
//    if (user) {
//        return user;
//    } else if (userId.length > 0) {
//        [self requestUserInfo:userId];
//    }
//    return nil;
//}
//
//- (void)requestUserInfo:(NSString *)userId
//{
//    if (userId) {
//        [SYRequestEngine requestObjByType:SYModelTypeUser
//                                    objID:userId
//                                 callback:^(BOOL success, NSInteger httpCode, id response) {
//                                     if (success) {
//                                         SYUser *user = [SYUser fromDict:response[kObjKey]];
//                                         if (user) {
//                                             [self cacheUser:user];
//                                         }
//                                     }
//                                 }];
//    }
//}
//
//- (void)requestUserInfos:(NSString *)userIds
//{
//    if (userIds) {
//        [SYRequestEngine searchStoreWithParams:@{ @"ids" : userIds,
//                                                  kFunctionKey : kFunctionQueryValue}
//                                      callback:^(BOOL success, NSInteger httpCode, id response) {
//                                          if (success) {
//                                              NSArray *users = [SYUser parseFromDicts:response[kPageKey][kResultKey]];
//                                              if (users.count > 0) {
//                                                  [self cacheUsers:users];
//                                              }
//                                          }
//                                      }];
//    }
//}

@end
