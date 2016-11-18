//
//  DDChatKitManager.m
//  DaoDao
//
//  Created by hetao on 16/9/7.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChatKitManager.h"
#import "LCCKUtil.h"
#import "NSObject+LCCKHUD.h"
#import "LCCKUser.h"
#import "MWPhotoBrowser.h"
#import <objc/runtime.h>
#import "LCChatKit.h"
#import "LCCKInputViewPluginPickImage.h"
#import "LCCKInputViewPluginTakePhoto.h"
#import "LCCKInputViewPluginLocation.h"
#import "LCCKAlertController.h"
#import "NSFileManager+LCCKExtension.h"
#import "LCCKVCardMessageCell.h"
#import "LCCKExampleConstants.h"
#import "LCCKContactManager.h"

#import "DDConversationListCell.h"
#import "LCCKInputViewPluginVCard.h"
#import "DDHomeViewController.h"

#ifdef DEBUG
static NSString *const LCCKAPPKEY = @"E7glabfvph8e91qthD9wxt7n";
static NSString *const LCCKAPPID  = @"56fTKRrEQiYcnhXgSbNjF2RR-gzGzoHsz";
#elif TEST
static NSString *const LCCKAPPKEY = @"aLnJXroXfsO3O2y0TzMeyx0z";
static NSString *const LCCKAPPID  = @"bcBzimEL1vcQy8qPkdM064mA-gzGzoHsz";
#else
static NSString *const LCCKAPPKEY = @"RhI4OeI0gPrOClX4oIoODjQn";
static NSString *const LCCKAPPID  = @"DqcSj1K2at8yCGhq37IrLvkr-gzGzoHsz";
#endif

@interface DDChatKitManager () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;

@end

@implementation DDChatKitManager

#pragma mark - SDK Life Control

+ (void)invokeThisMethodInDidFinishLaunching {
    // 如果APP是在国外使用，开启北美节点
    //    [AVOSCloud setServiceRegion:AVServiceRegionUS];
    // 启用未读消息
    [AVIMClient setUserOptions:@{ AVIMUserOptionUseUnread : @(YES) }];
    [AVIMClient setTimeoutIntervalInSeconds:20];
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
    //    [LCCKInputViewPluginLocation registerSubclass];
    // 关闭单点登陆
    [[LCChatKit sharedInstance] setDisableSingleSignOn:NO];
}

+ (void)invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)invokeThisMethodBeforeLogoutSuccess:(LCCKVoidBlock)success failed:(LCCKErrorBlock)failed {
    //    [AVOSCloudIM handleRemoteNotificationsWithDeviceToken:nil];
    [[LCChatKit sharedInstance] removeAllCachedProfiles];
    [[LCChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self clearLocalClientInfo];
            [LCCKUtil showNotificationWithTitle:@"退出成功" subtitle:nil type:LCCKMessageNotificationTypeSuccess];
            !success ?: success();
        } else {
            [LCCKUtil showNotificationWithTitle:@"退出失败" subtitle:nil type:LCCKMessageNotificationTypeError];
            !failed ?: failed(error);
        }
    }];
}

+ (void)saveLocalClientInfo:(NSString *)clientId {
    // 在系统偏好保存信息
    NSUserDefaults *defaultsSet = [NSUserDefaults standardUserDefaults];
    [defaultsSet setObject:clientId forKey:LCCK_KEY_USERID];
    [defaultsSet synchronize];
    NSString *subtitle = [NSString stringWithFormat:@"User Id 是 : %@", clientId];
    [LCCKUtil showNotificationWithTitle:@"登陆成功" subtitle:subtitle type:LCCKMessageNotificationTypeSuccess];
}

+ (void)clearLocalClientInfo {
    // 在系统偏好保存信息
    NSUserDefaults *defaultsSet = [NSUserDefaults standardUserDefaults];
    [defaultsSet setObject:nil forKey:LCCK_KEY_USERID];
    [defaultsSet synchronize];
}

