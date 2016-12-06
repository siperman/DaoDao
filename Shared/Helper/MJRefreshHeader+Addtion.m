//
//  MJRefreshHeader+Addtion.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "MJRefreshHeader+Addtion.h"

@implementation MJRefreshHeader (Addtion)

+ (MJRefreshNormalHeader *)normalHeader
{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    header.stateLabel.textColor = TextColor;
    header.backgroundColor = ClearColor;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"轻轻下拉，即刻刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"该放手了，我要刷新了..." forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    if (header.arrowView) {
        [header.arrowView removeFromSuperview];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"icon_jiantouXia")];
        [header setValue:imgView forKey:@"arrowView"];
        [header addSubview:imgView];
    }

    return header;
}

@end
