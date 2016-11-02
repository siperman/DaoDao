//
//  DDDemandInfoSmallTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDDemandInfoSmallTableViewCell.h"

@implementation DDDemandInfoSmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    self.label.text = ask.demand;
}

+ (CGFloat)cellHeight
{
    return 50.0;
}

@end
