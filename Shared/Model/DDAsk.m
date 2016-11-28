//
//  DDAsk.m
//  DaoDao
//
//  Created by hetao on 16/9/21.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAsk.h"

@implementation DDAsk

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"aid" : @"id",
             @"demand" : @"demand",
             @"industry" : @"industry",
             @"job" : @"job",
             @"expert" : @"expert",
             @"answers" : @"answers",
             @"cancelReason" : @"cancelReason",
             @"status" : @"status",
             @"createTime" : @"createTime",
             @"user" : @"user",
             @"answer" : @"answer",
             @"favorites" : @"favorites",
             };
}

- (NSString *)type
{
    DDUser *user = [DDUserManager manager].user;
    if ([self.user.uid isEqualToString:user.uid]) {
        return @"我发起";
    } else {
        return @"对方发起";
    }
}

- (BOOL)isMyAsk
{
    DDUser *user = [DDUserManager manager].user;
    return [self.user.uid isEqualToString:user.uid];
}

- (UIImage *)statusImage
{
    if (self.isMyAsk) {
        NSArray *imgNames = @[@"bq_loading", @"bq_ing", @"bq_done", @"bq_cancel", @"bq_fail"];
        NSString *imgName;
        NSInteger status = self.status.integerValue;

        if (status == DDAskPostSuccess ||
            status == DDAskWaitingHandOut ||
            status == DDAskWaitingAnswerInterest) {
            imgName = imgNames[0];
        } else if ((status >= DDAskWaitingSendMeet &&
                    status <= DDAskBothUnRate) ||
                   status == DDAskAskerRate) {
            imgName = imgNames[1];
        } else if (status == -1) { // 约局已取消
            imgName = imgNames[3];
        } else if (status == -2) { // 约局失效
            imgName = imgNames[4];
        } else {
            imgName = imgNames[2];
        }

        return Image(imgName);
    } else {
        NSArray *imgNames = @[@"bq_interest", @"bq_waitDate", @"bq_Wmeet", @"bq_comment", @"bq_done", @"bq_cancel", @"bq_fail"];
        NSString *imgName;
        NSInteger status = self.status.integerValue;

        if (status == DDAskWaitingSendMeet) {
            imgName = imgNames[0];
        } else if (status == DDAskWaitingAgreeMeet) {
            imgName = imgNames[1];
        } else if (status == DDAskWaitingMeet) {
            imgName = imgNames[2];
        } else if (status == DDAskAnswerRate ||
                   status == DDAskBothUnRate) {
            imgName = imgNames[3];
        } else if (status == DDAskAskerRate ||
                   status == DDAskBothRate) {
            imgName = imgNames[4];
        } else if (status == -5 ||
                   status == -3) {
            imgName = imgNames[6];
        } else if (status == -4) {
            imgName = imgNames[5];
        } else {
            return nil;
        }

        return Image(imgName);
    }
}
@end
