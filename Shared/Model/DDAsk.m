//
//  DDAsk.m
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAsk.h"

@implementation DDAsk

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"aid" : @"id",
             @"type" : @"type",
             @"demand" : @"demand",
             @"descr" : @"descr",
             @"industry" : @"industry",
             @"job" : @"job",
             @"expert" : @"expert",
             @"answers" : @"answers",
             @"cancelReason" : @"cancelReason",
             @"status" : @"status",
             @"createTime" : @"createTime",
             @"user" : @"user",
             @"answer" : @"answer",
             };
}

@end
