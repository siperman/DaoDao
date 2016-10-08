
//
//  MTLModel+Addition.m
//  Soouya
//
//  Created by hetao on 15/10/19.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "MTLModel+Addition.h"

@implementation MTLModel (Addition)

+ (instancetype)fromDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]] || [dict count] == 0) {
        return nil;
    }
    
    NSError *error = nil;
    id u = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:dict error:&error];
    if (error) {
        return nil;
    }
    
    return u;
}

+ (NSArray *)parseFromDicts:(NSArray<NSDictionary *> *)dicts
{
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *d in dicts) {
        id f = [self fromDict:d];
        if (f) {
            [results addObject:f];
        }
    }
    
    return results;
}

+ (NSValueTransformer *)thumbnailURLsJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *urls, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *results = [NSMutableArray array];

        for (NSString *u in urls) {
            NSString *thumbnailUrl = [ u stringByAppendingString:kThumbnailResolution];
            [results addObject:[NSURL URLWithString:RequestUrlFactory(thumbnailUrl)]];
        }

        return results;
    }];
}

+ (NSValueTransformer *)URLsJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *urls, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *results = [NSMutableArray array];

        for (NSString *u in urls) {
            [results addObject:[NSURL URLWithString:RequestUrlFactory(u)]];
        }

        return results;
    }];
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *url, BOOL *success, NSError *__autoreleasing *error) {
        if (url && url.length > 0) {
            return [NSURL URLWithString:RequestUrlFactory(url)];
        }

        return nil;
    }];
}

+ (NSValueTransformer *)stringValueJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if (value && value.length > 0) {
            return value;
        } else {
            return @"";
        }
    }];
}

+ (NSValueTransformer *)floatToStringJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        float w = [value floatValue];
        if (w >= 0) {
            return [NSString stringWithFormat:@"%0.2f", w];
        } else {
            return @"";
        }
    }];
}

+ (NSValueTransformer *)boolValueJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        if (value.integerValue > 0) {
            return @YES;
        } else {
            return @NO;
        }
    }];
}

+ (NSValueTransformer *)timeValueJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        double time = value.doubleValue / 1000;
        return [NSNumber numberWithDouble:time];
    }];
}

- (NSArray<NSURL *> *)convertToOriginURLs:(NSArray<NSURL *> *)thumbnailURLs
{
    NSMutableArray *results = [NSMutableArray array];
    
    if ([thumbnailURLs isKindOfClass:[NSArray class]]) {
        for (NSURL *url in thumbnailURLs) {
            NSString *extension = [url pathExtension];
            if ([url.absoluteString rangeOfString:extension].location != NSNotFound) {
                NSUInteger len = [url.absoluteString length] - [kThumbnailResolution length];
                NSString *u = [ url.absoluteString substringWithRange:NSMakeRange(0, len)];
                [results addObject:[NSURL URLWithString:u]];
            } else if (url) {
                [results addObject:[NSURL URLWithString:url.absoluteString]];
            }
        }
    }

    return results;
}

/**
 *  空标量异常
 *  有的时候API的response会有空值，比如copyToChina可能不是每次都有的，JSON是这样儿的：
 *  {
 *      "copyToChina": null
 *  }
 *  Mantle在这种情况会将newShit转换为nil，但如果是标量如NSInteger怎么办？KVC会直接raise NSInvalidArgumentException。
 *
 *  @param key
 */
- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key]; // For NSInteger/CGFloat/BOOL
}

@end
