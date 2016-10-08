//
//  DDAskInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 16/9/30.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskInfoTableViewCell.h"

@interface DDAskInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labDemand; // 需求
@property (weak, nonatomic) IBOutlet UILabel *labDesc; // 详细描述
@end

@implementation DDAskInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigView shadowStyle];
}

- (void)setAskInfo:(DDAsk *)askInfo
{
    if (_askInfo != askInfo) {
        _askInfo = askInfo;
        [self.imgHead sy_setThumbnailImageWithUrl:askInfo.user.headUrl];
        [self.imgGender setImage:([askInfo.user.gender boolValue] ? Image(@"icon_woman") : Image(@"icon_man"))];

        self.labName.text = askInfo.user.nickName;
        self.labGrade.text = MajorGrade(askInfo.user.major, askInfo.user.grade);
        self.labDemand.text = [NSString stringWithFormat:@"%@ | %@", askInfo.type, askInfo.demand];
        self.labDesc.text = askInfo.descr;
        [self layoutIfNeeded];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
