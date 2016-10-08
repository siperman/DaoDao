//
//  SYValidation.m
//  Soouya
//
//  Created by hetao on 15/6/14.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "SYValidation.h"
#import "SYCache.h"
#import <RegexKitLite/RegexKitLite.h>
#import "NSString+SYAddition.h"

static NSString *kValidationConfigFileName = @"validationConfig";

@implementation SYValidation

+ (BOOL)isText:(NSString *)text validateForType:(SYValidationType)type
{
    return [self isText:text andOtherInput:nil validateForType:type];
}

+ (BOOL)isText:(NSString *)text andOtherInput:(NSString *)otherInput validateForType:(SYValidationType)type
{
    switch (type) {
        case SYValidationTypeUsername:
        {
            return text.length >= 3 && text.length <= 12;
        }
        case SYValidationTypePassword:
        {
            return text.length >= 6 && text.length <= 20;
        }
        case SYValidationTypePhone:
        {
            return text.length == 11;
        }
        case SYValidationTypeNotEmpty:
        {
            return text.length > 0;
        }
        case SYValidationTypeEqual:
        {
            return [text isEqualToString:otherInput];
        }
        case SYValidationTypeNewSpec:
        {
            return text.length >= 1 && text.length <= 20;
        }
        case SYValidationTypeValid:
        {
            return YES;
        }
        default:
            return NO;
    }
}

static NSDictionary *dict = nil;
+ (NSString *)errMsgByCheckValue:(NSString *)value match:(NSString *)type
{
    // 检查乱码和 emoji 表情
    if ([value containsUTF8Errors] || [value stringContainsEmoji]) {
        return @"输入中不能包含特殊字符";
    }

    if ([type isEqualToString:kPhoneKey]) {
        if (value.length == 0) {
            return @"手机号不能为空喔！";
        } else if (value.length != 11) {
            return @"手机号输入错误，请重新输入！";
        }
    }

    return nil;
}

+ (void)saveValidationDict:(NSDictionary *)dict
{
    [[SYCache sharedInstance] saveItem:dict forKey:kValidationConfigFileName];
}

+ (NSDictionary *)validationDict
{
    return [[SYCache sharedInstance] itemForKey:kValidationConfigFileName];
}

@end
