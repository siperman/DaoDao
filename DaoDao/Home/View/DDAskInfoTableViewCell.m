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
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labDemand; // 需求
@property (weak, nonatomic) IBOutlet UILabel *labRelation; // 关系
@end

@implementation DDAskInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigView shadowStyle];
    [self.labDemand normalTextStyle];
    [self.btnLeft setTitleColor:ColorHex(@"707070")];
}

- (void)setAskInfo:(DDAsk *)askInfo
{
    _askInfo = askInfo;
    [self.imgHead sy_setThumbnailImageWithUrl:askInfo.user.headUrl];
    [self.imgGender setImage:([askInfo.user.gender boolValue] ? Image(@"icon_woman") : Image(@"icon_man"))];

    self.labName.text = askInfo.user.nickName;
    self.labGrade.text = MajorGrade(askInfo.user.major, askInfo.user.grade);
    self.labDemand.text = askInfo.demand;
    self.labRelation.text = askInfo.user.relation;

    if (askInfo.status.integerValue >= DDAskWaitingSendMeet) {
        [self.btnRight setTitle:@"您已感兴趣"];
        self.btnLeft.enabled = NO;
        self.btnRight.enabled = NO;
    } else if (askInfo.status.integerValue < DDAskPostSuccess) {
        [self.btnLeft setTitle:@"您已不感兴趣"];
        self.btnLeft.enabled = NO;
        self.btnRight.enabled = NO;
    }

    [self layoutIfNeeded];
}

- (IBAction)disinterest:(UIButton *)sender
{
    [MobClick event:PieceDtl_uninterestBtn_click];
    [self.viewController showLoadingHUD];
    [SYRequestEngine disinterestAskWithId:_askInfo.aid
                                 callback:^(BOOL success, id response) {
                                     [self.viewController hideAllHUD];
                                     if (success) {
                                         _askInfo.status = @(-1);
                                         if ([self.delegete respondsToSelector:@selector(disinterestAskWithId:callback:)]) {
                                             [self.delegete disinterest:_askInfo];
                                         }
                                     } else {
                                         [self.viewController showRequestNotice:response];
                                     }
                                 }];
}

- (IBAction)interest:(UIButton *)sender
{
    [MobClick event:PieceDtl_interestBtn_click];
    [self.viewController showLoadingHUD];

    [SYRequestEngine interestAskWithId:_askInfo.aid
                              callback:^(BOOL success, id response) {
                                  [self.viewController hideAllHUD];
                                  if (success) {
                                      _askInfo.status = @(3); // 待约见
                                      if ([self.delegete respondsToSelector:@selector(interest:)]) {
                                          [self.delegete interest:_askInfo];
                                      }
                                  } else {
                                      [self.viewController showRequestNotice:response];
                                  }
                              }];
}

+ (CGFloat)cellHeight
{
    return 186.0;
}

@end