+ (void)invokeThisMethodAfterLoginSuccessWithClientId:(NSString *)clientId success:(LCCKVoidBlock)success failed:(LCCKErrorBlock)failed  {
    [[self sharedInstance] exampleInit];
    [[LCChatKit sharedInstance] openWithClientId:clientId force:YES callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self saveLocalClientInfo:clientId];
            !success ?: success();
        } else {
            [LCCKUtil showNotificationWithTitle:@"登陆失败" subtitle:nil type:LCCKMessageNotificationTypeError];
            !failed ?: failed(error);
        }
    }];
    //TODO:
}

+ (void)invokeThisMethodInApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
        /*!
         *  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
         {
         aps =     {
         alert = "lcckkit : sdfsdf";
         badge = 4;
         sound = default;
         };
         convid = 55bae86300b0efdcbe3e742e;
         }
         */
        [[LCChatKit sharedInstance] didReceiveRemoteNotification:userInfo];
        [MobClick event:EnterIm];
    }
}

+ (void)invokeThisMethodInApplicationWillResignActive:(UIApplication *)application {
    [[LCChatKit sharedInstance] syncBadge];
}

+ (void)invokeThisMethodInApplicationWillTerminate:(UIApplication *)application {
    [[LCChatKit sharedInstance] syncBadge];
}

#pragma -
#pragma mark - init Method

/**
 *  初始化的示例代码
 */
