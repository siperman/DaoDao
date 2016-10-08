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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Appearance
    [self configureAppearance];

    // Setting
    {
        [[SYImageCache sharedInstance] setup];

//        [iVersion sharedInstance].delegate = self;
    }


//    // LeanCloud
//    {
//#if DEBUG
//        NSString *LCAppID = @"mbg71pbet86aftm7hkis54e0x195iwgl720otx2mmkqrp97z";
//        NSString *LCAppKey = @"eakbm5hrpegqkiq7n70v89bvhxa8s8gwckvp4wztjur1b3fr";
//#else
//        NSString *LCAppID = @"1uglj479yoah6wh37oftjsiuvw84yr6ceygrvu3pvef0aflq";
//        NSString *LCAppKey = @"oi4vt7vbezgbwo9cs6j7xrptaeghsqfldk20lpl44hr1rfp8";
//#endif
//        [AVOSCloud setApplicationId:LCAppID clientKey:LCAppKey];
//        [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
//    }

    // Umeng
    {
//#if DEBUG
//        NSString *UMKey = @"55cd6169e0f55ad7940005ef";
//#else
//        NSString *UMKey = @"54d9ff1afd98c5a093000299";
//#endif
//        UMConfigInstance.appKey = UMKey;
//        [MobClick startWithConfigure:UMConfigInstance];
//        [MobClick setCrashReportEnabled:NO];
//
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        [MobClick setAppVersion:version];
//
//        [UMSocialData setAppKey:UMKey];
//        [UMSocialWechatHandler setWXAppId:@"wx7541cb00cec835a5" appSecret:@"1cebf9fd328b5b544916a4a18ae44fb9" url:@"http://www.soouya.com"];
//        [UMSocialQQHandler setQQWithAppId:@"1104078523" appKey:@"TFRnP4gVTRoPjP6B" url:@"http://www.soouya.com"];
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
    return YES;
}

- (void)configureAppearance {
    // 导航标题
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName : TitleColor}];
        [[UINavigationBar appearance] setBarTintColor:MainColor];
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    // 后退箭头
    UIImage *backButtonImage = [Image(@"icon_back") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
    UIImage *backSelButtonImage = [Image(@"icon_back_sel") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backSelButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64.0) forBarMetrics:UIBarMetricsDefault];   // Just hide the title

    // 按钮
//    [[UIButton appearance] setBackgroundImage:[UIImage imageWithColor:CCCColor] forState:UIControlStateDisabled];

    [[UIPageControl appearance] setPageIndicatorTintColor:TextColor];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:SecondColor];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
