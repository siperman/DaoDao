//
//  ChooseImageViewModel.m
//  DaoDao
//
//  Created by hetao on 16/9/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "ChooseImageViewModel.h"

@implementation ChooseImageViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"imgUrl" : @"value",
             };
}

+ (NSValueTransformer *)imgUrlJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *urls, BOOL *success, NSError *__autoreleasing *error) {
        if ([urls isKindOfClass:[NSArray class]] &&
            urls.count > 0) {
            return [urls firstObject];
        } else {
            return @"";
        }
    }];
}

@end