- (void)exampleInit {
#ifndef __OPTIMIZE__
    //        [LCChatKit setAllLogsEnabled:YES];
//    [[LCChatKit sharedInstance] setUseDevPushCerticate:YES];
#endif
    /**
     * @attention 请区别 `[AVOSCloud setApplicationId:appId clientKey:appKey];` 与 `[LCChatKit setAppId:appId appKey:appKey];`。
     两者功能并不相同，前者不能代替后者。即使你在 `-[AppDelegate application:didFinishLaunchingWithOptions:]` 方法里已经设置过前者，也不能因此不调用后者。
     前者为 LeanCloud-SDK 初始化，后者为 ChatKit 初始化。后者需要你在**每次**登录操作时调用一次，前者只需要你在程序启动时调用。
     如果你使用了 LeanCloud-SDK 的其他功能，你可能要根据需要，这两个方法都使用到。
     */
    [LCChatKit setAppId:LCCKAPPID appKey:LCCKAPPKEY];

#warning 注意：setFetchProfilesBlock 方法必须实现，如果不实现，ChatKit将无法显示用户头像、用户昵称。以下方法循环模拟了通过 userIds 同步查询 users 信息的过程，这里需要替换为 App 的 API 同步查询
    [[LCChatKit sharedInstance] setFetchProfilesBlock:^(NSArray<NSString *> *userIds, LCCKFetchProfilesCompletionHandler completionHandler) {
        if (userIds.count == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"User ids is nil";
            NSDictionary *errorInfo = @{
                                        @"code" : @(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:@"DDChatKitManager"
                                                 code:code
                                             userInfo:errorInfo];
            !completionHandler ?: completionHandler(nil, error);
            return;
        }

        NSMutableArray *users_ = [NSMutableArray array];
        NSMutableArray *userIds_ = [userIds mutableCopy];
        NSMutableArray *locUserIds_ = [NSMutableArray array];
        for (NSString *uid in userIds) {
            // 先本地取
            LCCKUser *user = [LCCKUser loadFromDiskWithKey:uid];
            if (user) {
                [users_ addObject:user];
                [userIds_ removeObject:uid];
                [locUserIds_ addObject:uid];
            }
        }

        if (userIds_.count > 0) {
            NSString *uids = [userIds_ componentsJoinedByString:@","];
            [SYRequestEngine requestUserWithIds:uids callback:^(BOOL success, id response) {
                if (success) {
                    NSArray *users = [LCCKUser parseFromDicts:response[kPageKey][kResultKey]];
                    for (LCCKUser *user in users) {
                        // 缓存到本地
                        [user saveToDiskWithKey:user.userId];
                    }
                    [users_ addObjectsFromArray:users];

                    !completionHandler ?: completionHandler([users_ copy], nil);
                } else {

                    [userIds enumerateObjectsUsingBlock:^(NSString * _Nonnull clientId, NSUInteger idx, BOOL * _Nonnull stop) {
                        //注意：如果网络请求失败，请至少提供 ClientId！
                        LCCKUser *user_ = [LCCKUser userWithClientId:clientId];
                        [users_ addObject:user_];
                    }];
                    !completionHandler ?: completionHandler([users_ copy], nil);
                }
            }];
        } else {
            !completionHandler ?: completionHandler([users_ copy], nil);
        }

        if (locUserIds_.count > 0) {
            // 更新本地user
            NSString *uids = [locUserIds_ componentsJoinedByString:@","];
            [SYRequestEngine requestUserWithIds:uids callback:^(BOOL success, id response) {
                if (success) {
                    NSArray *users = [LCCKUser parseFromDicts:response[kPageKey][kResultKey]];
                    for (LCCKUser *user in users) {
                        // 缓存到本地
                        [user saveToDiskWithKey:user.userId];
                    }
                }
            }];
        }
    }];

    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(NSIndexPath *indexPath, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        [[self class] exampleOpenConversationViewControllerWithConversaionId:conversation.conversationId fromNavigationController:controller.navigationController];
    }];

    [[LCChatKit sharedInstance] setDidDeleteConversationsListCellBlock:^(NSIndexPath *indexPath, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        //TODO:
    }];

    [[LCChatKit sharedInstance] setFetchConversationHandler:^(AVIMConversation *conversation, LCCKConversationViewController *aConversationController) {
        if (!conversation.createAt) {
            return;
        }
        [aConversationController configureBarButtonItemStyle:LCCKBarButtonItemStyleSingleProfile action:nil];
    }];

    [[LCChatKit sharedInstance] setConversationInvalidedHandler:^(NSString *conversationId, LCCKConversationViewController *conversationController, id<LCCKUserDelegate> administrator, NSError *error) {
        NSString *title;
        NSString *subTitle;
        //错误码参考：https://leancloud.cn/docs/realtime_v2.html#%E4%BA%91%E7%AB%AF%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E
        if (error.code == 4401) {
            /**
             * 下列情景下会执行
             - 当前用户被踢出群，也会执行
             - 用户不在当前群众，且未开启 `enableAutoJoin` (自动进群)
             */
            [conversationController.navigationController popToRootViewControllerAnimated:YES];
            title = @"进群失败！";
            subTitle = [NSString stringWithFormat:@"请联系管理员%@", administrator.name ?: administrator.clientId];
            LCCKLog(@"%@", error.description);
            [LCCKUtil showNotificationWithTitle:title subtitle:subTitle type:LCCKMessageNotificationTypeError];
        } else if (error.code == 4304) {
            title = @"群已满";
            [LCCKUtil showNotificationWithTitle:title subtitle:subTitle type:LCCKMessageNotificationTypeError];

        }
    }];

    [[LCChatKit sharedInstance] setLoadLatestMessagesHandler:^(LCCKConversationViewController *conversationController, BOOL succeeded, NSError *error) {
        [[self class] lcck_hideHUDForView:conversationController.view];
        NSString *title;
        LCCKMessageNotificationType type;
        if (succeeded) {
            title = @"聊天记录加载成功";
            type = LCCKMessageNotificationTypeSuccess;
        } else {
            title = @"聊天记录加载失败";
            type = LCCKMessageNotificationTypeError;
        }
#ifndef __OPTIMIZE__
        [LCCKUtil showNotificationWithTitle:title subtitle:nil type:type];
#else
#endif
    }];

    //    替换默认预览图片的样式
    //    [[LCChatKit sharedInstance] setPreviewImageMessageBlock:^(NSUInteger index, NSArray *allVisibleImages, NSArray *allVisibleThumbs, NSDictionary *userInfo) {
    //        [self examplePreviewImageMessageWithInitialIndex:index allVisibleImages:allVisibleImages allVisibleThumbs:allVisibleThumbs];
    //    }];

    //    长按菜单
    //    [[LCChatKit sharedInstance] setLongPressMessageBlock:^NSArray<UIMenuItem *> *(LCCKMessage *message, NSDictionary *userInfo) {
    //        LCCKMenuItem *copyItem = [[LCCKMenuItem alloc] initWithTitle:LCCKLocalizedStrings(@"copy")
    //                                                               block:^{
    //                                                                   UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //                                                                   [pasteboard setString:[message text]];
    //                                                               }];
    //
    //        LCCKConversationViewController *conversationViewController = userInfo[LCCKLongPressMessageUserInfoKeyFromController];
    //        LCCKMenuItem *transpondItem = [[LCCKMenuItem alloc] initWithTitle:LCCKLocalizedStrings(@"transpond")
    //                                                                    block:^{
    //                                                                        [self transpondMessage:message toConversationViewController:conversationViewController];
    //                                                                    }];
    //        NSArray *menuItems = [NSArray array];
    //        if (message.mediaType ==  kAVIMMessageMediaTypeText) {
    //            menuItems = @[ copyItem, transpondItem ];
    //        }
    //        return menuItems;
    //    }];

#if DEBUG
    [[LCChatKit sharedInstance] setHUDActionBlock:^(UIViewController *viewController, UIView *view, NSString *title, LCCKMessageHUDActionType type) {
        switch (type) {
                case LCCKMessageHUDActionTypeShow:
                [[self class] lcck_showMessage:title toView:view];
                break;

                case LCCKMessageHUDActionTypeHide:
                [[self class] lcck_hideHUDForView:view];
                break;

                case LCCKMessageHUDActionTypeError:
                [[self class] lcck_showError:title toView:view];
                break;

                case LCCKMessageHUDActionTypeSuccess:
                [[self class] lcck_showSuccess:title toView:view];
                break;
        }
    }];

    [[LCChatKit sharedInstance] setShowNotificationBlock:^(UIViewController *viewController, NSString *title, NSString *subtitle, LCCKMessageNotificationType type) {
        [self exampleShowNotificationWithTitle:title subtitle:subtitle type:type];
    }];
#endif

    [[LCChatKit sharedInstance] setOpenProfileBlock:^(NSString *userId, id<LCCKUserDelegate> user, __kindof UIViewController *parentController) {
        if (!userId) {
            [parentController showNotice:@"用户不存在"];
            return;
        }
        [self exampleOpenProfileForUser:user userId:userId parentController:parentController];
    }];

    //    开启圆角可能导致4S等低端机型卡顿，谨慎开启。
    [[LCChatKit sharedInstance] setAvatarImageViewCornerRadiusBlock:^CGFloat(CGSize avatarImageViewSize) {
        if (avatarImageViewSize.height > 0) {
            return avatarImageViewSize.height/2;
        }
        return 5;
    }];



    // 自定义Cell菜单
//    [[LCChatKit sharedInstance] setConversationEditActionBlock:^NSArray *(NSIndexPath *indexPath, NSArray<UITableViewRowAction *> *editActions, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
//        return [self exampleConversationEditActionAtIndexPath:indexPath conversation:conversation controller:controller];
//    }];

    //    如果不是TabBar样式，请实现该 Blcok 来设置 Badge 红标。
    [[LCChatKit sharedInstance] setMarkBadgeWithTotalUnreadCountBlock:^(NSInteger totalUnreadCount, UIViewController *controller) {
        [self exampleMarkBadgeWithTotalUnreadCount:totalUnreadCount controller:controller];
    }];

    [[LCChatKit sharedInstance] setPreviewLocationMessageBlock:^(CLLocation *location, NSString *geolocations, NSDictionary *userInfo) {
        [self examplePreViewLocationMessageWithLocation:location geolocations:geolocations];
    }];

    [[LCChatKit sharedInstance] setForceReconnectSessionBlock:^(NSError *aError, BOOL granted, __kindof UIViewController *viewController, LCCKReconnectSessionCompletionHandler completionHandler) {
        BOOL isSingleSignOnOffline = (aError.code == 4111);
        // - 用户允许重连请求，发起重连或强制登录
        if (granted == YES) {
            BOOL force = NO;
            NSString *title = @"正在重连聊天服务...";
            if (isSingleSignOnOffline) {
                force = YES;
                title = @"正在强制登录...";
            }
            [[self class] lcck_showMessage:title toView:viewController.view];
            [[LCChatKit sharedInstance] openWithClientId:[LCChatKit sharedInstance].clientId force:force callback:^(BOOL succeeded, NSError *error) {
                [[self class] lcck_hideHUDForView:viewController.view];
                !completionHandler ?: completionHandler(succeeded, error);
            }];
            return;
        }

        // - 显示返回信息
        NSInteger code = 0;
        NSString *errorReasonText = @"not granted";
        NSDictionary *errorInfo = @{
                                    @"code":@(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:code
                                         userInfo:errorInfo];
        !completionHandler ?: completionHandler(NO, error);
    }];

    // 自定义消息列表样式
    [[LCCKConversationListService sharedInstance] setCellForRowBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, AVIMConversation *conversation) {
        DDConversationListCell *cell = [DDConversationListCell dequeueOrCreateCellByTableView:tableView];

        return cell;
    }];

    [[LCCKConversationListService sharedInstance] setConfigureCellBlock:^(UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath, AVIMConversation *conversation) {
//        DDConversationListCell *cell = (DDConversationListCell *)[tableView cellForRowAtIndexPath:indexPath];

        [(DDConversationListCell *)cell configureCell:conversation];

    }];

    [[LCCKConversationListService sharedInstance] setHeightForRowBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath, AVIMConversation *conversation) {
        return [DDConversationListCell cellHeight];
    }];
}

