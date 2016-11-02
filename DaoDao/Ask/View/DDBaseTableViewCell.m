//
//  DDBaseTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/31.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDBaseTableViewCell.h"

@implementation DDBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    self.backgroundColor = ClearColor;
    self.contentView.backgroundColor = ClearColor;
}


- (void)configureCellWithData:(id)data
{

}

+ (CGFloat)cellHeight
{
    return 50.0;
}


@end
