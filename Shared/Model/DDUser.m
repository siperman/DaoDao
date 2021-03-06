//
//  DDUser.m
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUser.h"

@implementation DDUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uid" : @"id",
             @"title" : @"title",
             @"mobilePhone" : @"mobilePhone",
             @"headUrl" : @"headUrl",
             @"nickName" : @"nickName",
             @"realName" : @"realName",
             @"gender" : @"gender",
             @"major" : @"major",
             @"grade" : @"grade",
             @"job" : @"job",
             @"industry" : @"industry",
             @"year" : @"year",
             @"company" : @"company",
             @"province" : @"province",
             @"city" : @"city",
             @"expert" : @"expert",
             @"topic" : @"topic",
             @"tags" : @"tags",
             @"showMsgDetail" : @"showMsgDetail",
             @"inviteCode" : @"inviteCode",
             @"status" : @"status",
             @"lastMeetTime" : @"lastMeetTime",
             @"meetTimes" : @"meetTimes",
             @"integrity" : @"integrity",
             @"isMeeting" : @"isMeeting",
             @"askReds" : @"askReds",
             @"answerReds" : @"answerReds",
             };
}

+ (NSValueTransformer *)tagsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[DDRateTag class]];
}

+ (NSValueTransformer *)realNameJSONTransformer
{
    return [self stringDecryptJSONTransformer];
}

+ (NSValueTransformer *)titleJSONTransformer
{
    return [self stringDecryptJSONTransformer];
}

+ (NSValueTransformer *)mobilePhoneJSONTransformer
{
    return [self stringDecryptJSONTransformer];
}

+ (NSValueTransformer *)companyJSONTransformer
{
    return [self stringDecryptJSONTransformer];
}

- (NSString *)relation
{
    return _meetTimes.integerValue ? @"TA和您见过" : @"";
}

- (UIImage *)genderImage
{
    return [self.gender boolValue] ? Image(@"icon_woman") : Image(@"icon_man");
}

@end

@implementation DDRateTag

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"tag" : @"tag",
              @"count" : @"count"};
}

- (NSString *)tagStr
{
    return [NSString stringWithFormat:@"%@  %@", self.tag, self.count];
}
@end
