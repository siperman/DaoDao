//
//  DDAskHandOutTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/31.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskHandOutTableViewCell.h"

@implementation DDAskHandOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithData:(id)data
{
    DDAsk *ask = (DDAsk *)data;
    if (ask.answers.integerValue > 0) {
        NSString *left = @"正在努力为您派送邀请，已发送给";
        NSString *right = @"人\n请耐心等待...";
        NSString *text = [NSString stringWithFormat:@"%@%@%@", left, ask.answers, right];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr setAttributes:@{NSForegroundColorAttributeName : SecondColor} range:NSMakeRange(left.length, text.length - left.length - right.length)];

        self.label.attributedText = attrStr;
    } else {
        self.label.text = @"正在努力为您筛选最合适的靠谱人\n请耐心等待...";
    }
}

+ (CGFloat)cellHeight
{
    return 80.0;
}

@end
