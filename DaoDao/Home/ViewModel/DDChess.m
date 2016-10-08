//
//  DDChess.m
//  DaoDao
//
//  Created by hetao on 16/9/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChess.h"

@implementation DDChess

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cid" : @"id",
             @"isWhite" : @"color",
             @"isBig" : @"size",
             @"isLighting" : @"flash",
             };
}

+ (NSValueTransformer *)isWhiteJSONTransformer
{
    return [self boolValueJSONTransformer];
}

+ (NSValueTransformer *)isBigJSONTransformer
{
    return [self boolValueJSONTransformer];
}

+ (NSValueTransformer *)isLightingJSONTransformer
{
    return [self boolValueJSONTransformer];
}


@end
