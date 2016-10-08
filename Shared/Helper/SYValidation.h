//
//  SYValidation.h
//  Soouya
//
//  Created by hetao on 15/6/14.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYValidation : NSObject

+ (BOOL)isText:(NSString *)text validateForType:(SYValidationType)type;

+ (BOOL)isText:(NSString *)text andOtherInput:(NSString *)otherInput validateForType:(SYValidationType)type;

+ (NSString *)errMsgByCheckValue:(NSString *)value match:(NSString *)type;

+ (void)saveValidationDict:(NSDictionary *)dict;

@end