+ (void)tryPresentViewControllerViewController:(UIViewController *)viewController {
    if (viewController) {
        UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController = [(UINavigationController*)rootViewController visibleViewController];
        }
        [rootViewController presentViewController:viewController animated:YES completion:nil];
    }
}

- (NSArray *)exampleConversationEditActionAtIndexPath:(NSIndexPath *)indexPath
                                         conversation:(AVIMConversation *)conversation
                                           controller:(LCCKConversationListViewController *)controller {
    // 如果需要自定义其他会话的菜单，在此编辑
    return [self rightButtonsAtIndexPath:indexPath conversation:conversation controller:controller];
}

typedef void (^UITableViewRowActionHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

- (void)markReadStatusAtIndexPath:(NSIndexPath *)indexPath
                            title:(NSString **)title
                           handle:(UITableViewRowActionHandler *)handler
                     conversation:(AVIMConversation *)conversation
                       controller:(LCCKConversationListViewController *)controller {
    NSString *conversationId = conversation.conversationId;
    if (conversation.lcck_unreadCount > 0) {
        if (*title == nil) {
            *title = @"标记为已读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversationId];
        };
    } else {
        if (*title == nil) {
            *title = @"标记为未读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] increaseUnreadCountWithConversationId:conversationId];
        };
    }
}

- (NSArray *)rightButtonsAtIndexPath:(NSIndexPath *)indexPath
                        conversation:(AVIMConversation *)conversation
                          controller:(LCCKConversationListViewController *)controller {
    NSString *title = nil;
    UITableViewRowActionHandler handler = nil;
    [self markReadStatusAtIndexPath:indexPath
                              title:&title
                             handle:&handler
                       conversation:conversation
                         controller:controller];
    UITableViewRowAction *actionItemMore = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:title
                                                                            handler:handler];
    actionItemMore.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    UITableViewRowAction *actionItemDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:LCCKLocalizedStrings(@"Delete")
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                  [[LCChatKit sharedInstance] deleteRecentConversationWithConversationId:conversation.conversationId];
                                                                              }];

    UITableViewRowAction *actionItemChangeGroupAvatar = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                           title:@"改群头像"
                                                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                             [[self class] exampleChangeGroupAvatarURLsForConversationId:conversation.conversationId shouldInsert:NO];
                                                                                         }];
    actionItemChangeGroupAvatar.backgroundColor = [UIColor colorWithRed:251/255.f green:186/255.f blue:11/255.f alpha:1.0];
    if (conversation.lcck_type == LCCKConversationTypeSingle) {
        return @[ actionItemDelete, actionItemMore ];
    }
    return @[ actionItemDelete, actionItemMore, actionItemChangeGroupAvatar];
}

