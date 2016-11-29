//
//  AppDelegate.m
//  DaoDao
//
//  Created by hetao on 16/9/2.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+ImageWithColor.h"
#import "SYImageCache.h"
#import "SYPrefManager.h"
#import "DDConfig.h"
#import "DDChatKitManager.h"
#import "LCCKBadgeView.h"
#import "SYUtils.h"
#import "DDGuidePagesViewController.h"
#import "DDHomeViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate () <DDGuidePagesProtocol>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Appearance
    [self configureAppearance];
    sleep(2);

    // Setting
    {
        [[SYImageCache sharedInstance] setup];
        [Fabric with:@[[Crashlytics class]]];
    }

    // LeanCloud
    {
        [DDChatKitManager invokeThisMethodInDidFinishLaunching];
        [SYUtils registerNotification];
    }

    // Umeng
    {
#if DEBUG || TEST
        NSString *UMKey = @"58073d59c895767d3a0000eb";
#else
        NSString *UMKey = @"57eba4e767e58ee6b80018c5";
#endif
        UMConfigInstance.appKey = UMKey;
        [MobClick startWithConfigure:UMConfigInstance];
        [MobClick setCrashReportEnabled:NO];

        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
    }
    // Cookies
    {
        // 设置上次运行APP时的cookies，以继续保持在服务端的状态
        [SYPrefManager setupCookies];
    }

    // Utils
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

        [SYRequestEngine requestConfigCallback:^(BOOL success, id response) {
            if (success) {
                [DDConfig saveConfigDict:response[kObjKey]];
            }
        }];
    }

    // Guide
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        /*
         *  images : 引导图数组
         */
        NSArray *images = @[@"guide01", @"guide02", @"guide03"];
        if ([DDGuidePagesViewController isShow]) {
            self.window.rootViewController = [DDGuidePagesViewController shareGuideVC];
            [[DDGuidePagesViewController shareGuideVC] initWithGuideImages:images];
            [DDGuidePagesViewController shareGuideVC].delegate = self;
        }else{
            [self guideDone];
        }
    }
    return YES;
}

- (void)guideDone
{
    DDHomeViewController *vc = [[DDHomeViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)configureAppearance {
    // 导航标题
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : TitleTextFont, NSForegroundColorAttributeName : TitleColor}];
        [[UINavigationBar appearance] setBarTintColor:ColorHex(@"100402")];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    }

    // 后退箭头
    UIImage *backButtonImage = [Image(@"icon_back") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    UIImage *backSelButtonImage = [Image(@"icon_back_sel") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backSelButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64.0) forBarMetrics:UIBarMetricsDefault];   // Just hide the title
    [[UIBarButtonItem appearance] setTintColor:BarTintColor];

    [[UIPageControl appearance] setPageIndicatorTintColor:TextColor];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:MainColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    [[UITableViewHeaderFooterView appearance] setTintColor:ClearColor];
    [[LCCKBadgeView appearance] setBadgeTextFont:SmallTextFont];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [SYPrefManager setObject:deviceToken forKey:kCurrentDeviceToken];
    [DDChatKitManager invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [DDChatKitManager invokeThisMethodInApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [DDChatKitManager invokeThisMethodInApplication:application didReceiveRemoteNotification:userInfo];

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    // 不做后台刷新
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSLog(@"========%@", notification);
    NSDictionary *userInfo = notification.request.content.userInfo;

    [DDChatKitManager invokeThisMethodInApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    NSLog(@"response:%@", response);
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [DDChatKitManager invokeThisMethodInApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [DDChatKitManager invokeThisMethodInApplicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [DDChatKitManager invokeThisMethodInApplicationWillTerminate:application];
}

@end
