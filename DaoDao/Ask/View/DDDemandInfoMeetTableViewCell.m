//
//  DDDemandInfoMeetTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDDemandInfoMeetTableViewCell.h"

@implementation DDDemandInfoMeetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    self.labDemand.text = ask.demand;
    self.labDesc.text = [NSString stringWithFormat:@"职务：%@\n行业：%@\n专家：%@", [ask.job componentsJoinedByString:@"、"], [ask.industry componentsJoinedByString:@"、"], [ask.expert componentsJoinedByString:@"、"]];
}

+ (CGFloat)cellHeight
{
    return 176.0;
}
@end
