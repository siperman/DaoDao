//
//  DDMyAnswerTableViewCell.m
//  DaoDao
//
//  Created by hetao on 2016/11/1.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMyAnswerTableViewCell.h"

@interface DDMyAnswerTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系

@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *labDemand;

@end

@implementation DDMyAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labDemand.textColor = TextColor;
    [self.imgHead sy_round];
}

- (void)setUser:(DDUser *)user
{
    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.imgGender setImage:user.genderImage];

    self.labName.text = user.title;
    self.labGrade.text = MajorGrade(user.major, user.grade);
    self.labRelation.text = user.relation;
}

- (void)configureCellWithData:(id)data
{
    if ([data isKindOfClass:[DDUser class]]) {
        [self setUser:data];
    } else if ([data isKindOfClass:[DDAsk class]]) {
        DDAsk *ask = (DDAsk *)data;
        if (ask.isMyAsk) {
            [self setUser:ask.answer.user];
        } else {
            [self setUser:ask.user];
        }

        self.statusImgView.image = [ask statusImage];
        self.labDemand.text = ask.demand;
    }
}

+ (CGFloat)cellHeight
{
    return 72.0 + 55.0;
}
@end
