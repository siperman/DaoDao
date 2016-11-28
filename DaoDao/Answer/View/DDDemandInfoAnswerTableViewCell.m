//
//  DDDemandInfoAnswerTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDDemandInfoAnswerTableViewCell.h"

@implementation DDDemandInfoAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    self.labDemand.attributedText = [ask.demand attributedStringWithLineSpacing:6.0];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ask.answer.meet.time.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";

    NSString *timeStr = [dateFormatter stringFromDate:date];
    NSString *text = [NSString stringWithFormat:@"时间：%@\n地点：%@ %@", timeStr, ask.answer.meet.city, ask.answer.meet.addr];
    self.labDesc.attributedText = [text attributedStringWithLineSpacing:6.0];
}

@end
