//
//  DDAnswer.m
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAnswer.h"

@implementation DDAnswer

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"isFavorite" : @"isFavorite",
             @"cancelReason" : @"cancelReason",
             @"conversionId" : @"conversionId",
             @"user" : @"user",
             @"askRate" : @"askRate",
             @"answerRate" : @"answerRate",
             @"meet" : @"meet",
             };
}


@end

//////////////////////////////////////////////////////////////////

@implementation DDRate

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"useful" : @"useful",
             @"happy" : @"happy",
             @"impress" : @"impress",
             };
}

@end

//////////////////////////////////////////////////////////////////

@implementation DDMeet

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"time" : @"time",
             @"city" : @"city",
             @"addr" : @"addr",
             };
}

@end
