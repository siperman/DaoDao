//
//  DDUserInfoTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/26.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUserInfoTableViewCell.h"

@interface DDUserInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系

@end

@implementation DDUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(DDUser *)user
{
    if (_user != user) {
        _user = user;
        [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
        [self.imgGender setImage:([user.gender boolValue] ? Image(@"icon_woman") : Image(@"icon_man"))];

        self.labName.text = user.nickName;
        self.labGrade.text = MajorGrade(user.major, user.grade);
        self.labRelation.text = user.relation;
        [self layoutIfNeeded];
    }
}

+ (CGFloat)cellHeight
{
    return 72.0;
}

@end
