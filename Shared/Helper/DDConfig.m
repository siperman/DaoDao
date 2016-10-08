//
//  DDConfig.m
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDConfig.h"
#import "SYCache.h"

static NSString *kSysConfigFileName = @"sysConfig";

@implementation DDConfig

+ (NSArray <NSDictionary*>*)femaleRate
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"femaleRate"];
}

+ (NSArray <NSDictionary*>*)maleRate
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"maleRate"];
}

+ (NSArray <NSDictionary*>*)topic
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"topic"];
}

+ (NSArray <NSDictionary*>*)expert
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"expert"];
}

+ (NSArray <NSDictionary*>*)job
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"job"];
}

+ (NSArray <NSDictionary*>*)industry
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"industry"];
}

+ (NSArray <NSDictionary*>*)majorGrade
{
    NSDictionary *dict = [self configDict];
    return [dict objectForKey:@"majorGrade"];
}

+ (void)saveConfigDict:(NSDictionary *)dict
{
    [[SYCache sharedInstance] saveItem:dict forKey:kSysConfigFileName];
}

+ (NSDictionary *)configDict
{
    return [[SYCache sharedInstance] itemForKey:kSysConfigFileName];
}

@end
