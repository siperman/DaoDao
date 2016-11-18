//
//  DDAskChatManager.m
//  DaoDao
//
//  Created by hetao on 2016/10/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskChatManager.h"
#import "SYCache.h"
#import <libkern/OSAtomic.h>

static NSString * const SYCachedAskInfoFileName = @"conv_ask";

@interface DDAskChatManager ()
@property (nonatomic, strong) NSMutableDictionary <NSString*, DDAsk*> *cachedAsks;
@property (nonatomic, strong) dispatch_queue_t updateAskInfoQueue;
@property (nonatomic, assign) OSSpinLock spinlock;
@end

@implementation DDAskChatManager

+ (instancetype)sharedInstance
{
    static DDAskChatManager *instance = nil;
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

    NSDictionary *dict = [[SYCache sharedInstance] itemForKey:SYCachedAskInfoFileName];
    if (!dict) {
        _cachedAsks = [NSMutableDictionary dictionary];
    } else {
        _cachedAsks = [NSMutableDictionary dictionaryWithDictionary:dict];
    }

//    _updateAskInfoQueue = dispatch_queue_create("com.daodao.daodao", DISPATCH_QUEUE_SERIAL);
    [self subscribeNotication:kUpdateAskInfoNotification selector:@selector(handleNotification:)];

    return self;
}

- (void)handleNotification:(NSNotification*) notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        DDAsk *newAsk = userInfo[kNewAskKey];
        if (newAsk) {
            [self cacheAsk:newAsk ForConversationId:newAsk.answer.conversionId];
        }
    }
}

- (void)cacheAsk:(DDAsk *)ask ForConversationId:(NSString *)conversationId
{
    NSDictionary *tempAsks = nil;

    if (conversationId && ask) {
        OSSpinLockLock(&_spinlock);
        [self.cachedAsks setObject:ask forKey:conversationId];
        tempAsks = [NSDictionary dictionaryWithDictionary:self.cachedAsks];
        OSSpinLockUnlock(&_spinlock);

        [[SYCache sharedInstance] saveItem:tempAsks forKey:SYCachedAskInfoFileName];
        POST_NOTIFICATION(kUpdateIMAskInfoNotification, nil);
    }
}

- (DDAsk *)getCachedProfileIfExists:(NSString *)conversationId
{
    return self.cachedAsks[conversationId];
}

- (void)getProfilesInBackgroundForConversationId:(NSString *)conversationId callback:(DDAskChatCallback)callback
{
    WeakSelf;
    [SYRequestEngine requestAskInfoWithId:conversationId callback:^(BOOL success, id response) {
        if (success) {
            DDAsk *ask = [DDAsk fromDict:response[kObjKey]];
            if (ask) {
                [weakSelf cacheAsk:ask ForConversationId:conversationId];
                if (callback) {
                    callback(ask);
                }
            }
        } else {
            callback(nil);
        }
    }];
}


@end
