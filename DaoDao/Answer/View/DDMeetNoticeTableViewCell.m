//
//  DDMeetNoticeTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMeetNoticeTableViewCell.h"

@implementation DDMeetNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    self.labTime.text = [SYUtils dateDetailSinceNowFormInterval:ask.answer.meet.time];
}

@end
