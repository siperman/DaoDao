//
//  NSObject+Addition.m
//  Soouya
//
//  Created by hetao on 15/11/3.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "NSObject+Addition.h"

@implementation NSObject (Addition)

+ (NSString *)className
{
    return NSStringFromClass(self);
}

- (NSString *)jsonString
{
    NSString *jsonString = @"";
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (Notification)

- (void)subscribeNotication:(NSString *)name selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void)unsubscribeAllNotications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)unsubscribeNotication:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

@end
