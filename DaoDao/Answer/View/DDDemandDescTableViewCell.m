//
//  DDDemandDescTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/15.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDDemandDescTableViewCell.h"

@implementation DDDemandDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    self.labDemand.text = ask.demand;
}

@end
