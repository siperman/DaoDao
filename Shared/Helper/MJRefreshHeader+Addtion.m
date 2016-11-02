//
//  MJRefreshHeader+Addtion.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "MJRefreshHeader+Addtion.h"
#import <ChatKit/LCCKSettingService.h>

@implementation MJRefreshHeader (Addtion)

+ (MJRefreshNormalHeader *)normalHeader
{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    header.stateLabel.textColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-TextColor"];
    header.lastUpdatedTimeLabel.textColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-TextColor"];
    header.backgroundColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-BackgroundColor"];
    return header;
}

@end
