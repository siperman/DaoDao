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
    return header;
}

@end