#pragma -
#pragma mark - Other Method

/**
 *  打开单聊页面
 */
+ (void)exampleOpenConversationViewControllerWithPeerId:(NSString *)peerId fromNavigationController:(UINavigationController *)navigationController {
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:peerId];
    [conversationViewController setViewWillDisappearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
        [self lcck_hideHUDForView:viewController.view];
    }];
    [self pushToViewController:conversationViewController];
}

+ (void)exampleOpenConversationViewControllerWithConversaionId:(NSString *)conversationId fromNavigationController:(UINavigationController *)aNavigationController {
    [MobClick event:EnterIm];
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithConversationId:conversationId];
    conversationViewController.enableAutoJoin = YES;
    [conversationViewController setViewWillDisappearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
        [self lcck_hideHUDForView:viewController.view];
    }];
    [conversationViewController setViewWillAppearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:aAnimated];
    }];
    // 禁止双击文字全屏
    conversationViewController.disableTextShowInFullScreen = YES;

    [aNavigationController pushViewController:conversationViewController animated:YES];
}

+ (void)pushToViewController:(UIViewController *)viewController {
    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
    UIWindow *window = delegate.window;
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)window.rootViewController pushViewController:viewController animated:YES];
    }
}

- (void)exampleMarkBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount controller:(UIViewController *)controller {
    debugLog(@"============totalUnreadCount : %ld", (long)totalUnreadCount);
    [DDUserManager manager].notificationManager.unreadIMMessagesCount = totalUnreadCount;
    if (totalUnreadCount > 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)examplePreViewLocationMessageWithLocation:(CLLocation *)location geolocations:(NSString *)geolocations {
    NSString *title = [NSString stringWithFormat:@"打开地理位置：%@", geolocations];
    NSString *subTitle = [NSString stringWithFormat:@"纬度：%@\n经度：%@",@(location.coordinate.latitude), @(location.coordinate.longitude)];
    [LCCKUtil showNotificationWithTitle:title subtitle:subTitle type:LCCKMessageNotificationTypeMessage];
}

void dispatch_async_limit(dispatch_queue_t queue, NSUInteger limitSemaphoreCount, dispatch_block_t block) {
    static dispatch_semaphore_t limitSemaphore;
    static dispatch_queue_t receiverQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(limitSemaphoreCount);
        receiverQueue = dispatch_queue_create("receiver", DISPATCH_QUEUE_SERIAL);
    });
    dispatch_async(receiverQueue, ^{
        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            !block ? : block();
            dispatch_semaphore_signal(limitSemaphore);
        });
    });
}

