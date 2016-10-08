//
//  MTLModel+Addition.h
//  Soouya
//
//  Created by hetao on 15/10/19.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "MTLModel.h"

@interface MTLModel (Addition)

+ (instancetype)fromDict:(NSDictionary *)dict;

+ (NSArray *)parseFromDicts:(NSArray<NSDictionary *> *)dicts;

+ (NSValueTransformer *)stringValueJSONTransformer;

+ (NSValueTransformer *)floatToStringJSONTransformer;

+ (NSValueTransformer *)boolValueJSONTransformer;

+ (NSValueTransformer *)timeValueJSONTransformer;

+ (NSValueTransformer *)thumbnailURLsJSONTransformer;

+ (NSValueTransformer *)URLsJSONTransformer;

+ (NSValueTransformer *)URLJSONTransformer;

- (NSArray<NSURL *> *)convertToOriginURLs:(NSArray<NSURL *> *)thumbnailURLs;

- (void)setNilValueForKey:(NSString *)key;

@end
