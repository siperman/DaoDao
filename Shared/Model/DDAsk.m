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
             @"demand" : @"demand",
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

- (NSString *)type
{
    DDUser *user = [DDUserManager manager].user;
    if ([self.user.uid isEqualToString:user.uid]) {
        return @"我发起";
    } else {
        return @"对方发起";
    }
}

@end