- (void)transpondMessage:(LCCKMessage *)message toConversationViewController:(LCCKConversationViewController *)conversationViewController {
    AVIMConversation *conversation = [conversationViewController getConversationIfExists];
    NSArray *allPersonIds;
    if (conversation.lcck_type == LCCKConversationTypeSingle) {
        //FIXME: add more to allPersonIds
        allPersonIds = [[LCCKContactManager defaultManager] fetchContactPeerIds];
    } else {
        allPersonIds = conversation.members;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:allPersonIds shouldSameCount:YES error:nil];
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];
    LCCKContactListViewController *contactListViewController = [[LCCKContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:allPersonIds] excludedUserIds:[NSSet setWithArray:@[currentClientID]] mode:LCCKContactListModeMultipleSelection];
    contactListViewController.title = LCCKLocalizedStrings(@"transpond");
    [contactListViewController setSelectedContactsCallback:^(UIViewController *viewController, NSArray<NSString *> *peerIds) {
        if (!peerIds || peerIds.count == 0) {
            return;
        }
        dispatch_source_t _processingQueueSource;
        _processingQueueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0,
                                                        dispatch_get_global_queue(0, 0));
        __block NSUInteger totalComplete = 0;
        dispatch_source_set_event_handler(_processingQueueSource, ^{
            NSUInteger value = dispatch_source_get_data(_processingQueueSource);
            totalComplete += value;
            // NSLog(@"发了%@,总共%@",@(totalComplete),  @(peerIds.count));
            // NSLog(@"进度：%@", @((CGFloat)totalComplete/(peerIds.count)));
            // 服务端限制，一分钟只能查询30条Conversation信息，故这里最多转发30条。
            if (totalComplete/(allPersonIds.count) == 1 || totalComplete >= 30) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [[self class] lcck_hideHUD];
                    [[self class] lcck_showSuccess:@"转发完成"];
                });
            }
        });
        dispatch_resume(_processingQueueSource);
        NSString *title = [NSString stringWithFormat:@"%@...",LCCKLocalizedStrings(@"transpond")];
        [[self class] lcck_showMessage:title];
        for (NSString *peerId in peerIds) {
            dispatch_async_limit(queue, 10, ^{
                [[LCCKConversationService sharedInstance] fecthConversationWithPeerId:peerId callback:^(AVIMConversation *conversation, NSError *error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        if (!error) {
                            AVIMTypedMessage *avimTypedMessage = [AVIMTypedMessage lcck_messageWithLCCKMessage:message];
                            [conversation sendMessage:avimTypedMessage callback:^(BOOL succeeded, NSError *error) {
                                dispatch_source_merge_data(_processingQueueSource, 1);
                            }];
                        } else {
                            dispatch_source_merge_data(_processingQueueSource, 1);
                        }

                    });
                }
                 ];
            });
        }
    }];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:contactListViewController];
    [conversationViewController presentViewController:navigationViewController animated:YES completion:nil];
}

