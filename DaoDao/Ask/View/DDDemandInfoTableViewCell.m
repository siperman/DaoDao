//
//  DDDemandInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDDemandInfoTableViewCell.h"

@implementation DDDemandInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;

    // TODO: 纯英文和中文高度还不一样
    self.labDemand.attributedText = [ask.demand attributedStringWithLineSpacing:6.0];
    NSString *text = [NSString stringWithFormat:@"职务：%@\n行业：%@\n专家：%@", [ask.job componentsJoinedByString:@"、"], [ask.industry componentsJoinedByString:@"、"], [ask.expert componentsJoinedByString:@"、"]];
    self.labDesc.attributedText = [text attributedStringWithLineSpacing:6.0];
}

+ (CGFloat)cellHeight
{
    return 176.0;
}

@end