+ (void)exampleChangeGroupAvatarURLsForConversationId:(NSString *)conversationId {
    [self exampleChangeGroupAvatarURLsForConversationId:conversationId shouldInsert:YES];
}

+ (void)exampleChangeGroupAvatarURLsForConversationId:(NSString *)conversationId shouldInsert:(BOOL)shouldInsert {
    [self lcck_showMessage:@"正在设置群头像"];
    [[LCCKConversationService sharedInstance] fecthConversationWithConversationId:conversationId callback:^(AVIMConversation *conversation, NSError *error) {
        [conversation lcck_setObject:LCCKTestConversationGroupAvatarURLs[arc4random_uniform((int)LCCKTestConversationGroupAvatarURLs.count - 1)] forKey:LCCKConversationGroupAvatarURLKey callback:^(BOOL succeeded, NSError *error) {
            [self lcck_hideHUD];
            if (succeeded) {
                [self lcck_showSuccess:@"设置群头像成功"];
                if (shouldInsert) {
                    [[LCCKConversationService sharedInstance] insertRecentConversation:conversation];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:LCCKNotificationConversationListDataSourceUpdated object:self];
            } else {
                [self lcck_showError:@"设置群头像失败"];
            }
        }];
    }];
}
- (void)examplePreviewImageMessageWithInitialIndex:(NSUInteger)index allVisibleImages:(NSArray *)allVisibleImages allVisibleThumbs:(NSArray *)allVisibleThumbs {
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:[allVisibleImages count]];
    NSMutableArray *thumbs = [[NSMutableArray alloc] initWithCapacity:[allVisibleThumbs count]];
    MWPhoto *photo;
    MWPhoto *thumb;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    for (NSUInteger index = 0; index < allVisibleImages.count; index++) {
        id image_ = allVisibleImages[index];
        if ([image_ isKindOfClass:[UIImage class]]) {
            photo = [MWPhoto photoWithImage:image_];
        } else {
            photo = [MWPhoto photoWithURL:image_];
        }
        [photos addObject:photo];

        id thumb_ = allVisibleThumbs[index];
        if ([thumb_ isKindOfClass:[UIImage class]]) {
            thumb = [MWPhoto photoWithImage:thumb_];
        } else {
            thumb = [MWPhoto photoWithURL:thumb_];
        }
        [thumbs addObject:thumb];
    }
    // Options
    startOnGrid = NO;
    displayNavArrows = YES;
    self.photos = photos;
    self.thumbs = thumbs;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:index];
    // Reset selections
    if (displaySelectionButtons) {
        _selections = [[NSMutableArray alloc] initWithCapacity:[allVisibleImages count]];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [[self class] pushToViewController:browser];
}

- (void)exampleOpenProfileForUser:(id<LCCKUserDelegate>)user userId:(NSString *)userId parentController:(__kindof UIViewController *)parentController {
    DDUserHomePageViewController *vc = [DDUserHomePageViewController viewController];
    vc.userId = userId;
    [parentController.navigationController pushViewController:vc animated:YES];
}

- (void)exampleShowNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(LCCKMessageNotificationType)type {
    [LCCKUtil showNotificationWithTitle:title subtitle:subtitle type:type];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
    return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
    return [_thumbs objectAtIndex:index];
    return nil;
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}

#pragma mark -
#pragma mark - Private Methods

/**
 * create a singleton instance of DDChatKitManager
 */
+ (instancetype)sharedInstance {
    static DDChatKitManager *_sharedDDChatKitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDDChatKitManager = [[self alloc] init];
    });
    return _sharedDDChatKitManager;
}

@end
